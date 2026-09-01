# Create the AtchisonAcademyCourses site — unlisted course content at courses.atchisonacademy.com

* **ID:** Spec0021
* **Status:** In Development
* **Date Created:** 2026-09-01
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** AtchisonAcademyCourses (new, site index 6), plus
  repo-root shared infrastructure (`lib/worktree_env.rb`,
  `test/worktree_env_test.rb`, `Procfile`, `CLAUDE.md`,
  `Projects/services.md`, `.worktreeinclude`). **No changes to any existing
  site, and no changes to `shared/` or its builders** (see Open Question 3).

---

## Problem/Requirement

atchisonacademy.com is the Academy's marketing site: it describes courses and
links out to the platforms that host them. The Academy-native courses,
however, need a place where the **actual course content** lives — the videos,
readings, and resource lists a purchaser works through. That place does not
exist yet.

This spec creates it: a seventh Bridgetown site in the monorepo,
`AtchisonAcademyCourses/`, to be hosted at **courses.atchisonacademy.com**.

The site is deliberately **unlisted** — reachable only by someone who has been
given a URL (typically a purchaser). Concretely:

* **No index page at the root URL (`/`).** The root gives nothing away.
* **The catalog of courses lives at a random slug** (e.g. `/so29disozi/`) —
  one private bookmark for Lee, not a public directory.
* **Each course's index lives at `/<course-id>/<secret>/`** with a random
  secret per course (e.g. `/sample-course/woid9w8d99/`), so knowing one
  course's URL reveals nothing about any other course.
* **No `sitemap.xml` at all**, and a **`robots.txt` that disallows
  everything**, so well-behaved crawlers never fetch a page.

Within a course there is an index page plus one page per **module/lesson
pair**. Every lesson page is created from one standard template and is one of
three content types: a **video**, a **text document** (prose with images), or
a **list of resources**. All layout and styling ship in this spec, designed
for comfortable reading/watching and easy movement between lessons — but the
only course created now is a **placeholder course with fake modules/lessons**;
real courses come later, one content-only change each.

Every page inside a course — the course index and every lesson — must also
carry a **sharing notice**: this content is for the purchaser's personal use
and these pages should not be shared. The notice is paired with the link that
**is** meant to be passed along — the course's purchase/marketing page on
**atchisonacademy.com** (not courses.atchisonacademy.com). The site derives
that purchase URL from the course's `course_id` (see Part 3), so course
authors never type it.

### What "unlisted" is and is not

This is obscurity, not access control. Anyone who has a URL can open it and
share it. That is the accepted trade-off for now; if real gating is ever
needed, that is a follow-on (Netlify password protection / basic auth /
a gated platform), not part of this spec.

One nuance worth recording: `robots.txt` `Disallow: /` stops compliant
crawlers from *fetching* pages — which also means they never see a page-level
`noindex`. If someone ever publishes a link to one of these URLs, a search
engine could still list the bare URL (without content). The spec adds
belt-and-suspenders `noindex` anyway (header + meta), but the real protection
is that these URLs are only ever handed out privately.

### What this spec deliberately does not do (the Netlify/DNS boundary)

Per the established process boundary, everything at the Netlify and DNS layer
is Lee's to do by hand and out of scope. This spec produces a repo directory
that builds locally and is ready to have a Netlify site pointed at it. It does
not create or configure the Netlify site or its build settings, and it does
not create the `courses.atchisonacademy.com` DNS record/subdomain.

**Ordering constraint:** until Lee does the Netlify-side work, the site exists
only in local dev (and on whatever Netlify preview URL he later creates).
That intermediate state is safe — nothing in this spec touches any live site.
**Open Question 7 asks what, if any, of the Netlify side already exists.**

---

## Solution/Fix/Change

Four parts: register the site with the monorepo's shared infrastructure,
create the site scaffold, build the content model and templates, and add the
placeholder course.

### Part 1 — Register site index 6

