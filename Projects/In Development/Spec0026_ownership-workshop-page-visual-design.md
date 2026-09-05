# Ownership Workshop page — visual design and equal-weight CTAs

* **ID:** Spec0026
* **Status:** Implementing
* **Date Created:** 2026-09-05
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** AtchisonAcademy, LeeAtchison *(stylesheet parity only — see Spec0025 Q4)*

---

## Problem/Requirement

Spec0025 built `atchisonacademy.com/ownership-workshop` and it carries everything the
offer needs. Reviewing the live page on 2026-09-05, Lee raised two problems. The second
is the serious one.

### 1. The page is a wall of text

There is no image on it. A page asking a director to consider a $6,000 engagement gives
a reader nothing to look at and no reason to start reading.

### 2. 🔴 The two calls to action are grossly unequal, which breaks a project rule

The two contact routes sit side by side in two columns. **They do not render at
remotely the same size or shape.**

- The **SavvyCal** widget renders inline with an avatar, a headline, a duration and
  location, a **full month calendar**, and a timezone selector. It is tall and visually
  busy.
- The **Kit** form renders as five compact fields and a button, roughly a quarter of the
  visual weight.

⚠️ **This is a rule violation, not a matter of taste.** The `workshop-ownership` project
records, twice, that the two routes are **equal options with no hierarchy**, and that
neither may be presented as the serious one. Lee's words, recorded 2026-09-04:
*"Some people (myself included) would much rather discuss via email than on a phone call,
but some want the phone call."* An earlier draft that demoted the email door was
corrected on those grounds.

⭐ **The current layout re-creates that hierarchy visually.** The copy says the doors are
equal; the page says the call is the main event and email is the small box beside it. **A
reader believes the layout.**

### Why this needs a fix in shape, not in styling

Any approach that leaves both embeds rendered inline is trying to make two third-party
widgets of fundamentally different size look equal. That fight does not end — their
heights are set by SavvyCal and Kit, change when either vendor changes their embed, and
differ again at every viewport width.

### Mobile is a first-class case here

**Lee, 2026-09-05:** *"I believe executives may very well be doing this on phones, so
making it look and act reasonable on mobile is important."* The buyers this page targets
are directors and VPs, who read email on a phone. **Mobile is not the degraded case to
be checked last; it is a primary case.**

---

## Solution/Fix/Change

### 1. Replace the side-by-side embeds with an accordion

**Two identical buttons, both collapsed on load. Clicking one expands its form in place.**

⭐ **Equality becomes structural rather than styled.** On load the page shows two
identical amber buttons and nothing else, so **there is nothing left that can be
unequal**. The vendors' widget sizes stop mattering, because no widget is on screen until
a reader chooses one.

**Required behaviour:**

- **Both start collapsed.** Nothing is expanded on load. **An expanded-by-default panel
  would become the primary door** and re-create the problem this spec exists to fix.
- **The two buttons are identical** in size, shape, colour, and weight. Both amber fill
  (`#F2A93B`) with `#262626` text, per Spec0025 §4.
- 🔴 **When one panel expands, the other button stays visible and closed.** It must not
  be pushed off-screen. **On a phone, a collapsed sibling scrolled out of view is the
  same as not existing**, which quietly restores the hierarchy at exactly the moment the
  reader is choosing.
- **On expand, scroll the top of the panel into view.** The SavvyCal widget is tall even
  when expanded; a reader on a phone should land at the top of it rather than mid-calendar.
- Standard accessible disclosure semantics: real `<button>` elements, `aria-expanded`,
  `aria-controls`, keyboard operable, and both panels open with JavaScript disabled.

### 2. ⛔ Modals were considered and rejected — do not re-propose

Lee's first suggestion was a dialog for each route, and it solves the equality problem
just as well. **It was rejected on a concrete finding, and the finding should not have to
be rediscovered.**

