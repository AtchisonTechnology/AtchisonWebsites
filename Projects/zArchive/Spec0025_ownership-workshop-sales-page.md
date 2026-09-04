# Ownership Workshop sales page on atchisonacademy.com

**PR:** https://github.com/AtchisonTechnology/AtchisonWebsites/pull/29

* **ID:** Spec0025
* **Status:** Closed
* **Date Created:** 2026-09-04
* **Date Implemented:** 2026-09-04
* **Systems Impacted:** AtchisonAcademy, LeeAtchison *(stylesheet parity only — see Q4)*

---

## Problem/Requirement

The Atchison Academy is running a paid validation test called `workshop-ownership`:
a private half-day working session on service ownership and criticality, sold at
**$6,000 flat per engagement**, up to ~25 attendees, remote, buyer-scheduled. It is
**sold before it is built** — no facilitation material is produced until an
engagement is signed.

The test asks a question the Academy's earlier free lead magnet could not: *will
anyone spend money on this problem?* It needs a public page to point an offer at.

**Everything except the page already exists.** Two contact routes were built and
verified on 2026-09-04:

1. **A booked 20-minute call** — SavvyCal, at
   `https://savvycal.com/leeatchison/discuss-the-ownership-workshop-with-lee-atchison`
2. **An emailed question** — Kit embed form `workshop-ownership`, form id `9883199`,
   uid `6d6d7ce9c0`

Both collect the same five fields (first name, email, company, job title, and one
**optional** open question) and both apply the same two Kit tags. The finished sales
copy lives outside this repo, in Dropbox at
`Atchison Academy/workshop-ownership/Marketing/Sales Page.md`.

What is missing is the page itself.

### Two constraints that come from the project, not from this repo

These are recorded in the project's own planning file and must survive
implementation. Both have cost the project a correction already.

- 🔴 **The two contact routes are EQUAL options, and neither may be presented as
  primary.** They are not a main path and a fallback. Some buyers prefer email and
  some prefer a call, and a page that implies the call is "the serious one" loses the
  email people entirely. This governs layout, order, heading weight, and button
  styling alike.
- 🔴 **No dates, no seat counts, no open enrollment anywhere on the page.** The buyer
  schedules privately. A public date or a ticket count would turn this into an
  open-enrollment event, which the Academy has ruled out.

---

## Solution/Fix/Change

### 1. Add the page

A new standalone page at **`/ownership-workshop`** on the AtchisonAcademy site.

⚠️ **The URL word order is reversed from the project's internal ID, deliberately.**
The Dropbox project folder is named `workshop-ownership` because putting the format
first makes workshops sort together in that folder. That is an internal filing
convention. The URL is market-facing and reads the way a person says it: *ownership
workshop*. **Do not "fix" the slug to match the folder name.**

Source file: `AtchisonAcademy/src/ownership-workshop.erb`.

The page is not part of the `books` or `courses` collections. It is a one-off
marketing page, closest in kind to `index.erb` than to a collection item.

### 2. Bring the copy across

Copy comes from `Sales Page.md` in the Dropbox project folder, which has been through
Lee's edit pass and a voice check. Its sections map to the page as: headline, subhead,
body, "What happens in the room", "What you leave with", "Who it is for", "Format and
price", then the two calls to action, then a short bio block.

**The copy is final and is not to be rewritten during implementation.** If something
reads wrong on the page, raise it rather than editing it.

⭐ **Source of truth, before and after launch** *(Q5, decided 2026-09-04)*. **Until the page
is live, `Sales Page.md` in Dropbox is canonical** and the page is built from it. **The
moment the page ships, the repo page becomes canonical** and `Sales Page.md` is marked
superseded, keeping only the positioning reasoning and the notes-for-Lee section.

### 3. Embed both contact routes

Both go **in the page**, not linked out. That is what keeps them symmetric.

- **SavvyCal** — the scheduling widget, embedded.
- **Kit** — the embed form:
  ```html
  <script async data-uid="6d6d7ce9c0"
    src="https://softwarearchitectureinsights.kit.com/6d6d7ce9c0/index.js"></script>
  ```

Both are third-party scripts on a site that currently loads only its own bundle plus
Fathom analytics. Implementation should confirm they coexist and that neither blocks
render.

### 4. Style it to the Academy brand

Values come from `Marketing/Brand/Web/BRAND-INSTRUCTIONS.md` in the Dropbox Academy
folder, which is the canonical brand reference. Primary `#0F3D91`, call-to-action
fill `#F2A93B` with `#262626` text.

🔴 **Both route buttons get identical styling.** The brand rule reserves amber for one
conversion action per page. Here the single conversion action is *starting a
conversation*, offered two ways, so both buttons are amber and nothing else on the
page uses amber. Making one amber and one blue would encode exactly the hierarchy the
project forbids.

### 5. SEO and analytics

- The page joins the sitemap and carries a self-referential canonical. It is
  Academy-owned and exists on no other site, so the cross-domain `canonical_site`
  machinery from Spec0009 is not involved.
