# Academy sales pages, offer landing pages, and the Architecting for Cost launch pages

* **ID:** Spec0031
* **Status:** Closed
* **Date Created:** 2026-10-02
* **Date Implemented:** 2026-10-02
* **Systems Impacted:** AtchisonAcademy, shared *(one course file: `shared/_courses/architecting-for-cost.md`)*

---

## Problem/Requirement

Atchison Academy is about to sell its first self-paced course directly:
**Architecting for Cost** ($695, Kit checkout, delivered on Cedarras at
`courses.atchisonacademy.com`). The site has nothing that sells it.

Today the course is a `hidden: true` item in the shared courses collection,
with placeholder "in early development" copy. The home page is a catalog of
books and platform courses. There is no sales page, no Buy button, and no way
to show a special price.

Two needs, one of them general:

1. **The pages this launch needs** — a sales page, a launch-price landing
   page, a free worksheet signup page, a post-purchase welcome page, a webinar
   page, and a rebuilt home page that leads with the Academy's own courses.
2. **A reusable, organized way to add special-price landing pages** — for this
   course and every future Academy product. This is the part that has to last.

### Why special prices need their own pages

Kit checkout has **no discount-code field**. A discount exists only as a
coupon *link*. So every special price needs a page whose Buy button carries
that link. There will be many over time: the launch price now, later webinar
offers, future courses, possibly workshops.

Hand-building each one as a copy of the sales page would drift within weeks.
The requirement is a mechanism where:

- Each landing page is **built from its product's sales page**, so an edit to
  the sales page carries through to every landing page derived from it.
- Each can change only: the **price shown**, the **Buy link**, the
  **headline and intro**, an **offer end date**, and **extra sections**.
- Landing pages are **unlisted** — not in navigation, not in the sitemap,
  hidden from search engines.
- When an offer ends, its page **redirects to the sales page**.
- Every outbound Buy link carries **tracking tags** (`utm_` parameters), like
  every other page.
- Adding one is **a single new file**, with the build failing loudly if it is
  wrong.

### Dates that drive this

| Date | What |
|---|---|
| Oct 12–23 | Build window |
| **Mon Oct 26** | **Sales page and launch page live.** The Oct 27 newsletter ad points at the launch page |
| Thu Nov 19, 10am Pacific | Launch webinar |
| Sun Nov 22, midnight Pacific | Launch price ends (advertised) |

### Source documents (Dropbox, outside this repo)

All under `Atchison Academy/` in Lee's Dropbox:

- `architecting-for-cost/Marketing/Marketing Plan.md` — the plan. §4.1 lists
  these pages as W1–W7 (website page IDs).
- `architecting-for-cost/Marketing/Product Descriptions.md` — approved short
  and full course descriptions.
- `architecting-for-cost/Marketing/course-image-master.png` — the course image.
- `architecting-for-cost/Course Outline.md` §2 — module titles and lessons.
- `Marketing/Brand/Web/BRAND-INSTRUCTIONS.md` — brand values. Do not invent any.
- `Course Delivery.md` — checkout, entitlement and sign-in facts.

---

## Solution/Fix/Change

The work is in two parts. **Part A is the general mechanism** and is the reason
this spec exists. **Part B is the Architecting for Cost pages**, built on it.

# Part A — The general mechanism

## A1. Three kinds of selling page

Every page that sells something on this site is one of three kinds. Name them
this way in code, comments and docs.

| Kind | What it is | Indexed? | One per… |
|---|---|---|---|
| **Sales page** | The permanent, public page for a product. Every Buy link, ad and email points here by default | Yes | Product |
| **Offer page** | A special-price copy of a sales page, for one campaign. Unlisted, and it expires | No | Campaign |
| **Supporting page** | A page in the buying path that sells nothing itself: a post-purchase welcome page, a free lead-magnet signup page, a webinar page | Welcome: no. Free and webinar: yes | As needed |

## A2. URL rules

One rule per kind, so any future page's URL is predictable:

| Kind | URL | Example |
|---|---|---|
| Sales page, course | `/courses/<course-slug>/` | `/courses/architecting-for-cost/` |
| Sales page, other product | `/<product-slug>/` | `/ownership-workshop/` |
| **Offer page** | **`<sales page URL><offer-slug>/`** | `/courses/architecting-for-cost/launch/` |
| Welcome page | `<sales page URL>welcome/` | `/courses/architecting-for-cost/welcome/` |
| Free lead magnet | `/free/<slug>/` | `/free/cost-attribution-worksheet/` |
| Webinar | `/webinars/<slug>/` | existing `/webinars/architecting-with-ai/` |

