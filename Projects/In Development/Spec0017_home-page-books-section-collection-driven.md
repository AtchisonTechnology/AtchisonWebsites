# Make the leeatchison.com home page Books section collection-driven

* **ID:** Spec0017
* **Status:** In Development
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison` (`src/index.erb`, and `frontend/styles/index.css` only if Open Question 2 lands on capping the grid). No file under `shared/` changes, so `AtchisonAcademy` is untouched.

---

## Problem/Requirement

`LeeAtchison/src/index.erb` lines 73–140 render the home page's Books section
as four hardcoded `<article class="book-card">` blocks. Every fact on every
card — cover path, badge, title, author line, blurb, link — is typed into the
template, while the same facts already live in `shared/_books/` and are read by
`src/books.erb`, `src/_layouts/book.erb`, and (after Spec0016) the What's New
band on the very same page.

Four concrete consequences, all verified against the repo on 2026-08-31:

1. **The order is wrong and nobody can tell.** The four hardcoded cards are the
   four `feature_leeatchison` books, but in the order 1, 3, 2, 4:

   | Position | Home page | `order_leeatchison` |
   |---|---|---|
   | 1 | The Software Conductor | 1 |
   | 2 | Business Breakthrough 3.0 | **3** |
   | 3 | Architecting for Scale | **2** |
   | 4 | Overcoming IT Complexity | 4 |

   `/books` renders these same four books in 1, 2, 3, 4. The two pages
   disagree today and no build failure says so.

2. **The author line is written by hand and differs from the data.** The
   Business Breakthrough 3.0 card reads *"with Ken Gavranovic"*. The book's
   `authors:` list is `[Lee Atchison, Ken Gavranovic]`, which `books.erb`
   renders as *"Lee Atchison, Ken Gavranovic"*. Neither is wrong; they are just
   two different strings for the same fact, maintained separately.

3. **The blurb is a hand-edited variant of `summary`.** Three of the four cards
   quote `summary` verbatim. *The Software Conductor* does not: the home page
   says *"…from software developer to architect. Designing systems. Leading
   teams. Creating harmony."* while `summary` says *"…from software developer
   to architect — designing systems, leading teams, creating harmony."* A
   deliberate rewrite at some point, now an untracked fork.

4. **A fifth featured book would silently break the row.** `.books-grid` is
   `grid-template-columns: repeat(4, 1fr)` (line 482). Adding
   `feature_leeatchison` to a fifth book leaves the home page rendering four
   hardcoded cards regardless — and if this section is converted without
   thought, it renders 4 + 1 orphan.

This is the same class of problem Spec0016 fixed in the *Courses* section on
this page, where the hardcoding had already produced a factual error (the home
page named the Coursera specialization wrongly for months). The Books section
has not gone factually wrong yet. It has gone quietly inconsistent, which is
the same failure one step earlier.

### Why this is a separate spec from Spec0016

Spec0016 converted the Courses section and deliberately left this one alone.
The Courses block was a straight template swap: those cards already pointed at
local `/courses/:slug/` pages, so reading them from the collection changed
nothing a visitor could see except the content becoming correct.

The Books cards are not that. Three of the four link **off-site**, to
standalone book sites:

| Card | Home page link | `book_url` in front matter | `amazon_url` |
|---|---|---|---|
| The Software Conductor | `thesoftwareconductor.com` | ✅ same | ✅ |
| Business Breakthrough 3.0 | `businessbreakthrough30.com` | ✅ same | — |
| Architecting for Scale | `architectingforscale.com` | ✅ same | ✅ |
| Overcoming IT Complexity | Amazon (`tag=leeatchison-20`) | **absent** | ✅ same |

So converting the section forces a decision the Courses conversion never had to
make: does a home-page book card send a visitor to leeatchison.com's own book
page, or straight out to that book's marketing site? Open Question 1.

**The good news, found while writing this spec:** every one of those four
destinations is *already in the front matter*. The home page's link column is
exactly `book_url || amazon_url` for all four books, so no URL needs
hardcoding to preserve today's behavior. **Decided 2026-08-31: keep both
destinations** — local page primary, off-site secondary. §2 has the markup.

### The inconsistency Spec0016 introduced

Spec0016's What's New band renders *The Software Conductor* as a `.book-card`
linking to the **local** `/books/the-software-conductor/` page. Four screens
below, this section renders the same book as a `.book-card` linking to
**thesoftwareconductor.com**. Same component, same book, same page, two
destinations. That was accepted there as a known cost, explicitly deferred to
this spec (Spec0016 §2, "Link targets", decided 2026-08-31).

**Resolved 2026-08-31:** both now treat the local book page as a book card's
primary destination. The band shows only that link; this section adds a
secondary off-site link, because it is the page's showcase for the book
properties. Same primary behavior in both places, one of them carrying an extra
affordance — a deliberate difference rather than the contradiction it is
today.

---

## Solution/Fix/Change

### 1. Read the collection

`index.erb` already builds `spotlight_books` and `featured_courses` at the top
of the file (Spec0016 §2). Add the featured-books list to that same preamble:

```erb
featured_books = site.collections["books"].resources
                   .select { |b| b.data.feature_leeatchison }
                   .sort_by { |b| b.data.order_leeatchison || 99 }
