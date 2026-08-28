# STOSA site: book CTA, refreshed bio, and Atchison Academy hero

* **ID:** Spec0001
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-08-28
* **Date Implemented:** (pending)
* **Systems Impacted:** stosa

---

## Problem/Requirement

stosa.org does its job today: it explains the STOSA framework clearly and
credibly. What it does not do is send an engaged reader anywhere useful. A
visitor who finishes the framework content has no strong path to the book that
covers STOSA in depth, and no path at all to Atchison Academy. The author bio
is also out of date relative to the canonical bio on leeatchison.com.

Four changes are requested. None of them alter the framework content, the
diagrams, the navigation, or the visual identity of the site.

1. **Add an Architecting for Scale call to action.** Primary link to the book
   page on leeatchison.com, with a secondary link to the Amazon listing.
2. **Update the About Lee Atchison bio** to match current positioning.
3. **Remove any reference to Soundings of the Tech Tide.** (See note below:
   a full search of the site found none, so this is a verification step.)
4. **Add an Atchison Academy hero near the bottom of the page**, linking to
   atchisonacademy.com.

### Note on item 3

A case-insensitive search of the entire `stosa/` directory (source, frontend,
and built `output/`) for `soundings`, `tidesoundings`, and `tech tide` returned
zero matches. The only external links on the site today are leeatchison.com,
architectingforscale.com, and softwarearchitectureinsights.com (About section
plus footer). Item 3 is therefore carried in this spec as a verification and
confirmation step rather than a content removal. If verification finds a
reference in a place not covered by the search (for example a Netlify redirect
or an OG image), it is removed as part of this spec.

---

## Solution/Fix/Change

All work is confined to three files plus one new image asset:

| File | Change |
|---|---|
| `stosa/src/index.erb` | New book CTA band, rewritten About bio, new Academy band |
| `stosa/frontend/styles/index.css` | New `.book-cta` and `.academy-cta` styles |
| `stosa/src/images/logo-academy.png` | New asset, copied from `LeeAtchison/src/images/logo-academy.png` |

Existing design tokens are reused throughout (`--color-ink`, `--color-accent`,
`--color-bg-alt`, `--font-heading`, `--max-width`, `--section-padding`). No new
tokens, no new fonts, no CSS framework. The single 680px breakpoint continues
to collapse multi-column layouts to one column.

### 1. Architecting for Scale CTA band

**Placement:** immediately after the **Advantages** section
(`id="advantages"`, currently ending around line 159 of `src/index.erb`) and
before **Service Ownership** (`id="ownership"`). This is the point where a
reader has just absorbed why STOSA matters and is most likely to want more
depth.

**Structure:** a full-width band with its own background (proposed:
`--color-ink` dark band, matching the hero, so it reads as a deliberate break
rather than a fourth grey section). Two columns above 680px, stacked below:

* **Left:** book cover image. `src/images/cover-600.png` already exists in the
  repo (600 x 787, the Architecting for Scale 2nd Edition O'Reilly cover) and is
  currently unreferenced by any template. Reuse it. Add `alt="Architecting for
  Scale, 2nd Edition, by Lee Atchison"` and `loading="lazy"`.
* **Right:** label, heading, one paragraph, two buttons.

**Proposed copy** (subject to approval, see Open Questions):

> **Label:** Go Deeper
> **Heading:** STOSA in Depth
> **Body:** STOSA is one part of a larger approach to building applications
> that stay available as they grow. *Architecting for Scale* (O'Reilly, 2nd
> Edition) covers STOSA, service ownership, risk management, and high
> availability in full.
> **Primary button:** Read the Book
> **Secondary button:** Buy on Amazon

**Links:**

* Primary: `https://leeatchison.com/books/architecting-for-scale/`
* Secondary: `https://www.amazon.com/dp/B0859P45K9/?tag=leeatchison-20`
  (the affiliate-tagged URL already used in `LeeAtchison/src/_books/architecting-for-scale.md`)

Both open in a new tab with `target="_blank" rel="noopener"`, consistent with
every other external link on the site.

Button styling: primary uses the existing `.btn .btn-primary`; the secondary
Amazon link uses `.btn .btn-white` (already defined for use on the dark hero)
so no new button variant is needed.

### 2. Updated About Lee Atchison bio

Replace the single paragraph in the `id="about"` section of `src/index.erb`
with two shorter paragraphs drawn from the canonical bio on
`LeeAtchison/src/about.erb`, keeping the STOSA-site specifics (STOSA
authorship, Architecting for Scale, Seattle).

**Proposed replacement text** (subject to approval, see Open Questions):

> Lee Atchison is a CTO, chief software architect, author, and recognized voice
> on cloud computing, scalability, and high availability. He created Single
> Team Oriented Service Architecture (STOSA) and covers it in depth in
> *Architecting for Scale* (O'Reilly), his guide to building systems that stay
> available as they grow.
>
> Over three decades, Lee has held executive and senior engineering roles at
> Amazon.com, AWS, New Relic, Blameless, and Hewlett Packard. Today he works
> with organizations as a fractional chief architect through his practice,
> Atchison Technology, and teaches through Atchison Academy. He lives in
> Seattle, Washington.

Changes from the current bio: adds CTO and chief architect framing, names the
full company list, adds the fractional chief architect practice and Atchison
Academy, and drops the "seven years at Amazon and AWS and eight at New Relic"
tenure counts (which date the copy and require maintenance). Seattle is
retained per the site content rules. No em-dashes, per the site content rules.

**Links row.** The `.about-links` row below the bio currently carries three
links: leeatchison.com, Architecting for Scale (book), and the Software
Architecture Insights newsletter. Add a fourth link to
`https://thesoftwareconductor.com`, labeled **The Software Conductor (book)**,
so the row covers both books. Proposed final order:

| Order | Label | URL |
|---|---|---|
| 1 | leeatchison.com | `https://leeatchison.com` |
| 2 | Architecting for Scale (book) | `https://architectingforscale.com` |
| 3 | The Software Conductor (book) | `https://thesoftwareconductor.com` |
| 4 | Software Architecture Insights newsletter | `https://softwarearchitectureinsights.com` |

The books sit together, with the newsletter last. `.about-links` is already a
flex row that wraps, so a fourth item needs no CSS change; confirm the wrap
behavior at the 680px breakpoint during testing.

Note that the CTA band in item 1 links to the book page on **leeatchison.com**,
while this row links to the book's own site, **architectingforscale.com**. Both
are intentional: the CTA drives to the richer page with buy links, the bio row
lists his properties. See Open Question 8.

### 3. Soundings of the Tech Tide verification

Confirm no reference exists, in this order:

1. `grep -rniE "soundings|tidesoundings|tech.?tide" stosa/` across source,
   `frontend/`, `output/`, `netlify.toml`, and `config/`.
2. Confirm the same on the live site by checking the rendered homepage and the
   `<head>` meta tags at stosa.org.
3. If any reference is found, remove it and note it in this spec's History of
   Updates before proceeding.

No content change is expected.

### 4. Atchison Academy hero

**Placement:** as the final section of `src/index.erb`, after the
`id="about"` section and before the site footer.

**Structure:** full-width band, centered, visually distinct from the About
section above it (proposed: `--color-bg-alt` light band with the Academy shield
logo, so the page ends on a lighter note than the dark book CTA and the two
bands do not compete).

**Contents:**

* Academy shield logo, `src/images/logo-academy.png` (copied from
  `LeeAtchison/src/images/logo-academy.png`, 256px purple shield, ~50KB),
  sized around 72px, `alt="Atchison Academy"`.
* Heading and one-line pitch.
* One primary button to `https://atchisonacademy.com`.

**Proposed copy** (subject to approval, see Open Questions):

> **Heading:** Keep Learning at Atchison Academy
> **Body:** Books, courses, and training from Lee Atchison, for software
> architects and technology leaders who want to build, scale, and lead with
> confidence.
> **Button:** Visit Atchison Academy

**Link target. Decided 2026-08-28:** always link to
`https://atchisonacademy.com`, never to a resolved destination behind it.
Atchison Academy is a brand with its own domain, and where that domain points is
an implementation detail that will change. Today it is an alias domain on the
leeatchison.com Netlify site that 301-redirects every path to
`https://leeatchison.com/academy/` (see `LeeAtchison/netlify.toml`), so the link
currently costs one redirect hop. That hop is acceptable and is not a reason to
hardcode the redirect target anywhere on stosa.org. When atchisonacademy.com
becomes its own site, this link keeps working with no change here.

This applies to any future Academy reference on stosa.org, not just this band.

### Section rhythm after the changes

| Order | Section | Background |
|---|---|---|
| 1 | Hero | dark ink |
| 2 | Key facts strip | accent |
| 3 | What is STOSA? | grey (`alt`) |
| 4 | STOSA vs. Non-STOSA | white |
| 5 | Advantages | grey (`alt`) |
| 6 | **Book CTA (new)** | **dark ink** |
| 7 | Service Ownership | white |
| 8 | Organization | grey (`alt`) |
| 9 | About | white |
| 10 | **Atchison Academy (new)** | **grey** |
| 11 | Footer | existing |

Both new bands carry their own background, so no existing `section` /
`section alt` class needs to change.

---

## Testing

1. **Local build.** `stosa/bin/dev` (port 10000 on main, or 10000 + N in a
   worktree). Confirm the site builds with no Bridgetown or esbuild errors.
2. **Visual review, desktop.** Full-page review at 1440px wide. Both new bands
   read as intentional; the dark book CTA does not fight the hero; spacing
   matches the existing `--section-padding` rhythm.
3. **Visual review, mobile.** At 375px and at the 680px breakpoint: the CTA's
   two columns stack with the cover above the text; the cover does not
   overflow; both buttons are full-width or comfortably tappable; the Academy
   band stays centered.
4. **Link verification.** Click every link in both new bands and in the
   updated About section, including all four `.about-links` entries. Confirm
   the row wraps cleanly at 680px and below with four items. Confirm:
   * leeatchison.com/books/architecting-for-scale/ resolves (200, correct book
     page).
   * The Amazon URL resolves to Architecting for Scale with the
     `tag=leeatchison-20` affiliate tag intact.
   * The Academy button's `href` is exactly `https://atchisonacademy.com`, not
     a resolved destination, and the domain resolves to the Academy page
     (today via its 301).
   * thesoftwareconductor.com resolves to The Software Conductor book site.
   * All three open in a new tab and carry `rel="noopener"`.
5. **Soundings verification.** The grep in item 3 returns zero matches against
   both `src/` and a fresh `output/` build.
6. **Content rules check.** No em-dashes anywhere in the new or edited copy.
   Author location reads Seattle. No invented STOSA rules, statistics, or
   endorsements introduced.
7. **Regression check.** Navbar anchors (`#what-is-stosa`, `#ownership`,
   `#organization`, `#about`) still scroll to the right sections after two new
   sections are inserted. Footer unchanged. OG meta tags unchanged.
8. **Production build.** `rake deploy` (clean, esbuild, build) completes
   cleanly before the PR.

---

## Summary of Steps Needed

1. Resolve the Open Questions below (copy approval, band colors, Academy link
   target).
2. Copy `LeeAtchison/src/images/logo-academy.png` to
   `stosa/src/images/logo-academy.png`.
3. Add the book CTA band to `src/index.erb` after the Advantages section.
4. Replace the About bio paragraph with the approved two-paragraph version, and
   add the fourth link (The Software Conductor) to the `.about-links` row.
5. Add the Atchison Academy band to `src/index.erb` after the About section.
6. Add `.book-cta` and `.academy-cta` styles to the STOSA-specific block at the
   bottom of `frontend/styles/index.css`, including the 680px collapse rules.
7. Run the Soundings verification grep and the live-site check.
8. Run the full test plan above.
9. Request permission to commit; create a PR on request.

---

## Open Questions

1. **Book CTA copy.** Is the proposed "STOSA in Depth" heading and body
   paragraph right, or should it lean harder on a specific benefit (for example
   the risk matrix or the availability material)? *Proposed above, awaiting
   approval.*
2. **Book CTA band color.** Proposal is a dark ink band to break the grey/white
   alternation. The alternative is the accent blue used by the key facts strip,
   which is louder but ties the CTA to the "Covered in Depth / Architecting for
   Scale" fact already in that strip. *Recommendation: dark ink.*
3. **Academy band copy.** The proposed pitch is adapted from the Academy hero
   on leeatchison.com. Approve as written, or supply different copy?
4. **Key facts strip.** Its middle item already says "Covered in Depth /
   Architecting for Scale" but is not a link. Should it become a link to the
   same book page now that a full CTA exists, or stay plain text so the CTA
   band is the single conversion point? *Recommendation: stay plain text.*
5. **About links row, Academy.** The row is gaining The Software Conductor
   (confirmed). Should it also gain a fifth link to Atchison Academy, or is the
   new Academy band directly below it sufficient? *Recommendation: no Academy
   link in the row, to avoid duplicating it twice within one screen.*
6. **Book site vs. book page.** The links row points at
   architectingforscale.com while the CTA band points at
   leeatchison.com/books/architecting-for-scale/. Keep both as proposed, or
   make them consistent? *Recommendation: keep both. They serve different
   jobs.*
7. **Branching mode.** Implement on `main` (this is a contained, single-site
   content change) or in a `spec0001` worktree (stosa dev port 10001)?
   *Recommendation: worktree, since the site is live and the change touches
   shared CSS.*

---

## History of Updates

* **2026-08-28** Spec created from Lee's four requests for stosa.org. Research
  performed before drafting: read `stosa/CLAUDE.md`, `src/index.erb`,
  `_partials/_footer.erb`, `_components/shared/navbar.erb`,
  `_data/site_metadata.yml`, and `frontend/styles/index.css`; read
  `LeeAtchison/src/about.erb`, `src/academy.erb`,
  `src/_books/architecting-for-scale.md`, and `netlify.toml`.
* **2026-08-28** Established that no Soundings of the Tech Tide reference
  exists anywhere in `stosa/`. Item 3 recorded as a verification step rather
  than a removal, per Lee's direction.
* **2026-08-28** Established that `stosa/src/images/cover-600.png` is the
  Architecting for Scale 2nd Edition cover and is currently unreferenced by any
  template. Spec reuses it rather than adding a new asset.
* **2026-08-28** Established that `atchisonacademy.com` 301-redirects to
  `leeatchison.com/academy/` via `LeeAtchison/netlify.toml`. Initially raised as
  an open question; resolved same day (see below).
* **2026-08-28** Placement decisions confirmed by Lee: book CTA as a dedicated
  mid-page band; bio rewritten from the leeatchison.com canonical bio; Academy
  band after the About section and before the footer; Soundings handled as
  verification only.
* **2026-08-28** Lee added a requirement: the `.about-links` row must also link
  to thesoftwareconductor.com. Recorded in the bio item with a proposed link
  order that groups the two books together. Raised the resulting consistency
  question (book site vs. book page) as Open Question 7.
* **2026-08-28** **Decided (Lee):** Academy links always point at
  `https://atchisonacademy.com`. The current 301 to leeatchison.com/academy/ is
  temporary and must not be relied on or shortcut, since atchisonacademy.com
  will not always be a redirect. Open Question 4 closed and the remaining
  questions renumbered.