Offer slugs name the campaign, not the price: `launch`, `webinar-2027-q1`,
`newsletter`. A price in a URL goes stale the day it changes.

## A3. Where things live

```
AtchisonAcademy/src/
  _data/sales/
    architecting-for-cost.yml     # ALL sales content for one product (A4)
  _offers/                        # NEW collection: one file per offer page (A5)
    architecting-for-cost-launch.md
  _layouts/
    sales.erb                     # renders a sales page from its data file
    offer.erb                     # renders an offer page: the same sections, with overrides
  _partials/sales/                # one partial per section, shared by both layouts
    _hero.erb  _trailer.erb  _who.erb  _modules.erb  _includes.erb
    _about.erb  _price.erb  _faq.erb  _quotes.erb
  courses/architecting-for-cost/
    welcome.erb                   # supporting page (Part B)
  free/
    cost-attribution-worksheet.erb  # supporting page (Part B)
  webinars/
    <slug>.erb                    # supporting page (Part B)
  _redirects.erb                  # generated Netlify redirects for ended offers (A7)
plugins/builders/
  offers.rb                       # validates offers and computes their state (A6)
```

**Why sales content goes in a data file, not in the course's markdown.**
The course file lives in `shared/_courses/`, which leeatchison.com also reads.
Sales content is Academy-only, and it is structured (sections, modules, FAQ),
which YAML expresses better than markdown body text. The course file keeps
what every course has (title, summary, ordering, card image) and gains two
keys that point at the data file. Offer pages read the same data file. That is
what makes sales-page edits carry through.

**Why offers are a collection.** It gives one folder that lists every offer,
past and present. A builder can validate all of them at once. And Bridgetown
gives each one a page with no extra wiring.

## A4. The sales data file

`src/_data/sales/<product>.yml`. One per product. Everything a sales page
shows comes from here. Sketch:

```yaml
product: architecting-for-cost          # must match the file name
sales_url: /courses/architecting-for-cost/
title: "Architecting for Cost"
tagline: "Cloud spend as a design decision."
hook: "Finance can't fix your cloud bill. ..."   # hero line
price: 695
currency: USD
buy_url: "https://softwarearchitectureinsights.kit.com/products/architecting-for-cost"  # confirmed by Lee 2026-10-02 (Q2)
trailer:
  vimeo_id: null                        # optional; section hides while null
  poster: /images/sales/architecting-for-cost/trailer-poster.jpg
og_image: /images/sales/architecting-for-cost/og.png
sections:                               # ORDER and PRESENCE of sections
  - who
  - modules
  - includes
  - about
  - price
  - quotes                              # renders only if quotes: is non-empty
  - faq
who: [...]
modules: [{ title: "...", summary: "..." }, ...]
includes: [...]
price_note: "..."                       # e.g. the reduced-price-on-request line
contact_url: "https://leeatchison.com/contact"   # Lee 2026-10-02 (Q1)
quotes: []                              # real quotes only; empty until they exist
faq: [{ q: "...", a: "..." }, ...]
```

The shape above is a sketch. Settle the exact keys during implementation,
but keep three rules:

- **`sections:` controls order and presence.** A future product can drop or
  reorder sections without touching a layout.
- **Optional sections hide themselves when empty** (trailer, quotes). The
  page must look finished with them absent.
- **Nothing in a partial is product-specific.** Every word on the page comes
  from the data file.

The course file `shared/_courses/architecting-for-cost.md` changes to:

```yaml
layout: sales
sales_data: architecting-for-cost
```

…its placeholder body copy is removed, and `hidden: true` stays until launch
(see B8). Course cards elsewhere on the site keep working from `title`,
`summary` and `cover_image`, unchanged.

A non-course product (a future workshop) gets a standalone page, e.g.
`src/<product-slug>.erb`, with `layout: sales` and `sales_data:` in its front
matter. Same layout, same partials. *Moving the existing Ownership Workshop
page onto this is out of scope (see Out of scope).*

## A5. The offer file

One file in `src/_offers/` per offer. Everything not stated here comes from
the product's sales data file.