```

`shared_content.rb` has already dropped everything without `show_leeatchison`
at `:site, :post_read`, so no membership filter is needed — the site's
CLAUDE.md rule that templates filter only on featuring and order.

### 2. Replace the four hardcoded cards

**File:** `src/index.erb`, lines 80–138 (the `<div class="books-grid">` block
and its four `<article>` children). The `<section class="books" id="books">`
wrapper, its `.section-header` (label *Published Works*, title *Books by Lee
Atchison*, and the "Practical guides…" line) stay exactly as they are.

Render each card from the resource, following `books.erb` lines 25–48 for
field handling — `badge_style || 'new'`, the `if book.data.authors` guard, and
`authors.join(", ")`:

```erb
<div class="books-grid">
  <% featured_books.each do |book| %>
    <article class="book-card">
      <a href="<%= relative_url book.relative_url %>" class="book-card-link-wrap">
        <div class="book-cover-wrap">
          <img src="<%= relative_url book.data.cover_image %>"
               alt="<%= book.data.title %> book cover" class="book-cover" />
        </div>
      </a>
      <div class="book-card-body">
        <% if book.data.badge %>
          <span class="book-tag book-tag--<%= book.data.badge_style || 'new' %>"><%= book.data.badge %></span>
        <% end %>
        <h3><a href="<%= relative_url book.relative_url %>"><%= book.data.title %></a></h3>
        <% if book.data.authors %>
          <p class="book-authors"><%= book.data.authors.join(", ") %></p>
        <% end %>
        <p><%= book.data.summary %></p>
        <div class="book-card-actions">
          <a href="<%= relative_url book.relative_url %>" class="book-link">Details &rarr;</a>
          <% if book.data.book_url %>
            <a href="<%= book.data.book_url %>" class="book-link book-link--amazon"
               target="_blank" rel="noopener noreferrer">Visit the book site</a>
          <% elsif book.data.amazon_url %>
            <a href="<%= book.data.amazon_url %>" class="book-link book-link--amazon"
               target="_blank" rel="noopener noreferrer">Amazon</a>
          <% end %>
        </div>
      </div>
    </article>
  <% end %>
