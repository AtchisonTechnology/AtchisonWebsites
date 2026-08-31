# Raise the new courses and the new book on the leeatchison.com home page

* **ID:** Spec0016
* **Status:** In Development
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison` (`src/index.erb` and `frontend/styles/index.css`). Content is read from `shared/_courses/`, which `AtchisonAcademy` also reads — but §2 changes only how `LeeAtchison` renders it, and §5 explains why nothing about the Academy site moves.

---

## Problem/Requirement

Lee's newest work is the least visible thing on leeatchison.com. The home page
runs hero → pillars → about → books → courses → insights → contact, so:

1. **The new book is four screens down and undifferentiated.** *The Software
   Conductor* (Independent, May 2026, `badge: New Release`) is the first of
   four equal-weight cards in the Books section. It carries a "New Release"
   tag, but nothing about its placement says so.
2. **The three 2026 Coursera courses do not appear on the home page at all.**
   *Risk Management for Scalable Systems* and *Cloud Architecture for Scalable
   Systems* (both `updated: Aug 2026`, both `feature_leeatchison: true`) and
   *Scalable Availability in Software Architecture* (`Apr 2026`) are named
   nowhere on `/`.
3. **The Courses section shows platforms, not courses.** It is a hardcoded
   block of four `.platform-card`s — Atchison Academy, Coursera, LinkedIn
   Learning, O'Reilly Media — completed to four destinations by Spec0011. It
   is the only home-page section about the courses, and it names exactly two
   of the thirteen courses on the site, both hardcoded.
4. **That hardcoding has already drifted.** `src/index.erb` line 172 says
   *"The **Architecting Scalable Systems** specialization."* The specialization
   Spec0015 shipped is *Architecting Scalable Applications and Systems*
   (`shared/_courses/architecting-scalable-applications-and-systems.md`). The
   home page has been naming it wrong since before it existed. The O'Reilly
   card likewise hardcodes *Cloud Migration Fundamentals*, which is correct
   today only by coincidence.

The Books section is hardcoded the same way — the same four books as
`feature_leeatchison`, in the order 1, 3, 2, 4 rather than
`order_leeatchison` order. That is a real inconsistency but it is *not* in
scope here; see Open Question 3.

### Decided at request time (2026-08-31)

Lee answered three scoping questions before this spec was written:

- **"My new book" is *The Software Conductor*** — already on the page, so this
  spec raises its prominence rather than adding content.
- **Approach: a new "What's New" band directly under the hero**, rather than
  reordering the existing sections. The existing section order and content
  survive.
- **The Courses section should be driven from the shared collection**, the way
  `AtchisonAcademy/src/index.erb` and `LeeAtchison/src/courses.erb` already
  are, instead of hardcoded platform cards.

---

## Solution/Fix/Change

### 1. New "What's New" band, between the hero and the pillars

Insert one `<section class="whats-new">` after the hero section closes
(`src/index.erb` line 18), before `<section class="pillars">`. It holds three
things, left to right on desktop:

- **The new book** — cover, "New Release" tag, title, one-line summary, link.
- **Two new-course cards** — the featured courses, newest first.
- **A single "See everything new" style link** into `/courses`.

**Data source, not hardcoded markup.** Read the collections at the top of
`index.erb` the way `AtchisonAcademy/src/index.erb` already does, and take the
top of each ordered list:

```erb
<%
  featured_books   = site.collections["books"].resources
                       .select { |b| b.data.feature_leeatchison }
                       .sort_by { |b| b.data.order_leeatchison || 99 }
  featured_courses = site.collections["courses"].resources
                       .select { |c| c.data.feature_leeatchison }
                       .sort_by { |c| c.data.order_leeatchison || 99 }

  spotlight_book    = featured_books.first
  spotlight_courses = featured_courses.first(2)
%>
```

The builder has already dropped everything without `show_leeatchison` at
`:site, :post_read`, so no membership filter is needed — only featuring and
order, per the site's CLAUDE.md.

**Why reuse `order_leeatchison` rather than add a `spotlight_*` key.** Slot 1
is *The Software Conductor* and slots 1–2 are the two Aug 2026 Coursera
courses, so the existing keys already produce exactly the right band today,
and Lee re-sorts these lists whenever something new ships (Spec0014,
Spec0015). Adding a third per-site key means a third thing to keep in sync and
a fourth builder validation. The cost is that "new" is expressed as "sorted
first" rather than stated. See Open Question 2.

**Render the band with the existing card classes** — `.book-card` for the book
and `.course-card` for the courses — so it inherits the site's card styling
and the platform badge. New CSS is limited to the band's own wrapper (§3).

**Link targets.** The course cards link to their local pages
(`relative_url course.relative_url`), matching `courses.erb`. The book card
links to `spotlight_book.relative_url` — the local `/books/the-software-conductor/`
page — **not** `https://thesoftwareconductor.com` as the hardcoded Books
section does. That is a deliberate difference from the section below it: the
band is a data-driven card and the collection's own `book_url` is available on
the book's page. See Open Question 4.