```yaml
---
layout: offer
product: architecting-for-cost          # REQUIRED: a sales data file
permalink: /courses/architecting-for-cost/launch/   # REQUIRED: sales_url + slug
title: "Architecting for Cost — Launch Price"
price: 495                              # REQUIRED
buy_url: "<Kit coupon link>"            # REQUIRED: the coupon link
headline: "..."                         # optional: replaces the hero hook
intro: "..."                            # optional: a short paragraph under it
ends_at: 2026-11-22T23:59:59-08:00      # optional: advertised end, with offset
show_end: true                          # show "Ends Sunday, November 22 at midnight Pacific"
redirect_at: 2026-11-25T23:59:59-08:00  # optional: defaults to ends_at
utm_campaign: "..."                     # added to the Buy link (A8)
extra_sections:                         # optional: inserted before the price section
  - partial: webinar_recap
---
Optional markdown body. When present, it renders as an extra section above
the price section.
```

**`ends_at` and `redirect_at` are separate on purpose.** The advertised end
and the moment the page actually goes away can differ. For this launch, the
coupon keeps working quietly until Wed Nov 25, three days after the advertised
Sun Nov 22 end (Lee, 2026-10-02).

The offer page shows the offer price and the standard price together:
"**$495** (regularly $695)". The standard price comes from the sales data
file, so it is never typed twice.

## A6. The offer builder, and the checks that fail the build

`plugins/builders/offers.rb`, following the pattern of `shared_content.rb`.
At `:site, :post_read` it checks every offer and **raises with a clear
message** if:

1. `product` names no file in `src/_data/sales/`.
2. `permalink` is not exactly the product's `sales_url` plus one path segment.
3. `price` or `buy_url` is missing.
4. `price` is not lower than the product's standard price.
5. Two offers share a permalink.
6. `redirect_at` is earlier than `ends_at`.

It also sets, on every offer resource:

- `noindex: true` and `sitemap_exclude: true` — always, no opt-out.
- `offer_state`: `active` or `ended`, computed from `redirect_at` against the
  build time.

**Hidden pages.** Today `hidden: true` only works for books and courses:
`shared_content.rb` drops hidden items from those two collections, using its
`hidden?` rule (hidden in production, visible in dev and on deploy previews —
Spec0010). Nothing else honors the key. Extend the same rule, not a copy of
it, to:

- **Offers.** An offer **inherits its product's hidden state**: while the
  sales page is hidden, every offer for it is hidden too. An offer can also
  be hidden on its own.
- **Standalone pages** (`src/**/*.erb`). The welcome, free worksheet and
  webinar pages all need to stay out of production until launch.

A hidden page must also stay out of the sitemap and out of `_redirects`.

## A7. When an offer ends

A static site cannot redirect at an exact moment on its own. Use two layers:

1. **In the page (exact timing).** The offer page carries `redirect_at` in a
   data attribute. A few lines in `frontend/javascript/index.js` check the
   visitor's clock against it on load and send them to the sales page with
   `location.replace()` once it has passed. This covers the gap until the
   next deploy.
2. **At the server (durable).** `src/_redirects.erb` (layout none, permalink
   `/_redirects`, sitemap-excluded) writes one Netlify rule per offer whose
   `offer_state` is `ended`:

   ```
   /courses/architecting-for-cost/launch/  /courses/architecting-for-cost/  302!
   ```

   **302, not 301** — the URL may be reused by a later campaign. **The `!` is
   required**: the page file still exists in the output, and Netlify serves
   an existing file over a rule unless the rule is forced.

Layer 2 only takes effect at the next deploy after `redirect_at`. **The
launch checklist (B9) includes a deploy on Thu Nov 26**, the day after
`redirect_at`. That is Thanksgiving; the in-page redirect covers the gap
if the deploy slips a day. A scheduled automatic rebuild is
not needed for one offer a quarter. Revisit if offers become frequent.

`_redirects` is a new file for this site. `netlify.toml` here has no
`[[redirects]]` today. Netlify processes `_redirects` first, so there is
nothing to reconcile.

## A8. Shared page needs

These apply to every sales, offer and supporting page. Build them as general
features of `_head.erb` and the layouts, not per page.

- **`noindex` front matter → `<meta name="robots" content="noindex">`** in
  `_head.erb`. General, so any page can use it. Offer and welcome pages set it.
- **Per-page social image.** `_head.erb` today always uses
  `/images/og-card.png`. Add an override: `image:` front matter, or for sales
  and offer pages, the data file's `og_image`. Keep 1200×630, and keep the
  declared width/height true.