</div>
```

**Three visible changes fall out of this, and all three are the point:**

- Cards 2 and 3 swap, giving *Architecting for Scale* before *Business
  Breakthrough 3.0*, matching `/books` and `order_leeatchison`.
- The BB3.0 author line becomes "Lee Atchison, Ken Gavranovic".
- *The Software Conductor*'s blurb becomes the `summary` sentence.

None needs a content decision: `shared/` is the source of truth by
construction (Spec0008), and these three strings are the drift. If Lee prefers
the home page's punchier Software Conductor blurb, the fix is to edit
`summary` in `shared/_books/the-software-conductor.md` — which then also
improves its card on `/books`, on the Academy home page, and in Spec0016's
band. Flagged in Testing step 3 as a look-at-it, not as a blocker.

**Link behavior** (decided 2026-08-31): cover and title go to the local
`/books/:slug/` page; a second link beside "Details →" goes off-site, labeled
from the destination. `book_url` is preferred over `amazon_url`, and the
`elsif` means exactly one off-site link renders — which reproduces today's four
destinations precisely, since *Overcoming IT Complexity* is the only one of the
four with no `book_url`. This is the pattern `books.erb` lines 41–46 already
ship, so the band above and this section now agree on where a book card's
primary link goes, while the book sites keep their home-page entry point.

**External-link convention:** `target="_blank" rel="noopener noreferrer"` on
the off-site link, matching `books.erb` and Spec0007's rule that only the
navbar's cross-property entries stay in the same tab.

**No CSS changes.** `.book-card`, `.book-card-link-wrap`, `.book-cover-wrap`,
`.book-tag`, `.book-tag--*`, `.book-authors`, `.book-card-actions`,
`.book-link` and `.book-link--amazon` are all already defined and already used
by `books.erb`; the markup above reuses them unchanged. One wrinkle: the
off-site link reuses `.book-link--amazon` even when it points at a book site
rather than Amazon — see Open Question 3.

### 3. Also fix the section's missing "View all"

The Books section has never linked to `/books`, the same gap Spec0016 closed in
the Courses section. Add below the grid, matching what that spec added there:

```erb
<div style="text-align:center; margin-top:2.5rem;">
  <a href="<%= relative_url '/books' %>" class="btn btn-outline">View All Books &rarr;</a>
