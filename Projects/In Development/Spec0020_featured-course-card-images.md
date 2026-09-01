# Show a card image on featured courses, as featured books already do

* **ID:** Spec0020
* **Status:** Implementing
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison` (`src/courses.erb`, `src/index.erb`, `frontend/styles/index.css`), `AtchisonAcademy` (`src/courses.erb`, `src/index.erb`, `frontend/styles/index.css`), and `shared/_courses/` (a new front-matter key on the featured courses) plus `shared/images/courses/` (new art).

---

## Problem/Requirement

Featured **books** lead with their cover. Featured **courses** lead with a line
of small uppercase platform text. Side by side on the same page — and on the
Academy home page they are two sections apart, on leeatchison.com's home page
they will be adjacent once Spec0016 lands — the courses read as the lesser
thing, because a card with a picture outweighs a card without one no matter
what the words say.

Nothing about a course prevents it. The `.course-card` markup in all four
templates is: platform badge, `<h3>`, summary, "Learn more →". There is no
image slot because **no course carries an image**. `shared/_courses/` has no
image key at all, and `shared/images/courses/` does not exist until Spec0019
creates it.

Six courses are featured across the two sites today:

| Course | leeatchison.com | atchisonacademy.com |
|---|---|---|
| Risk Management for Scalable Systems | ✅ (1) | — |
| Cloud Architecture for Scalable Systems | ✅ (2) | — |
| Architecting Scalable Applications and Systems | — | ✅ (1) |
| Software Architecture: From Developer to Architect | — | ✅ (2) |
| Cloud Architecture: Advanced Concepts | — | ✅ (3) |
| Cloud Migration Fundamentals | — | ✅ (4) |

No overlap, which is why this is six pieces of art rather than four.

---

## Solution/Fix/Change

### 1. A `cover_image` key on courses

Reuse the books' key name rather than inventing `card_image` or `thumbnail`.
Both collections then answer "what picture represents this item?" with the same
key, which is what lets the four templates share one conditional shape and what
makes the next person's guess correct.

```yaml
cover_image: /images/courses/risk-management-for-scalable-systems.png
```

Path convention: `/images/courses/<the course's own slug>.<ext>`, matching the
books' `/images/books/<slug>.<ext>`. The slug is the filename without
extension, which is also what the URL uses, so there is never a second name to
remember.

**Absent means no image**, exactly as it does for the six books with no
`cover_image` today. This is deliberate and load-bearing: eleven courses on
leeatchison.com and nine on Academy are not featured and get no art in this
spec, and the two pre-launch and two hidden Academy-native courses may never
get any. Every template branch below must render correctly without the key.

**No builder validation** (decided 2026-08-31). `shared_content.rb` could be
made to require `cover_image` on any course carrying `feature_*`, mirroring how
`validate_availability!` requires `platform`. Lee ruled against it: a featured
course with no art is an undesirable display, not a broken site, and it is
fixed by editing one line of course configuration. Failing the build over it
would also make §5's incremental path — ship the images one at a time — illegal
for no benefit.

### 2. The art

**Lee supplies the source files, at whatever size and shape he has**
(decided 2026-08-31); **normalizing them is part of implementing this spec**,
not a precondition on him. Raw files go in `assets_inbox/` per each site's
CLAUDE.md and are processed into place rather than referenced directly.

**Target: 16:9 at 600px wide** (`600×338`) in the repo — roughly 2× the largest
rendered card width, matching how the book covers were prepared (max 500px for
a portrait cover). A `1200×675` source is the ideal input, not a requirement.

Normalization is scale-to-cover then center-crop, so an off-ratio source loses
its edges rather than being squashed:

```python
# python3 + Pillow, both present in this repo's dev environment
from PIL import Image, ImageOps
ImageOps.fit(Image.open(src), (600, 338), method=Image.LANCZOS) \
        .save("shared/images/courses/<slug>.png")
```

`ImageOps.fit` does both steps in one call and centers the crop. Equivalent
with ImageMagick: `convert <src> -resize 600x338^ -gravity center -extent
600x338 shared/images/courses/<slug>.png`.

**Trap worth naming:** each site's CLAUDE.md documents `sips -Z` for image
work. That is macOS-only and it **scales without cropping**, so it cannot turn
an off-ratio source into a 16:9 file on its own — it would silently produce a
600px-wide image of the wrong height. Use one of the two commands above, or
`sips -Z 600` followed by `sips -c 338 600`. Worth a one-line amendment to
those CLAUDE.md sections while in there.

**A wrong aspect ratio is cosmetic, not broken.** §4's `aspect-ratio: 16 / 9`
box with `object-fit: cover` crops whatever it is handed, so a 4:3 or square
source still renders as a correct-looking card — it just loses more of its
edges than the author intended and carries bytes the page never shows.
Normalize for predictable crops and file size, not for correctness.

