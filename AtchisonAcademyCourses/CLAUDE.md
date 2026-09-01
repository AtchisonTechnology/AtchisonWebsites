# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this site is

The **unlisted** course-content site behind Atchison Academy's purchased
courses — the videos, readings, and resource lists a purchaser works through
after buying a course at atchisonacademy.com. Built with **Bridgetown 2.1.2**,
ERB templates, esbuild, and PostCSS. Deployed on Netlify at
**courses.atchisonacademy.com** (Spec0021).

**This site does not join the repo-root `shared/` collections.** Unlike
`LeeAtchison` and `AtchisonAcademy`, it carries no symlinks into `shared/`
and no `show_`/`feature_`/`order_`/`canonical_site` front-matter keys — its
`courses` and `lessons` collections are this site's own content, not
marketing metadata. The only thing it reads from `shared/` is a read-only
filename check (see **Purchase-link derivation** below).

## Unlisted, not access-controlled

There is no login and no gating. Anyone who has a URL can open and share it
— that is an accepted trade-off, not a bug; real gating (Netlify password
protection, basic auth, a gated platform) is a follow-on spec if ever
needed. Concretely:

- **No index page at the root URL (`/`).** `src/index.erb` is a minimal page
  that says nothing about courses and links to atchisonacademy.com — so a
  stray visitor, or a purchaser who trims their URL down to the domain,
  lands somewhere that looks intentional rather than broken.
- **The catalog of every course lives at a random slug**
  (`src/catalog.erb`, currently `/dga8c6isac/`) — Lee's private bookmark,
  not a public directory. It is not linked from anywhere else on the site.