- Inbound links use UTM campaign token **`workshop-ownership`** — the project ID form,
  **not** the URL slug. This follows the convention in
  `/Professional/Social Media/UTM Standard.md`, where an asset attached to a form uses
  its own ID as the campaign so that analytics group by the thing being sold rather
  than by whichever article pointed at it. **The slug and the campaign token differ on
  purpose; do not reconcile them.**
- Fathom needs no change — it separates traffic by hostname, not by site ID.

---

## Testing

Run the site locally (`AtchisonAcademy/bin/dev`, port 16000 on `main`, 16000 + N in a
`spec####` worktree) and confirm:

1. `/ownership-workshop` renders, with correct title, canonical, and OG tags.
2. **Both embeds actually load and are usable** — the SavvyCal widget shows real
   availability, and the Kit form shows all five fields in order.
3. The two routes read as equal. Check this at mobile width too, where stacking can
   silently make the top one look primary.
4. No date, seat count, or enrollment language anywhere on the page.
5. The page appears in `sitemap.xml`.
6. Nothing else on the site changed — the shared CSS file is read by other pages.
7. **`diff` the two sites' `index.css` and confirm they are still identical** (Q4). A
   difference here is the failure this decision exists to prevent.
8. **The navbar and footer render on the page** (Q1) — it is not a chrome-free landing
   page.
9. The page is reachable **only** by its URL: no new navbar entry for the offer, and nothing
   on the site links to it (Q1, Q6).
7. A Netlify deploy preview builds and both third-party embeds still load there.

⚠️ **One end-to-end submission test is owed, and it belongs to the Academy project
rather than to this spec.** It is the only thing that can prove the two Kit tags
actually apply on submit. It writes a real subscriber and a real booking, both of
which must be deleted afterward — a previous Academy form was polluted this way twice.
Coordinate before running it.

---

## Summary of Steps Needed

1. Create `AtchisonAcademy/src/ownership-workshop.erb` with front matter and the
   approved copy.
2. Add the SavvyCal embed and the Kit form embed.
3. Add page styles.
4. Verify sitemap entry, canonical, and OG tags.
5. Test locally, then on a deploy preview, against the list above.
6. Add the page styles to `LeeAtchison/frontend/styles/index.css` as well, byte-identical,
   so the two stylesheets do not diverge (Q4).
7. Mark `Sales Page.md` in Dropbox as superseded once the page is live (Q5).

---

## Open Questions

**All six answered by Lee on 2026-09-04.** None remain open; the spec is implementable.

1. ✅ **No navbar ENTRY for the offer — but the page still HAS the navbar.**
   ⚠️ **These are two different things and the distinction is the whole answer**
   *(Lee, 2026-09-04)*. The page renders the normal site chrome: navbar, footer, the standard
   `default.erb` shell. **It is not a stripped, chrome-free landing page.** A visitor who
   arrives from an email can still reach the rest of the Academy from it.
   **What does not happen is adding an entry to the navbar's `LINKS` list for this offer.**
   The page is reachable only by its URL. The test runs about four weeks and every visitor
   arrives from an email or a LinkedIn post, so navigation is not how anyone finds it, and a
   temporary validation page does not take a permanent slot in a short list. Revisit if it
   sells.

2. ✅ **Layout: CONSTRAINED, the standard 65rem `<main>`.** Not the home page's full-width
   `page_class: homepage` treatment. The page is mostly prose and 65rem is a comfortable
   measure. This is also the least new CSS, which matters given Q4.

3. ✅ **Open Graph card: the site's existing generic `og-card.png`.** No page-specific card.
   Traffic comes from Lee's own email and posts, where he controls the surrounding copy, so
   the card carries less than usual. ⚠️ If this is ever revisited, a replacement must be
   exactly 1200×630 — `_head.erb` declares those dimensions.

4. ✅ **Page CSS goes into BOTH sites' `frontend/styles/index.css`, kept byte-identical.**
   Not Academy-only, and not a second stylesheet.
   ⭐ **The reasoning, because this looks wrong at first glance:** `AtchisonAcademy`'s
   stylesheet is a verbatim copy of `LeeAtchison`'s, and its own `CLAUDE.md` says to prefer
   keeping shared rules identical rather than trimming, because a diverged file has to be
   reconciled by hand every time either changes. The Academy file **already** carries rules
   for pages that site does not have. Adding these rules to LeeAtchison too is the same
   trade in reverse: a few unreferenced rules, in exchange for the two files still diffing
   clean. **This is why `LeeAtchison` appears in Systems Impacted despite having no page
   here.** Scope the rules under a `body.ownership-workshop` class.