</div>
```

(`AtchisonAcademy/src/index.erb` uses exactly this inline-style block for its
own "View All Books" button; matching it is the cheapest consistent option and
avoids a new CSS rule for one button. Replacing both with a shared class is a
tidy-up for whenever someone is in that stylesheet anyway.)

### 4. What this does *not* change

- **No file under `shared/` is touched**, so `AtchisonAcademy` renders
  identically and no `shared_content.rb` validation is involved. This is a
  single-template change plus one optional CSS rule.
- **`/books` is untouched.** It already reads the collection correctly.
- **The What's New band is untouched.** Open Question 1 may make its book card
  and this section's cards agree, but the band's own code does not change
  either way.
- **No new front-matter key**, and in particular no `spotlight_*` involvement —
  this section is governed by `feature_leeatchison`, as it always has been.
- **No book is added, removed, featured or unfeatured.** Same four books.

---

## Testing

Run the site locally — `bin/site-port LeeAtchison` for this checkout's port:

1. **`/` renders four book cards** in `order_leeatchison` order: The Software
   Conductor, Architecting for Scale, Business Breakthrough 3.0, Overcoming IT
   Complexity. Confirm the swap actually happened — this is the change most
   likely to look like a mistake to someone who knows the old page.
2. **Every card's cover, badge, badge color, author line and blurb match its
   file** in `shared/_books/`. The badge colors come from `badge_style`
   (`new` / `collab` / `oreilly`), so a wrong-colored tag means a wrong
   `badge_style`, not a CSS problem.
3. **Read the Software Conductor blurb on the page.** It is now the `summary`
   sentence. Decide whether to keep it or promote the old home-page wording
   into `summary` (§2). Either is fine; drifting again is not.
4. **Every card's link goes where Open Question 1 decided**, with no 404s, and
   every Amazon URL still carries `tag=leeatchison-20` (CLAUDE.md's standing
   rule — check the rendered HTML, not the front matter).
5. **`View All Books →` reaches `/books`**, and `/books` shows the same four
   books in the same order in its featured row.
6. **The What's New band and the Books section agree**, or disagree
   deliberately per Open Question 1. Look at both on one screen-scroll.
7. **Responsive.** `.books-grid` is `repeat(4, 1fr)`, dropping to 2 at 1024px
   and 600px. Nothing here changes that, but confirm the cards still fill it
   evenly now that the author lines are longer.
8. **Add a fifth featured book temporarily** — set `feature_leeatchison: true`
   on any book, rebuild, and look at the row. This is the Open Question 2
   evidence; remove it afterward.
9. **`AtchisonAcademy` builds green and its output is unchanged.** `git status`
   showing nothing modified under `shared/` is most of this proof.

`rake test` (port derivation) is unaffected but should still pass.

---

## Summary of Steps Needed

1. Add `featured_books` to the `index.erb` preamble (§1).
2. Replace the four hardcoded `<article>` blocks with the collection loop (§2).
3. Add the link block per whatever Open Question 1 decides (§2).
4. Add the `View All Books →` button (§3).
5. Cap or wrap the grid if Open Question 2 says so (§4 of Testing is the
   evidence).
6. Work through Testing, and confirm nothing under `shared/` is modified.

---

## Open Questions

1. **Should the featured-books grid be capped or made to wrap?**
   *(Superseded by Spec0018, 2026-08-31 — recorded so the reasoning stays
   findable.)* `.books-grid` is `repeat(4, 1fr)` and there are exactly four
   featured books, so today's page is correct by coincidence. Spec0018 replaces
   that base rule in both stylesheets with
   `repeat(auto-fit, minmax(220px, 260px))` plus `justify-content: center`, to
   fix the left-hugging two-card row on atchisonacademy.com/books. This page's
   grid uses the same class and inherits the fix. Whichever spec ships second
   should confirm the rule is already in place rather than write it twice; if
   Spec0018 is cancelled, this reopens as originally posed.

2. **Should the section's `.section-header` copy change?** It currently reads
   *"Practical guides for architects and technology leaders navigating modern
   software challenges."* `/books` says something similar but not identical.
   **Proposed: leave both alone.** They are section intros, not facts about
   books, and nothing about this conversion makes them wrong.

3. **Is `.book-link--amazon` the right class for a non-Amazon off-site link?**
   §2 reuses it for "Visit the book site" because it already carries the
   secondary-link styling and adding a rule for one button is noise. The class
   name is then inaccurate on three of the four cards. Options: reuse and accept
   the misnomer; add `.book-link--external` as an identical rule and pick the
   right name per destination; or rename outright in both stylesheets and both
   `books.erb` copies. **Proposed: reuse it now**, and rename in whatever spec
   next touches that CSS for another reason — a cosmetic rename across four
   files is not worth its own diff.

**Answered 2026-08-31:**

- **A book card links both ways:** cover and title to the local
  `/books/:slug/` page, plus one off-site link chosen as `book_url` then
  `amazon_url`.

---

## History of Updates

**2026-08-31 — Spec created**, from the item queued in `_Projects.md` during
Spec0016's refinement. Written against commit `bd0d672`.

**2026-08-31 — Found: all four link destinations are already in the front
matter.** The home page's hardcoded links are exactly `book_url || amazon_url`
for all four books (*Overcoming IT Complexity* is the one with no `book_url`,
which is why its card points at Amazon). This shrinks Open Question 1 from
"where do we get these URLs" to purely "which destination should a card
prefer" — no URL needs hardcoding under any option.

**2026-08-31 — Found: three concrete drifts, not just a structural smell.** The
card order disagrees with `order_leeatchison` (1, 3, 2, 4), the BB3.0 author
line is a hand-written string the data renders differently, and *The Software
Conductor*'s blurb is a hand-edited fork of its `summary`. Recorded in the
Problem section so the conversion's visible diffs are expected rather than
alarming at review.

**2026-08-31 — Noted: this spec inherits an inconsistency Spec0016 knowingly
created.** That spec's What's New band links a book card locally while this
section links the same book off-site. It was accepted there as a deferred cost
and named this spec as where it resolves; Open Question 1 is that resolution.

**2026-08-31 — Decided: both destinations, matching `books.erb`.** The
alternatives were local-only (fully consistent with Spec0016's band, but it
removes the home page's only direct route to the three book sites) and
off-site-only (preserves today's behavior, but leaves the band and this section
disagreeing about the same book). Both is the only option that loses nothing,
and the pattern already ships one page over with CSS that exists, so it costs
no new styling.

**2026-08-31 — Decided: the six coverless books keep their icon cards.** Asked
while settling the art questions on Spec0020. The O'Reilly-report books stay in
the `.secondary-book-card` tier with no `cover_image`, so nothing in this
spec's featured grid changes on their account.
