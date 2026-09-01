# Raise the new courses and the new book on the leeatchison.com home page

**PR:** [#21](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/21)

* **ID:** Spec0016
* **Status:** Verifying
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison` (`src/index.erb`, `frontend/styles/index.css`, `plugins/builders/shared_content.rb`), `AtchisonAcademy` (`plugins/builders/shared_content.rb` only — the mandatory matching half of the builder change), and three files under `shared/` that gain one front-matter key each.

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

Lee answered four scoping questions before and during the writing of this spec:

- **"My new book" is *The Software Conductor*** — already on the page, so this
  spec raises its prominence rather than adding content.
- **Approach: a new "What's New" band directly under the hero**, rather than
  reordering the existing sections. The existing section order and content
  survive.
- **The Courses section should be driven from the shared collection**, the way
  `AtchisonAcademy/src/index.erb` and `LeeAtchison/src/courses.erb` already
  are, instead of hardcoded platform cards.
- **The band's membership is an explicit `spotlight_leeatchison` key**, not
  inferred from the existing sort order. See §1 and History of Updates.

---

## Solution/Fix/Change

### 1. A new per-site key: `spotlight_leeatchison`

**What goes in the What's New band is stated, not inferred.** A boolean
front-matter key, `spotlight_leeatchison`, marks an item as belonging in the
band. Like every other per-site key in this repo (Spec0008), **absent means
false**, so only `true` is ever written.

**Why a fourth key rather than reusing `order_leeatchison`.** Taking the
first-sorted featured items would produce exactly the right band today — slot 1
is the book, slots 1–2 are the two Aug 2026 Coursera courses — but only by
coincidence. Those lists are re-sorted for unrelated reasons (Spec0014 put Risk
Management at slot 1; Spec0015 re-sorted the Academy row into take-this-order),
and the day a 2024 course is promoted to slot 1 for a good reason, the home
page silently starts advertising it as new. The failure is invisible: nothing
in the repo objects, and nobody edited the home page. A section headed
"What's New" should say which items it believes are new.

**The two concepts stay separate:**

| Key | Question it answers | Read by |
|---|---|---|
| `feature_leeatchison` | Does this item get the prominent treatment within its own section? | `books.erb`, `courses.erb`, the rebuilt home Courses section (§3) |
| `spotlight_leeatchison` | Is this item new enough to sit above the fold on the home page? | The What's New band (§2) only |

An item can carry either, both, or neither. `order_leeatchison` continues to
do all sorting, including within the band.

#### 1a. Builder support

**Files:** `LeeAtchison/plugins/builders/shared_content.rb` **and**
`AtchisonAcademy/plugins/builders/shared_content.rb`.

Two edits per file, identical in both — the copies differ only in `SITE_KEY`
(line 44), and that property must survive this change:

```ruby
FEATURE_FLAG   = :"feature_#{SITE_KEY}"
ORDER_KEY      = :"order_#{SITE_KEY}"
SPOTLIGHT_FLAG = :"spotlight_#{SITE_KEY}"     # new, after line 49
```

and in `validate_stray_site_keys!` (line 105):

```ruby
stray = [FEATURE_FLAG, ORDER_KEY, SPOTLIGHT_FLAG].select { |key| resource.data.key?(key) }
```

That is the whole builder change. It buys the same guarantee the other two
keys have: `spotlight_leeatchison` on an item without `show_leeatchison` fails
the build with the existing message rather than silently doing nothing.

Update the method's comment above line 99 — it currently reads *"`feature_*`
and `order_*` are only meaningful alongside the matching `show_*`"* — to name
all three keys.

**`spotlight_academy` will exist as a consequence, and nothing renders it.**
The Academy builder derives its flag from its own `SITE_KEY`, so the symmetric
edit gives that site a validated-but-unused key. That is the correct trade:
keeping the two builders line-for-line identical apart from `SITE_KEY` is what
makes them reviewable, and the alternative — a key that exists on one site and
not the other — is the kind of asymmetry that CLAUDE.md warns about. If Lee
ever wants a What's New band on atchisonacademy.com, the key and its validation
are already there.

#### 1b. Front-matter edits — the band's membership today

Add `spotlight_leeatchison: true` to exactly three files under `shared/`, each
directly below its existing `feature_leeatchison: true` line:

| File | Why it's in the band |
|---|---|
| `_books/the-software-conductor.md` | `release_date: May 2026`, `badge: New Release` — the new book |
| `_courses/risk-management-for-scalable-systems.md` | `updated: Aug 2026`, newest course, added by Spec0014 |
| `_courses/cloud-architecture-for-scalable-systems.md` | `updated: Aug 2026` |

All three already carry `show_leeatchison: true`, so the new validation passes.
Nothing else changes in those files.

**Deliberately not spotlighted** (decided 2026-08-31): *Scalable Availability
in Software Architecture* (`Apr 2026`). It is the oldest of the three Coursera
courses, and holding the band to three cards is what lets its headline claim
newness honestly. One line adds it if the band reads thin on screen
(Testing step 4).

**Maintenance note for the spec's own record:** the band now has to be curated
by hand, which is the point — and the cost. Whoever ships the next course adds
one line and removes one. Open Question 2 asks whether the build should enforce
a cap so the band cannot quietly grow to seven cards.

### 2. The What's New band, between the hero and the pillars

Insert one `<section class="whats-new">` after the hero section closes
(`src/index.erb` line 18), before `<section class="pillars">`.

**Data source.** Read the collections at the top of `index.erb` the way
`AtchisonAcademy/src/index.erb` already does. The builder has already dropped
everything without `show_leeatchison` at `:site, :post_read`, so no membership
filter is needed — only spotlight and order, per the site's CLAUDE.md:

```erb
<%
  spotlight_books   = site.collections["books"].resources
                        .select { |b| b.data.spotlight_leeatchison }
                        .sort_by { |b| b.data.order_leeatchison || 99 }
  spotlight_courses = site.collections["courses"].resources
                        .select { |c| c.data.spotlight_leeatchison }
                        .sort_by { |c| c.data.order_leeatchison || 99 }

  featured_courses  = site.collections["courses"].resources
                        .select { |c| c.data.feature_leeatchison }
                        .sort_by { |c| c.data.order_leeatchison || 99 }
%>
```

`featured_courses` is for §3 and is derived here so the file reads the
collections once.

**Wrap the whole band in `<% unless spotlight_books.empty? && spotlight_courses.empty? %>`**,
matching the guard `AtchisonAcademy/src/index.erb` puts on its own sections. A
band with nothing in it should not render an empty strip — and once membership
is explicit rather than "whatever sorted first", empty is a state that can
actually happen.

**Render with the existing card classes** — `.book-card` for the book,
`.course-card` for the courses, including `courses.erb`'s `prelaunch` branch —
so the band inherits the site's card styling and platform badge. New CSS is
limited to the band's own wrapper (§4).

**Link targets** (decided 2026-08-31). Course cards link to their local pages
(`relative_url course.relative_url`), matching `courses.erb`. The book card
links to `book.relative_url` — the local `/books/the-software-conductor/` page
— **not** `https://thesoftwareconductor.com` as the hardcoded Books section
does. That is a visible inconsistency on one page, accepted deliberately: the
band should behave like the rest of the collection-driven page, and the book's
own page carries `book_url` to thesoftwareconductor.com one click later. It
resolves when the Books section gets its own spec.

**Copy** (decided 2026-08-31). Section label `What's New`, section title
**"What's New from Lee"**, in the site's existing `.section-label` /
`.section-title` pair. The label and the title deliberately say nearly the same
thing — the redundancy is the point, since the title has to hold up as the
band's contents rotate and a dated claim like "New This Year" would not. No
intro paragraph: the band's job is to be scanned in under two seconds on the
way past.

### 3. Rebuild the Courses section from the shared collection

**File:** `src/index.erb`, the `<section class="courses" id="courses">` block,
lines 142–196.

Keep:

- The section wrapper, its `id="courses"`, and its two-column
  `.courses-inner` grid.
- The whole left column: the `180,000+` `.stat-card`, which Spec0011
  deliberately corrected and which is the section's strongest asset.
- The `.section-label`, `.section-title` and `.courses-desc` in the right
  column.

Replace the `<div class="platform-cards">` block (lines 156–193) with a grid of
real course cards, rendered from `featured_courses` in `order_leeatchison`
order, using the `.course-card` markup from `courses.erb` lines 37–46:

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
  (`target="_blank" rel="noopener noreferrer"`, matching `courses.erb` line 87
  and Spec0007's rule that only the navbar entry stays same-tab).

**Three things this fixes for free.** The wrong specialization name (§4 of the
problem) disappears with the block that held it; the O'Reilly card's hardcoded
course title goes with it; and the section stops being able to drift from the
data at all.

**Two things it costs, and why that is acceptable.** The four platform
destinations Spec0011 completed stop being listed as such, and the Atchison
Academy logo leaves the home page. The per-course `.course-card-platform` badge
names the platform on every card, so the platform information survives at the
level a visitor acts on, and the explicit Academy button above replaces the
Academy platform card's job with a link that Spec0011's card never had.
Recorded here because it partially reverses a Spec0011 decision on purpose.
See Open Question 1 for the "keep both" alternative.

**The band and this section will overlap.** Both currently render *Risk
Management* and *Cloud Architecture* — spotlight and feature are set on the
same two courses today. Two cards repeated four screens apart is acceptable and
arguably reinforcing, but it is a real consequence of keeping the two keys
independent, and worth looking at once it is on screen (Testing step 4). The
lever if it reads badly is `feature_leeatchison`, not the band: featuring a
different pair changes the lower section without touching what is "new".

### 4. CSS

**File:** `frontend/styles/index.css`.

New rules:

- `.whats-new` — the band. It sits between `.hero` (navy gradient) and
  `.pillars` (`var(--bg)`), and the page alternates
  `bg / bg-alt / bg / bg-alt / navy / bg`. Give it `var(--bg-alt)` so the
  hero → band → pillars sequence keeps the alternation, with
  `padding: 3.5rem 2rem` — shorter than the 5rem sections, since it is a strip
  rather than a full section.
- `.whats-new-inner` — `max-width: var(--max-w); margin: 0 auto;` and a grid.
  Proposed `grid-template-columns: 1fr 2fr` (book, then the course cards).
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

### 5. The specialization is not on leeatchison.com

*Architecting Scalable Applications and Systems* has no `show_leeatchison` key,
so `shared_content.rb` drops it from this site entirely — no page, no card, no
possible link target, and no legal place for a `spotlight_leeatchison` key
(the new validation in §1a would fail the build). Spec0015 decided this
deliberately ("Academy only", 2026-08-31), on the grounds that its three member
courses are already listed here.

**Confirmed 2026-08-31: it stays Academy-only.** The question was put to Lee
directly, with a recommendation to bring it over — the band in §2 is exactly
the place a program-level card belongs, and Spec0015's reasoning ("the member
courses are already listed here") is weakened by a band whose whole job is to
name new things. He chose to leave that decision standing.

This is the single biggest simplification to this spec. No `order_leeatchison`
renumbering across the course collection, no new page on leeatchison.com, no
`show_*` flag touched anywhere, and §6's "Academy renders identically" claim
survives intact. The band's newness is carried by the two member Coursera
courses; the specialization page stays an atchisonacademy.com asset.

### 6. What this does *not* change

- **`AtchisonAcademy` renders identically.** Its builder gains a constant and
  one array element (§1a), and `spotlight_academy` is set on nothing, so its
  own validation passes trivially and no template reads the key. The three
  `shared/` files gain `spotlight_leeatchison`, which that site's builder never
  looks at. Verify this rather than assume it — Testing step 9.
- **No `canonical_site`, `show_*`, `feature_*`, `order_*` or `availability`
  value changes**, so the other three validations behave exactly as before.
- **The Books section stays hardcoded** and keeps its external
  `thesoftwareconductor.com` / `businessbreakthrough30.com` /
  `architectingforscale.com` links. Converting it is its own spec (decided
  2026-08-31); the item is queued in `Projects/_Projects.md`.
- **The About, Insights and Contact sections and the hero do not move.** The
  hero's `Explore Resources` button still points at `/#insights`; the band does
  not take an anchor.
- **No documentation counts change.** No book or course is added or removed.
  `CLAUDE.md`'s key table for `LeeAtchison` **does** need the new row — see
  step 7 of the Summary.

---

## Testing

Run the site locally — `bin/site-port LeeAtchison` for this checkout's port —
and check:

1. **The build runs.** With the §1a change in place, a green build already
   proves the three new keys are on items that carry `show_leeatchison`.
2. **The validation actually fires.** Temporarily add `spotlight_leeatchison: true`
   to an Academy-only course (`architecting-scalable-applications-and-systems.md`
   is the natural one) and confirm the build fails naming that file and key,
   then remove it. A new build failure that has never been seen to fail is not
   yet a guarantee.
3. **`/` renders the What's New band** directly below the hero, above the
   pillars, with *The Software Conductor* (cover, "New Release" tag) and the
   two Coursera cards, *Risk Management for Scalable Systems* first.
4. **Judge the band and the Courses section on screen.** Three cards in the
   band is the decided default (§1b) — confirm it does not read thin, and add
   *Scalable Availability* only if it does. Do two cards fill the Courses
   section's `1.6fr` column next to the stat card? Does the repeat of the same
   two courses in both places read as reinforcement or as duplication (§3)?
5. **Every card links somewhere real** — no 404s, and the book card lands on
   the local `/books/the-software-conductor/` page, not
   thesoftwareconductor.com.
6. **No stale specialization name anywhere on `/`.**
   `grep -ri "Architecting Scalable Systems" LeeAtchison/src/` should return
   nothing (note the shipped name has "Applications and" in the middle).
7. **Responsive.** At 900px the band and the course grid both collapse to one
   column; at 768px the band's padding drops with its neighbors; at 540px
   nothing overflows.
8. **Dead CSS.** `grep -rn "platform-card" LeeAtchison/` returns nothing after
   the removal.
9. **`AtchisonAcademy` builds green and its output is unchanged.** Build it
   before and after and diff `output/` — the builder edit and the three
   `shared/` keys must produce a byte-identical site. This is the one claim in
   §6 worth proving rather than reasoning about.
10. **`/courses` and `/books` on both sites are untouched.** Same cards, same
    order.

`rake test` (port derivation) is unaffected but should still pass.

---

## Summary of Steps Needed

1. Add `SPOTLIGHT_FLAG` and extend `validate_stray_site_keys!` in **both**
   copies of `shared_content.rb`, and update the method comment (§1a).
2. Add `spotlight_leeatchison: true` to the three `shared/` files in §1b.
3. Add the collection-reading ERB preamble to `LeeAtchison/src/index.erb` (§2).
4. Insert the `.whats-new` band, with its empty guard, between the hero and the
   pillars (§2).
5. Replace the `.platform-cards` block in the Courses section with a
   collection-driven `.home-courses-grid`, plus the two links below it (§3).
6. Add `.whats-new`, `.whats-new-inner` and `.home-courses-grid` to
   `frontend/styles/index.css`, add both to the existing 900px and 768px media
   blocks, and delete the seven dead `.platform-*` rules and the
   `.platform-cards` responsive line (§4).
7. Add `spotlight_leeatchison` / `spotlight_academy` to the key table in
   `LeeAtchison/CLAUDE.md` and `AtchisonAcademy/CLAUDE.md`, noting that the
   Academy key is validated but unrendered.
8. Work through Testing on both sites, including the deliberate-failure check
   (step 2) and the Academy output diff (step 9).

---

## Open Questions

**None. Every question raised during refinement is answered below.**

1. **Should the build cap the band's size?** *(Deferred 2026-08-31, not open —
   recorded here so it stays findable.)* The explicit key removes the "silently
   wrong" failure but not the "silently grows" one: nothing stops
   `spotlight_leeatchison` accumulating until the band is a wall. A count check
   would live in the `:site, :post_read` hook after the per-resource loop, not
   in `validate!`, since it is a property of the set rather than of any one
   item — perhaps a dozen lines. Revisit if the band ever grows past four.

**Answered 2026-08-31:**

- **An explicit `spotlight_leeatchison` key**, not the existing sort order,
  decides what appears in the band.
- **The band's title is "What's New from Lee"**, under the `What's New` label.
- **The specialization stays Academy-only.** No `show_leeatchison`, no
  `order_leeatchison` renumbering, no `shared/` change beyond the three
  spotlight keys.
- **No build-time cap on the band's size**, for now.
- **The Books section is not converted here** — it gets its own spec, queued in
  `_Projects.md`.
- **The band's book card links to the local book page**, not
  `thesoftwareconductor.com`.
- **Three cards in the band, not four:** *Scalable Availability in Software
  Architecture* is not spotlighted.

---

## History of Updates

**2026-08-31 — Spec created.** Written from Lee's request to put the new
courses and the new book higher on the leeatchison.com home page, against the
repo state at commit `bd0d672` (Spec0015 merged and archived that day).

**2026-08-31 — Decided: the new book is *The Software Conductor*.** Lee
confirmed it is not a book missing from `shared/_books/`, so this spec adds no
content — only placement.

**2026-08-31 — Decided: a new band under the hero, not a section reorder.**
The alternative offered was moving Books and Courses above About. Lee chose the
band. It leaves every existing section's order, content and anchor intact,
which keeps the diff to one insertion plus one replacement.

**2026-08-31 — Decided: the Courses section becomes collection-driven.** Lee
chose this over the narrower option of correcting the stale specialization name
in the hardcoded platform cards. That narrower fix is now unnecessary — the
block holding the wrong name is being deleted.

**2026-08-31 — Decided: an explicit `spotlight_leeatchison` key.** The spec
originally derived the band from `feature_leeatchison` + `order_leeatchison`,
taking the first-sorted items, on the grounds that it produced the right answer
today with no new machinery. Lee asked for the explicit key instead, and it is
the better call: the derived version was correct only by coincidence and would
have failed silently the first time those lists were re-sorted for an unrelated
reason — a "What's New" band advertising a 2024 course, with nobody having
edited the home page. The cost is one more per-site key, one more build
validation, and hand-curation of the band. §1 records the trade; Open Question 2
records what the key still does not protect against.

**2026-08-31 — Noted: this partially reverses Spec0011.** That spec
deliberately completed the home page's platform cards to all four destinations.
Replacing them is a considered trade, not an oversight: the per-card platform
badge keeps the platform information, and the section gains the `/courses` and
Academy links it never had. Recorded so the reversal is findable from either
spec.

**2026-08-31 — Noted: Spec0015's "Academy only" decision is the page's biggest
open question.** It was made on 2026-08-31, before this request, and on
reasoning ("the member courses are already listed there") that a What's New
band changes. Carried as Open Question 1 rather than assumed either way.

**2026-08-31 — Decided: the specialization stays Academy-only.** Put to Lee
with a recommendation to bring it over; he chose to leave Spec0015's decision
standing. Removes the course renumbering, the new page, and the only risk to
§6's "Academy renders identically" claim. See §5.

**2026-08-31 — Decided: no build-time cap on the band, for now.** The explicit
key fixes the failure that would have been silent and wrong; a size cap guards
a failure that would be visible and merely ugly. Deferred rather than refused —
Open Question 2 records where the check would go.

**2026-08-31 — Decided: the Books section gets its own spec.** Converting it is
a link-destination question (three standalone book sites versus local
collection pages), not the template swap the Courses section was. Queued in
`Projects/_Projects.md` so it is not lost when this spec archives.

**2026-08-31 — Decided: the band's book card links locally**, accepting a
visible inconsistency with the Books section below until that section is
converted.

**2026-08-31 — Decided: three cards, not four.** *Scalable Availability in
Software Architecture* (Apr 2026) stays out of the band. Keeping the oldest
Coursera course out is what lets the headline claim newness honestly.

**2026-08-31 — Decided: the band is titled "What's New from Lee."** Three
options were offered and all three declined before Lee chose this one on a
second pass. It repeats the section label almost exactly, which is the reason
it works: the band's contents rotate by hand, so a title making a dated claim
(*New This Year*) or a release claim (*Just Released*) can be falsified by a
curation choice, while this one cannot.

**2026-08-31 — Spec fully refined.** All six questions raised during refinement
are answered and recorded above; the size-cap check is deliberately deferred
rather than open. No further input needed before implementation.
