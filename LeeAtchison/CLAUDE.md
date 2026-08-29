# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Always use the `bin/bridgetown` binstub to ensure the correct version runs.

```bash
bin/bridgetown start       # Dev server with live reload at http://localhost:4000
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

## Architecture

This is a **Bridgetown 2.1.2** static site. The template engine is ERB (set in `config/initializers.rb`). The frontend pipeline is esbuild + PostCSS (with `postcss-preset-env` and `postcss-flexbugs-fixes`).

### Source layout

```
src/
  index.erb               # Homepage — full-width layout via page_class: homepage
  about.erb               # About page
  books.erb               # Books listing page
  courses.erb             # Courses listing page
  contact.erb             # Contact page
  schedule.erb            # Schedule/availability page
  robots.txt.erb          # Dynamic robots.txt
  sitemap.xml.erb         # Dynamic sitemap
  404.html                # 404 error page
  500.html                # 500 error page
  _layouts/
    default.erb           # Root layout: navbar → <main> → footer
    page.erb              # Adds <h1> from data.title, then yields (extends default)
    post.erb              # Same as page.erb (for blog posts)
    book.erb              # Book detail layout (full-width via body.book)
    course.erb            # Course detail layout (full-width via body.course)
  _partials/
    _head.erb             # <head> contents: meta, canonical/OG, favicon, assets
    _footer.erb           # Site footer
  _components/shared/
    navbar.erb            # Navigation template
    navbar.rb             # Bridgetown::Component class (receives metadata, resource)
  _data/
    site_metadata.yml     # title, tagline, email, description — accessed as site.metadata
  images/
    lee-atchison.png      # Lee's headshot (240×240)
    sai-logo.png          # Software Architecture Insights logo
    logo-academy.png      # Atchison Academy logo
    logo.svg              # Primary logo (SVG)
    favicon.png           # Favicon (Lee's headshot, 32×32)
    linkedin-learners-badge.png  # LinkedIn Learning badge
    pets404.png           # 404 page illustration
    books/                # Resized book cover images (max 500px)
frontend/
  styles/index.css              # All CSS — design tokens, component styles, responsive
  styles/syntax-highlighting.css  # Code syntax highlighting styles
  javascript/index.js           # JS entry point (minimal)
assets_inbox/             # Staging area for raw assets — NEVER reference directly
                          # Copy and resize into src/images/ before use
```

### Key patterns

**Full-width homepage layout**: The default layout wraps all content in `<main>` with `max-width: 65rem`. The homepage bypasses this by setting `page_class: homepage` in its frontmatter, which adds `body.homepage` — CSS then overrides `body.homepage main` to be full-width with no padding or box-shadow.

**Component structure**: Components are a Ruby class + ERB template pair. The class sets instance variables in `initialize`; the template accesses them directly. `render Shared::Navbar.new(metadata: site.metadata, resource: resource)` is the call pattern.

**Internal links**: Always use the `relative_url` helper (e.g., `relative_url '/images/foo.png'`) for links and asset paths to support potential subdirectory deployments.

**CSS**: A single `frontend/styles/index.css` file with CSS custom properties at `:root`. PostCSS compiles it; esbuild bundles it with a content-hash filename. Non-homepage page styles are under `body:not(.homepage)`.

**Adding images**: Place raw source files in `assets_inbox/`, then resize with `sips -Z <maxpx> source --out src/images/dest` and reference via `relative_url`.

**Site metadata**: `src/_data/site_metadata.yml` is the single source for site title, tagline, email, and description. Access as `site.metadata.title`, etc. in templates.

**Collections**: Defined in `bridgetown.config.yml` (not in `config/initializers.rb` — the Ruby DSL doesn't support collection registration). Access in ERB as `site.collections["books"].resources`. In collection index pages or layouts, iterate with `.sort_by { |b| b.data.order_leeatchison || 99 }`.

**The books and courses collections are shared** (Spec0008). `src/_books` and `src/_courses` are **symlinks** to `../../shared/_books` and `../../shared/_courses` at the repo root — one set of files, read by this site and by `AtchisonAcademy`. Edit the files under `shared/`; never replace the symlinks with real directories. Both sites' dev watchers follow the symlink, so an edit under `shared/` live-rebuilds both.

`plugins/builders/shared_content.rb` filters the collections at `:site, :post_read` down to the items carrying `show_leeatchison`, so this site never generates a page or sitemap entry for an Academy-only item. It also raises at build time if an item carries `feature_leeatchison` or `order_leeatchison` without `show_leeatchison`. Templates therefore never filter on membership — only on featuring and order.

The same builder also resolves each item's `canonical_site` into cross-domain SEO
(Spec0009). It carries a `SITES` registry — site key → `show_` flag and production URL —
and a single `SITE_KEY`, which is the only line that differs from the `AtchisonAcademy`
copy; `show_leeatchison`, `feature_leeatchison` and `order_leeatchison` are all derived from it, so a
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

**Collection front matter**: Books use `layout: book`; courses use `layout: course`. Both layouts extend `default` and produce full-width pages via the `body.book` / `body.course` CSS selectors. Key book fields: `cover_image`, `amazon_url`, `book_url`, `badge`, `badge_style`, `summary`, `testimonials[]`. Key course fields: `platform`, `platform_url`, `summary`.

Because the files are shared, membership, featuring and ordering are expressed with one key per site (Spec0008) — `show_*` and `feature_*` are booleans where **absent means false**, so only `true` is ever written:

| Key | Meaning |
|---|---|
| `show_leeatchison` | The item appears on this site |
| `show_academy` | The item appears on atchisonacademy.com |
| `feature_leeatchison` | Featured on this site (`books.erb`, `courses.erb`) |
| `feature_academy` | Featured on atchisonacademy.com |
| `order_leeatchison` | Sort position on this site |
| `order_academy` | Sort position on atchisonacademy.com |
| `canonical_site` | Which site owns the SEO original of this item's page — `leeatchison` or `academy` |

`feature_*` and `order_*` are written only on items carrying the matching `show_*`; the builder fails the build otherwise. The retired `academy`, `academy_featured`, `featured` and bare `order` keys are gone — nothing reads them.

`canonical_site` (Spec0009) is set on **all 22 items**, not only the ten that appear on both
sites — a key on a single-site item is a true statement of where that page belongs, and
carrying it everywhere makes the rule uniform rather than a sparse exception list. Today's
assignment rule is by source: books from O'Reilly Media → `leeatchison`, Independent →
`academy`; courses from LinkedIn Learning or O'Reilly Media → `leeatchison`, Coursera →
`academy`. Two further build failures come from this key: an item with `show_` true for more
than one site and no `canonical_site`, and a `canonical_site` naming a site whose `show_`
flag is not set on that item. Those two rules are what stop a new item, or a flipped `show_`
flag, from silently re-creating duplicate pages across the two domains.

**Amazon Associates**: Every link to amazon.com must include the query parameter `tag=leeatchison-20`. Example: `https://www.amazon.com/dp/XXXXXXXXX?tag=leeatchison-20`.