Indices are permanent and a new site takes the next unused index.
`AtchisonAcademyCourses` is index **6**, which under the existing scheme
(`8000 + (s-1) * 2000`) gives:

| Index | Site | Live URL | main | `spec####` | `bug####` |
|---|---|---|---|---|---|
| 6 | `AtchisonAcademyCourses` | courses.atchisonacademy.com | 18000 | 18000 + N | 19000 + N |

Files to update (the same checklist Spec0005 followed for index 5):

1. **`lib/worktree_env.rb`** — add `"AtchisonAcademyCourses" => 6` to
   `SERVICES`. The port math needs no change.
2. **`test/worktree_env_test.rb`** — add the site to the `SITES` constant and
   the expected-port hashes, plus block-edge assertions for 18999 / 19999.
   The no-collisions sweep then covers it automatically.
3. **`Procfile`** — add `courses: AtchisonAcademyCourses/bin/dev`.
4. **`CLAUDE.md`** (repo root) — add the site to the repo table and the
   port-derivation table; update "Six independent Bridgetown sites" and the
   "six, indices 0–5" sentence to seven / 0–6. Note in the repo table that
   this site does **not** join the shared collections (if that is the answer
   to Open Question 3).
5. **`Projects/services.md`** — add the row for index 6.
6. **`.worktreeinclude`** — extend the `bundle install` / `npm install`
   comment loop to the new site.

### Part 2 — Create the `AtchisonAcademyCourses/` scaffold

Copy `AtchisonAcademy`'s scaffold (itself copied from `LeeAtchison` in
Spec0005) and change what is site-specific. The standard Bridgetown 2.1.2
scaffold files are copied verbatim; `package.json` changes only its `"name"`.
`bin/dev` and `config/puma.rb` need no edits — registering index 6 in Part 1
is the entire port configuration.

Site-specific files:

| File | What it is here |
|---|---|
| `bridgetown.config.yml` | `courses` and `lessons` collections (see Part 3). No books. |
| `config/initializers.rb` | `template_engine "erb"` plus the Spec0004 context-aware `url` block with `https://courses.atchisonacademy.com` as the production literal |
| `netlify.toml` | AtchisonAcademy's file as the base (no `[[redirects]]`), **plus** an `X-Robots-Tag: noindex, nofollow` entry in the site-wide `[[headers]]` block. Per the Bug0001/Bug0002 lessons, the `[build] ignore` command is included only if the site reads `shared/` (Open Question 3); headers are only verifiable on a deploy, never in local dev |
| `src/robots.txt.erb` | `User-agent: *` / `Disallow: /` — and **no** `Sitemap:` line |
| *(no `src/sitemap.xml.erb`)* | The file simply does not exist; nothing in the scaffold generates a sitemap without it |
| `src/index.*` | **No course index at `/`** — root behavior per Open Question 1 |
| `src/_data/site_metadata.yml` | `title: Atchison Academy Courses`, minimal description |
| `src/_partials/_head.erb` | Minimal head: title, viewport, favicon, CSS/JS, `<meta name="robots" content="noindex, nofollow">`. No canonical, no Open Graph, no social cards — this site must not be attractive to share-unfurl. Analytics per Open Question 4 |
| 404/500 pages, favicon | Copied from AtchisonAcademy (reusing the Academy shield favicon and pets404 art keeps the family resemblance) |

**No `src/_books` / `src/_courses` symlinks into `shared/`, and no
`shared_content.rb` builder** — this site's `_courses` collection is its own
content, not the marketing collection (Open Question 3 confirms). Because it
never shows shared items, the two existing builders' `SITES` registries and
the `canonical_site` rules are untouched.

### Part 3 — Content model and the standard lesson template

**Courses** — `src/_courses/<course-id>.md`, one file per course:

```yaml
---
layout: course
course_id: sample-course
secret: woid9w8d99          # random, generated once, then never changes
title: Sample Course
description: One-paragraph description shown on the course index.
permalink: /sample-course/woid9w8d99/
modules:
  - number: 1
    title: Getting Started
  - number: 2
    title: Going Deeper
---
Optional welcome prose for the course index page.
```

The `permalink` is written out explicitly in front matter (course-id + secret)
rather than derived, so a URL can never silently change out from under a
purchaser. Module numbers/titles live once, on the course file.

**Purchase-link derivation** — the marketing site publishes every course at
`https://atchisonacademy.com/courses/<slug>/`, where `<slug>` is the shared
course file's name. This site requires `course_id` to equal that slug, which
makes the purchase URL derivable with no extra front matter:

```
purchase_url = "https://atchisonacademy.com/courses/#{course_id}/"
```

computed by a small helper the layouts call. An optional `purchase_url`
front-matter key overrides the derivation for any course whose two IDs must
ever diverge (and for the placeholder course, which has no marketing page).
The domain is always the **production** atchisonacademy.com literal — never a
deploy-preview URL — because a share link must point at the real marketing
site even when rendered on a preview.

**Lessons** — `src/_lessons/<course-id>/<m>x<l>-<slug>.md`, one file per
module/lesson pair, using the same `<module>x<lesson>` ID convention as the
course-production process (3x2, 5x1):

```yaml
---
layout: lesson
course: sample-course
module: 1
lesson: 2
title: Title of this lesson
content_type: video        # video | text | resources
video_url: https://...     # video lessons only
resources:                 # resources lessons only
  - title: Resource name
    url: https://...
    note: One-line description
permalink: /sample-course/woid9w8d99/1x2/
---
Body: the document itself for `text` lessons (markdown, images under
src/images/courses/<course-id>/); optional intro/notes for the other types.
```

Lesson URLs sit **under the course's secret path** and get no secret of their
own — they inherit unlistability from the course, and predictable `1x2`-style
paths are exactly what makes prev/next navigation and purchaser bookmarks
sane. The permalink is again explicit in front matter.

**Catalog** — one page, `src/catalog.erb`, with `permalink: /<random>/`
(its own random slug, e.g. `/so29disozi/`): lists every course with title,
description, and a link to its secret index. This is Lee's private bookmark.

**Validation builder** (`plugins/builders/course_content.rb`) — fail loud, in
the house style of the shared-content builders. The build fails when:

* a course is missing `course_id`, `secret` (≥ 8 chars), `title`, or
  `permalink`, or its permalink disagrees with `/<course_id>/<secret>/`;
* two courses share a `course_id` or a `secret`;
* a lesson names a `course` that doesn't exist, duplicates another lesson's
  `<module>x<lesson>` pair, has a `module` number not declared on its course,
  has an invalid `content_type`, is `video` without `video_url`, or is
  `resources` without a non-empty `resources` list;
* a lesson's permalink disagrees with `<course permalink> + <m>x<l>/`;
* a course has no `purchase_url` override and no
  `shared/_courses/<course_id>.md` file exists — meaning the derived purchase
  link would 404. (A read-only filename check against `shared/`; the site
  still does not join the shared collections.)

That is what stops a typo from silently publishing a lesson at a guessable
URL or orphaning it from its course navigation.

### Part 4 — Layouts and styles

Layouts (extending a shared `default.erb`, as the other sites do):

* **`course.erb`** — course index: title, description, welcome prose, then
  the outline grouped by module: each module's title with its lessons listed
  in order, each row showing the lesson number, title, and a small type
  marker (video / text / resources). Every row links to the lesson page.
