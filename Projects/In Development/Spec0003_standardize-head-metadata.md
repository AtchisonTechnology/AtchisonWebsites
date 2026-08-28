# Standardize head metadata across all five sites

* **ID:** Spec0003
* **Status:** In Spec Development/Refinement
* **Date Created:** 2026-08-28
* **Date Implemented:** (pending)
* **Systems Impacted:** LeeAtchison, TheSoftwareConductor, stosa, BusinessBreakthrough30, ArchitectingForScale

---

## Problem/Requirement

The five sites each carry their own `src/_partials/_head.erb`. They were
written at different times and have drifted apart. An audit of all five found
four distinct defects, none of which produces a visible error on the sites
themselves, and all of which affect how the sites appear when shared or
crawled.

### Current state

| Site | canonical | og:title | og:description | og:image | og:url | per-page description |
|---|---|---|---|---|---|---|
| LeeAtchison | none | none | none | none | none | yes |
| TheSoftwareConductor | none | yes | site-level | portrait cover | hardcoded root | no |
| stosa | none | yes | site-level | **404** | hardcoded root | no |
| BusinessBreakthrough30 | none | yes | site-level | portrait cover | hardcoded root | no |
| ArchitectingForScale | none | yes | site-level | portrait cover | hardcoded root | no |

### Defect 1: stosa.org's og:image does not exist

`stosa/src/_partials/_head.erb` declares:

```
<meta property="og:image" content="https://stosa.org/images/stosa-og.png" />
```

There is no `stosa-og.png` in `stosa/src/images/` or in the built `output/`.
Every share of stosa.org on LinkedIn, Threads, Slack, or anywhere else that
reads Open Graph renders with no preview image. This is live today and is the
most immediately costly item in this spec, because stosa.org is actively
promoted.

### Defect 2: leeatchison.com emits no Open Graph tags at all

`LeeAtchison/src/_partials/_head.erb` contains charset, viewport, title,
description, favicon, stylesheet, and analytics. There is no `og:title`,
`og:description`, `og:image`, `og:type`, or `og:url`.

leeatchison.com is the hub site and has by far the most shareable pages: the
`books` and `courses` collections, posts, the Academy page, and the about page.
Every link to any of them previews bare, falling back to whatever the platform
scrapes. This is the largest gap of the five, and it sits on the site that most
needs the tags.

Note that leeatchison.com is simultaneously the most sophisticated of the five
on `description`: its head partial supports a per-page override
(`defined?(description) && description ? description : metadata.description`)
and its layout passes `description: data.description`. The other four have no
such support. The drift runs in both directions.

### Defect 3: og:url is hardcoded to the site root on four sites

All four sites that have Open Graph tags hardcode the site root:

```
<meta property="og:url" content="https://stosa.org" />
```

Every page therefore declares itself to be the homepage. Combined with
`og:description` always resolving to `metadata.description`, a shared sub-page
misrepresents itself completely: homepage URL, homepage description, homepage
title only avoided because `og:title` correctly uses the resolved page title.

On the three near-single-page sites this rarely bites in practice. On any site
with collections it is simply wrong, and it will bite leeatchison.com the
moment Open Graph tags are added there under the same pattern, which is the
argument for fixing the pattern in the same pass that introduces it.

### Defect 4: no canonical tag on any page of any site

None of the five sites emits `<link rel="canonical">`. No site uses
`bridgetown-seo-tag` or any equivalent plugin, so nothing supplies one
implicitly.

This matters for three specific failure modes, not for general SEO virtue:

* **Netlify deploy URLs are indexable.** Each site also answers on its
  `*.netlify.app` domain, and each `robots.txt` says `User-agent: * / Allow: /`
  and is served on that domain too. Any stray link to a netlify.app URL can
  index a complete duplicate of the site. A self-referencing canonical pointing
  at the production domain resolves this decisively.
* **Tracking parameters create duplicate URLs.** Social promotion appends
  query parameters, and platforms add their own. Each variant is a distinct URL
  to a crawler. A self-canonical collapses them.
* **Alias domains.** Any alias domain not covered by a redirect rule serves
  the whole site under a second name. This is the atchisonacademy.com problem
  (see Spec0002), and a canonical is the backstop for the case where a redirect
  rule is missing or has not been added yet.

### Defect 5: og:image aspect ratio

The three sites with a working og:image all point at their portrait book
cover:

| Site | og:image | Dimensions |
|---|---|---|
| TheSoftwareConductor | cover-1000.png | 1000 x 1600 |
| BusinessBreakthrough30 | cover-1000.png | 1000 x 1511 |
| ArchitectingForScale | cover-1000.png | 1000 x 1312 |