- 🔴 **Kit's form format is a per-form property. Switching `workshop-ownership` to modal
  means creating a NEW form** — verified by Lee 2026-09-05. New form id, new embed
  snippet, and **both Kit tags re-applied by hand**: `workshop-ownership-conversation`
  (the gate metric) and `no-auto-sai` (the consent guard). ⚠️ **A modal form that
  silently lost `no-auto-sai` would start subscribing sales enquiries to the SAI
  newsletter**, which is the exact failure that tag exists to prevent.
- **The accordion keeps the existing form** — id `9883199`, uid `6d6d7ce9c0` — already
  built, already field-verified.
- Dialogs are also the weaker choice on a phone, where they get cramped and can fight the
  on-screen keyboard.

**Tabs were also rejected:** a tabbed panel forces a default tab, and whichever tab is
open on load becomes the primary door.

### 3. Add the tier map image

**Asset:** `Atchison Academy/workshop-ownership/Marketing/tier-map.svg` in Dropbox,
with `tier-map-preview.png` beside it. Built 2026-09-05 in the Academy palette and real
Aptos, **760×751**. Copy it into `AtchisonAcademy/src/images/`.
✅ **This is the approved version** — redrawn the same day to drop the "Fix this first"
strip per Open Question 2.

**Placement:** beside the **"What you leave with"** section, text and image side by side,
image stacking below the text on narrow screens.

⭐ **It is not decoration, and that is why this one rather than a photo or a stock image.**
It shows the deliverable — the thing four hours actually produces. It also carries the
page's own argument: the **deploy tool sits in Tier 1 marked "nobody had said so,"** which
is the body copy's claim about the internal tool that pages you at 3am, shown instead of
asserted. **A reader who skims only the image still receives the pitch.**

SVG, so it scales cleanly and does not go soft when it stacks full-width on a phone.

### 4. Hide the "Built with Kit" badge

The embedded form renders a **"Built with Kit"** badge, visible on the live page. It is a
vendor mark on a page carrying a $6,000 offer. Hiding it is a Kit account setting, done in
Kit rather than in this repo.

### 5. Add a photo of Lee near the bio block

**`Lee Casual Vertical.jpeg`**, from `Atchison Academy/workshop-ownership/Marketing/`,
downscaled to ~640px wide and placed beside the bio text. See Open Question 1 for why the
vertical rather than the square, and for the downscaling note.

A trust cue next to the bio. Separate from the tier map and doing a different job:
the tier map makes the offer concrete, the photo makes the person real.

### 6. Stylesheet parity

Per Spec0025 Q4, new page CSS goes into **both** sites' `frontend/styles/index.css`,
byte-identical, scoped under `body.ownership-workshop`. **That is why `LeeAtchison`
appears in Systems Impacted despite gaining no page.**

---

## Testing

Test **mobile first**, since that is where the buyers are and where the equality
requirement is hardest to hold.

1. **On a phone-width viewport**, both buttons render collapsed, identical, and stacked.
2. Expanding either one leaves the other **visible and reachable without scrolling
   past the expanded panel**.
3. On expand, the viewport lands at the top of the panel, not mid-widget.
4. Both embeds work inside the accordion — the SavvyCal widget shows real availability
   and the Kit form shows all five fields in order.
5. Desktop: the two buttons still read as equal; neither is wider, taller or heavier.
6. Keyboard only: both panels can be opened and closed, and focus order is sensible.
7. With JavaScript disabled, both panels are open and both forms usable.
8. The tier map is legible at phone width and does not blur.
9. **`diff` the two sites' `index.css` and confirm they are still identical.**
10. Nothing else on either site changed.
11. A Netlify deploy preview builds and both third-party embeds still load there.

⚠️ **The end-to-end submission test is still owed and still belongs to the Academy
project, not to this spec.** It is the only thing that proves the two Kit tags apply on
submit. It writes a real subscriber and a real booking that must both be deleted
afterward. **Re-run it after this change**, since the form moves into an accordion.

---

## Summary of Steps Needed

1. Rebuild the call-to-action block as a two-button accordion, both collapsed.
2. Move the SavvyCal and Kit embeds into their panels, unchanged.
3. Copy `tier-map.svg` into `AtchisonAcademy/src/images/` and place it beside
   "What you leave with".