- **Buy-link tracking.** Every Buy button gets
  `utm_source=atchisonacademy&utm_medium=web&utm_content=<position>`
  (`hero`, `price`, `footer`), plus the offer's `utm_campaign` on offer pages.
  **And** a small script copies any `utm_*` parameters the visitor arrived with
  onto the Buy links, so the newsletter or LinkedIn source survives to
  checkout. Arrival parameters win over the page's own defaults. Follow
  `Professional/Social Media/UTM Standard.md` in Dropbox for naming.
- **A Fathom event on Buy clicks**, named per page (e.g.
  `buy-architecting-for-cost-launch`), so traffic and Buy clicks can be
  compared per page. Fathom needs no other change.
- **Brand.** One amber call-to-action color, used only for Buy. Several Buy
  buttons on one page are fine; they are the same action. Values from
  `BRAND-INSTRUCTIONS.md` only. While here, copy that file into the repo as
  `AtchisonAcademy/BRAND.md` and point to it from this site's `CLAUDE.md`, as
  the file itself asks.

## A9. The trailer embed

The trailer is hosted on Vimeo, like every course video.

- **Sales and offer pages: muted autoplay** (Lee, 2026-10-02; this replaced
  the original click-to-play). The player loads on page open with the Vimeo
  parameters `autoplay=1&muted=1&texttrack=en`. **Vimeo's own Unmute
  button** turns the sound on. There is no button of our own: a "Watch with
  sound" prompt was built, and then removed at Lee's request (2026-10-02)
  because it doubled Vimeo's.
- **Everywhere else: click to play.** That means the home page's featured
  course. A poster image with a play button renders, and the Vimeo player
  loads only when it is clicked.
- **Reduced motion:** a visitor whose browser asks for reduced motion gets
  click to play on every page, as BRAND.md §8 requires.
- **Captions on by default** (Vimeo's `texttrack` player parameter), in every
  case.
- **Domain privacy.** The Vimeo embed lock is currently set to
  `courses.atchisonacademy.com`. The trailer either needs `atchisonacademy.com`
  added to its allowed domains, or should be a public video. *Lee sets this in
  Vimeo; note it in the launch checklist.*
- **While there is no trailer** (`vimeo_id: null`), the hero shows the course
  image in the video's place. The trailer will not exist on Oct 26.

## A10. Documentation

Add a section to `AtchisonAcademy/CLAUDE.md` titled **"Selling pages: sales
pages, offers, and supporting pages"**. It covers A1–A9 briefly and ends with
this checklist, so a future session can add an offer without reading this
spec:

> **To add an offer page:**
> 1. Create the coupon link in Kit.
> 2. Add `src/_offers/<product>-<offer-slug>.md` with `product`, `permalink`,
>    `price`, `buy_url`, and any overrides.
> 3. Set `ends_at` / `redirect_at` if it expires.
> 4. Build. The builder rejects a wrong product, permalink or price.
> 5. Check the deploy preview: price, Buy link (hover it), end-date line.
> 6. Put a reminder in Todoist to deploy the day after `redirect_at`.

---

# Part B — The Architecting for Cost pages

Codes in parentheses are the marketing plan's page IDs (W1–W7).

## B1. Sales page (W2) — `/courses/architecting-for-cost/`

The course's existing collection page, switched to `layout: sales` (A4).

**Hero, top of page:**

- **On a wide screen:** headline (the hook), one line of pitch, the price and
  the Buy button on the left. The trailer on the right.
- **On a phone:** headline, then the trailer, then the Buy button.
- The Buy button must be visible without scrolling at common laptop and
  phone sizes.

**Sections, in order:**

1. **Hero** — the hook: finance can't fix your cloud bill (the floor).
2. **Who it's for** — architects and senior or staff engineers handed a cost
   target; engineering leaders and CTOs who ran the finance playbook and hit
   its floor.
3. **What you'll learn** — the eight modules, one line each, from
   `Course Outline.md` §2.
4. **What's included** — 33 video lessons with readings, about three hours of
   video, and the 8 worksheets and templates, each named.
5. **About Lee** — short bio and photo (`lee-casual-vertical.jpeg` is already
   in the site).
6. **Price and Buy** — $695, the Buy button, and one line that students and
   people paying for it themselves can contact Lee about a reduced price.
7. **Peer quotes** — hidden until real quotes exist. Only real quotes.
8. **FAQ** — how access and sign-in work; what's included; refunds (30 days,
   no questions asked); buying for a team (contact Lee).