**Copy.** Section label "What's New", section title to be confirmed with Lee
(proposed: *"Just Released"*). Do not write a paragraph of intro copy — the
band's job is to be scanned in under two seconds on the way past.

### 2. Rebuild the Courses section from the shared collection

**File:** `src/index.erb`, the `<section class="courses" id="courses">` block,
lines 142–196.

Keep:

- The section wrapper, its `id="courses"`, and its two-column
  `.courses-inner` grid.
- The whole left column: the `180,000+` `.stat-card`, which Spec0011
  deliberately corrected and which is the section's strongest asset.
- The `.section-label`, `.section-title` and `.courses-desc` in the right
  column.

Replace the `<div class="platform-cards">` block (lines 156–193) with a grid
of real course cards, rendered from `featured_courses` — the same list §1
derives — in `order_leeatchison` order, using the `.course-card` markup from
`courses.erb` lines 37–46 including the `prelaunch` branch:

```erb
<div class="home-courses-grid">
  <% featured_courses.each do |course| %>
    <a href="<%= relative_url course.relative_url %>" class="course-card">
      <% if course.data.availability == "prelaunch" %>
        <span class="course-card-platform course-platform-badge--prelaunch">Coming Soon</span>
      <% else %>
        <span class="course-card-platform"><%= course.data.platform %></span>
      <% end %>
      <h3><%= course.data.title %></h3>
      <p><%= course.data.summary %></p>
      <span class="course-card-link">Learn more &rarr;</span>
    </a>
  <% end %>
</div>
```

Then add, below the grid, the two links the section has never had:

- `View All Courses →` to `/courses` (`.btn.btn-outline`).
- `Explore the Academy →` to `https://atchisonacademy.com`
  (`target="_blank" rel="noopener noreferrer"`, matching `courses.erb`
  line 87 and Spec0007's rule that only the navbar entry stays same-tab).

**Three things this fixes for free.** The wrong specialization name (§4 of the
problem) disappears with the block that held it; the O'Reilly card's
hardcoded course title goes with it; and the section stops being able to drift
from the data at all.

**Two things it costs, and why that is acceptable.** The four platform
destinations Spec0011 completed stop being listed as such, and the Atchison
Academy logo leaves the home page. The per-course `.course-card-platform`
badge names the platform on every card, so the platform information survives
at the level a visitor actually acts on, and the explicit Academy button above
replaces the Academy platform card's job with a link that Spec0011's card
never had. Recorded here because it partially reverses a Spec0011 decision on
purpose. See Open Question 1 for the "keep both" alternative.

**Only two cards render today.** `feature_leeatchison` is set on exactly two
courses. A two-card grid in a `1.6fr` column reads fine, but it is a thinner
section than the four platform cards it replaces. Options if it looks sparse:
add `feature_leeatchison: true` to *Scalable Availability in Software
Architecture* (`order_leeatchison: 3`) for a three-card row, or take
`.first(4)` of all courses in order rather than the featured subset. This is a
look-at-it decision — Testing step 4.

### 3. CSS

**File:** `frontend/styles/index.css`.

New rules:

- `.whats-new` — the band. It sits between `.hero` (navy gradient) and
  `.pillars` (`var(--bg)`), and the page alternates
  `bg / bg-alt / bg / bg-alt / navy / bg`. Give it `var(--bg-alt)` so the
  hero → band → pillars sequence keeps the alternation, with
  `padding: 3.5rem 2rem` — shorter than the 5rem sections, since it is a strip
  rather than a full section.
- `.whats-new-inner` — `max-width: var(--max-w); margin: 0 auto;` and a grid.
  Proposed `grid-template-columns: 1fr 2fr` (book, then the two course cards).
- `.home-courses-grid` — `display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.25rem;`
  matching `.courses-grid` (line 1468) without reusing that class, whose
  `max-width: var(--max-w); margin: 0 auto` is wrong inside the right-hand
  column of `.courses-inner`.

Responsive, in the existing media blocks rather than new ones:

- `@media (max-width: 900px)` (line 1964) — add `.whats-new-inner` and
  `.home-courses-grid` to the `grid-template-columns: 1fr` list that
  `.courses-inner` and `.platform-cards` are already in. **Delete the
  `.platform-cards` line there** in the same edit; the class no longer exists.
- `@media (max-width: 768px)` (line 1990) — add `.whats-new` to the
  `padding-top/bottom: 3.5rem` selector list.

**Dead CSS to remove** once the block is gone: `.platform-cards`,
`.platform-card`, `.platform-icon-wrap`, `.platform-logo-wrap`,
`.platform-logo`, `.platform-card strong`, `.platform-card span` (lines
645–712) and the `.platform-cards` responsive line above. Grep both sites
first — `AtchisonAcademy` has its own stylesheet and may carry its own copies;
this spec removes them only from `LeeAtchison`.

**Do not touch `.course-card`, `.course-card-platform`, `.course-card-link` or
`.course-card p`** (lines 1476–1524). They are shared with `/courses` and
`.course-card p { flex: 1 }` is what keeps card heights even. Reusing them
unchanged is the point.

Note in passing: `.course-card--featured` and `.featured-courses-section` are
used in `courses.erb` but have **no CSS rule in either site's stylesheet**, so
featured cards on `/courses` already render identically to the rest. Do not
reach for `--featured` here expecting it to do something. Pre-existing and out
of scope.

### 4. The specialization is not on leeatchison.com

*Architecting Scalable Applications and Systems* has no `show_leeatchison`
key, so `shared_content.rb` drops it from this site entirely — no page, no
card, no possible link target. Spec0015 decided this deliberately ("Academy
only", 2026-08-31), on the grounds that its three member courses are already
listed here.

That decision was made three days before Lee asked for the new courses to be
raised, and the band in §1 is exactly the place a program-level card belongs.
**This spec does not change it** — the band renders the two featured courses
and nothing else — but it is the largest open decision on the page. Open
Question 1 carries the options.

### 5. What this does *not* change

- **`AtchisonAcademy` renders identically.** No file under `shared/` is
  touched — no front matter, no `platforms.yml`, no course body. This is a
  template and stylesheet change confined to `LeeAtchison/src/index.erb` and
  `LeeAtchison/frontend/styles/index.css`.
- **No new front-matter keys**, so `shared_content.rb`'s three validations
  (`validate_site_keys!`, `validate_availability!`, the `canonical_site`
  rules) are unaffected and no builder edit is needed.
- **The Books section stays hardcoded** and keeps its external
  `thesoftwareconductor.com` / `businessbreakthrough30.com` /
  `architectingforscale.com` links. Open Question 3.
- **The About, Insights and Contact sections and the hero do not move.** The
  hero's `Explore Resources` button still points at `/#insights`; the band
  does not take an anchor.
- **No documentation counts change.** No book or course is added or removed.

---

## Testing

Run the site locally — `bin/site-port LeeAtchison` for this checkout's port —
and check:

1. **The build runs.** `shared_content.rb` raises on bad front matter; nothing
   here changes front matter, so a red build means a template error.
2. **`/` renders the What's New band** directly below the hero, above the
   pillars, with *The Software Conductor* (cover, "New Release" tag) and the
   two Coursera cards, *Risk Management for Scalable Systems* first.
3. **Every card in the band links somewhere real** — no 404s, and confirm the
   book card's destination is whichever Open Question 4 settles on.
4. **The Courses section** shows two course cards with `COURSERA` badges
   instead of the four platform cards, with the `180,000+` stat card intact
   beside them, and both new buttons below. **Judge whether two cards is
   enough** (§2) at this step.
5. **No stale specialization name anywhere on `/`.**
   `grep -ri "Architecting Scalable Systems" LeeAtchison/src/` should return
   nothing (note the shipped name has "Applications and" in the middle).
6. **Responsive.** At 900px the band and the course grid both collapse to one
   column; at 768px the band's padding drops with its neighbors; at 540px
   nothing overflows. The `COURSERA SPECIALIZATION` badge width problem
   Spec0015 flagged does not apply here — no specialization card renders on
   this site.
7. **Dead CSS.** `grep -rn "platform-card" LeeAtchison/` returns nothing after
   the removal, and `AtchisonAcademy` still builds and renders unchanged.
8. **`/courses` and `/books` are untouched.** Same cards, same order.
9. **`AtchisonAcademy` builds green** and its home page is byte-identical.
   (Fast check: `git status` should show no file under `shared/` modified.)

`rake test` (port derivation) is unaffected but should still pass.

---

## Summary of Steps Needed

1. Add the collection-reading ERB preamble to `LeeAtchison/src/index.erb` (§1).
2. Insert the `.whats-new` band between the hero and the pillars (§1).
3. Replace the `.platform-cards` block in the Courses section with a
   collection-driven `.home-courses-grid`, plus the two links below it (§2).
4. Add `.whats-new`, `.whats-new-inner` and `.home-courses-grid` to
   `frontend/styles/index.css`, and add both to the existing 900px and 768px
   media blocks (§3).
5. Delete the seven dead `.platform-*` rules and the `.platform-cards`
   responsive line (§3).
6. Work through Testing on `LeeAtchison`, and confirm `AtchisonAcademy` is
   untouched.

---

## Open Questions

1. **Should the *Architecting Scalable Applications and Systems* specialization
   come to leeatchison.com?** Spec0015 said Academy-only, before this request
   existed. Three options: (a) leave it — the band shows the two member
   courses, nothing changes; (b) add `show_leeatchison`, `order_leeatchison: 1`
   and `feature_leeatchison: true` to the specialization file, which gives this
   site its own `/courses/architecting-scalable-applications-and-systems/` page,
   puts the program card at the head of the band, and requires renumbering
   `order_leeatchison` on every course below it — a `shared/` change, so §5's
   "Academy renders identically" claim would need re-checking; (c) a
   hand-written cross-site card in the band linking to
   `atchisonacademy.com/courses/architecting-scalable-applications-and-systems/`,
   which is one card of markup but reintroduces exactly the hardcoding §2
   removes. **Proposed: (b)**, as the thing Lee actually asked for — but it is
   a real reversal of a three-day-old decision and doubles the spec's blast
   radius, so it needs an explicit yes.
2. **Reuse `order_leeatchison`, or add an explicit `spotlight_leeatchison` key?**
   Reuse is proposed (§1) and is correct today with zero new machinery. The
   risk is silent: a future re-sort that puts an older course at slot 1 changes
   the "What's New" band without anyone noticing they did it. **Proposed:
   reuse, and revisit if it ever misfires.**
3. **Should the Books section also become collection-driven?** It has the same
   hardcoding as the Courses section did, plus an order that already disagrees
   with `order_leeatchison` (page shows 1, 3, 2, 4). Doing it here would make
   the whole home page data-driven in one pass; leaving it keeps this spec to
   one section. **Proposed: leave it, and raise it as its own spec** — the
   Books cards link to three standalone book *sites*, not to the local
   collection pages, so converting them is a link-destination decision rather
   than a template swap.
4. **Where should the band's book card link — the local
   `/books/the-software-conductor/` page, or `thesoftwareconductor.com`?**
   §1 proposes local, for consistency with the course cards and with
   `AtchisonAcademy/src/index.erb`. The Books section directly below will then
   link the same book off-site, which is visibly inconsistent on one page.
   **Proposed: local in the band**, and fold the Books section into the same
   rule whenever Open Question 3 is settled.
5. **Section title for the band.** Proposed *"Just Released"* under a
   `What's New` label. Lee's call.

---

## History of Updates

**2026-08-31 — Spec created.** Written from Lee's request to put the new
courses and the new book higher on the leeatchison.com home page, against the
repo state at commit `bd0d672` (Spec0015 merged and archived that day).

**2026-08-31 — Decided: the new book is *The Software Conductor*.** Lee
confirmed it is not a book missing from `shared/_books/`, so this spec adds no
content — only placement.

**2026-08-31 — Decided: a new band under the hero, not a section reorder.**
The alternative offered was moving Books and Courses above About. Lee chose
the band. It leaves every existing section's order, content and anchor intact,
which keeps the diff to one insertion plus one replacement.

**2026-08-31 — Decided: the Courses section becomes collection-driven.** Lee
chose this over the narrower option of correcting the stale specialization
name in the hardcoded platform cards. That narrower fix is now unnecessary —
the block holding the wrong name is being deleted.

**2026-08-31 — Noted: this partially reverses Spec0011.** That spec
deliberately completed the home page's platform cards to all four
destinations. Replacing them is a considered trade, not an oversight: the
per-card platform badge keeps the platform information, and the section gains
the `/courses` and Academy links it never had. Recorded so the reversal is
findable from either spec.

**2026-08-31 — Noted: Spec0015's "Academy only" decision is the page's biggest
open question.** It was made on 2026-08-31, before this request, and on
reasoning ("the member courses are already listed there") that a What's New
band changes. Carried as Open Question 1 rather than assumed either way.