5. ✅ **After the page ships, THE REPO PAGE IS THE SOURCE OF TRUTH for the copy.**
   `Atchison Academy/workshop-ownership/Marketing/Sales Page.md` in Dropbox gets marked
   superseded and keeps what the repo cannot hold: the positioning reasoning, the rejected
   framings, and the notes-for-Lee section.
   ⭐ **Why this way round, given the Academy folder is normally canonical:** a copy tweak
   will happen on the page, because that is where the copy is being looked at. A convention
   that requires editing Dropbox first and re-copying is the convention that gets skipped,
   and skipping it drifts silently.
   ⚠️ **This reverses the earlier instruction in section 2 of this spec** *("the file in
   Dropbox is the source of truth and has to stay in sync")* — that applies only up to the
   moment the page goes live. **Section 2 is amended accordingly below.**

6. ✅ **Nothing on the site links to the page.** It is purely a destination for email and
   LinkedIn.
   ⭐ **This is a measurement decision, not a design one.** The project's gate counts unique
   clicks to the page as a validity check — below ~25 clicks the offer never really reached
   anyone and a zero result says nothing. Internal traffic from people already browsing the
   Academy site would inflate that count without telling anyone anything.

---

## History of Updates

* **2026-09-04** — Spec created. Drafted after both contact routes were built and
  verified the same day, so the page is the only remaining piece of the Academy's
  `workshop-ownership` Phase 1 offer. The URL `/ownership-workshop` and the UTM
  campaign token `workshop-ownership` were both **approved by Lee on 2026-09-04**,
  including the deliberate word-order reversal between them. The equal-doors
  constraint and the no-public-dates constraint are carried in from the project's
  planning file rather than invented here; both are recorded there as corrections Lee
  made to earlier drafts. Six open questions raised, five with proposals, none
  decided.
* **2026-09-04** — **All six open questions answered by Lee**, so nothing blocks
  implementation. No navbar entry, constrained 65rem layout, generic OG card, page CSS
  added to **both** sites to keep the stylesheets identical, the repo page becomes the
  copy's source of truth once live, and nothing on the site links to the page. Two of the
  six were decided on grounds outside the repo and the reasoning is recorded with them: the
  no-internal-links answer protects the project's click-count gate signal from being
  inflated by site browsers, and the stylesheet answer follows the site's own documented
  preference for parity over trimming.
  ⚠️ **Q1 clarified by Lee the same day:** the page keeps the site's normal navbar and
  footer. What is excluded is a navbar *entry* for the offer. A "sales page" here does not
  mean a stripped landing page. `LeeAtchison` was added to Systems Impacted as a
  result of Q4 — stylesheet parity only, no page and no content change on that site.
* **2026-09-04** — Status moved to **Implementing**; implementation begun.
* **2026-09-04** — First implementation pass complete: `AtchisonAcademy/src/ownership-workshop.erb`
  created with the approved copy verbatim (headline through bio block), both contact routes
  embedded in-page (SavvyCal inline widget, Kit form script), and the two CTAs styled
  identically per the equal-doors rule. Page CSS added to both sites' `frontend/styles/index.css`
  as one identical block scoped under `body.ownership-workshop` (Q4). Verified locally: builds
  clean on both sites, page renders at `/ownership-workshop/` with correct title/canonical/OG
  tags, appears in `sitemap.xml`, keeps the site's normal navbar (no new nav entry) and footer,
  carries no dates/seat-counts/enrollment language, and reads as equal doors at both desktop and
  mobile widths (screenshotted). The two stylesheets' *added* block is confirmed byte-identical
  between sites; **note for Lee:** the two files as a whole were already not byte-identical before
  this change (pre-existing divergence — LeeAtchison carries "What's New" home-band CSS Academy
  doesn't have, Academy carries `.platform-card` CSS LeeAtchison doesn't have), so the Q4/Testing-
  item-7 "confirm they are still identical" check does not hold file-wide; flagging rather than
  fixing, since reconciling that is its own spec per this site's CLAUDE.md. Both third-party
  embeds (SavvyCal, Kit) could not be loaded end-to-end in this sandbox (outbound network to
  savvycal.com/kit.com is blocked here — confirmed the same failure hits the pre-existing Fathom
  script, so it's an environment limit, not a code issue); that check, and the real submission
  test, still need a Netlify deploy preview per the spec's own Testing section. Not yet committed
  or pushed.
* **2026-09-04** — Committed and pushed to `claude/spec0025-implementation-spsyrf`;
  [PR #29](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/29) opened from the UI and
  linked at the top of this file. All eight sites' Netlify deploy-preview checks resolved clean
  (atchisonacademy and leeatchison built and went ready; the other six canceled — no relevant
  changes) and no CI check suite failed. **Status moved to Closed** and the spec archived on
  Lee's go-ahead; PR #29 merged the same day.
  ⚠️ **Follow-up outside this repo, not done here:** Solution §2/Summary-step-7 call for marking
  `Atchison Academy/workshop-ownership/Marketing/Sales Page.md` in Dropbox as superseded once the
  page is live (Q5) — worth doing once the production deploy from this merge is confirmed out.
  The end-to-end Kit-tag/SavvyCal-booking submission test (Testing section, final note) is also
  still owed and belongs to the Academy project, coordinated separately before running it.
