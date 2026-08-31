# Add the Architecting Scalable Applications and Systems specialization page and rebuild the Academy Featured row

[PR #19](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/19)

* **ID:** Spec0015
* **Status:** Closed
* **Date Created:** 2026-08-31
* **Date Implemented:** 2026-08-31
* **Systems Impacted:** `AtchisonAcademy` (content lives in `shared/_courses/` and `shared/_data/`, which `LeeAtchison` also reads — see §5 for why that site's rendered output does not change)

---

## Problem/Requirement

The three Coursera courses — *Scalable Availability in Software Architecture*,
*Cloud Architecture for Scalable Systems*, and *Risk Management for Scalable
Systems* — are a published Coursera **specialization**, *Architecting Scalable
Applications and Systems*
(`https://www.coursera.org/specializations/architecting-scalable-applications-systems/`).
Neither site knows the specialization exists. Visitors see three related
courses with no front door and no stated order.

Two things follow from that, plus one repair:

1. **atchisonacademy.com has no specialization page.** The full page copy is
   written, voice-audited, and fact-checked against the live Coursera page on
   2026-08-31.
2. **The Academy Featured row is in the wrong order and features the wrong
   fourth item.** It currently reads Risk Management, Cloud Architecture,
   Scalable Availability, *Software Architecture: From Developer to Architect*
   — newest-Coursera-first, which is the reverse of the order the courses are
   meant to be taken in, and a LinkedIn Learning course sitting in the fourth
   slot. Once a program card sits above the row saying "start with
   availability," newest-first reads as a contradiction.
3. **Course 2's sequence paragraph does not say the courses have an order.**
   Spec0014 §4 stripped ordinal framing from all three Coursera courses,
   leaving Course 2 with a bare "cover related ground" cross-reference. That
   was right for the problem in front of it and is now under-informative: the
   specialization page directly states the order, and the Course 3 page
   already names what the availability course contributes. Course 2 should
   match Course 3.

### On the source docs' "Replace this" quote

`_Academy Site Edits - 2026-08-31.md` quotes the text to replace as *"This is
the second of two companion courses, best taken in this order, following
Scalable Availability in Software Architecture."* **That text is no longer in
the repo.** Spec0014 §4 replaced it on 2026-08-31 (commit `913f015`). It was
still on the live page when the docs were written because of Bug0001 —
Netlify's build-skip check ignored `shared/`, so course content changes never
triggered an Academy production build. Bug0001 shipped the same day (PR #18).

So the edit is a rewrite of the *current* paragraph, not the one quoted, and
the diff is smaller than the source doc implies. Exact current text is in §1.

### Sources of truth

Both in Dropbox, both verified against the live Coursera pages on 2026-08-31:

- `Professional/_Active Projects/Coursera/_Academy Page - Specialization.md` —
  full page copy for the new page.
- `Professional/_Active Projects/Coursera/_Academy Site Edits - 2026-08-31.md` —
  the Course 2 paragraph and the Featured row change.

---

## Solution/Fix/Change

### 1. Course 2's sequence paragraph

**File:** `shared/_courses/cloud-architecture-for-scalable-systems.md`, About
This Course, second paragraph (line 23).

Current:

> *Scalable Availability in Software Architecture* and *Risk Management for
> Scalable Systems* cover related ground. It stands on its own if the cloud
> decisions are already on your desk.

Replace with:

> *Scalable Availability in Software Architecture* comes before this one, and
> *Risk Management for Scalable Systems* picks up where it leaves off. The
> availability course sets the service tiers and internal SLAs that this one
> spends against. It stands on its own if the cloud decisions are already on
> your desk.

Three points of care:

- **Keep the markdown italics on both course titles.** The Dropbox draft is
  plain text; every course cross-reference in `shared/_courses/` is
  italicized, and the two named here already are on the other two pages.
- **The closing sentence is unchanged.** It is the part doing work for a
  visitor and it survives verbatim.
- **This partially reverses a Spec0014 decision, deliberately.** Spec0014 §4
  removed sequencing because ordinal framing had broken twice ("companion
  course" singular, then "second of two" at three courses). The new wording
  is not ordinal: it names its neighbors rather than counting or numbering
  itself, so a fourth Coursera course cannot falsify it the way a number can.
  It also mirrors the middle sentence already published on the Course 3 page
  ("Service tiers and internal SLAs from the availability course show up
  throughout this one"), which is the model Lee asked for.

Nothing else on that page changes. `duration`, `level`, `updated` and
`summary` were all fact-checked under Spec0013 and Spec0014 and still hold.

### 2. New file: `shared/_courses/architecting-scalable-applications-and-systems.md`

The slug follows from the filename — `collections.courses.permalink` is
`/courses/:slug/` — giving
`/courses/architecting-scalable-applications-and-systems/`, which is the URL
every piece of already-written copy points at.

Front matter:

```yaml
---
layout: course
title: "Architecting Scalable Applications and Systems"
platform: Coursera Specialization
platform_url: "https://www.coursera.org/specializations/architecting-scalable-applications-systems/"
show_academy: true
order_academy: 1
feature_academy: true
canonical_site: academy
duration: "~30 hrs · 3 courses · 16 modules"
level: "Advanced"
updated: "Aug 2026"
summary: "Three courses on availability, cloud architecture, and technical risk, decided from the architect's seat — the full program, in the order it was built to run."
---
```

Notes on the front-matter choices:

- **No `show_leeatchison`, `order_leeatchison` or `feature_leeatchison`**
  (decided 2026-08-31 — Academy only). `validate_stray_site_keys!` fails the
  build if an `order_*`/`feature_*` appears without its matching `show_*`, so
  all three must be absent, not set to `false`.
- **`canonical_site: academy` on a single-site item is valid** and is what the
  other Academy-only courses do. The builder's own comment: *"A
  `canonical_site` on a single-site item is fine: it states, truthfully, where
  that page belongs."*
- **`duration` renders as the hero meta line.** `course.erb` joins
  `[duration, level, "Updated #{updated}"]` with `" • "`, producing
  `~30 hrs · 3 courses · 16 modules • Advanced • Updated Aug 2026` — the meta
  line the draft specifies, with no template change.
- **`summary` uses the em-dash variant** (decided 2026-08-31), matching the
  four cards it sits beside on the same grid.
- **No `availability` key**, so it defaults to `available`;
  `validate_availability!` then requires `platform` (present) and forbids all
  three `prelaunch_*` keys (absent).

Body, from `_Academy Page - Specialization.md`, in five `##` sections:
*About This Specialization*, *What You'll Learn*, *The Three Courses*, *Who
This Is For*, *Program Structure*. The `course` layout just yields the body,
so the extra section and the renamed first section need no template change.

**Do not write the draft's hero block, meta line, H1, enrollment note, repeat
CTA block, or its "Courses index card" section into the body.** All of those
are rendered by `course.erb` from front matter and `platforms.yml`; writing
them into the body renders them twice. This is the same trap Spec0014 §1
called out.

The three "Learn more →" links in *The Three Courses* are the only internal
links in any course body. Write them as root-relative markdown links
(`/courses/scalable-availability-software-architecture/`,
`/courses/cloud-architecture-for-scalable-systems/`,
`/courses/risk-management-for-scalable-systems/`). All three slugs verified
against the repo 2026-08-31; note Course 1 has no "in" in its slug.

**Hero art is out of scope.** `course.erb` has no image slot, so
`Marketing/Specialization - specialization-logo.png` has nowhere to go without
a layout change. Adding one is a separate spec if it is wanted.

### 3. New `platforms.yml` entry

**File:** `shared/_data/platforms.yml`

`platform: Coursera Specialization` is not a key there today, so the course
layout would fall back to a bare "Take This Course →" with no access note.
Add:

```yaml
"Coursera Specialization":
  access_note: "Available exclusively on Coursera. Enroll directly, through Coursera Plus, or start a free trial — financial aid is available if cost is a barrier."
  info_url:    "https://www.coursera.org/courseraplus"
  info_label:  "Coursera pricing & Coursera Plus"
  cta_label:   "Get the Specialization on Coursera"
```

`access_note`, `info_url` and `info_label` are byte-identical to the
`"Coursera"` entry — the enrollment terms are the same. Only `cta_label`
differs, and it is the one the draft specifies for both the hero and footer
buttons.

The alternative — `platform: Coursera` plus a per-course `cta_label:`
override — was rejected because `platform` is also what both index templates
print in the card badge, and the card needs to read as a program rather than a
fourth course.

### 4. The Academy Featured row

`feature_academy` selects the Featured group; `order_academy` sorts within
both groups. Four cards before, four after, so the grid keeps its shape.

| | Before | After |
|---|---|---|
| 1 | Risk Management for Scalable Systems | **Architecting Scalable Applications and Systems** (specialization) |
| 2 | Cloud Architecture for Scalable Systems | Scalable Availability in Software Architecture |
| 3 | Scalable Availability in Software Architecture | Cloud Architecture for Scalable Systems |
| 4 | Software Architecture: From Developer to Architect | Risk Management for Scalable Systems |

*Software Architecture: From Developer to Architect* loses
`feature_academy: true` and moves to the head of *More Courses*. It keeps
`show_academy` and its Academy page; only the flag goes.

`order_academy` changes — the new item takes slot 1 and everything shifts down
one until the first existing gap at 9, preserving the sparse numbering
Spec0014 established:

| File | old | new |
|---|---|---|
| `architecting-scalable-applications-and-systems` (new) | — | 1 |
| `scalable-availability-software-architecture` | 3 | 2 |
| `cloud-architecture-for-scalable-systems` | 2 | 3 |
| `risk-management-for-scalable-systems` | 1 | 4 |
| `software-architecture-developer-to-architect` | 4 | 5 |
| `cloud-migration-fundamentals` | 5 | 6 |
| `avoiding-bad-decisions-cloud-strategy` | 6 | 7 |
| `cloud-architecture-advanced-concepts` | 7 | 8 |

Unchanged, because slot 9 is free and the shift stops there:
`framing-cloud-discussions-c-suite` (10),
`understanding-impact-merger-it-teams` (12),
`architecting-systems-with-ai` (13), `service-ownership` (14),
`cloud-cost-architecture` (15, hidden), `velocity-safe-architecture` (16,
hidden). Sort keys are only compared, never displayed, so the gap costs
nothing.

Note the top three courses swap places rather than all shifting: Risk
Management moves from first to last within Featured, because the row is
changing from newest-first to take-this-order.

### 5. What this does *not* change

**No template change anywhere.** `courses.erb`, `index.erb` and `course.erb`
already read `feature_academy`/`order_academy` and `platforms.yml`; nothing
caps the featured count at four.

**`AtchisonAcademy/src/index.erb` changes as a side effect, correctly.** The
home page renders `academy_courses_featured` then `academy_courses_other` into
one grid off the same two keys, so the specialization card lands first there
too and the three courses follow in take-this-order. That is the intended
result, but it is a second page to look at.

**leeatchison.com renders identically.** The new file has no
`show_leeatchison`, so `shared_content.rb` drops it at `post_read` on that
site — no page, no sitemap entry, no card, and no `order_leeatchison`
renumbering. The Course 2 paragraph edit *is* visible on
`leeatchison.com/courses/cloud-architecture-for-scalable-systems/`, since that
course is on both sites; the new wording is site-neutral and reads correctly
there.

**`course.erb`'s "More Courses by Lee" strip is unsorted** — it takes
`.first(4)` of the collection in read order, not `order_academy` order. Adding
an eighteenth file can change which four appear on every Academy course page.
Cosmetic, pre-existing, and out of scope; just do not be surprised by it in
the diff review.

### 6. Course-count documentation

Adding one shared course makes the counts stale in three places (17 → 18
shared, 13 → 14 Academy):

- `CLAUDE.md` line 32 — `_courses/   # 17 course resources`
- `AtchisonAcademy/CLAUDE.md` line 129 — "10 books and 17 courses there; this
  site shows the 2 books and 13 courses marked `show_academy`"
- `AtchisonAcademy/README.md` lines 62–63 — same sentence

Per the skill's general principle, doc artifacts that track content are
in-scope for the change that moves them.

---

## Testing

Run the Academy site locally — `bin/site-port AtchisonAcademy` for this
checkout's port — and check, in order:

1. **The build runs at all.** `shared_content.rb` raises on bad front matter,
   so a green build already proves `canonical_site`, the absent
   `*_leeatchison` keys and the `availability` defaults are all valid. A
   failure here names the offending file and key.
2. **`/courses/architecting-scalable-applications-and-systems/` renders**, with
   the platform badge, the meta line
   `~30 hrs · 3 courses · 16 modules • Advanced • Updated Aug 2026`, the
   "Get the Specialization on Coursera" button in the hero *and* in the footer
   CTA, and the Coursera enrollment note with a working pricing link. Confirm
   the hero button and the footer button both point at the specialization URL,
   not a course URL.
3. **The badge fits.** `COURSERA SPECIALIZATION` is uppercased at 0.14em
   letter-spacing by `.course-platform-badge` — roughly twice the width of any
   badge on the site today. Look at the course-page hero pill and both index
   cards at mobile width before accepting it. If it wraps badly, the fallback
   in the source doc is to set `platform: Coursera` and let the page title
   carry the distinction; that would also make §3 unnecessary.
4. **The three "Learn more →" links in *The Three Courses* resolve** to the
   three course pages, no 404s.
5. **`/courses/` Featured row** reads specialization, availability, cloud,
   risk — four cards, one row, same grid shape as before — and *Software
   Architecture: From Developer to Architect* is the first card in *More
   Courses*.
6. **The home page** (`/`) shows the same order in its single grid.
7. **Course 2's page** shows the new paragraph with both course titles in
   italics and the closing sentence intact.
8. **leeatchison.com** builds green and its `/courses/` page is unchanged
   apart from Course 2's paragraph. Confirm no
   `/courses/architecting-scalable-applications-and-systems/` page is
   generated there.
9. **Sitemaps.** The new page appears in the Academy sitemap and is absent
   from leeatchison.com's.

`rake test` for the port-derivation unit tests is unaffected by this change
but should still pass.

---

## Summary of Steps Needed

1. Rewrite the second paragraph of About This Course in
   `shared/_courses/cloud-architecture-for-scalable-systems.md` (§1).
2. Add the `"Coursera Specialization"` entry to `shared/_data/platforms.yml`
   (§3).
3. Create `shared/_courses/architecting-scalable-applications-and-systems.md`
   from the Dropbox draft, front matter per §2, body in five sections, hero and
   CTA copy left to the layout.
4. Set the eight `order_academy` values in the §4 table, and remove
   `feature_academy: true` from
   `shared/_courses/software-architecture-developer-to-architect.md`.
5. Update the three course counts in §6.
6. Work through Testing, on both sites.

---

## Open Questions

1. **Does the `COURSERA SPECIALIZATION` badge look right?** Answerable only by
   looking at it (Testing step 3). If it does not, fall back to
   `platform: Coursera` and drop §3.
2. **Should Course 1 and Course 3 get the same treatment as Course 2?** Lee
   asked for Course 2 only, and Course 3 is already the model. Course 1 still
   reads "*Cloud Architecture for Scalable Systems* and *Risk Management for
   Scalable Systems* cover related ground" — true, but it is the entry point
   of the program and says nothing about being first. Proposed: leave it, and
   revisit if the specialization page changes how people arrive at it.
3. **Should the specialization page link back to the Coursera specialization
   from within *The Three Courses*,** or is the hero/footer CTA enough?
   Proposed: hero and footer only, matching every course page.

**Answered 2026-08-31:**

- **Academy only**, no leeatchison.com presence for the specialization page.
- **Em-dash card summary**, matching the neighboring cards rather than the
  no-em-dash voice rule.

---

## History of Updates

**2026-08-31 — Spec created.** Written from two Dropbox source docs,
`_Academy Site Edits - 2026-08-31.md` and `_Academy Page - Specialization.md`,
both fact-checked against the live Coursera pages that day.

**2026-08-31 — Course 2's "replace this" text corrected against the repo.**
The source doc quotes the pre-Spec0014 paragraph as live. It is not in the
repo; Spec0014 replaced it that morning and Bug0001 explains why the browser
still showed it. §1 now quotes the actual current line, which makes the edit a
smaller and more targeted rewrite.

**2026-08-31 — Decided: Academy only.** The source docs address
atchisonacademy.com only. Adding the specialization to leeatchison.com would
mean a second Featured row to reorder and a second index to verify, for a page
whose three member courses are already listed there. Deferred rather than
refused.

**2026-08-31 — Decided: em-dash card summary.** The source doc offers both. The
four cards already on that grid all use an em dash; matching them won over the
voice rule for a 25-word card. Note this differs from Spec0014 §1, which chose
the em-dash-free variant for the Risk Management card.

**2026-08-31 — Decided: keep the specialization in the `_courses` collection**
rather than building it as a standalone page. It gets `/courses/:slug/`, the
`course` layout, index cards, and the canonical/sitemap machinery for free, and
the only thing that does not fit — the platform label — is one `platforms.yml`
key. A standalone page would duplicate `course.erb` to gain nothing this page
needs.

**2026-08-31 — Decided: shift `order_academy` to the first gap, not densify.**
Spec0014 established that the sparse Academy numbering is deliberate (the gaps
are courses not shown on Academy). Shifting slots 1–8 and stopping at the free
slot 9 touches eight files instead of thirteen and preserves that property.

**2026-08-31 — Noted: this partially reverses Spec0014 §4.** That spec removed
sequencing language from all three Coursera courses because it kept breaking.
The replacement here re-introduces sequence but names the neighbors instead of
numbering the course, which is what makes it survive a fourth course — and it
matches what Spec0014 itself already published on the Course 3 page.

**2026-08-31 — Revised during PR review: Featured row changed from
"specialization + its three member courses" to "specialization + one course
per non-Coursera platform."** §4's original plan featured the specialization
alongside all three individual Coursera courses (Availability, Cloud
Architecture for Scalable Systems, Risk Management), demoting only
*Software Architecture: From Developer to Architect*. After seeing it live in
the Deploy Preview, Lee asked for the opposite emphasis: only the
specialization card represents the Coursera program in Featured, and the slots
freed up go to one course per other platform instead —
*Software Architecture: From Developer to Architect* (LinkedIn Learning),
*Cloud Architecture: Advanced Concepts* (LinkedIn Learning), and
*Cloud Migration Fundamentals* (O'Reilly Media), in that order. All three
individual Coursera courses (Availability, Cloud Architecture for Scalable
Systems, Risk Management) move to the top of More Courses instead. Final
`order_academy` (Featured, in display order): specialization (1), Software
Architecture: From Developer to Architect (2), Cloud Architecture: Advanced
Concepts (3), Cloud Migration Fundamentals (4); then Scalable Availability
(5), Cloud Architecture for Scalable Systems (6), Risk Management (7),
Avoiding Bad Decisions in Your Cloud Strategy (8) leading More Courses. §4's
table above documents the plan as originally written; this entry is the
record of what actually shipped.

**2026-08-31 — Closed.** [PR #19](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/19)
merged. Along the way, PR #19 surfaced that Bug0001's Netlify ignore-build fix
does not reliably trigger automatic Deploy Preview builds on a new branch —
tracked separately as Bug0002, not a blocker for this spec (manual "Trigger
deploy" was used to verify both the initial and revised Featured row live).