**Baked-in titles, reversing the earlier decision** (decided 2026-08-31,
reversed 2026-09-01). The original decision was image-only art, with the
title left to the `<h3>` beneath it. In practice, the marketing art Lee
supplies from the Coursera campaign assets has the title baked in as part of
the graphic, and no textless version exists — Lee confirmed on 2026-09-01
that these are shipped as-is rather than blocked on art that doesn't exist.
The duplication this creates (title in the image, title in the `<h3>` right
below it) is accepted as a byproduct of reusing existing marketing art rather
than commissioning card-specific art.

Six files needed, named for the slugs in the table above.

**Depends on Spec0019.** That spec creates `shared/images/courses/` and
symlinks it into both sites. Until it lands there is nowhere to put a shared
course image, and putting them in the two per-site trees instead would create
six duplicated files for Spec0019 to clean up. **Spec0019 must ship first.**

### 3. Card markup — four templates, one shape

Add above the platform badge in each featured-course card:

```erb
<% if course.data.cover_image %>
  <div class="course-cover-wrap">
    <img src="<%= relative_url course.data.cover_image %>"
         alt="<%= course.data.title %> course image" class="course-cover" />
  </div>
<% end %>
```

The four places:

| File | Block |
|---|---|
| `LeeAtchison/src/courses.erb` | featured row, line 37 |
| `LeeAtchison/src/index.erb` | the home Courses grid, once Spec0016 rebuilds it |
| `AtchisonAcademy/src/courses.erb` | featured row, line 37 |
| `AtchisonAcademy/src/index.erb` | `academy_courses_featured` loop |

**Featured cards only.** The non-featured loops in `courses.erb` and the
Academy home page keep today's text-only card. That is what "featured" buys and
it matches the books, where `.secondary-book-card` shows an icon rather than a
cover. A course that is not featured but happens to carry `cover_image` shows
no image — the `if` lives only in the featured branches.

**Spec0016's What's New band** renders course cards too. It should take the
image on the same terms — a band about what's new, holding the plainest cards
on the page, would be an odd result. If Spec0016 has shipped, this is a fifth
place to edit; if not, fold it into that spec's card markup. Flag it either
way so it is not missed.

### 4. CSS — both stylesheets, edited identically by hand

```css
.course-cover-wrap {
  aspect-ratio: 16 / 9;
  border-radius: var(--radius-sm);
  overflow: hidden;
  margin-bottom: 0.75rem;
  background: var(--bg-alt);
}

.course-cover {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
```

`aspect-ratio` plus `object-fit: cover` is what keeps a row of cards even when
the six source files inevitably differ by a few pixels — the alternative,
trusting the art to be uniform, breaks the first time it is not.
The `background` shows while the image loads and behind anything transparent.

`.course-card` is already `display: flex; flex-direction: column` with
`.course-card p { flex: 1 }` doing the height-evening, so an image at the top of
the flex column needs no further layout work.

**Do not add a fixed `height`.** `.courses-grid` is two columns on both sites
and the cards are fluid; a fixed height re-introduces exactly the fragility
`aspect-ratio` removes.

### 5. What this does *not* change

- **No course page changes.** `course.erb` has no image slot and does not get
  one here — Spec0015 already identified adding one as its own piece of work.
  `cover_image` is card art in this spec, nothing more.
- **No `feature_*` or `order_*` value changes.** The same six courses are
  featured before and after.
- **No book card changes**, and no `.book-cover` / `.book-cover-wrap` CSS is
  touched. The two card types stay visually distinct: portrait covers for
  books, landscape thumbnails for courses.
- **No `platforms.yml`, no builder, no validation** (§1).
- **Text-only featured cards remain valid.** Until all six images exist, a
  featured course without art renders exactly as it does today — so this can
  ship incrementally, image by image, without a half-broken page at any point.

---

## Testing

Both sites — `bin/site-port LeeAtchison`, `bin/site-port AtchisonAcademy`:

1. **Build green on both**, with `shared/images/courses/` populated and
   symlinked (Spec0019).
2. **`/courses` featured row on each site** shows the image above the platform
   badge, cards even in height, no stretched or squashed art. leeatchison.com
   has two featured cards, Academy four.
3. **Both home pages** show the same treatment in their courses grids.
4. **Non-featured cards are unchanged** — no image, no gap where one would be,
   no shifted spacing. Check a "Coming Soon" pre-launch card specifically: it
   renders the prelaunch badge and must not gain an empty `.course-cover-wrap`.
5. **Delete one image temporarily and rebuild.** The card renders text-only and
   the build stays green — the fallback in §1 is the thing that lets this ship
   incrementally, so it needs to be seen working, not assumed.
6. **Both grids at 1024px, 768px and 375px.** Images scale with the card, the
   16:9 box holds, nothing overflows.
7. **`alt` text is on every image** and names the course.
8. **Spec0016's band** takes the image too, or is explicitly recorded as not
   doing so (§3).
9. **The images come from `shared/`** — `git ls-files` shows them once, under
   `shared/images/courses/`, not twice under the two sites (the Spec0019
   guarantee, re-checked here because this is the spec that adds files).

`rake test` (port derivation) is unaffected but should still pass.

---

## Summary of Steps Needed

