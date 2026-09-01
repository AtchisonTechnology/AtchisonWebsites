# Center the featured-books grid when fewer than four books are featured

* **ID:** Spec0018
* **Status:** Implementing
* **Date Created:** 2026-08-31
* **Date Implemented:** 2026-09-01
* **Systems Impacted:** `LeeAtchison` and `AtchisonAcademy` — `frontend/styles/index.css` in each. CSS only; no template, no front matter, no content.

---

## Problem/Requirement

`.books-grid` is `grid-template-columns: repeat(4, 1fr)` in both sites'
stylesheets (line 482 in each). Four fixed columns is correct **only when
exactly four books are featured**, and only one site has four.

| Site | `feature_*` books | Result |
|---|---|---|
| leeatchison.com | 4 | Row fills the container. Looks right by coincidence. |
| atchisonacademy.com | 2 | Two cards occupy the first two of four columns and hug the left edge, with half the row empty. |

Verified on the live site 2026-08-31: **atchisonacademy.com/books** renders
*The Software Conductor* and *Business Breakthrough 3.0* pinned to the left of
a centered page whose hero, section header and every other block are centered.
It reads as a layout bug, because it is one.

### The home page is already patched, separately

`AtchisonAcademy/frontend/styles/index.css` line 1830 carries:

```css
.academy-section .books-grid {
  grid-template-columns: repeat(auto-fit, minmax(220px, 260px));
  justify-content: center;
}
```

`.academy-section` wraps the home page's books block but not `/books`, whose
grid sits inside `.featured-books-section`. So the home page centers correctly
and `/books` does not — the fix exists, applied to one of the two places that
need it. Confirmed live: the home page's two cards are centered, `/books`'
are not.

That patch also outranks the responsive overrides at lines 2057
(`@media (max-width: 1024px)`) and 2083 (`@media (max-width: 600px)`), which
set `.books-grid { grid-template-columns: repeat(2, 1fr) }` at lower
specificity (`0,1,0` against `0,2,0`). Specificity beats source order, so those
media rules have never applied to the Academy home page at all. Anyone reading
the stylesheet would reasonably assume they do.

### Why fix the base rule rather than add a second patch

Decided with Lee 2026-08-31. Adding
`.featured-books-section .books-grid { … }` alongside the existing
`.academy-section .books-grid { … }` would fix `/books` with the narrowest
possible diff, and leave the stylesheet carrying two copies of one idea, a
base rule that is wrong everywhere it is not overridden, and a third copy
waiting to be written the next time a `.books-grid` appears somewhere new.

The base rule is the defect. `repeat(4, 1fr)` encodes "there are exactly four
featured books" into a stylesheet that has no way to know that.

**The change is visually a near-no-op on leeatchison.com — but only at the
right cap.** `.books-grid` sits inside `.section-inner`, whose 32px
side padding narrows the real container to **1036px**, not the full 1100px
`--max-w` the original math in this section assumed. Today's actual card
width is `(1036 − 3×24) / 4 = 241px`, not 257px.

That distinction matters because of how `auto-fit` counts tracks: for
`minmax(min, <fixed-max>)`, the browser decides how many tracks fit using the
**fixed max value**, not a value it's free to shrink further. At a 260px cap,
`4 × 260 + 3×24 = 1112px` doesn't fit in 1036px, so it drops to 3 tracks and
the 4th book wraps to its own centered row — confirmed by loading both
`/books` and `/` locally and reading the computed
`grid-template-columns` off `.books-grid` (`"260px 260px 260px"`, 4
children). That is a real, visible layout change on leeatchison.com, not a
no-op, and it fails Testing item 3 below.

**Corrected: the cap is 240px, not 260px.** Verified empirically (overriding
`grid-template-columns` in a live page and reading the computed value back)
that 241px is the largest max that still yields 4 tracks at this container
width, and 240px leaves a safe margin. At 240px, leeatchison.com's four-book
row renders at 240px cards — 1px narrower than today's actual 241px,
imperceptible — and keeps all 4 books on one row.

---

## Solution/Fix/Change

### 1. Replace the base rule, in both stylesheets

**Files:** `LeeAtchison/frontend/styles/index.css` and
`AtchisonAcademy/frontend/styles/index.css`, line 482 in each. The two files
are independent copies and must be edited identically by hand — the same
convention CLAUDE.md sets for the duplicated `SITES` registry.

