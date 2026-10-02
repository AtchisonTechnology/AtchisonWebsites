# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Brand, color, typography and logo rules: see BRAND.md. Follow it exactly; do not invent brand values.

## Commands

Always use the `bin/bridgetown` binstub to ensure the correct version runs.

```bash
bin/dev                    # Dev server on this checkout's derived port (16000 on main)
bin/bridgetown start       # Same server, but only on the derived port via config/puma.rb
bin/bridgetown build       # One-shot build to output/
bin/bridgetown clean       # Delete output/ and .bridgetown-cache/

rake deploy                # Production build: clean → frontend:build (minified) → build
rake test                  # Build with BRIDGETOWN_ENV=test
```

Frontend assets are bundled separately by esbuild and watched automatically during `start`. To run them independently:

```bash
npm run esbuild            # One-shot minified bundle (production)
npm run esbuild-dev        # Watch mode (development)
```

**Dev port.** This is site index 5 in the monorepo: `16000` on `main`, `16000 + N` in a
`spec####` worktree, `17000 + N` in a `bug####` worktree. Nothing here hardcodes it —
`bin/dev` and `config/puma.rb` both re-derive it from `../lib/worktree_env.rb`, keyed on
the repo-root directory name. See `../Projects/services.md` for the full table.

## Architecture

This is a **Bridgetown 2.1.2** static site. The template engine is ERB (set in `config/initializers.rb`). The frontend pipeline is esbuild + PostCSS (with `postcss-preset-env` and `postcss-flexbugs-fixes`).

It is the standalone site for **Atchison Academy** — Lee Atchison's books, courses,
and training. Its home page is the page that used to live at `leeatchison.com/academy`,
and its two collections carry only the `show_academy` books and courses from the shared
collections at the repo root (see **Shared collections** below).

### Source layout

```
src/
  index.erb               # Home page — the Academy landing page (page_class: homepage)
  books.erb               # Books listing page
  courses.erb             # Courses listing page
  robots.txt.erb          # Dynamic robots.txt
  sitemap.xml.erb         # Dynamic sitemap
  404.html                # 404 error page
  500.html                # 500 error page
  favicon.ico             # Empty placeholder, so the browser's automatic /favicon.ico
                          # request does not 404. The real icon is images/favicon.png.
  _layouts/
    default.erb           # Root layout: navbar → <main> → footer
    page.erb              # Adds <h1> from data.title, then yields (extends default)
    book.erb              # Book detail layout (full-width via body.book)
    course.erb            # Course detail layout (full-width via body.course)
    sales.erb             # Sales page, rendered from a sales data file (Spec0031)
    offer.erb             # Offer page: the sales page with overrides (Spec0031)
  _partials/
    _head.erb             # <head> contents: meta, canonical/OG, robots, favicon, assets, Fathom
    _footer.erb           # Site footer
    sales/                # One partial per selling-page section (Spec0031)
  _offers/                # Offer pages, one file each (Spec0031)
  courses/<slug>/welcome.erb  # Post-purchase welcome pages
  free/                   # Free lead-magnet signup pages
  webinars/               # Webinar pages
  redirects.erb           # Generates /_redirects for ended offers
  _components/shared/
    navbar.erb            # Navigation template
    navbar.rb             # Bridgetown::Component class (receives metadata, resource)
  _data/
    site_metadata.yml     # title, tagline, description — accessed as site.metadata
    sales/<product>.yml   # All sales copy and settings for one product (Spec0031)
  _books/                 # -> ../../shared/_books  (symlink; 2 shown here)
  _courses/               # -> ../../shared/_courses (symlink; 12 shown here)
  images/
    logo-academy.png      # Atchison Academy logo — hero and closing CTA band
    favicon.png           # Favicon (Academy shield logo, 32×32)
    og-card.png           # Open Graph / Twitter card (1200×630)
    learners-badge.png     # Neutral reach badge, 180,000+ learners (courses hero; byte-identical to LeeAtchison's copy)
    pets404.png           # 404/500 page illustration
    books/                # -> ../../../shared/images/books (symlink; Spec0019)
    courses/              # -> ../../../shared/images/courses (symlink; empty until Spec0020)
frontend/
  styles/index.css              # All CSS — design tokens, component styles, responsive
  styles/syntax-highlighting.css  # Code syntax highlighting styles
  javascript/index.js           # JS entry point (minimal)
assets_inbox/             # Staging area for raw assets — NEVER reference directly
                          # Copy and resize into src/images/ before use
```