Open Graph consumers expect roughly 1.91:1 landscape (1200 x 630 is the
convention). A tall portrait image is letterboxed with large empty margins, or
cropped hard through the middle of the cover, depending on the platform. The
tags are working; the images are the wrong shape for the slot.

---

## Solution/Fix/Change

Bring all five head partials to one contract. Per site the edit touches exactly
two files, because only `default.erb` renders the head partial in every site
and all other layouts inherit through it:

| File | Change |
|---|---|
| `<Site>/src/_layouts/default.erb` | Pass `resource: resource` (and `description: data.description` where missing) to the head partial |
| `<Site>/src/_partials/_head.erb` | Emit canonical and the full Open Graph set from per-page values |

### The standard head contract

Every site's head partial emits, in this order:

1. charset, viewport
2. `<title>` (existing per-site logic, unchanged)
3. `<meta name="description">`, per-page with site-level fallback
4. `<link rel="canonical">`, absolute, per-page
5. `og:title`, `og:description`, `og:type`, `og:url`, `og:image` (absolute URL)
6. `twitter:card` and companions (see Open Questions)
7. existing per-site links: fonts, favicons, manifest, stylesheet, JS,
   live reload, analytics

### Required plumbing change

`_head.erb` is currently rendered with explicit locals and does **not** receive
the resource:

```erb
<%= render "head", metadata: site.metadata, title: data.title %>
```

Per-page canonical and `og:url` need it. Each `default.erb` gains
`resource: resource`, matching the pattern the navbar already uses in the same
file (`render Shared::Navbar.new(metadata: site.metadata, resource: resource)`).

### Canonical and og:url implementation

Both need the absolute URL of the current page. Bridgetown exposes this on the
resource; the implementation should use the resource's absolute URL helper
rather than string-concatenating `site.config.url` with a relative path.

Two details to verify at implementation time rather than assume:

* **Trailing slashes.** All five sites set `pretty_urls = true` in
  `netlify.toml`, so Netlify serves `/academy/` and redirects `/academy` to it.
  The canonical must match the served form exactly. A canonical pointing at a
  URL that then redirects is a self-inflicted wound.
* **Non-resource pages.** `robots.txt`, `sitemap.xml`, `404`, and `500` render
  through different paths or `layout: none`. Confirm none of them break when
  the head partial expects a resource, and that the 404 page does not emit a
  canonical claiming to be a real URL.

### Per-site work

* **LeeAtchison:** add canonical and the complete Open Graph set. Needs a
  social image (none exists; `src/images/` has only `logo-academy.png`,
  `logo.svg`, and `sai-logo.png`). Keep the existing per-page description
  logic as the model for the others.
* **stosa:** add canonical. Fix `og:image` (see Open Questions), make `og:url`
  per-page, add per-page description support.
* **TheSoftwareConductor, BusinessBreakthrough30, ArchitectingForScale:** add
  canonical, make `og:url` per-page, add per-page description support, and
  replace the portrait `og:image`.

### Scope boundary

This spec covers the head partials, their layouts' locals, and the social
images they reference. It does not touch page content, sitemaps, `robots.txt`,
or redirect rules. The atchisonacademy.com redirect is Spec0002 and stays
there.

---

## Testing