1. **Wait for Spec0019** — `shared/images/courses/` symlinked into both sites.
2. Lee supplies six source images; resize into `shared/images/courses/` with
   `sips -Z 600` (§2).
3. Add `cover_image` to the six featured course files in `shared/_courses/`
   (§1).
4. Add the image block to the four featured-card templates (§3), plus
   Spec0016's band.
5. Add `.course-cover-wrap` and `.course-cover` to both stylesheets (§4).
6. Document `cover_image` for courses in both sites' CLAUDE.md, beside the
   existing key table.
7. Work through Testing, including the deliberate missing-image check.

---

## Open Questions

1. **Do the two hidden and two pre-launch Academy-native courses need art
   eventually?** None is featured today, so none is in scope. **Proposed: leave
   them** — but if `architecting-systems-with-ai` or `service-ownership` is ever
   featured at launch, its art is part of that launch, not a follow-up.

**Answered 2026-08-31:**

- **16:9 at 600px wide in the repo** (`600×338`), from a `1200×675` source
  where one exists. Lee may supply art at any size or shape; normalizing it is
  part of implementing this spec (§2).
- **Image only — the course title is not baked into the art** (§2).
- **No build validation requiring `cover_image` on a featured course** (§1).

---

## History of Updates

**2026-09-01 — Tracker migration.** `_Project Tracker.md` was retired; this
file's Status field is now the sole source of truth. This spec's implementation
session had already moved Status to **Implementing** on its own branch before
the tracker was retired on `main`, so that is the status carried forward here
— not the `In Spec Development/Refinement` placeholder `main` still showed at
retirement time, which predates that move. No content changes beyond the
Status field.

**2026-08-31 — Spec created**, from Lee's request to show an image for featured
books *and* courses on both sites. Written against commit `bd0d672`.

**2026-08-31 — Found: courses have no image key at all.** This is not a
template omission to fix but a new front-matter key, six new image files, and
new CSS — which is why it is a larger spec than "add an `<img>` tag".

**2026-08-31 — Decided: Lee supplies the source images.** The alternatives
offered were reusing the platforms' own course artwork (fast and recognizable,
but four different brands side by side and not his assets) and generating
branded cards from title and platform (one visual system, but design work
before anything ships). Lee will provide them, so this spec covers the key,
the markup, the CSS and the missing-image fallback.

**2026-08-31 — Decided: reuse the books' `cover_image` key name.** One key
answering the same question across both collections beats a second name that
would have to be explained in both CLAUDE.md key tables.

**2026-08-31 — Noted: ordering.** Spec0019 must ship first, or the six images
land in two per-site trees and need deduplicating. Spec0016 adds a fifth place
to render a course card; whichever of the two ships second picks up the other's
markup.

**2026-08-31 — Decided: 16:9 at 600px wide, and resizing is this spec's job.**
Lee accepted the proposed ratio and said the art he supplies may need resizing.
So §2 specifies the normalization step and its command rather than a spec Lee
has to hit — and records that the `sips -Z` both CLAUDE.md files document
cannot crop, which is the trap someone following those docs literally would hit
on the first off-ratio source file.

**2026-08-31 — Decided: the art carries no text.** Purely visual, with the
title left to the `<h3>` and the platform left to the badge. Keeps the art
correctable without a re-export and stops the same words appearing twice in one
card.

**2026-08-31 — Decided: no build validation for missing course art.** Lee's
reasoning: a featured course without an image is an undesired display, easily
fixed in the course configuration — not a state worth failing a build over.
That also preserves the incremental path in §5, where the six images can land
one at a time.

**2026-09-01 — Moved to Implementing.** Spec0019 confirmed shipped (both
`shared/images/{books,courses}/` symlinks live in both sites). Found a fifth
render site beyond the four in §3's table: Spec0016 shipped in the interim
and added the "What's New" band on `LeeAtchison/src/index.erb`
(`spotlight_courses`, lines 61-72), which §3 flagged as a fifth place to edit
if Spec0016 had already landed by the time this spec was implemented — it had.
`AtchisonAcademy/src/index.erb` carries no such band (`spotlight_academy` is
validated but unrendered there, per that site's `CLAUDE.md`), so the total is
five card sites, not four: `LeeAtchison/src/courses.erb`,
`LeeAtchison/src/index.erb` (both the Courses section and the What's New
band), `AtchisonAcademy/src/courses.erb`, and
`AtchisonAcademy/src/index.erb`.

**2026-09-01 — First two of six images landed.** Lee supplied Coursera
marketing art for `cloud-architecture-for-scalable-systems` and
`risk-management-for-scalable-systems` via `LeeAtchison/assets_inbox/`.
Normalized both from their 1000×1000 source to 600×338 with `ImageOps.fit`
(center-crop trims top/bottom evenly, full width preserved, nothing
cut off) and set `cover_image` on both course files. Both courses' art has
the title baked in (see the reversed decision above) — still four to go:
`architecting-scalable-applications-and-systems` (the specialization),
`cloud-architecture-advanced-concepts`, `cloud-migration-fundamentals`, and
`software-architecture-developer-to-architect`.