### Key patterns

**Full-width homepage layout**: The default layout wraps all content in `<main>` with `max-width: 65rem`. The home page bypasses this by setting `page_class: homepage` in its frontmatter, which adds `body.homepage` — CSS then overrides `body.homepage main` to be full-width with no padding or box-shadow.

**Component structure**: Components are a Ruby class + ERB template pair. The class sets instance variables in `initialize`; the template accesses them directly. `render Shared::Navbar.new(metadata: site.metadata, resource: resource)` is the call pattern.

**Navbar**: `LINKS` lists exactly the pages this site has, plus one outbound entry to
leeatchison.com. Two independent flags, each meaning exactly one thing (Spec0007):
`external: true` emits `path` as-is, while every other entry goes through
`relative_url`, which would mangle an absolute URL; `new_tab: true` adds
`target="_blank" rel="noopener noreferrer"`. Adding a new outbound link means setting
`external:`, not just pasting a URL into `path`. Same-tab is the default and a new
window is opt-in — the leeatchison.com entry sets no `new_tab:`, because moving between
Lee's two properties is navigation within one body of work and should feel continuous.
Set `new_tab:` only for a genuinely third-party destination.

**Internal links**: Always use the `relative_url` helper (e.g., `relative_url '/images/foo.png'`) for links and asset paths to support potential subdirectory deployments.

**Site URL and deploy previews**: `config/initializers.rb` sets `url` conditionally — a
Netlify Deploy Preview (`CONTEXT=deploy-preview` with a non-empty `DEPLOY_PRIME_URL`)
builds against the preview's own hostname, so canonical, `og:url`, the sitemap, and
robots' `Sitemap:` line describe the preview; everything else, production included, uses
the `https://atchisonacademy.com` literal. Both halves of that test are load-bearing —
see Spec0004. **Never add a `url:` key to `bridgetown.config.yml`**: a YAML value wins
over the initializer and would silently pin every preview to the production hostname.

**CSS**: A single `frontend/styles/index.css` file with CSS custom properties at `:root`. PostCSS compiles it; esbuild bundles it with a content-hash filename. Non-homepage page styles are under `body:not(.homepage)`.

**CSS divergence**: `frontend/styles/index.css` is a verbatim copy of `LeeAtchison`'s, so
it carries rules for pages this site does not have (about, contact, schedule, AI-Native,
posts). That was deliberate — trimming it risks dropping a rule a copied partial quietly
depends on, and a trimmed file has to be reconciled by hand against LeeAtchison's every
time either changes. Treat trimming as its own spec once this site's page set has
settled; until then, prefer keeping shared rules identical between the two files.

**Adding images**: Place raw source files in `assets_inbox/`, then resize (`sips -Z <maxpx> source --out src/images/dest` on macOS) and reference via `relative_url`. `og-card.png` must stay 1200×630 — `_head.erb` declares those exact dimensions. `sips -Z` only scales — it never crops — so it cannot turn an off-ratio source into the 16:9 `600×338` course cards Spec0020 wants; use `sips -Z 600` followed by `sips -c 338 600`, or Pillow's `ImageOps.fit`/ImageMagick's `-gravity center -extent`, to center-crop instead.

**Site metadata**: `src/_data/site_metadata.yml` is the single source for site title, tagline, and description. Access as `site.metadata.title`, etc. in templates.