- **Each course's index lives at `/<course_id>/<secret>/`**, with a random
  secret generated once per course and never regenerated (regenerating one
  is a deliberate re-key that breaks every purchaser's bookmark). Lessons
  sit under that path with no secret of their own
  (`/<course_id>/<secret>/<module>x<lesson>/`) — they inherit unlistability
  from the course.
- **No `sitemap.xml` at all** — the file simply does not exist in `src/`,
  so nothing generates one. **`robots.txt`** (`src/robots.txt.erb`)
  disallows everything, with no `Sitemap:` line.
- **Belt-and-suspenders `noindex`**: `_head.erb` emits
  `<meta name="robots" content="noindex, nofollow">` on every page, and
  `netlify.toml` sends an `X-Robots-Tag: noindex, nofollow` header
  site-wide — because `Disallow: /` only stops a compliant crawler from
  *fetching* a page, which means it never sees a page-level noindex either.
- **Minimal `_head.erb`**: no canonical tag, no Open Graph / Twitter card —
  nothing that makes a shared link unfurl into something worth clicking.
- **No navbar.** `_layouts/default.erb` is just `<head>` → `<main>` →
  footer; there is nothing here to navigate to except a course you already
  have the link for.

## Source layout

```
src/
  index.erb                # Root (/) — minimal, links out to atchisonacademy.com, no course info
  catalog.erb               # Lee's private course listing, random-slug permalink
  robots.txt.erb            # Disallow: / for all agents, no Sitemap: line
  404.html / 500.html       # Error pages
  favicon.ico                # Empty placeholder (real icon is images/favicon.png)
  _layouts/
    default.erb              # <head> -> <main> -> footer. No navbar.
    course.erb                # Course index: header/cover, welcome prose, module outline, sharing notice
    lesson.erb                 # THE standard lesson template — every lesson renders through this
  _partials/
    _head.erb                  # Minimal head: title, viewport, favicon, CSS/JS, noindex meta, Fathom
    _footer.erb                 # Site footer
    _sharing_notice.erb          # Do-not-share band + purchase link; rendered by course.erb and lesson.erb
    _lesson_outline.erb           # Module/lesson list; rendered by lesson.erb's sidebar AND its mobile <details>
  _data/
    site_metadata.yml            # title, description
  _courses/                      # One file per course (own content, no shared/ symlink)
  _lessons/<course-id>/          # One file per module/lesson pair
  images/
    favicon.png, pets404.png      # Reused from AtchisonAcademy (shield favicon, pets404 art)
    courses/<course-id>/           # Cover art + any in-lesson images for that course
frontend/
  styles/index.css                 # Fresh, purpose-built CSS starting from AtchisonAcademy's tokens
  styles/syntax-highlighting.css     # Code syntax highlighting (copied, in case a text lesson embeds code)
  javascript/index.js                 # Just the CSS/component imports — no nav-toggle JS, nothing to toggle
plugins/builders/
  course_content.rb                    # Validation builder — see below
```

## Content model

### Courses (`src/_courses/<course-id>.md`)

```yaml
---
layout: course
course_id: sample-course          # must equal the shared/_courses/<slug>.md filename, unless purchase_url overrides
secret: woid9w8d99                 # random, >= 8 chars, generated once, NEVER regenerated
title: Sample Course
description: One-paragraph description shown on the course index.
cover_image: /images/courses/sample-course/cover.png   # optional
purchase_url: https://...          # optional override — see Purchase-link derivation
permalink: /sample-course/woid9w8d99/     # must equal /<course_id>/<secret>/
modules:
  - number: 1
    title: Getting Started
  - number: 2
    title: Going Deeper
---
Optional welcome prose for the course index page.
```

Generate a secret with:

```sh
ruby -rsecurerandom -e 'puts SecureRandom.alphanumeric(10).downcase'
```

### Lessons (`src/_lessons/<course-id>/<m>x<l>-<slug>.md`)

```yaml
---
layout: lesson
course: sample-course             # must name an existing course's course_id
module: 1                          # must be declared on that course's modules list
lesson: 2
title: Title of this lesson
content_type: video                # video | text | resources
vimeo_id: 800363806                 # video lessons only — numeric Vimeo video ID (not a URL)
resources:                          # resources lessons only — non-empty
  - title: Resource name
    url: https://...
    note: One-line description
permalink: /sample-course/woid9w8d99/1x2/   # must equal <course permalink> + <module>x<lesson>/
---
Body: the document itself for `text` lessons (images under
src/images/courses/<course-id>/); optional intro/notes for `video` and
`resources` lessons.
```

`lesson.erb` builds the Vimeo embed itself from `vimeo_id` — Vimeo's standard
responsive markup (padding-box wrapper, iframe at
`https://player.vimeo.com/video/<vimeo_id>`, `player.js`) — a course author
never touches embed HTML. This is the placeholder-course answer for video
hosting; the general answer for real courses (native `<video>` vs a different
platform) is still open per Spec0021 Open Question 2.

### Purchase-link derivation

The sharing notice on every course page links to that course's purchase page
on the *marketing* site:

```
purchase_url = course.data.purchase_url || "https://atchisonacademy.com/courses/#{course_id}/"
```

— computed by the `course_purchase_url` helper (defined in
`plugins/builders/course_content.rb`), always using the production
`atchisonacademy.com` literal, never a deploy-preview URL. Set
`course_id` equal to the marketing course's `shared/_courses/<slug>.md`
filename and the link derives itself; set `purchase_url` explicitly to
override (required for a course with no marketing page, like the
placeholder). The builder fails the build if a course has no override and no
matching `shared/_courses/<course_id>.md` file exists — that is the *only*
thing this site reads from `shared/`, and it's read-only.

## Validation builder (`plugins/builders/course_content.rb`)

Fails the build, loud, in the house style of `AtchisonAcademy`'s
`shared_content.rb`, when:

- a course is missing `course_id`, `secret` (< 8 chars), `title`, or
  `permalink`, or its permalink disagrees with `/<course_id>/<secret>/`;
- two courses share a `course_id` or a `secret`;
- a course sets `cover_image` but no matching file exists under `src/`;
- a course has no `purchase_url` override and no matching
  `shared/_courses/<course_id>.md` file;
- a lesson names a `course` that doesn't exist, duplicates another lesson's
  `<module>x<lesson>` pair, has a `module` not declared on its course, has an
  invalid `content_type`, is `video` without a numeric `vimeo_id`, or is
  `resources` without a non-empty `resources` list;
- a lesson's permalink disagrees with `<course permalink> + <m>x<l>/`.

It also defines two template helpers: `course_purchase_url(course)` (above)
and `course_lessons(site, course)` — that course's lessons, sorted by
`(module, lesson)`, which `course.erb` and `lesson.erb` both use for the
module outline and prev/next navigation.

## Adding a real course

1. Generate a secret (command above).
2. Add `src/_courses/<course-id>.md` — `course_id` matching the marketing
   site's `shared/_courses/<slug>.md` filename (or set `purchase_url`
   explicitly), the generated `secret`, and a `modules` list.
3. Add one `src/_lessons/<course-id>/<m>x<l>-<slug>.md` file per lesson.
4. If the course has cover art, drop it under
   `src/images/courses/<course-id>/` and set `cover_image`.
5. Run the site (`bin/dev`) — the validation builder catches a typo'd
   permalink, an orphaned lesson, or a broken `cover_image`/purchase link
   immediately, as a build failure rather than a silently broken page.
6. Add the catalog entry — nothing to do; `catalog.erb` lists every course in
   the collection automatically.

## Dev port

Site index 6 in the monorepo: `18000` on `main`, `18000 + N` in a
`spec####` worktree, `19000 + N` in a `bug####` worktree. `bin/dev` and
`config/puma.rb` re-derive it from `../lib/worktree_env.rb`. See
`../Projects/services.md`.

## Netlify / DNS

`netlify.toml` here creates no site by itself — Netlify site creation and the
`courses.atchisonacademy.com` DNS record are Lee's to do by hand, per the
established process boundary (Spec0004 and every site since). Until that's
done this site exists only in local dev and on ad hoc Netlify previews.
Unlike `AtchisonAcademy`/`LeeAtchison`, this `netlify.toml` has **no**
`[build] ignore` command — this site does not read `shared/` content (only a
read-only filename check at build time), so Netlify's default build-skip
diff, scoped to this site's own base directory, is already correct; see
Bug0001/Bug0002 for why the two shared-content sites need the widened
pathspec and this one does not.