* **`lesson.erb`** — **the standard template** every lesson page renders
  through; a course author only ever writes front matter + markdown:
  * Header: course title (linked back to the course index) and
    "Module N — Module Title · Lesson NxM".
  * Content area, switched on `content_type`:
    * `video` — responsive 16:9 embed of `video_url`, full content width,
      with the body rendered as notes below it;
    * `text` — the body as a readable document (comfortable measure
      ~70ch, generous line height, styled images with captions);
    * `resources` — the `resources` list as styled cards/rows (title
      linked, note underneath), body as optional intro above.
  * **Prev / next navigation** at top and bottom — derived by sorting the
    course's lessons by (module, lesson); shows the neighboring lesson's
    number and title; first/last lesson link back to the course index.
  * **Course outline** — on wide screens a sidebar listing every module and
    lesson with the current one highlighted; collapses to a
    `<details>`-style "Course contents" block on mobile. Getting anywhere
    in the course is always one click.
* **`_partials/_sharing_notice.erb`** — rendered on the course index **and
  every lesson page** (a compact band above the footer): a friendly
  do-not-share line plus the course's purchase link, shown as a visible,
  copy-friendly URL so it is obvious this is the link to pass along.
  Wording and placement per Open Question 8.

CSS: a fresh `frontend/styles/index.css` that starts from AtchisonAcademy's
design tokens (palette, type scale, spacing) so the site is recognizably the
Academy's, but purpose-built for consumption rather than marketing — no hero
bands or CTA sections; a content column plus outline sidebar, sticky enough
navigation to move between lessons without scrolling hunts, and print-clean
text pages.

### Part 5 — The placeholder course

One clearly-fake course exercising everything, e.g. `sample-course` /
`woid9w8d99` (real random slugs generated at implementation time — see Open
Question 5 — not these documentation examples):

* Module 1 — Getting Started: **1x1** video (placeholder/public video URL),
  **1x2** text (a few paragraphs plus one image).
* Module 2 — Going Deeper: **2x1** text, **2x2** resources (3–4 fake
  entries).

The placeholder course sets `purchase_url:` explicitly (a fake course has no
marketing page — pointing at `https://atchisonacademy.com/courses/` is fine),
which exercises the override path; the sharing notice renders on all five of
its pages.

Plus the catalog page listing it. Content is visibly lorem-flavored so it can
never be mistaken for a real course.

---

## Testing

