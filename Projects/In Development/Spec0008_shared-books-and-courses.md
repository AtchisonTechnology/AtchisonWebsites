# Share the books and courses collections between leeatchison.com and atchisonacademy.com

* **ID:** Spec0008
* **Status:** Implementing
* **Date Created:** 2026-08-29
* **Date Implemented:** —
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy`

---

## Problem/Requirement

`LeeAtchison` and `AtchisonAcademy` each carry their own `src/_books` and
`src/_courses` collections. Ten of those files exist in both sites and are
today **byte-identical duplicates**:

* `_books/business-breakthrough-3.md`, `_books/the-software-conductor.md`
* eight of the twelve courses

Every edit to a shared book or course has to be made twice, by hand, in two
directories. Nothing enforces that the two copies stay the same, and nothing
reports it when they drift. The duplication was created deliberately when
Spec0005 stood up the standalone Academy site; it was the right move then and
is the wrong one to keep.

There is a second, related problem. Which items appear where — and in what
order — is currently expressed inconsistently:

* **membership** — by which directory the file happens to sit in, plus an
  `academy: true` key that duplicates the same fact
* **featuring on leeatchison.com** — `featured: true`
* **featuring on atchisonacademy.com** — `academy_featured: true`, which
  `AtchisonAcademy/src/index.erb` reads but `AtchisonAcademy/src/courses.erb`
  and `books.erb` do not — those two pages read `featured`, which is Lee's
  flag. The Academy's own course and book index pages are therefore featuring
  by Lee's editorial choices, not the Academy's.
* **ordering** — a single `order`, so the Academy has no way to sequence its
  own shelf.

The requirement: **one copy of each book and course**, with front matter — not
directory placement — deciding which site shows it, which site features it,
and in what order each site presents it, with a parallel key per site.

---

## Solution/Fix/Change

Three parts: a shared folder, a symmetric per-site key scheme, and a per-site
read-time filter.

### 1. One shared folder, reached by symlink

Create a single canonical home at the repo root:

```
shared/
├── _books/       # 10 files
└── _courses/     # 12 files
```

and replace each site's collection folder with a symlink to it:

```
LeeAtchison/src/_books        -> ../../shared/_books
LeeAtchison/src/_courses      -> ../../shared/_courses
AtchisonAcademy/src/_books    -> ../../shared/_books
AtchisonAcademy/src/_courses  -> ../../shared/_courses
```

**Why symlinks and not a config setting.** Bridgetown has no per-collection
source path, and `collections_dir` is resolved inside the site's `src`, so it
cannot point at a sibling directory. The symlink is the only zero-code way to
give two sites one set of files.

**Why this is safe.** `Bridgetown::Collection` (2.1.2) reaches a collection
folder through `File.directory?`, then `Dir.exist?` and `Dir.chdir` inside
`Utils.safe_glob` before globbing `**/*`. All four follow a symlinked
directory. The `**` glob's refusal to descend into symlinked *sub*directories
never comes into play, because the symlink is the collection root itself, not
something nested below it.

Git stores symlinks natively and Netlify checks them out with the rest of the
repo, so both dev and deploy see real files. Netlify's per-site base directory
does not restrict this — the whole repo is cloned regardless of which
subdirectory the build runs in.

### 2. Parallel per-site front matter keys

Replace `academy`, `featured`, `academy_featured` and `order` with three
symmetric pairs, present on both books and courses:

| Key | Meaning |
|---|---|
| `show_leeatchison` | The item appears on leeatchison.com |
| `show_academy` | The item appears on atchisonacademy.com |
| `feature_leeatchison` | The item is featured on leeatchison.com |
| `feature_academy` | The item is featured on atchisonacademy.com |
| `order_leeatchison` | Sort position on leeatchison.com |
| `order_academy` | Sort position on atchisonacademy.com |

Rules:

* The `show_*` and `feature_*` keys are booleans. **Absent means `false`**, so
  only `true` is ever written — no `false` lines to maintain.
* `feature_*` and `order_*` are only meaningful when the matching `show_*` is
  true, and are written only on items that carry it. A `feature_academy: true`
  or `order_academy:` on a non-Academy item is a content error, and the build
  should surface it (see Testing).
* `order_*` values are per-site and independent. They start out identical for
  the items both sites carry, which means the Academy's sequence begins as a
  subsequence of Lee's, with gaps — that sorts correctly, and either site can
  be re-sequenced later without touching the other.
* The bare `order` key is retired entirely; nothing reads it after this spec.
* Nothing else about the schema changes: `platform`, `summary`,
  `cover_image`, `badge` and the rest stay as they are.

Adding a third site later means adding a third set of three keys, not
restructuring anything.

### 3. A per-site read-time filter

Filtering only in the page templates is not sufficient: the collection would
still generate a `/courses/:slug/` or `/books/:slug/` page on **both** sites
for **all** 22 items, and both sitemaps would list them. The filter has to run
when the collection is read.

Each site gets one builder — same file, one word different:

```ruby
# LeeAtchison/plugins/builders/shared_content.rb
class SharedContent < SiteBuilder
  SHOW_FLAG = :show_leeatchison   # :show_academy in AtchisonAcademy

  def build
    hook :site, :post_read do |site|
      %w[books courses].each do |label|
        site.collections[label].resources.select! { |r| r.data[SHOW_FLAG] }
      end
    end
  end
end
```

`site.resources` is derived from the collections on every call, so removing a
resource here removes its page, its sitemap entry, and its appearance in every
"more courses"/"other books" list — no template in either site has to know the
filter exists.

### 4. Template updates

With membership handled at read time, the page templates deal only with
featuring and ordering:

| File | Change |
|---|---|
| `LeeAtchison/src/courses.erb` | `featured` → `feature_leeatchison`; sort on `order_leeatchison` |
| `LeeAtchison/src/books.erb` | `featured` → `feature_leeatchison`; sort on `order_leeatchison` |
| `AtchisonAcademy/src/courses.erb` | `featured` → `feature_academy`; sort on `order_academy` |
| `AtchisonAcademy/src/books.erb` | `featured` → `feature_academy`; sort on `order_academy` |
| `AtchisonAcademy/src/index.erb` | drop the now-redundant `.select { .data.academy }` on both collections; `academy_featured` → `feature_academy`; sort on `order_academy` |

The existing `|| 99` fallback stays, so an item missing its site's `order_*`
sorts last rather than raising.

The `book.erb` and `course.erb` layouts enumerate their collection for the
related-items strips but read no membership, featuring or order key, so they
need no change.

### 5. Front matter migration

Derived from the current files. `show_leeatchison: true` on all 22, since
every item is on Lee's site today, and `order_academy` starts equal to
`order_leeatchison` on every item the Academy carries.

**Books** (all 10 keep `show_leeatchison: true`):

| File | order_lee | show_academy | order_academy | feature_lee | feature_academy |
|---|---|---|---|---|---|
| `the-software-conductor` | 1 | ✅ | 1 | ✅ | ✅ |
| `architecting-for-scale` | 2 | | — | ✅ | |
| `business-breakthrough-3` | 3 | ✅ | 3 | ✅ | ✅ |
| `overcoming-it-complexity` | 4 | | — | ✅ | |
| `architecting-a-cloud-security-strategy` | 5 | | — | | |
| `caching-at-scale-with-redis` | 6 | | — | | |
| `97-things-cloud-engineer` | 7 | | — | | |
| `97-things-infosec` | 8 | | — | | |
| `identity-in-modern-applications` | 9 | | — | | |
| `what-is-polycloud` | 10 | | — | | |

**Courses** (all 12 keep `show_leeatchison: true`; none is featured on Lee's
site today, and none becomes so here):

| File | order_lee | show_academy | order_academy | feature_academy |
|---|---|---|---|---|
| `cloud-architecture-for-scalable-systems` | 1 | ✅ | 1 | ✅ |
| `scalable-availability-software-architecture` | 2 | ✅ | 2 | ✅ |
| `software-architecture-developer-to-architect` | 3 | ✅ | 3 | ✅ |
| `cloud-migration-fundamentals` | 4 | ✅ | 4 | ✅ |
| `avoiding-bad-decisions-cloud-strategy` | 5 | ✅ | 5 | |
| `cloud-architecture-advanced-concepts` | 6 | ✅ | 6 | |
| `cloud-careers-developer-to-architect` | 7 | | — | |
| `cloud-center-of-excellence` | 8 | | — | |
| `framing-cloud-discussions-c-suite` | 9 | ✅ | 9 | |
| `presenting-cloud-migration-benefits` | 10 | | — | |
| `understanding-impact-merger-it-teams` | 11 | ✅ | 11 | |
| `understanding-value-cloud-native` | 12 | | — | |

The old `academy`, `academy_featured`, `featured` and `order` keys are deleted
in the same edit.

**One intended behavior change falls out of this** (confirmed — see Open
Question 2): atchisonacademy.com's `/courses` page currently features nothing,
because it filters on `featured` and no course carries it. After the change it
features the four courses marked `feature_academy` — the same four the Academy
home page already features.

---

## Testing

Local, both sites running (`LeeAtchison/bin/dev`, `AtchisonAcademy/bin/dev`):

1. **Symlink resolution.** Both sites build clean. `output/` contains
   `/books/<slug>/` and `/courses/<slug>/` pages.
2. **Counts.** leeatchison.com: 10 book pages, 12 course pages.
   atchisonacademy.com: 2 book pages, 8 course pages — and *no* page for an
   item it should not carry (spot-check `/courses/cloud-center-of-excellence/`
   returns a 404 on the Academy build).
3. **Sitemaps.** Each site's `sitemap.xml` lists only its own items. This is
   the check that proves the filter runs at read time and not just in the
   templates.
4. **Featuring.** leeatchison.com `/books` features the same four books as
   before; `/courses` features none, as before. atchisonacademy.com `/books`
   features both; `/courses` features the four `feature_academy` courses; the
   Academy home page is unchanged.
5. **Ordering.** Both sites' `/books` and `/courses` list in the same sequence
   as before the change — the Academy's ordering is unchanged by the gaps in
   its `order_academy` values. Then, as a one-off proof the pair is really
   independent: swap two `order_academy` values, confirm only the Academy
   reorders, and revert.
6. **Related-item strips.** A course page's "More Courses by Lee" strip on the
   Academy build offers only Academy courses; same for the book strip.
7. **Live edit.** Change a title in `shared/_courses/…` with both dev servers
   running and confirm both sites rebuild and show it. If Bridgetown's watcher
   does not follow the symlink, that is a dev-loop annoyance to note, not a
   build failure — record the finding either way.
8. **Key hygiene.** `grep -rn "^academy:\|^academy_featured:\|^featured:\|^order:" shared/`
   returns nothing, and no item carries `feature_academy` or `order_academy`
   without `show_academy`.
9. **Deploy previews.** Netlify preview builds for both sites succeed, which
   is what proves the symlink survives a fresh clone in CI.

---

## Summary of Steps Needed

1. Create `shared/_books` and `shared/_courses` at the repo root; `git mv` the
   canonical copies out of `LeeAtchison/src` into them.
2. Delete `AtchisonAcademy/src/_books` and `src/_courses` (the 10 duplicates).
3. Create the four symlinks; confirm `git` records them as symlinks
   (mode 120000), not as copied directories.
4. Rewrite front matter across all 22 files per the migration tables.
5. Add `plugins/builders/shared_content.rb` to each site.
6. Update the five templates.
7. Run the test list above on both sites.
8. Update `CLAUDE.md` at the repo root (a `shared/` entry and what it is) and
   both sites' `CLAUDE.md` (their books/courses collections are symlinks into
   `shared/`, and the six per-site keys).

---

## Open Questions

1. ~~**Folder name — `shared/` or `shared_data/`?**~~ **Decided 2026-08-29:**
   `shared/`, with the collections directly inside it. `shared_data` reads as
   Bridgetown `_data` — YAML config consumed by templates — which is not what
   these are; they are content resources.

2. ~~**The Academy `/courses` featuring change.**~~ **Decided 2026-08-29:**
   accepted. The four `feature_academy` courses become featured on
   atchisonacademy.com/courses, matching what the Academy home page already
   does. This is the flags finally being honored, not a change of editorial
   intent.

3. ~~**Should `order` be per-site too?**~~ **Decided 2026-08-29:** yes —
   `order_leeatchison` and `order_academy`, set up now rather than retrofitted
   later. Both start with the same values; the bare `order` key is retired.

4. ~~**Should the other four sites participate?**~~ **Decided 2026-08-29:**
   not in the foreseeable future, though it is likely eventually. `stosa`,
   `ArchitectingForScale`, `BusinessBreakthrough30` and `TheSoftwareConductor`
   define no books/courses collections and are out of scope here. The key
   scheme is what keeps the door open: a fifth site joins by adding its own
   `show_`/`feature_`/`order_` set, its two symlinks and its builder, with no
   change to existing content or to the two sites in this spec.

5. ~~**Does anything outside the repo read these paths?**~~ **Decided
   2026-08-29:** no. Nothing outside the repo is expected to write into these
   folders, so the move needs no coordination beyond the repo itself.

---

## History of Updates

**2026-08-29 — Spec created.** Originated from Lee's question about whether
two Bridgetown sites can share markdown collections. Investigated first,
then wrote this up:

* Confirmed all 10 overlapping files are currently byte-identical, so this is
  de-duplication rather than a merge.
* Confirmed against `bridgetown-core` 2.1.2 source that a symlinked collection
  directory is read normally (`File.directory?` → `Dir.exist?` → `Dir.chdir` →
  `Dir.glob`, all of which follow symlinks). Rejected `collections_dir`, which
  cannot escape `src`. Considered and set aside two alternatives: a build-time
  copy step (adds generated files and breaks the dev watch loop) and a
  gem-based Bridgetown source manifest (framework-blessed, but a gem, a
  `Gemfile` entry per site and an initializer to solve what one symlink
  solves).
* Established that template-level filtering alone is insufficient — resource
  pages and sitemap entries are generated per collection regardless of what
  the index templates render — which is why the `:site, :post_read` builder is
  part of the design rather than an optimization.
* Lee asked for parallel per-site flags rather than the existing asymmetric
  `academy` / `featured` / `academy_featured` scheme.
* Found in passing that `AtchisonAcademy/src/courses.erb` and `books.erb`
  feature on `featured`, Lee's flag, rather than `academy_featured` — an
  existing inconsistency this spec resolves. Raised as Open Question 2 because
  fixing it changes a live page.

**2026-08-29 — Open Questions 1–3 answered by Lee.** Folder name is `shared/`.
The Academy `/courses` featuring change is accepted. Ordering joins the
symmetric scheme as `order_leeatchison` / `order_academy` — Lee's reasoning
was to set it up right now rather than retrofit it when the Academy first
wants its own sequence. Solution §2, §4 and §5, Testing item 5, and Step 8
updated accordingly; the bare `order` key is now retired rather than kept.

**2026-08-29 — Open Questions 4–5 answered by Lee; spec fully refined.** Other
sites may adopt this eventually but not in the foreseeable future, so scope
stays at the two sites — the per-site key scheme already makes a later
addition additive. Nothing outside the repo writes into the collection
folders, so no external coordination is needed. No open questions remain.

**2026-08-29 — Moved to Implementing** at Lee's direction. Spec content is
frozen from here; changes of scope start a new spec.
