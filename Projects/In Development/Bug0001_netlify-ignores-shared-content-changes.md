# Netlify skips a site's production build when only shared/ content changes

[PR #18](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/18)

* **ID:** Bug0001
* **Status:** Verifying
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy`

---

## Bug Description

Each site is a separate Netlify project scoped to its own directory as its
"Base directory" (`LeeAtchison`, `AtchisonAcademy`, etc. — one `netlify.toml`
per site, at that site's root). Netlify's default build-skip behavior for a
site with a base directory set is to run

```
git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- <base-directory>
```

on every push and skip the build entirely when that command reports no
differences.

`LeeAtchison` and `AtchisonAcademy` don't just read their own directory,
though (Spec0008) — `src/_books` and `src/_courses` in both are **symlinks**
to `shared/_books` and `shared/_courses` at the repo root. A change confined
to `shared/` (adding, editing, or re-sorting a book or course) never touches
a path under `LeeAtchison/` or `AtchisonAcademy/` in git's eyes — only the
symlink *target*, which lives outside both directories. Netlify's diff-based
skip check has no way to know that, so it sees "nothing under my base
directory changed" and skips the production build.

Spec0008 addressed the adjacent question — will the files actually be
present at build time — and confirmed they are, because Netlify checks out
the whole repo regardless of base directory (Spec0008, "Why this is safe").
It never addressed this separate question: will the build **run** at all.
The two are different Netlify mechanisms (checkout scope vs. build-skip
heuristic), and only the first was checked.

**Observed:** PR #17 (Spec0014) added a new shared course and re-sorted the
other twelve, touching only `shared/_courses/*.md`, `AtchisonAcademy/`,
`Projects/`, and root `CLAUDE.md` — no file under `LeeAtchison/` changed.
After the PR merged, atchisonacademy.com rebuilt (its own `CLAUDE.md` and
`README.md` had changed directly), but leeatchison.com did not, and the new
course was missing from the live site until Lee manually triggered a deploy
from the Netlify dashboard.

This will recur on any future change confined to `shared/_books/` or
`shared/_courses/` — including one that touches only `AtchisonAcademy/`
directly (which would rebuild Academy but silently skip LeeAtchison, or vice
versa) — until fixed.

---

## Solution/Fix/Change

Netlify also supports a custom `ignore` command in `netlify.toml` under
`[build]`, which overrides the default base-directory-only diff check. Add
one to each affected site's `netlify.toml` that also considers `shared/`:

`LeeAtchison/netlify.toml`:

```toml
[build]
  ignore = "git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- LeeAtchison shared"
```

`AtchisonAcademy/netlify.toml`:

```toml
[build]
  ignore = "git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- AtchisonAcademy shared"
```

`git diff --quiet` exits 1 (differences found) if *either* pathspec has
changes and 0 (no differences) only if *neither* has — which is exactly
Netlify's convention for this command: exit 0 skips the build, non-zero lets
it proceed. Deploy Previews use the same `[build]` command/environment as
production per each site's existing `netlify.toml` comment, and the `ignore`
setting isn't scoped per-context, so this applies to previews too — desired,
since a preview confined to `shared/` should also build.

The other four sites (`TheSoftwareConductor`, `stosa`,
`BusinessBreakthrough30`, `ArchitectingForScale`) don't read `shared/` at
all (Spec0008), so Netlify's default base-directory-only check is already
correct for them. No change needed there.

---

## Testing

1. Confirm both edited `netlify.toml` files still parse (`bin/bridgetown
   build` on each site succeeds unaffected — the `ignore` key only affects
   Netlify's own decision to invoke the build, not the build itself).
2. Manually evaluate the ignore command against real history: pick two
   commits where only `shared/` changed and confirm
   `git diff --quiet <old> <new> -- LeeAtchison shared` exits 1 (would
   build), while `git diff --quiet <old> <new> -- LeeAtchison` (the old
   default) exits 0 (would have skipped) — reproducing the bug and
   confirming the fix on the same data.
3. Since this can't be exercised end-to-end without pushing two more
   commits to Netlify and comparing skip/build outcomes, the real
   confirmation is the next shared-content-only spec: watch that both
   leeatchison.com and atchisonacademy.com actually redeploy without manual
   intervention.

---

## Summary of Steps Needed

1. Add `[build] ignore = "..."` to `LeeAtchison/netlify.toml`, scoped to
   `LeeAtchison shared`.
2. Add the same to `AtchisonAcademy/netlify.toml`, scoped to
   `AtchisonAcademy shared`.
3. Verify both `netlify.toml` files are still valid and each site still
   builds locally.

---

## Open Questions

None — Lee confirmed the fix and asked for it to be made 2026-08-31.

---

## History of Updates

- **2026-08-31** — Bug created and moved straight to Implementing (Lee's
  explicit go-ahead). Found while investigating why leeatchison.com didn't
  pick up Spec0014's new course automatically after PR #17 merged; Lee had
  already forced a rebuild by hand. Confirmed via the Netlify API that the
  production deploy that eventually shipped Spec0014's content
  (`deploy_source: "api"`, commit `1312070`) was a manually triggered
  redeploy of the already-merged commit, not the automatic git-push build —
  consistent with the automatic build having been skipped.