**Copy:** written outside the repo as
`architecting-for-cost/Marketing/Sales Page Copy.md` in Dropbox, in Lee's
voice, approved by Lee. **Until the page ships, that file is the source.**
After it ships, the data file is the source and the Dropbox file is marked
superseded — the same rule Spec0025 used. Implementation can start before the
copy is final, using `Product Descriptions.md` as placeholder text. **Do not
write or rewrite sales copy during implementation.** Raise anything that
reads wrong.

## B2. Launch page (W7) — `/courses/architecting-for-cost/launch/`

The first offer page (A5).

- Price **$495** (regularly $695).
- Buy link: **`https://softwarearchitectureinsights.kit.com/products/architecting-for-cost?promo=LAUNCH`** (Lee, 2026-10-02). It already has a query string, so
  the tracking tags (A8) must be appended with `&`, not `?`.
- Headline and intro: launch-specific, from the copy file.
- **Ends Sun Nov 22, midnight Pacific** — shown on the page.
- `redirect_at`: **Wed Nov 25, midnight Pacific.** The coupon keeps working
  quietly for three days after the advertised end (Lee, 2026-10-02).
- Launch emails, newsletter ads and the webinar all point here.

## B3. Free worksheet page (W3) — `/free/cost-attribution-worksheet/`

A short page: the problem in two lines, what the Cost Attribution Worksheet
does, and the Kit signup form (email only).

- The Kit form and its tag are being built separately in Kit. **The form's
  embed `uid` is not known yet** — leave a clearly marked placeholder, and the
  page must build without it.
- Embed pattern: the same Kit script embed as `ownership-workshop.erb`.
- Indexed and in the sitemap. It is public by design.
- **Goes live early, not at launch** (Lee, 2026-10-02). It carries its own
  `hidden: true` until the Kit form's `uid` is wired in. Then its `hidden` is
  removed, ahead of Oct 26, so the signup runs live but unpromoted during the
  build window.

## B3a. Worksheet answer thanks page — `/free/cost-attribution-worksheet/thanks/`

Source: `AtchisonAcademy/src/free/cost-attribution-worksheet/thanks.erb`.

The landing page for the three Kit Link Triggers in the free Cost Attribution
Worksheet's confirmation email. Readers click one of three answers to *"When
you flag a cost problem caused by an architectural decision, what happens?"*
Kit tags the click, then sends them here. The page only says thanks.

