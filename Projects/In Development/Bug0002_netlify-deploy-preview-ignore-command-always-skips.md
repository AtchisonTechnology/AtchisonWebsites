# Netlify deploy-preview builds for LeeAtchison/AtchisonAcademy skip on every automatic push, not just the first

* **ID:** Bug0002
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy`

---

## Bug Description

Bug0001 added a custom `[build] ignore` command to `LeeAtchison/netlify.toml` and
`AtchisonAcademy/netlify.toml` so a change confined to `shared/` (which reaches both
sites only through a symlink) still triggers a build:

```
git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- <SiteDir> shared
```

`$CACHED_COMMIT_REF` is documented as the commit of the branch/context's last
successful deploy. On [PR #19](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/19)
(Spec0015, a brand-new branch), this command reported "no differences" — and the
automatic Deploy Preview build **skipped** — on every one of three consecutive
automatic pushes to both `LeeAtchison` and `AtchisonAcademy`, even on a push whose
diff touched `AtchisonAcademy/netlify.toml` and `LeeAtchison/netlify.toml` directly
(not just `shared/`). A direct, unambiguous change under a site's own base directory
should never be skippable by this command, under any theory of how
`$CACHED_COMMIT_REF` behaves — so the failure is broader than "the widened diff
doesn't cover `shared/`" (Bug0001's original bug); it is closer to "the automatic
ignore check never lets a Deploy Preview build proceed at all" on this branch.

A manual "Trigger deploy" from the Netlify dashboard **does** build correctly and
shows the real content (confirmed twice on PR #19, at two different commits) —
manual triggers appear to bypass the `ignore` command entirely. That is the only
reliable way found so far to get a working Deploy Preview on a new PR for either
site.

### First hypothesis, tried and disproven

Working theory going in: `$CACHED_COMMIT_REF` is empty/unset when a branch/context
has no prior successful deploy, and being unquoted in the command, it word-splits
away — collapsing `git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- paths` to a
single-ref `git diff --quiet $COMMIT_REF -- paths`, which compares a clean checkout
of that exact commit against itself and is always empty, regardless of actual
content.

Reproduced locally on a clean tree (matching Netlify's build environment): with
`CACHED_COMMIT_REF` unset, the original command exits 0 (skip); a version falling
back to git's empty-tree hash (`${CACHED_COMMIT_REF:-4b825dc642cb6eb9a060e54bf8d69288fbee4904}`)
exits 1 (build) under the same conditions. That fix was committed and pushed to
PR #19.

**It did not fix the live behavior.** The actual Netlify deploy log for the next
automatic push (`AtchisonAcademy` deploy `6a95f2e91f8f3800080e036a`) shows Netlify
used the exact updated command verbatim and it still returned exit 0:

```
2:32:56 PM: Custom ignore command detected. Proceeding with the specified command:
'git diff --quiet ${CACHED_COMMIT_REF:-4b825dc642cb6eb9a060e54bf8d69288fbee4904}
$COMMIT_REF -- AtchisonAcademy shared'
2:32:56 PM: User-specified ignore command returned exit code 0. Returning early
from build.
2:32:57 PM: Failed during stage 'checking build content for changes': Canceled
build due to no content change
```

This proves `$CACHED_COMMIT_REF` is not unset/empty in this context — the `:-`
fallback never triggers, since the command still evaluates to "no diff" using
whatever real value it does have. That rules the original hypothesis out as the
(complete) explanation. The empty-tree fallback was reverted on PR #19 (commit
`ac5552f`) rather than left in place solving nothing.

### What's still unknown

- What does `$CACHED_COMMIT_REF` actually resolve to for a Deploy Preview build in
  this Netlify account/plan, on a branch with no prior *automatic* successful
  build? (Does a manual trigger's success count toward it for the *next* automatic
  build? Evidence says no — the second automatic push still skipped after the
  first manual trigger had already succeeded.)
- Is this specific to the Deploy Preview context, or does the same failure mode
  risk production builds on `main` too? Bug0001 was only verified against
  historical commits, never against a live push-triggered build, so this may have
  been silently true there as well.
- The deploy log's first line — `Waiting for other deploys from your team to
  complete` — shows this Netlify team is on a concurrency-limited plan (builds
  queue rather than running in parallel). Not obviously related to the skip
  itself, but noted in case queuing interacts with how `$CACHED_COMMIT_REF` gets
  populated for a context.

---

## Solution/Fix/Change

Not yet determined — this needs the unknowns above answered before a real fix can
be written with confidence, per the lesson from the disproven first attempt.

Candidate directions for the next investigation pass:

1. **Instrument, don't guess.** Temporarily change the `ignore` command to `echo`
   `$CACHED_COMMIT_REF` and `$COMMIT_REF` (or write them to a file Netlify's build
   log would surface) on a throwaway branch, push, and read the actual values from
   a real deploy log before writing any fix.
2. **Stop depending on `$CACHED_COMMIT_REF` for correctness.** Deploy Previews
   also get `$BASE_REF` (documented as the PR's target branch name, e.g. `main`)
   and `$PULL_REQUEST`/`$REVIEW_ID`. A command that diffs against
   `origin/$BASE_REF` (or its merge-base with `$COMMIT_REF`) when in a
   pull-request context, and only falls back to `$CACHED_COMMIT_REF` for
   production/branch-deploy contexts, would not depend on a cache value whose
   actual Deploy-Preview semantics are apparently not what Netlify's docs
   describe (or not what they're commonly assumed to describe). Needs confirming
   the base branch's history is actually available in Netlify's checkout for a PR
   build (Bug0001's original design already assumes arbitrary two-SHA diffs work,
   which implies enough history is present).
3. Any fix must be verified against a **live** push-triggered build before being
   trusted, not just simulated locally — the first attempt passed local
   simulation and still failed live, because the local simulation couldn't
   reproduce Netlify's actual environment-variable behavior.

---

## Testing

1. Reproduce first: confirm on a fresh branch that an automatic push touching only
   `shared/` (or a site's own directory) skips both `LeeAtchison` and
   `AtchisonAcademy`'s Deploy Preview builds, by reading the real deploy log (not
   just the PR comment's "canceled" summary — the log names the exact command and
   exit code).
2. Whatever fix is written, push it and confirm the *next* automatic push (not a
   manual trigger) actually builds and posts "ready" with the real content, for
   both sites, without needing a manual retrigger.
3. Confirm a push that touches *neither* the site's own directory nor `shared/`
   still correctly skips — the fix must not regress Bug0001's original build-skip
   savings by making every push build every site regardless of content.

---

## Summary of Steps Needed

1. Instrument the ignore command on a throwaway branch to read the real
   `$CACHED_COMMIT_REF`/`$COMMIT_REF`/`$BASE_REF` values Netlify actually supplies
   for a Deploy Preview build.
2. Based on that, design a fix that doesn't depend on assumptions about
   `$CACHED_COMMIT_REF` that turned out to be wrong once.
3. Verify the fix against a live automatic push (not local simulation, and not a
   manual trigger) before considering this closed.
4. Update `LeeAtchison/netlify.toml` and `AtchisonAcademy/netlify.toml` together,
   as Bug0001 did.

---

## Open Questions

1. **Should this also be checked against `main`/production**, not just Deploy
   Previews? If the same failure mode applies there, a `shared/`-only merge could
   silently fail to redeploy production again — the exact Bug0001 symptom,
   recurring through a different mechanism.
2. **Is the team's concurrency-limited build queue worth raising with Netlify
   support directly**, in case they can state authoritatively what
   `$CACHED_COMMIT_REF` actually contains for this account's Deploy Preview
   builds, rather than reverse-engineering it from log output.

---

## History of Updates

**2026-08-31 — Bug created.** Found while driving [PR #19](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/19)
(Spec0015) to a testable state. Every automatic Deploy Preview build for
`LeeAtchison` and `AtchisonAcademy` skipped on that PR — three consecutive
pushes, including one that edited each site's own `netlify.toml` directly. A
first fix (falling back to git's empty-tree hash when `$CACHED_COMMIT_REF` is
empty) was verified locally, pushed, and then disproven by the actual Netlify
deploy log, which showed the fallback never triggers because
`$CACHED_COMMIT_REF` is not empty/unset in this context — it holds some other
value that still produces a false "no diff." That fix was reverted
(commit `ac5552f`) rather than left in place solving nothing. Manual "Trigger
deploy" from the Netlify dashboard remains the only confirmed-working path to a
real preview on a new PR branch, and was used to unblock Spec0015's review in
the meantime.