```css
.books-grid {
  max-width: var(--max-w);
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 240px));
  justify-content: center;
  gap: 1.5rem;
}
```

Only `grid-template-columns` changes and `justify-content` is added;
`max-width`, `margin` and `gap` stay. `auto-fit` collapses the tracks it cannot
fill to zero width, and `justify-content: center` then centers the tracks that
remain — which is what makes a two-card row sit in the middle and a four-card
row fill the container.

### 2. Delete the Academy home-page patch

**File:** `AtchisonAcademy/frontend/styles/index.css`, lines 1830–1833 — the
whole `.academy-section .books-grid` rule. It becomes a verbatim restatement of
the base rule. Leaving it in place would be harmless today and misleading
forever.

Nothing else in the `.academy-section` block changes.

### 3. Delete the two `.books-grid` column overrides in the media queries

**Files:** both stylesheets.

- `LeeAtchison`: line 1961 (`@media (max-width: 1024px)`) and line 1987
  (`@media (max-width: 600px)`).
- `AtchisonAcademy`: line 2057 and line 2083.

Both set `grid-template-columns: repeat(2, 1fr)`, which `auto-fit` now handles
on its own: the 220px minimum takes the row to two columns at roughly 700px of
container and to one column below about 480px, continuously rather than in two
jumps.

**Keep the `gap: 1rem` from the 600px rule**, and keep the `.books-grid` entry
in the 540px `gap: 1rem` list (LeeAtchison line 2020, AtchisonAcademy line
2116). Only the `grid-template-columns` declarations go; if a rule holds
nothing else, the rule goes with it.

Leaving these in would be an active bug rather than dead weight: at ≤1024px
they would override the base rule at equal specificity, restoring
`repeat(2, 1fr)` — which left-aligns a three-card row exactly the way the
four-column rule left-aligns a two-card row today.

### 4. What this does *not* change

- **No template, no front matter, no content.** No book is featured or
  unfeatured; `feature_leeatchison` and `feature_academy` are untouched, and
  nothing under `shared/` is read or written.
- **`.secondary-books-grid`, `.more-books-grid` and `.about-books-grid` are
  untouched.** They are different grids with their own rules;
  `.secondary-books-grid` already uses `auto-fill`/`minmax` and already behaves.
- **`.courses-grid` is untouched.** It is `repeat(2, 1fr)`, which fills at every
  card count above one, and both sites have well above one course. Out of scope
  by observation, not by assumption.
- **The `.book-card` itself does not change** — same padding, same cover
  treatment, same badge.

### 5. Relationship to Spec0017

Spec0017 Open Question 2 asks whether the leeatchison.com **home page**'s
featured-books grid should be capped or made to wrap, and proposes
`auto-fit`/`minmax` for it. That grid uses this same `.books-grid` class, so
**this spec answers that question**: once the base rule is `auto-fit`, the home
page inherits the behavior and Spec0017 has nothing to decide. Whichever ships
first, the other's note should be trimmed rather than implemented twice.

---

## Testing

Run both sites locally — `bin/site-port LeeAtchison` and
`bin/site-port AtchisonAcademy`:

1. **atchisonacademy.com `/books`** — the two featured cards are centered under
   the centered hero and section header. This is the reported defect; it is the
   one screen that must change.
2. **atchisonacademy.com `/`** — the books block looks exactly as it does
   today. The patch was deleted, so this proves the base rule reproduces it.
   A regression here means the base rule and the deleted patch were not
   equivalent.
3. **leeatchison.com `/books` and `/`** — four cards, unchanged. Compare
   against a screenshot taken before the edit; the cards should be the same
   size in the same positions, not merely "about right".
4. **Card count sensitivity.** Temporarily set `feature_leeatchison: true` on a
   fifth book and reload `/books`: five cards, centered, wrapping to a second
   row rather than producing a four-plus-orphan row. Then set it on only three
   and confirm a centered three-card row. Remove both afterward. This is the
   actual point of the change and the only way to see it.
5. **Widths.** At 1024px, 900px, 768px, 600px and 375px, on both sites, the
   grid steps down cleanly and stays centered, with no horizontal overflow and
   no single card stretched to full width. Pay attention to the range around
   700px, where the two-column media rule used to take over and `auto-fit` now
   does.