**Copy** (final, Lee 2026-10-02; don't rewrite):

- Headline: *Thanks. That helps.*
- Body: *Your answer tells me which cost problems to write about next.*
- Link: *Back to the Cost Attribution Worksheet* → `/free/cost-attribution-worksheet/`

**Rules:**

- `noindex`, and excluded from the sitemap. It's only reached from an email.
- No Buy button and no price. It doesn't use the amber call-to-action color.
- Same look as the free worksheet page (B3).
- Hidden until launch, the same as the free worksheet page: `hidden: true`,
  removed in the same commit as B3's.

## B4. Welcome page (W4) — `/courses/architecting-for-cost/welcome/`

Where Kit sends buyers after checkout. `noindex`, not in the sitemap.

Tells the buyer, in order:

1. Thank you — you're in.
2. Check your email for the sign-in details.
3. If this is your first Academy course, set your password.
4. Sign in at `courses.atchisonacademy.com` (button).

Take the exact sign-in steps from `Course Delivery.md`; do not guess them.
**After it ships, Lee changes the Kit product's after-purchase link to this
URL** (launch checklist).

## B5. Webinar page (W5) — `/webinars/why-finance-cant-fix-your-cloud-bill/`

Same pattern as `/webinars/architecting-with-ai/`. Two states from one front
matter key:

- **`upcoming`** — title, one line, date and time (Thu Nov 19, 10am Pacific),
  and a button to the LinkedIn Event.
- **`replay`** — the replay link, and a link to the launch page while the
  offer is active, otherwise the sales page.

**Title:** *Why Finance Can't Fix Your Cloud Bill* (Lee, 2026-10-02).
**The LinkedIn Event URL is not set yet.** Build the page with a placeholder
for it, and keep it `hidden` until it exists.

## B6. Home page rebuild (W1) — `/`

The home page leads with the Academy's own courses. Sections, in order:

1. **Hero** — the Academy's promise, and the logo (already in use).
2. **Featured course** — title, hook, trailer (or course image), and a button
   to its sales page. **Chosen with the existing `spotlight_academy` key**,
   which the builder already validates and nothing on this site renders yet
   (Spec0016). Its content comes from that course's sales data file. If no
   course carries the key, the section hides.
3. **How Academy courses work** — self-paced, video plus readings,
   downloadable worksheets, yours to keep.
4. **The free worksheet** — one line and a button to B3.
5. **About Lee** — short.
6. **Books and platform courses** — the existing sections, kept.
7. **Newsletter signup** — Software Architecture Insights.

Copy for the hero, "how it works" and about sections comes from the copy file
(B1).

**The home page must be safe to merge before launch** (Lee, 2026-10-02). Each
new section appears only once what it points to is public:

- **Featured course** and **How Academy courses work** — only when a visible
  course carries `spotlight_academy`. While the course is hidden, production
  drops it, so both sections hide.
- **The free worksheet** — only when the free worksheet page (B3) is not
  hidden.

So production never links to a hidden page, and the new sections go live with
the launch switch (B8) or, for the worksheet, when its page does (B3).

## B7. Assets

From Dropbox into `assets_inbox/`, then resized into
`src/images/sales/architecting-for-cost/`:

- `course-image-master.png` → `og.png` (1200×630, center-cropped) and a
  hero-sized fallback image.
- Trailer poster: a frame from the trailer once it exists. Until then, the
  course image.

## B8. Launch-day switch

The course stays `hidden: true` through the build, so production does not
show it, while deploy previews do. **Going live is one change:** remove
`hidden: true` from the course file. The launch page inherits it (A6), so it
goes live in the same change. The welcome page carries its
own `hidden: true`, removed in the same commit. The free worksheet page goes
live earlier, on its own (B3), and its thanks page (B3a) goes live in the same
commit as it. *Leave `hidden` in place; Lee decides
when to ship.*

## B9. Launch checklist (Lee, outside the repo)

1. Create the $295 coupon link in Kit. *(The $495 launch link is done — B2.)*
2. Set the Kit product's after-purchase link to the welcome page.
3. Add `atchisonacademy.com` to the trailer's allowed domains in Vimeo.
4. Remove `hidden: true` and deploy, by **Mon Oct 26**.
5. Test purchase end to end with a 100%-off link: sales page → checkout →
   welcome page → enrollment email → Cedarras sign-in.
6. Deploy again on Thu Nov 26, the day after the launch offer's `redirect_at`.
7. Point the three worksheet answer Link Triggers in Kit at https://atchisonacademy.com/free/cost-attribution-worksheet/thanks/

---

## Open questions

All answered by Lee, 2026-10-02.

| # | Question | Answer |
|---|---|---|
| **Q1** | How do people "contact Lee" for the reduced price and team pricing? | The existing contact form, `https://leeatchison.com/contact` — the same link the Academy footer uses |
| **Q2** | The exact Kit checkout link for the Buy button, and the two coupon links | Buy button: `https://softwarearchitectureinsights.kit.com/products/architecting-for-cost` ($695). $495 launch link: `https://softwarearchitectureinsights.kit.com/products/architecting-for-cost?promo=LAUNCH`. The $295 link is not needed in the repo — Lee sends it by hand |
| **Q3** | Webinar title and slug | *Why Finance Can't Fix Your Cloud Bill*, at `/webinars/why-finance-cant-fix-your-cloud-bill/`. The LinkedIn Event URL is still to come |
| — | Does the $495 coupon keep working after the advertised end? (B2) | Yes, quietly until Wed Nov 25, midnight Pacific. `redirect_at` is set to that; the page still shows Sun Nov 22 |

---

## Out of scope

- **Moving the Ownership Workshop page** onto the sales layout. It is
  hand-built and works. Add it to `_Projects.md` as a future idea.
- **The team page (W6).** An FAQ entry covers teams for now.
- **Trimming `index.css`.** Its own spec, as this site's `CLAUDE.md` says.
- **Anything on `courses.atchisonacademy.com`.** That is Cedarras.
- **Writing sales copy.** Done separately, in Dropbox.

---

## Testing

Run `AtchisonAcademy/bin/dev` (port 16000 on `main`, 16000 + N in a `spec####`
worktree) and check:

**The mechanism**

1. Each of the six builder rules in A6 fails the build with a readable message. Test each
   with a deliberately broken offer file, then remove it.
2. An offer page renders the sales page's sections, with only its overrides
   changed. Edit one module line in the data file; it changes on both pages.
3. Offer and welcome pages carry `noindex`, and are absent from `sitemap.xml`.
4. With `redirect_at` set in the past: the page redirects in the browser, and
   `output/_redirects` contains a forced 302 rule for it. With it in the
   future: no rule, no redirect.
5. An empty `quotes:` and a null trailer leave no gaps or empty headings.

**The pages**

6. Sales page and launch page: correct price, Buy link (hover it), and the end
   date on the launch page only.
7. Visiting with `?utm_source=sai&utm_campaign=x` puts those values on every
   Buy link.
8. Each page's social preview: title, description, and the course image.
   Check with a LinkedIn Post Inspector run on the deploy preview.
9. At phone width: hero order is headline → trailer → Buy, and Buy is visible
   without scrolling.
10. Trailer: on the sales and launch pages it starts playing muted on load,
    with captions on, and Vimeo's Unmute button turns the sound on. On the home page, and
    for reduced-motion visitors, it is click to play with no Vimeo requests
    before the click.
11. Home page: featured course shows from `spotlight_academy`; removing the
    key hides the section cleanly.
12. Production build (`hidden: true` still set): the sales, launch, welcome and
    free worksheet pages do not exist, and are absent from the sitemap. On a
    deploy preview they all render.
13. Production build, home page: with the course and worksheet page hidden,
    none of the new sections show and nothing links to a hidden page. Unhide
    only the worksheet page: its home section appears, the course sections
    don't.
14. Worksheet thanks page (B3a): it renders at
    `/free/cost-attribution-worksheet/thanks/` with the final copy and a link
    back to the worksheet page; it carries `noindex`; it is absent from
    `sitemap.xml`; and a production build (`hidden: true` still set) leaves
    it out, while a deploy preview renders it.

---

## Summary of Steps Needed

1. Part A: data file shape, `_offers` collection, `sales` and `offer` layouts,
   section partials, `offers.rb`, `_redirects.erb`, `_head.erb` (noindex and
   social image), Buy-link script, Fathom event, trailer embed.
2. `BRAND.md` copied in; `CLAUDE.md` section and checklist (A10).
3. Part B pages: sales, launch, free worksheet, worksheet thanks, welcome, webinar, home.
4. Assets into `src/images/sales/architecting-for-cost/`.
5. Testing above, on a deploy preview.
6. Lee: the B9 checklist, and the ship decision.

---

## History of Updates

- **2026-10-02 — Implemented on `main` (not committed).** Parts A and B built and tested as
  specified. Deviations and additions, each for a reason:
  - **`src/redirects.erb`, not `src/_redirects.erb`.** Bridgetown ignores source files that
    start with `_`; the permalink is still `/_redirects`.
  - **Buy buttons open Kit's checkout overlay** (`data-commerce` + Kit's `commerce.js`, the
    same embed as SoftwareArchitectureInsights' `donate.erb`), at Lee's request during
    implementation, rather than navigating to the Kit product page. Verified: the launch
    overlay shows $695 struck through and $495.
  - **Sales copy** is `Sales Page Copy.md` (approved by Lee 2026-10-02, arrived during
    implementation), transcribed verbatim. Its structure added a "The problem" section after
    the hero, a tagline line in the hero, per-page Buy labels ("Buy the course" / "Get the
    launch price"), and an offer `end_line:` override for the launch page's own end-date
    wording. `[contact]` renders as a "Contact me" link to `https://leeatchison.com/contact`
    (Q1).
  - **Welcome page sign-in steps** were checked against Cedarras's own code (enrollment and
    password-setup mailers and the `/login` and `/password/new` routes). The approved copy agrees
    with them.
  - **Selling pages carry the `course` body class**, set by `offers.rb` on sales and offer
    pages and by `page_class` on supporting pages. It opts them out of the boxed generic-page
    CSS the way the webinar pages already do, without editing selectors kept identical to
    LeeAtchison's copy.
  - **On phones, the hero drops the tagline** (and on an offer page, the pitch, which the intro
    stands in for), so Buy stays above the fold: 568px on the sales page and 631px on the
    launch page, at 375×812.
  - **`spotlight_academy: true`** added to the course file to feature it on the home page
    (§B6). The home page's old "Start Learning Today" band was replaced by the newsletter
    signup (§B6 item 7), using SAI's inline Kit form `c448363077`.
  - **Free worksheet page copy** reuses the home page's approved worksheet section. The copy
    file has nothing specific to that page.
  - **Ownership Workshop migration** added to `_Projects.md` as a future idea.
- **2026-10-02 — Added B3a, the worksheet answer thanks page** (Lee). It is where the three Kit
  Link Triggers in the worksheet confirmation email land. Built at
  `src/free/cost-attribution-worksheet/thanks.erb` with Lee's final copy: `noindex`,
  sitemap-excluded, no price or Buy button, and hidden until launch alongside B3. Added testing
  step 14 and launch checklist item 7. Verified: it renders in dev with `noindex` and no sitemap
  entry, a production build leaves it out, and a deploy preview renders it.
- **2026-10-02 — Lee's decisions on the implementation review.**
  - **UTM values:** the UTM Standard was updated to match the code rather than the other way
    round. It gains source `atchisonacademy`, medium `web`, named campaign `afc-launch`, the
    `hero`/`price`/`footer` Buy-button positions, and a new *Atchison Academy Buy Buttons*
    section. That section records two rules: the sales page Buy button deliberately carries no
    `utm_campaign`, and tags a visitor arrives with win over the page's own.
  - **Access length:** resolved. The FAQ's "does not expire" stands.
  - **Refund FAQ:** no email address goes on the public page. Buyers get it from the Cedarras
    email.
  - **Welcome page:** step 1 now names Cedarras as the sender (by name, with no address), and a
    "Get a new link" line points to `courses.atchisonacademy.com/password/new` for a lost or
    expired set-password link.
- **2026-10-02 — Worksheet form wired in; launch hero settled.**
  - The Kit form `4628ece1f7` (Lee) is set as `kit_form_uid` on the free worksheet page. Per
    B3, that page's `hidden` came off, along with the B3a thanks page's in the same change.
    Production builds now publish both: the worksheet page is indexed and in the sitemap, the
    thanks page is `noindex` and excluded, and the home page's worksheet section appears. Every
    course page stays hidden.
  - **Offer hero (Lee: "make it right"):** an offer's `intro` now replaces the sales pitch under
    the headline rather than sitting above it. So the launch hero reads: headline, launch intro,
    tagline (dropped on phones), then price and Buy.
  - The home page hero going live before launch: Lee doesn't mind, so no change.
- **2026-10-02 — Sales and launch pages live but unlisted** (Lee). Lee wanted them reachable but
  not referred to by the home page, the courses page or the sitemap. Added `unlisted: true`: the
  page is published, kept out of the sitemap, and skipped by every course listing, including the
  home page's featured course and "More Courses". The course file swapped `hidden: true` for
  `unlisted: true`, so the launch offer goes live with it. The welcome page's `hidden` came off
  too, so a buyer never lands on a 404. The webinar page stays hidden. Going fully public later
  means deleting the `unlisted` line.
- **2026-10-02 — Trailer added.** Vimeo `1232444304` (Lee) is now the trailer on the sales page
  and the launch page, with Vimeo's own title card as the poster. Tested: it plays on click with
  captions on. The play button moved to the poster's bottom-left so it doesn't cover the title
  card. The home page's featured-course section uses the same trailer, and it appears there
  once the course is no longer `unlisted`. *The Floor* short (`1232442814`) was not added to
  the launch page: a second video at the top would compete with the trailer and push Buy below
  the fold on phones.
- **2026-10-02 — Closed and archived** (Lee). Shipped to production in `d5d3655`, `4fde94b` and
  `4cb5f10`. The sales, launch, welcome, free worksheet and thanks pages are live; the sales and
  launch pages are unlisted. The webinar page stays hidden until its LinkedIn Event exists.
  Lee's open B9 checklist items continue outside this spec.
- **2026-10-02 — Trailer: muted autoplay on the sales and launch pages** (Lee, after closing). A9
  and testing step 10 were rewritten to match: the trailer autoplays muted with
  `autoplay=1&muted=1&texttrack=en`, and a centered "Watch with sound" button unmutes it and
  restarts it. Tested on the launch page: after the click the volume is 1, the player is unmuted
  and playing from the start, and the button is gone. The home page and reduced-motion visitors
  keep click to play.
- **2026-10-02 — "Watch with sound" removed** (Lee). It doubled Vimeo's own Unmute badge, and
  Vimeo moves that badge between screen sizes, so covering it wasn't reliable. The trailer still
  autoplays muted with captions; visitors unmute with Vimeo's button.
