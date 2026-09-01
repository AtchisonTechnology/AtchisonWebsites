# Move book and course card images into `shared/` so both sites read one copy

**PR:** [#24](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/24)

* **ID:** Spec0019
* **Status:** Closed
* **Date Created:** 2026-08-31
* **Date Implemented:** 2026-09-01
* **Systems Impacted:** `LeeAtchison` and `AtchisonAcademy` (`src/images/books`, `src/images/courses` become symlinks), plus a new `shared/images/` tree at the repo root. No template, no stylesheet, and no front-matter value changes.

---

## Problem/Requirement

Spec0008 moved the books and courses **collections** to `shared/` and reached
them from both sites through symlinks, so there is one copy of every book and
course file. It did not move the **images those files point at**.

`cover_image` is a site-relative path — every book uses the shape
`/images/books/<slug>.<ext>` — which each site resolves inside its own
`src/images/`. So the shared data is shared and the assets it references are
not:

| File | `LeeAtchison/src/images/books/` | `AtchisonAcademy/src/images/books/` |
|---|---|---|
| `the-software-conductor.png` | ✅ | ✅ **byte-identical** (`ea76fd01…`) |
| `business-breakthrough-3.jpg` | ✅ | ✅ **byte-identical** (`6dc45f7a…`) |
| `architecting-for-scale.jpg` | ✅ | — |
| `overcoming-it-complexity.png` | ✅ | — |

Two files are maintained twice today. That is small, and it is the shape of the
problem rather than its size: the moment a book gains `show_academy`, someone
has to know to copy its cover across, and nothing fails if they don't — the
card renders a broken image on one site only, on a page the person editing was
not looking at. It is the exact failure Spec0008 removed for the content and
left in place for the art.

Spec0020 adds card images for courses. Six courses are featured across the two
sites, four of them on Academy and two on leeatchison.com, with none shared
today — so that spec would triple this duplication if the images land in the
per-site trees. **This spec should ship before Spec0020**, so course art is
shared from its first day rather than deduplicated later.

---

## Solution/Fix/Change

### 1. New shared tree

Create at the repo root, beside the existing collections:

```
shared/
├── _books/
├── _courses/
├── _data/
└── images/          # new
    ├── books/
    └── courses/     # empty until Spec0020
```

Move the four covers from `LeeAtchison/src/images/books/` into
`shared/images/books/` with `git mv` so history follows them, and delete the
two duplicates under `AtchisonAcademy/src/images/books/` — they are
byte-identical to the ones being moved (md5 verified 2026-08-31), so nothing is
lost. Verify the hashes again at implementation time rather than trusting this
line; if either has diverged since, stop and ask which copy is canonical.

Create `shared/images/courses/` with a `.gitkeep` so the symlinks in §2 have a
target that exists before Spec0020 puts anything in it. A symlink to a missing
directory is a build failure, not an empty section.

### 2. Symlink both sites at both directories

Four symlinks, matching the pattern Spec0008 established for `src/_books` and
`src/_courses`:

```
LeeAtchison/src/images/books      -> ../../../shared/images/books
LeeAtchison/src/images/courses    -> ../../../shared/images/courses
AtchisonAcademy/src/images/books  -> ../../../shared/images/books
AtchisonAcademy/src/images/courses -> ../../../shared/images/courses
```

Three levels up, not two: the link sits in `<Site>/src/images/`, one directory
deeper than the collection symlinks in `<Site>/src/`. Getting this wrong
produces a dangling link that `ls` reports and the build does not.

Git stores these as mode 120000 and Netlify checks them out with the rest of
the repo, exactly as it already does for the collections, so dev and deploy
both see real files and both sites' watchers follow them.

### 3. Nothing else changes — which is the point

- **No `cover_image` value changes.** Every path stays
  `/images/books/<slug>.<ext>`. The symlink preserves the URL, so Bridgetown
  emits the same `output/images/books/…` on both sites and every rendered
  `<img src>` is byte-identical to today's.
- **No template or stylesheet changes.** `books.erb`, `book.erb`, both
  `index.erb`s, and Spec0016's band all keep working untouched.
- **No `shared_content.rb` involvement.** Images are not resources; the builder
  never sees them.
- **Per-site images stay per-site.** `logo-academy.png`, `learners-badge.png`,
  `pets404.png`, `og-card.png`, `favicon.png`, `lee-atchison.png`,
  `sai-logo.png` and `logo.svg` all stay in each site's own `src/images/`.
  Three of them are byte-identical across the two sites and are *not* moved
  here (decided 2026-08-31) — see Open Question 2.

### 4. The one real cost

After this, **both sites publish all four book covers**, including the two that
only leeatchison.com renders (`architecting-for-scale.jpg`,
`overcoming-it-complexity.png` — about 190KB together). Nothing links to them
on atchisonacademy.com, so they are unreferenced files on a CDN, not pages: no
sitemap entry, no crawl path, no user-visible effect.

The alternative — filtering the shared tree per site at build time — would mean
a builder that reads front matter to decide which image files to copy, which is
real machinery guarding 190KB. Rejected. Recorded so the extra files in
`output/` are recognized as intended rather than as a bug during review.

### 5. Netlify

`AtchisonAcademy/netlify.toml` line 29 already reads:

```
ignore = "git diff --quiet $CACHED_COMMIT_REF $COMMIT_REF -- ':(top)AtchisonAcademy' ':(top)shared'"
```

`':(top)shared'` covers `shared/images/` as well as the collections, so a cover
swapped under `shared/` still triggers both sites' production builds. Bug0001
is the reason that line exists; this spec is the second thing to depend on it,
which is worth knowing if it is ever narrowed. `LeeAtchison/netlify.toml`
carries the matching rule for its own directory — confirm both at
implementation time (Testing step 6).

Per the standing repo/Netlify boundary: no Netlify UI, build-setting or DNS
change is part of this spec. Nothing here needs one.

---

## Testing

1. **Both sites build green** from a clean state (`bin/bridgetown clean` then
   build), proving the symlinks resolve at read time and not just in a warm
   cache.
2. **Every book cover renders on both sites** — walk `/books`, the home page,
   and each of the four book detail pages on leeatchison.com, and `/books`,
   the home page and both book pages on atchisonacademy.com. A missing cover
   shows as a broken image, not a build error, so this has to be looked at.
3. **The rendered `<img src>` values are unchanged.** Diff the built
   `output/` HTML against a pre-change build: there should be **zero** HTML
   differences on either site. That is the strongest statement this spec can
   make about itself.
4. **`output/images/books/` contains the four covers on both sites**, including
   the two extras on Academy (§4).
5. **The symlinks are committed as symlinks.** `git ls-files -s` shows mode
   `120000` for all four, and `git show HEAD:<path>` prints the target string,
   not image bytes. A symlink accidentally committed as a real directory
   silently re-creates the duplication this removes — the same trap CLAUDE.md
   already warns about for `src/_books`.
6. **Both `netlify.toml` ignore rules include `shared`** (§5).
7. **A fresh worktree works.** Create one, run its `bundle install` and
   `npm install`, and build both sites — worktrees are separate checkouts, so
   this proves the relative symlink targets resolve from any checkout location
   and not just this one.

`rake test` (port derivation) is unaffected but should still pass.

---

## Summary of Steps Needed

1. `git mv` the four covers from `LeeAtchison/src/images/books/` to
   `shared/images/books/` (§1).
2. Re-verify the two Academy duplicates are byte-identical, then delete them
   (§1).
3. Create `shared/images/courses/` with a `.gitkeep` (§1).
4. Replace `<Site>/src/images/books` with a symlink and add
   `<Site>/src/images/courses`, in both sites — four links (§2).
5. Confirm both `netlify.toml` ignore rules cover `shared` (§5).
6. Add the shared-images arrangement to the `shared/` section of the repo-root
   `CLAUDE.md` and to each site's own CLAUDE.md where the collection symlinks
   are documented — including the "never replace a symlink with a real
   directory" warning, which now applies to four more paths.
7. Work through Testing, including the zero-HTML-diff check and the worktree
   check.

---

## Open Questions

**None.** All three questions raised during refinement are answered below.

1. **Should `shared/images/` hold anything besides `books/` and `courses/`?**
   *(Answered: no.)* Lee scoped this to "main images for books and courses",
   and keeping the tree to exactly those two keeps its meaning obvious: it holds
   art for the shared collections.

2. **What about the three non-collection images already duplicated
   byte-identically?** *(Answered 2026-08-31: leave them.)* `logo-academy.png`,
   `learners-badge.png` and `pets404.png` are the same file on both sites. They
   are site chrome rather than collection art, so sharing them does not follow
   from this spec's reasoning, and moving them would cost this spec its
   strongest property — that it changes zero rendered bytes. The residual risk
   is real and worth naming: `learners-badge.png` carries a number that has
   already been corrected on both sites once (Spec0011), and nothing stops the
   two copies diverging again. If one ever does, that is the moment to raise a
   `shared/images/site/` spec.

3. **Should the six books with no `cover_image` get one?** *(Answered
   2026-08-31: not now.)* `97-things-cloud-engineer`, `97-things-infosec`,
   `architecting-a-cloud-security-strategy`, `caching-at-scale-with-redis`,
   `identity-in-modern-applications` and `what-is-polycloud` keep rendering as
   icon-only `.secondary-book-card`s. This spec moves art; it does not
   commission it.

---

## History of Updates

**2026-08-31 — Spec created**, from Lee's request to put the main book and
course images in `shared/` so both sites can read them. Written against commit
`bd0d672`.

**2026-08-31 — Found: only two files are duplicated today, and they are
byte-identical.** `the-software-conductor.png` and `business-breakthrough-3.jpg`
match by md5 across the two sites, so the merge loses nothing and needs no
"which copy wins" decision. The other two covers exist only on leeatchison.com.

**2026-08-31 — Found: no front-matter change is needed.** Because
`cover_image` is already a site-relative `/images/books/…` path and the symlink
preserves it, this spec can be verified by asserting the built HTML does not
change at all — which became Testing step 3 and the spec's strongest check.

**2026-08-31 — Noted: ordering against Spec0020.** That spec adds course card
images for six featured courses. If it ships first, those files land in two
per-site trees and have to be deduplicated afterward. This spec should go
first.

**2026-08-31 — Decided: accept publishing two unused covers on Academy.**
Filtering the shared image tree per site would need a builder reading front
matter to decide which files to copy — real machinery to save about 190KB of
unreferenced CDN assets. Recorded in §4 so the extra files are not read as a
mistake at review.

**2026-08-31 — Decided: the three duplicated site-chrome images stay per-site.**
Asked alongside the other art questions. Sharing them would widen this spec past
its zero-rendered-bytes claim for images that are not collection art. The
`learners-badge.png` drift risk is recorded in Open Question 2 as the trigger
for revisiting.

**2026-08-31 — Decided: no covers for the six coverless books.** They stay in
the icon-only secondary tier. Keeps this spec's scope to relocating art that
already exists.

**2026-08-31 — Spec fully refined.** No open questions remain; ready for
implementation whenever Lee moves it. Ordering constraint stands: this ships
before Spec0020.

**2026-09-01 — Moved to Implementing.** Hashes re-verified at implementation
time (identical to the 2026-08-31 values), so the two Academy duplicates were
deleted with no "which copy wins" decision needed. Both `netlify.toml` ignore
rules were already confirmed to cover `shared`. Implemented on branch
`claude/spec0019-implementation-kmca2u`: the four covers moved into
`shared/images/books/` via `git mv`, `shared/images/courses/.gitkeep` added,
and all four symlinks created. Both sites rebuilt clean and the built
`output/` HTML diffed byte-for-byte against a pre-change build — zero
differences on leeatchison.com, and on atchisonacademy.com the only
difference is the two extra covers landing in `output/images/books/` as
expected (§4). Relative-symlink resolution from a different absolute path
was verified directly rather than via a full fresh-worktree bundle/npm
install. `CLAUDE.md` updated at the repo root and in both sites.

**2026-09-01 — Moved to Verifying.** Lee said "create a PR" —
[PR #24](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/24)
opened against `main`. Subscribed to PR activity to track CI and Netlify
deploy previews.

**2026-09-01 — Merge conflict resolved.** While this PR was open, PR #22
(Spec0017) merged to `main`, closing Spec0017 and editing the same
Refinement table in `Projects/_Project Tracker.md`. Merged `main` into this
branch and combined both edits by hand: Refinement keeps Spec0018,
Spec0020, and Spec0021, renumbered 1–3. Both sites rebuilt clean afterward
and `make test` passed.

**2026-09-01 — Closed and archived.** Lee confirmed the spec complete.
Both Netlify deploy previews (leeatchison, atchisonacademy) came back
green with no unexpected diffs. Moved to `zArchive/`.
