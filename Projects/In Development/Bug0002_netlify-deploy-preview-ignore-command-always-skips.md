# Netlify deploy-preview builds for LeeAtchison/AtchisonAcademy skip on every automatic push, not just the first

* **ID:** Bug0002
* **Status:** Implementing
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

*(2026-09-01: all three items below are now moot or answered — see the root
cause in Solution. With pathspecs that match no files, the diff was empty for
every possible value of `$CACHED_COMMIT_REF`, so none of the observed skips
carried any information about that variable at all.)*

- `$CACHED_COMMIT_REF`'s actual Deploy-Preview value: never directly observed,
  but irrelevant to this bug — the broken pathspecs made the command exit 0
  regardless. After the fix it only needs to be *a* valid commit; live
  verification (Testing below) will confirm.
- Production on `main`: **yes, affected identically.** The same ignore command
  runs in every deploy context, so no automatic push-triggered build
  (production, branch deploy, or Deploy Preview) can proceed for either site
  while the current command is in place. See Open Questions.
- The build-queue/concurrency observation: unrelated — the skip is fully
  explained without it.

---

## Solution/Fix/Change

**Root cause identified 2026-09-01** (fix below is *proposed*, not yet
implemented or decided):

Netlify runs a custom `ignore` command **from the site's base directory, not
the repo root**. This is documented — Netlify's ignore-builds docs state that
all paths in the ignore command are resolved relative to the base directory —
and both sites' base directories are their own site folders (that is also why
each site's `netlify.toml` gets picked up at all; there is none at the repo
root). Git resolves command-line pathspecs relative to the current working
directory, so run from inside `AtchisonAcademy/`:

- pathspec `AtchisonAcademy` means `AtchisonAcademy/AtchisonAcademy` — matches nothing;
- pathspec `shared` means `AtchisonAcademy/shared` — matches nothing (the
  symlinks live at `src/_books` and `src/_courses`).

`git diff --quiet` with pathspecs matching no files reports an empty diff and
exits 0, **for every commit pair and every value of `$CACHED_COMMIT_REF`**. So
the command skips every automatic build unconditionally. This explains all the
observed symptoms at once:

- skips even when the site's own `netlify.toml` changed (pathspec never matched it);
- the empty-tree fallback fix changed nothing (`$CACHED_COMMIT_REF`'s value was
  never the problem);
- local simulation passed while live builds failed (local tests were run from
  the repo root, where the pathspecs resolve correctly);
- manual "Trigger deploy" works (it bypasses the ignore command entirely).

**Reproduced locally (2026-09-01)** using commit `aff3b5c` (which edited both
sites' `netlify.toml` files directly):

```
# from repo root:
git diff --quiet aff3b5c~1 aff3b5c -- AtchisonAcademy shared   # exit 1 (build) — the local-simulation trap
# from AtchisonAcademy/ (how Netlify actually runs it):
git diff --quiet aff3b5c~1 aff3b5c -- AtchisonAcademy shared   # exit 0 (skip) — reproduces the live failure
```

**Proposed fix:** use git's `:(top)` pathspec magic, which resolves pathspecs
against the repo root regardless of the working directory:

```
# LeeAtchison/netlify.toml
ignore = "git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- ':(top)LeeAtchison' ':(top)shared'"
# AtchisonAcademy/netlify.toml
ignore = "git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- ':(top)AtchisonAcademy' ':(top)shared'"
```

Verified locally from inside `AtchisonAcademy/`: exit 1 (build) on `aff3b5c`
(real change under the site dir), and exit 0 (correctly skips) on `1567642`, a
commit touching only `LeeAtchison/` — so Bug0001's build-skip savings are
preserved. Because `:(top)` is CWD-independent, the same command now behaves
identically in local simulation and in Netlify's environment, closing the gap
that let the first fix pass locally and fail live.

Optional belt-and-braces (worth considering, not required by any observed
evidence): re-add the empty-tree fallback
`${CACHED_COMMIT_REF:-4b825dc642cb6eb9a060e54bf8d69288fbee4904}` — the deploy
log proved the variable *was* set in the one context inspected, but Netlify's
docs don't guarantee it in all contexts, and the fallback is harmless.

Live verification per the Testing section below is still mandatory before
this is considered fixed.

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
   *(2026-09-01: the factual half is answered — production **is** affected
   identically, since the same ignore command runs in every context; every
   automatic push-triggered production build has been skipping since Bug0001's
   command landed. Both sites' current production deploys (2026-08-31) show the
   post-merge content, which is consistent with Lee having triggered them
   manually from the dashboard — Lee to confirm. Whether the fix's live
   verification should explicitly include a `main` push remains open.)*
2. **Is the team's concurrency-limited build queue worth raising with Netlify
   support directly**, in case they can state authoritatively what
   `$CACHED_COMMIT_REF` actually contains for this account's Deploy Preview
   builds, rather than reverse-engineering it from log output.
   *(2026-09-01: likely unnecessary now — the root cause turned out not to
   involve `$CACHED_COMMIT_REF` or the queue at all.)*

---

## History of Updates

**2026-09-01 — Moved to Implementing (Lee's go-ahead); fix applied on `main`.**
Both sites' `netlify.toml` ignore commands switched to CWD-independent
`:(top)` pathspecs, with the base-directory gotcha documented in a comment
beside each. Working-tree change only — not yet committed or pushed; live
verification per the Testing section still pending.

**2026-09-01 — Root cause identified.** Netlify runs the custom `ignore`
command from the site's **base directory**, not the repo root (documented in
Netlify's ignore-builds docs; the same failure is the subject of the Netlify
forum thread "Ignore in monorepo always ignores"). Git pathspecs are
CWD-relative, so `-- LeeAtchison shared` / `-- AtchisonAcademy shared` match
no files from inside the base directories; `git diff --quiet` with unmatched
pathspecs exits 0, so every automatic build skips, for any commit pair and
any `$CACHED_COMMIT_REF` value — which is why the empty-tree fallback changed
nothing and why local simulation from the repo root passed while live builds
failed. Reproduced locally: the exact command exits 1 from the repo root and
0 from `AtchisonAcademy/` on the same commit pair. Proposed fix (not yet
implemented): top-relative pathspecs `':(top)<SiteDir>' ':(top)shared'`,
verified locally to build on a real change and still skip on a
LeeAtchison-only commit. Also established that production on `main` is
affected identically. Updated Solution, unknowns, and Open Questions
accordingly.

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