6. **Nothing else moved.** `/about` (`.about-books-grid`), the secondary books
   row on both `/books` pages, and the "More Books" strip on the book layout
   all render as before.

`rake test` (port derivation) is unaffected but should still pass.

---

## Summary of Steps Needed

1. Replace `.books-grid`'s `grid-template-columns` and add
   `justify-content: center`, in both stylesheets (§1).
2. Delete `.academy-section .books-grid` from the Academy stylesheet (§2).
3. Delete the two `.books-grid` column overrides from the media queries in each
   stylesheet, keeping the gap declarations (§3).
4. Work through Testing on both sites, including the temporary five-book and
   three-book checks.
5. Trim Spec0017's Open Question 2 to point here (§5).

---

## Open Questions

1. ~~Is 260px the right maximum card width?~~ **Superseded during
   implementation (2026-09-01).** Testing found the 260px cap Lee confirmed
   was based on a container-width miscalculation and actually broke the
   no-op on leeatchison.com (wraps the 4th book to its own row — see
   Problem/Requirement above). Re-confirmed with Lee: **use 240px**, the
   value that actually keeps leeatchison.com's four-book row on one line.

2. ~~Should `.courses-grid` get the same treatment preemptively?~~ **Decided
   (2026-09-01, Lee): no.** It is not misbehaving; changing it would be a
   redesign rather than a fix, and Spec0020 may change these cards anyway.

3. ~~Is the two-copies-of-the-stylesheet arrangement worth revisiting?~~
   **Decided (2026-09-01, Lee): note it and move on** — but if it happens a
   third time, it is worth its own spec.

---

## History of Updates

**2026-08-31 — Spec created**, from Lee's report that books are not centered on
the Atchison Academy home page. Written against commit `bd0d672`.

**2026-08-31 — Found: the home page is already centered; `/books` is not.**
Checked both pages on the live site. The home page carries a
`.academy-section .books-grid` override that centers it; `/books` sits in
`.featured-books-section` and misses it. The report was right that something is
uncentered — the page was the other one.

**2026-08-31 — Decided: fix the base rule, not add a second override.** Lee
chose this over patching `/books` alone. It removes the duplicate, makes the
next `.books-grid` correct by default, and is a visual no-op on leeatchison.com
because four `auto-fit` tracks at a 260px cap compute to the same 257px the
four `1fr` columns do today.

**2026-08-31 — Found: the responsive `.books-grid` overrides have never applied
to the Academy home page.** `.academy-section .books-grid` outranks them on
specificity regardless of source order. They are deleted here rather than left
as a rule that reads as active and is not.

**2026-09-01 — All Open Questions decided; moved to Implementing.** Lee
confirmed all three proposed answers as-is: keep the 260px cap, leave
`.courses-grid` untouched, and note the stylesheet-duplication concern rather
than act on it.

**2026-09-01 — Found during implementation: 260px was wrong, breaks the
no-op.** Testing on the running dev server (per Testing item 3) showed
leeatchison.com's four-book row wrapping to 3+1 instead of staying on one
line. Root cause: `.books-grid`'s real container is 1036px (inside
`.section-inner`'s padding), not the 1100px `--max-w` the original estimate
used, and `auto-fit` counts tracks using the `minmax()` max value as fixed —
4×260px+3×24px gap (1112px) doesn't fit 1036px. Re-confirmed with Lee: use
240px instead of 260px. Both stylesheets and the Solution section above are
updated to 240px.

**2026-09-01 — Implemented and tested; Spec0017 cross-reference updated.**
Both stylesheets carry the §1–§3 changes at the corrected 240px cap. Verified
against every Testing item on locally running dev servers (`bin/dev`,
Playwright): atchisonacademy.com's two-card `/books` and home-page rows both
center under their already-centered surroundings; leeatchison.com's four-book
row (both `/books` and `/`) stays on one line, matching today's site;
temporarily featuring a 5th book wrapped it to a centered second row and
temporarily dropping to 3 produced a centered three-card row (both reverted
after, `git status` under `shared/` clean); 1024/900/768/600/375px all step
down with no horizontal overflow and no stretched single card; `/about`, the
secondary books row, and `.courses-grid` render unchanged. `make test` still
passes (unaffected). Spec0017's Open Question 1 and Testing item 7 updated to
cite the corrected 240px value.