4. Downscale `Lee Casual Vertical.jpeg` to ~640px wide (no crop), copy into
   `AtchisonAcademy/src/images/`, and place it beside the bio block.
5. Add the CSS to both sites' `index.css`, scoped and byte-identical.
6. Hide the "Built with Kit" badge in the Kit account.
7. Test against the list above, mobile first, then on a deploy preview.

---

## Open Questions

1. ✅ **Photo chosen: `Lee Casual Vertical.jpeg`** — Lee supplied two headshots in
   `Atchison Academy/workshop-ownership/Marketing/` on 2026-09-05 and **delegated the
   choice** *("Your choice which is better")*. **Lee's own preference was the vertical
   one, and it is also the better fit.**

   **Why the vertical, and why the ratio helps rather than hurts:**
   - **It is the better photograph.** The lean-forward, hands-clasped posture reads as
     engaged and mid-conversation, matching the register of the call-to-action copy
     *("I will tell you whether this is worth your afternoon")*. `Lee Casual Square.jpeg`
     is a competent headshot; this one has a person in it.
   - **Portrait suits a side-by-side bio block better than square does.** In the
     constrained 65rem column, a portrait image and a paragraph of bio text fill each
     other's height. A square would leave dead space beneath it. Square would only win
     for a circular avatar slot, and the bio block is not one.

   ⚠️ **The source is 4024×6048 and 11 MB. It must be downscaled before it goes in the
   repo.** Target roughly 640px wide (2× a ~320px display width). **No crop is needed** —
   the aspect ratio is being used as-is, so `sips -Z 640` is sufficient and the
   crop recipe in `AtchisonAcademy/CLAUDE.md` does not apply here.

   ⚠️ **Minor, worth knowing:** the SavvyCal widget shows its own small circular avatar of
   Lee. Two photos of him can therefore appear on one screen — but only when that panel is
   expanded, and the bio sits further down the page, so this is not treated as a conflict.

2. ✅ **Tier map content: ships as drafted, MINUS the "Fix this first" strip** (Lee,
   2026-09-05). The strip has been removed and the asset redrawn; the image is now 760×751
   rather than 760×807.
   ⭐ **Why it went:** the deploy-tool row already carries the argument visually, and the
   strip restated it in words directly underneath. **Cutting a duplicate makes the image
   shorter, which matters most when it stacks full-width on a phone** — the primary case
   for this page.
   ✅ **Everything else stays:** nine services across three tiers, the generic service
   names *(deliberate — every reader recognises a checkout API and an admin console, and
   nothing reads as a specific company)*, the three tier descriptions, and the
   **deploy tool sitting in Tier 1 marked "nobody had said so,"** which is the row doing
   the persuading.
   ❌ **A fourth tier was offered and not taken.** The full framework runs Tier 1–4; three
   keeps the image compact. **Do not "correct" the image to four tiers for fidelity.**

3. ✅ **Button labels unchanged** (Lee, 2026-09-05): **"Book 20 minutes"** and
   **"Ask by email"**. Parallel in shape and length, both say what happens next, and
   neither reads as the serious option. ⚠️ **They currently render as section labels above
   the two columns; in the accordion they become the actual buttons.** Same words, new
   role.

---

## History of Updates

* **2026-09-05** — Spec created after Lee reviewed the live page built by Spec0025 and
  raised two problems: no imagery, and grossly unequal calls to action.
  **The CTA problem is recorded here as a rule violation rather than a styling
  complaint**, because the project's equal-doors constraint is a decision Lee made and
  corrected a draft over, and the current layout contradicts it visually while the copy
  honours it.
  **Modals were Lee's own first suggestion and were rejected on a finding he verified the
  same day**: Kit's form format is per-form, so a modal means a new form, a new id, and
  re-applying both tags — including the consent guard whose loss would subscribe sales
  enquiries to the newsletter. The rejection and its reason are recorded in the spec body
  so the idea is not re-proposed on its merits, which are real.
  **Mobile was raised by Lee as a primary case, not a final check**, on the grounds that
  the directors and VPs this page targets read email on phones. Two accordion
  requirements come directly from that: the sibling button stays on screen, and the
  expanded panel scrolls to its own top.
  The tier map was mocked up and shown before being specified. Three open questions
  raised, one with a proposal.