1. **Build all five sites** (`make dev`, or each site's `bin/dev`) and confirm
   no template errors. A head partial expecting a local it was not passed fails
   the build, which is the desired failure mode.
2. **View source on a representative page of each site** and confirm canonical
   and Open Graph tags are present and correct. For sites with collections,
   check a homepage, a collection item (a book page on leeatchison.com), and a
   post.
3. **Canonical correctness.** For each checked page, confirm the canonical URL
   is absolute, uses the production domain (not netlify.app, not localhost),
   matches the trailing-slash form Netlify serves, and points at the page
   itself rather than the site root.
4. **Trailing-slash verification against the live deploy:**

   ```bash
   curl -sS https://leeatchison.com/books/architecting-for-scale/ | grep -i canonical
   curl -sSI https://leeatchison.com/books/architecting-for-scale | head -3
   ```

   The canonical must equal the URL that the second command settles on.
5. **Non-resource pages.** Confirm `robots.txt` and `sitemap.xml` still render
   correctly on all five sites, and that the 404 and 500 pages build.
6. **Social preview validation.** Run one URL per site through a preview
   debugger (LinkedIn Post Inspector or equivalent) and confirm an image,
   title, and description render. Specifically confirm stosa.org now shows an
   image where it previously showed none.
7. **og:image sanity.** Confirm each og:image URL returns 200 and that its
   dimensions are close to 1200 x 630.
8. **Regression.** Confirm titles, descriptions, favicons, fonts, stylesheets,
   analytics, and live reload are all unchanged on every site. The head partial
   is on every page of every site, so a mistake here is total rather than
   local.

---

## Summary of Steps Needed

1. Resolve the Open Questions below, particularly the social images.
2. Produce the social images (one per site, 1200 x 630).
3. For each of the five sites: pass `resource:` (and `description:` where
   missing) from `default.erb` to the head partial.
4. For each of the five sites: update `_head.erb` to the standard contract.
5. Verify trailing-slash behavior against a deploy preview before finalizing
   the canonical implementation.
6. Run the full test plan.
7. Request permission to commit; create a PR on request.

---

## Open Questions

1. **stosa.org social image.** The referenced `stosa-og.png` never existed.
   Options: design a proper 1200 x 630 card (STOSA wordmark on the dark ink
   hero background, matching the site); reuse the existing
   `stosa/src/images/cover-600.png`, which is the Architecting for Scale cover
   and is off-brand for a framework site; or use the author photo. *
   Recommendation: design a proper card. It is the only one of the five that
   currently shows nothing at all.*
2. **Social images for the other four.** Replace the portrait book covers with
   1200 x 630 cards? For the three book sites a card showing the cover against
   a branded background reads far better than the bare portrait cover.
   leeatchison.com needs one created from scratch. *Recommendation: yes, five
   cards, one per site, as part of this spec.*
3. **Who produces the images.** Are these something you want to design, or
   should the spec include building them programmatically from existing assets
   (cover plus background plus wordmark, composited to 1200 x 630)?
4. **Twitter card tags.** Add `twitter:card = summary_large_image` plus
   `twitter:title` / `twitter:description` / `twitter:image`? Roughly four
   lines per site, and it controls how links render on X. *Recommendation: yes,
   while the file is open.*
5. **Per-page descriptions on the four non-LeeAtchison sites.** Adding the
   plumbing is cheap, but it only matters if pages actually set a `description`
   in front matter. Add the support now and populate front matter later, or
   leave those sites on the site-level description? *Recommendation: add the
   support now, since the marginal cost while editing the file is near zero.*
6. **Shared partial versus five copies.** The monorepo deliberately keeps the
   five sites independent, with no shared asset or template mechanism. This
   spec produces five near-identical head partials that then need to be kept in
   sync by hand. Accept that, or introduce a shared partial mechanism? *
   Recommendation: accept five copies. Introducing a cross-site sharing
   mechanism is a much larger architectural change than this spec should carry,
   and the head partials differ per site anyway (fonts, favicons, analytics).*
7. **Branching mode.** This touches all five sites, so a worktree needs all
   five booted (ports 3000 + N, 8000 + N, 10000 + N, 12000 + N, 14000 + N).
   *Recommendation: worktree.*

---

## History of Updates

* **2026-08-28** Spec created at Lee's request. Arose from Spec0002: while
  documenting the atchisonacademy.com redirect, it was noted that
  `LeeAtchison/src/_partials/_head.erb` emits no canonical tag, which made the
  redirect status the only canonicalization signal for that domain. Lee asked
  whether canonical tags should exist at all, prompting an audit of all five
  head partials.
* **2026-08-28** Audit performed across all five sites. Found five defects
  rather than the one asked about: stosa's og:image points at a file that does
  not exist; leeatchison.com has no Open Graph tags at all; og:url is hardcoded
  to the site root on the four sites that have Open Graph tags; no site emits a
  canonical; and the three working og:images are portrait book covers in a
  landscape slot.
* **2026-08-28** Established that only `default.erb` renders the head partial
  in each site, and that all other layouts (`page`, `post`, plus `book` and
  `course` on LeeAtchison) inherit through it. Scoped the change to two files
  per site.
* **2026-08-28** Established that the head partial is rendered with explicit
  locals and does not currently receive `resource`, so per-page canonical and
  og:url require a plumbing change in each `default.erb`.
* **2026-08-28** Confirmed no site uses `bridgetown-seo-tag` or an equivalent
  plugin, so nothing supplies these tags implicitly.
* **2026-08-28** **Decided (Lee):** scope this as a single spec covering all
  five head partials, rather than fixing canonical alone or splitting the
  stosa og:image out as a separate bug.