All local testing on this checkout's derived port (`bin/site-port
AtchisonAcademyCourses`; 18000 on main).

1. `make test` — port-derivation suite passes with seven sites, including
   the 18999/19999 block edges.
2. `bin/dev` boots; `/` shows the decided root behavior (Open Question 1)
   and **not** a course catalog.
3. `/robots.txt` serves the disallow-all file with no `Sitemap:` line;
   `/sitemap.xml` 404s; built `output/` contains no sitemap file.
4. Catalog page at its random slug lists the placeholder course; the course
   index shows both modules and all four lessons in order.
5. Each `content_type` renders correctly (video embed, text document with
   image, resources list).
6. Prev/next walks 1x1 → 1x2 → 2x1 → 2x2 and back; ends link to the course
   index; outline highlights the current lesson; mobile-width outline
   collapses.
7. Sharing notice: present on the course index and all four lesson pages,
   with the purchase link pointing at atchisonacademy.com. Derivation: give a
   temporary test course a `course_id` matching a real shared course file and
   confirm the derived URL; then remove the placeholder's `purchase_url`
   override and confirm the builder fails the build; restore.
8. Validation builder: temporarily break each rule (missing secret, dup
   secret, orphan lesson, bad content_type, video without URL) and confirm
   each fails the build with a clear message; restore.
9. On the eventual deploy preview (Netlify-side work is Lee's): confirm the
   `X-Robots-Tag` header is present and — if a `[build] ignore` command is
   included — that pathspecs use `:(top)` and are simulated from the site
   directory per Bug0002.

---

## Summary of Steps Needed

1. Register index 6: `lib/worktree_env.rb`, its test, `Procfile`, root
   `CLAUDE.md`, `Projects/services.md`, `.worktreeinclude`.
2. Scaffold `AtchisonAcademyCourses/` from AtchisonAcademy; site-specific
   config, netlify.toml with noindex header, disallow-all robots.txt, no
   sitemap, no root index.
3. Collections + validation builder (`courses`, `lessons`,
   `course_content.rb`).
4. Layouts (`course.erb`, `lesson.erb` standard template) and CSS.
5. Placeholder course (4 lessons across 2 modules, all three content types)
   and the random-slug catalog page.
6. Site `CLAUDE.md` documenting the architecture, the secret-URL rules, and
   how to add a real course.
7. Local test pass per Testing above.

---

## Open Questions

1. **Root URL (`/`) behavior.** Options: (a) serve the 404 page; (b) a
   minimal page that says nothing about courses and links to
   atchisonacademy.com. **Recommendation: (b)** — a stray visitor (or a
   purchaser who trims the URL) gets somewhere useful, and it looks
   intentional rather than broken.
2. **Where do lesson videos live?** The repo should not hold `.mp4`s (the
   production pipeline's finals are large, and repo weight is already a
   watched concern). Candidates: the existing Descript publish/share URLs,
   unlisted YouTube/Vimeo embeds, or an external bucket/CDN. The placeholder
   course just needs any embeddable URL; the real answer shapes the `video`
   rendering (native `<video>` tag vs iframe embed) so it should be settled
   before the first real course.
3. **Confirm: this site does not consume `shared/_courses`.** Its course
   files are content, not marketing metadata; keeping it out of the shared
   system means no symlinks, no `show_`/`canonical_site` keys, and no edits
   to the two existing builders' `SITES` registries. Cost: a course's title/
   description are typed here independently of its marketing page. (The
   purchase-link check in Part 3 reads `shared/_courses` file names at build
   time, but that is read-only validation — the collections stay separate.)
   **Recommendation: keep it standalone.**
4. **Analytics.** Include the Fathom snippet like the other sites, or omit
   it? Course-consumption stats seem genuinely useful.
   **Recommendation: include Fathom.**
5. **Secret slug format.** Recommendation: 10 lowercase letters+digits,
   generated once per course (e.g. `ruby -rsecurerandom -e 'puts
   SecureRandom.alphanumeric(10).downcase'`), written into front matter, and
   never regenerated — changing a secret is a deliberate re-key that breaks
   every purchaser's bookmark. Same for the catalog slug.
6. **Directory/site name.** `AtchisonAcademyCourses` as specified — confirm,
   since the index-6 registration makes it permanent.
7. **Netlify/DNS state.** Has any of the Netlify side been done already —
   site created, `courses.atchisonacademy.com` DNS/subdomain configured?
   This only affects how soon a deploy preview can verify item 9 under
   Testing; there is no merge gate either way.
8. **Sharing-notice wording and placement.** Proposed placement: one compact
   band above the footer on every course page (index and lessons). Proposed
   wording, to be tuned: *"This content is part of a purchased course —
   please don't share these pages. Know someone who'd enjoy this course?
   Share this link instead:"* followed by the purchase URL. Firm-but-friendly
   seems right for paying customers; confirm tone and whether the lesson
   pages should also repeat it anywhere else (e.g. under the video).

---

## History of Updates

* **2026-09-01** — Spec created from Lee's request: seventh site at
  courses.atchisonacademy.com for actual course content; unlisted by design
  (no root index, random-slug catalog and course URLs, no sitemap,
  disallow-all robots.txt); standard module/lesson template with
  video / text / resources content types; full layout and styles; placeholder
  course only for now. Open Questions 1–7 recorded; recommendations proposed
  but nothing decided.
* **2026-09-01** — Per Lee: every course page must carry a do-not-share
  notice paired with a shareable link to the course's purchase page on
  atchisonacademy.com, with the purchase URL derived from `course_id`. Added
  the requirement, the derivation rule (`course_id` must equal the marketing
  course's slug; optional `purchase_url` override; always the production
  domain), the builder check that the derived link cannot 404, the
  `_sharing_notice.erb` partial, testing items, and Open Question 8
  (notice wording/placement).