**Analytics**: `_head.erb`'s Fathom snippet uses `data-site="QZJQFDMY"`, the same site ID
as every other site in the monorepo. Academy traffic is separated by hostname inside
Fathom, not by site ID, which is what keeps `_head.erb` copyable across sites with no
per-site edit.

**Collections**: Defined in `bridgetown.config.yml` (not in `config/initializers.rb` — the Ruby DSL doesn't support collection registration). Access in ERB as `site.collections["books"].resources`. In collection index pages or layouts, iterate with `.sort_by { |b| b.data.order_academy || 99 }`.

**Shared collections** (Spec0008): `src/_books` and `src/_courses` are **symlinks** to `../../shared/_books` and `../../shared/_courses` at the repo root — one set of files, read by this site and by `LeeAtchison`. There are 10 books and 18 courses there; this site shows the 2 books and 14 courses marked `show_academy`. Edit the files under `shared/`; never replace the symlinks with real directories, and never edit an item on the assumption it is Academy-only — leeatchison.com reads the same file. Both sites' dev watchers follow the symlink, so an edit under `shared/` live-rebuilds both.

**Shared cover art** (Spec0019): `src/images/books` and `src/images/courses` are **symlinks** to `../../../shared/images/books` and `../../../shared/images/courses` — three levels up, since these sit one directory deeper than the collection symlinks above. `cover_image` stays a plain `/images/books/<slug>.<ext>` path in front matter; the symlink preserves it. This site publishes all four book covers (not just its own 2 shown books) because the shared tree is not filtered per site — the two unused covers are unreferenced CDN files, not a bug. Never replace either symlink with a real directory.

`plugins/builders/shared_content.rb` filters the collections at `:site, :post_read` down to the items carrying `show_academy`, so this site never generates a page or sitemap entry for a non-Academy item. It also raises at build time if an item carries `feature_academy` or `order_academy` without `show_academy`. Templates therefore never filter on membership — only on featuring and order.

The same builder also resolves each item's `canonical_site` into cross-domain SEO
(Spec0009). It carries a `SITES` registry — site key → `show_` flag and production URL —
and a single `SITE_KEY`, which is the only line that differs from the `LeeAtchison`
copy; `show_academy`, `feature_academy` and `order_academy` are all derived from it, so a
seventh site is one new `SITES` entry in each builder rather than a rewrite. **The `SITES`
constant is duplicated in both builders and must be kept in sync by hand** — deliberate,
matching how Spec0006 and Spec0007 already hardcode cross-property URLs in each site's own
files; a divergence shows up immediately in the canonical tag of the first page you look at.

When an item's `canonical_site` names the *other* site, the builder sets `canonical_url`
on the resource (that site's production URL plus the same path — both sites publish these
collections at identical paths) and `sitemap_exclude: true`. `_head.erb` emits
`canonical_url` as `<link rel="canonical">` when present, while `og:url` stays
self-referential so a shared card sends traffic to the page that was actually shared; and
`sitemap.xml.erb` already rejects `sitemap_exclude`, so it needed no change. The page
itself stays live, linked, and reachable — it simply stops being volunteered for indexing.
The cross-domain URL is emitted on deploy previews too, always pointing at production:
Netlify serves previews with an automatic `noindex` header, so it costs nothing there, and
there is no way to know the other site's preview URL (see Spec0004).

**Collection front matter**: Books use `layout: book`; courses use `layout: course`. Both layouts extend `default` and produce full-width pages via the `body.book` / `body.course` CSS selectors. Key book fields: `cover_image`, `amazon_url`, `book_url`, `badge`, `badge_style`, `summary`, `testimonials[]`. Key course fields: `platform`, `platform_url`, `summary`, `cover_image` (Spec0020) — a `/images/courses/<slug>.<ext>` path shown above the platform badge on **featured** course cards only (`courses.erb`'s featured row and the home page's Courses section — this site's home page carries no "What's New" band); absent means the card renders text-only, which is expected until every featured course has art.

`shared_content.rb`'s `validate_availability!` requires `platform` on every course whose
`availability` is not `prelaunch` (Spec0011) — a "Coming Soon" page is exempt since it may
legitimately not know its platform yet, but a shipped course must always say where it
lives, so `courses.erb` and `course.erb` never render an empty platform label. Any string
key in `shared/_data/platforms.yml` is a valid value; `"Atchison Academy"` is the one to
use for a course offered directly rather than through a third-party platform.

Because the files are shared, membership, featuring and ordering are expressed with one key per site (Spec0008) — `show_*` and `feature_*` are booleans where **absent means false**, so only `true` is ever written:

| Key | Meaning |
|---|---|
| `show_academy` | The item appears on this site |
| `show_leeatchison` | The item appears on leeatchison.com |
| `feature_academy` | Featured on this site (`index.erb`, `books.erb`, `courses.erb`) |
| `feature_leeatchison` | Featured on leeatchison.com |
| `order_academy` | Sort position on this site |
| `order_leeatchison` | Sort position on leeatchison.com |
| `spotlight_academy` | The home page's **featured course** on this site (Spec0031 §B6). The first visible course carrying it is featured, with its content from its sales data file; with none, the featured-course and how-it-works sections hide. `spotlight_leeatchison` drives leeatchison.com's "What's New" band (Spec0016) |
| `canonical_site` | Which site owns the SEO original of this item's page — `academy` or `leeatchison` |

`feature_*`, `order_*` and `spotlight_*` are written only on items carrying the matching `show_*`; the builder fails the build otherwise. This site's `order_academy` values start as a subsequence of `order_leeatchison` and so have gaps — that sorts correctly, and either site can be re-sequenced without touching the other. The retired `academy`, `academy_featured`, `featured` and bare `order` keys are gone — nothing reads them.

`canonical_site` (Spec0009) is set on **every book and course**, not only the ten that appear on both
sites — a key on a single-site item is a true statement of where that page belongs, and
carrying it everywhere makes the rule uniform rather than a sparse exception list. Today's
assignment rule is by source: books from O'Reilly Media → `leeatchison`, Independent →
`academy`; courses from LinkedIn Learning or O'Reilly Media → `leeatchison`, Coursera →
`academy`. Two further build failures come from this key: an item with `show_` true for more
than one site and no `canonical_site`, and a `canonical_site` naming a site whose `show_`
flag is not set on that item. Those two rules are what stop a new item, or a flipped `show_`
flag, from silently re-creating duplicate pages across the two domains.

**Amazon Associates**: Every link to amazon.com must include the query parameter `tag=leeatchison-20`. Example: `https://www.amazon.com/dp/XXXXXXXXX?tag=leeatchison-20`.

## Selling pages: sales pages, offers, and supporting pages

Spec0031 built this for Architecting for Cost, as a mechanism every later
Academy product reuses. Read this section before adding a price, a product or
a page that sells.

**Three kinds of selling page.**

| Kind | What it is | Indexed? | URL |
|---|---|---|---|
| **Sales page** | The permanent public page for a product. Every Buy link, ad and email points here by default | Yes | `/courses/<course-slug>/`, or `/<product-slug>/` for a non-course product |
| **Offer page** | A special-price copy of a sales page for one campaign. Unlisted, and it expires | No | `<sales page URL><offer-slug>/`, e.g. `/courses/architecting-for-cost/launch/` |
| **Supporting page** | Sells nothing itself: a welcome page, a free lead-magnet page, a webinar page | Welcome: no. Free and webinar: yes | `<sales page URL>welcome/`, `/free/<slug>/`, `/webinars/<slug>/` |

Offer slugs name the campaign (`launch`, `webinar-2027-q1`), never the price.

**Why offers exist at all:** Kit checkout has no discount-code field. A
discount exists only as a coupon *link*, so every special price needs a page
whose Buy button carries that link.

**Sales data file — `src/_data/sales/<product>.yml`.** Every word and setting
on a product's sales page: hook, pitch, price, `buy_url`, trailer, `og_image`,
and one block per section. `sections:` sets the order and presence of the
sections below the hero; each name is a partial in `src/_partials/sales/`.
Optional sections (quotes, the trailer) hide themselves when empty. Partials
hold no product-specific words. Text fields go through the `sales_text`
helper: escaped, then `**bold**`, `*italic*` and `{contact}` (a link to
`contact_url`, labelled `contact_label`) are expanded. Nothing else is.

A course's sales page is its own course page: the shared course file sets
`layout: sales` and `sales_data: <product>`, and keeps only what every course
has (title, summary, ordering, card image). The sales copy lives here, not in
`shared/`, because leeatchison.com reads `shared/` and sales copy is
Academy-only. A non-course product gets a standalone `src/<product-slug>.erb`
with the same two keys.

**Offer file — `src/_offers/<product>-<offer-slug>.md`.** Required: `product`,
`permalink`, `price`, `buy_url` (the coupon link). Optional overrides:
`headline`, `intro` (a callout under the headline, replacing the pitch), `buy_label`, `ends_at` and
`redirect_at` (timestamps with a UTC offset), `show_end`, `end_line` (replaces
the generated "Ends Sunday, November 22 at midnight Pacific"),
`utm_campaign`, `extra_sections` (partials inserted before the price section),
and a markdown body (also rendered before the price section). Everything else
comes from the product's sales data file, so a sales-page edit carries
through to every offer. The offer price shows beside the standard one:
"$495 (regularly $695)". `ends_at` is the advertised end; `redirect_at` (it
defaults to `ends_at`) is when the page actually goes away. They can differ:
a coupon can keep working quietly for a few days.

**`plugins/builders/offers.rb`** runs at `:site, :post_read` at high priority
and fails the build if an offer names no sales data file, has a permalink
that isn't the sales URL plus one segment, is missing `price` or `buy_url`,
isn't cheaper than the standard price, shares a permalink with another
offer, or has `redirect_at` before `ends_at`. It forces `noindex` and
`sitemap_exclude` on every offer (no opt-out), sets `offer_state`
(`active`/`ended`, from `redirect_at` against build time), and gives sales and
offer pages the `course selling` body class. (`course` opts them out of the
boxed generic-page CSS, as the webinar pages do; supporting pages set it in
their own `page_class`.) It also provides the helpers the selling layouts use:
`selling_page`, `sales_data_for`, `sales_text`, `buy_link` and
`current_offer_url`.

**Hidden pages.** `hidden: true` (Spec0010: hidden in production, visible in
dev and on deploy previews) now also covers standalone pages and offers.
`Builders::SharedContent.hidden?` is the one rule. `shared_content.rb` drops
hidden pages, and `offers.rb` drops hidden offers. **An offer also inherits
its sales page's hidden state.** So for a launch, unhiding the course
unhides its offers in the same change. A dropped page leaves the build
entirely, which keeps it out of the sitemap, out of `_redirects`, and out of
anything that links to it. The home page relies on this: its featured-course,
how-it-works and free-worksheet sections show only when their targets exist
in the build.

**Unlisted pages.** `unlisted: true` is the step between hidden and listed:
the page is published and reachable by its URL (from an email, an ad or a
coupon link), but the site never volunteers it. `shared_content.rb` keeps it
out of the sitemap, and the course listings (`index.erb`, including the
featured course; `courses.erb`; and `course.erb`'s "More Courses") skip it. It
is **not** `noindex`. An unlisted course's offers are live, since an offer
inherits only its sales page's *hidden* state. To list it, delete the
`unlisted` line.

**When an offer ends.** Two layers. In the page, `offer.erb` writes
`redirect_at` into a data attribute, and `frontend/javascript/index.js`
`location.replace()`s to the sales page once the visitor's clock passes it.
At the server, `src/redirects.erb` (named without the leading underscore,
because Bridgetown ignores `_`-prefixed sources; its permalink is
`/_redirects`) writes one rule per ended offer:
`/courses/x/launch/  /courses/x/  302!`. It's **302**, because the URL may be
reused. The **`!`** is required, because the page file still exists and
Netlify serves an existing file over an unforced rule. The server rule only
appears at the next deploy after `redirect_at`, so deploy that day.
`netlify.toml` still has no `[[redirects]]`; Netlify reads `_redirects` first.

**Buy buttons.** `src/_partials/sales/_buy.erb`. Each is
`<a class="btn btn-buy" data-buy data-commerce>`:

- `data-commerce` plus Kit's `commerce.js` (loaded once by `_page.erb`) opens
  Kit's checkout as an overlay on the page, the same embed as
  SoftwareArchitectureInsights' `donate.erb`.
- The href carries
  `utm_source=atchisonacademy&utm_medium=web[&utm_campaign=<offer's>]&utm_content=<hero|price|footer>`,
  appended with `&` when the coupon link already has a query string.
- `index.js` copies any `utm_*` the visitor arrived with onto every Buy link.
  Arrival values win.
- `index.js` fires the Fathom event in `data-fathom-event` on click:
  `buy-<product>` on the sales page, `buy-<product>-<offer-slug>` on an offer.

`btn-buy` is the **only** rule that uses `--aa-amber-fill`. Amber means Buy
(BRAND.md §2).

**Head.** Front matter `noindex: true` emits `<meta name="robots"
content="noindex">` on any page. The social image is `image:` front matter,
else a sales or offer page's `og_image`, else `/images/og-card.png`. Every
one must be 1200×630. The description falls back to the sales data file's
`description`.

**Trailer.** The trailer is Vimeo, click to play. The poster and a play
button render first, and the iframe (`autoplay=1&texttrack=en`) is created
only on click, so no Vimeo request happens before then. While `vimeo_id` is
null, the hero shows `hero_image` instead. The trailer's Vimeo privacy must
allow `atchisonacademy.com`, because course videos are locked to
`courses.atchisonacademy.com`.

**Brand tokens.** The `--aa-*` block at the head of the selling-pages
section of `index.css` is copied verbatim from BRAND.md. Selling pages use
only those tokens. The rest of the site still uses the LeeAtchison-derived
tokens.

> **To add an offer page:**
> 1. Create the coupon link in Kit.
> 2. Add `src/_offers/<product>-<offer-slug>.md` with `product`, `permalink`,
>    `price`, `buy_url`, and any overrides.
> 3. Set `ends_at` / `redirect_at` if it expires.
> 4. Build. The builder rejects a wrong product, permalink or price.
> 5. Check the deploy preview: price, Buy link (hover it), end-date line.
> 6. Put a reminder in Todoist to deploy the day after `redirect_at`.

## Netlify and the retired /academy page

`netlify.toml` here has **no `[[redirects]]` section at all**, and does not need one.
(The only redirects this site emits are the generated `_redirects` rules for ended offers —
see **Selling pages** above.)
The cutover is complete: `atchisonacademy.com` has its own Netlify site and resolves to
this directory rather than being an alias on the leeatchison.com site, so the two 302
rules that used to send it to `leeatchison.com/academy/` are gone from
`LeeAtchison/netlify.toml` (Spec0006).

Traffic now flows the other way. `leeatchison.com/academy` no longer exists — its page
was deleted, and `/academy` and `/academy/*` 301 to `https://atchisonacademy.com/` from
`LeeAtchison/netlify.toml`. Those rules live on that site because that is the site the
requests arrive at; nothing here needs to know about them.