* **2026-09-05** — **Photo question closed.** Lee supplied two headshots and delegated the
  choice; `Lee Casual Vertical.jpeg` selected, which was also his stated preference. The
  reasoning is recorded with the question, including why the portrait ratio is an
  advantage for a side-by-side bio block rather than the compromise it first appeared to
  be. **Two open questions remain**, both editorial calls on Lee's own material: the tier
  map's contents, and the two button labels.
* **2026-09-05** — **Both remaining questions answered; no open questions left and the
  spec is implementable.** Lee cut the tier map's "Fix this first" strip, on the grounds
  that the deploy-tool row already makes the point and a shorter image serves the mobile
  case better; the asset was redrawn and re-committed to Dropbox at 760×751. A fourth tier
  was offered and declined, recorded so nobody adds one for fidelity to the framework.
  Button labels keep their current wording, changing role from section headings to
  actual buttons.
* **2026-09-05** — Status moved to **Implementing** on Lee's go-ahead; implementation begun on branch `claude/spec0026-implementation-bxpr9n`.
* **2026-09-05** — **Implementation pass complete on `claude/spec0026-implementation-bxpr9n`.**
  The CTA block is now a two-button accordion: both buttons sit together *above* both
  panels, so expanding one never pushes the other below a phone screen; the script
  collapses both only once it is running (with JavaScript off both stay open, both forms
  usable); one open at a time; real `<button>`s with `aria-expanded`/`aria-controls`; on
  expand the door block scrolls to the top of the viewport, offset for the sticky header.
  The accordion script is inline on the page (like the SavvyCal init) rather than in
  `index.js`, because the two sites' `index.js` files are byte-identical and this spec's
  parity obligation to `LeeAtchison` is the stylesheet only. Both embeds moved into their
  panels unchanged (Kit form uid `6d6d7ce9c0` untouched). "What you leave with" now sits in
  its own 60rem band with the tier map beside the list, image column the larger of the two,
  stacking below the text under 720px. Photo downscaled with Pillow (no `sips` in the build
  sandbox) to **640×962**, scale-only, EXIF stripped, 77KB, beside the bio at 10rem wide and
  stacked above it under 560px. CSS added to both sites' `index.css` as one block replacing
  the Spec0025 block; the block is confirmed byte-identical between sites, and the
  whole-file divergence count is unchanged from before this spec (the pre-existing
  divergence Spec0025 flagged).
  ⚠️ **Two edits to the tier map on its way into `src/images/`, source in `assets_inbox/`
  left untouched:** (1) a fallback font stack (the site's own) was added behind `Aptos` on
  every text element — as an `<img>` the SVG cannot load web fonts, and Aptos is not on
  iOS, Android or macOS, so without it the primary mobile case would render in a serif
  default; (2) the C2PA provenance `<metadata>` blob (10KB of the 11.5KB file) was dropped,
  since it hashes the original bytes and cannot stay valid once the file is edited.
  Verified with headless Chromium at 390px and 1280px: both panels hidden on load, buttons
  identical in size, stacked on phone and side by side on desktop, sibling button inside
  the viewport after either expand, panel top in view, keyboard operable (Enter/Space/Tab),
  no-JS shows both panels, every image loads, LeeAtchison still builds. **Not verifiable
  here:** the SavvyCal and Kit embeds (outbound network is blocked in this sandbox, same as
  Spec0025) — check on the deploy preview that both mount correctly inside a panel that was
  `hidden` at page load, since neither vendor script was tested against that.
  **Still owed, outside this repo:** §4 hiding the "Built with Kit" badge (Kit account
  setting, Lee), and the end-to-end submission test that proves both Kit tags apply.
