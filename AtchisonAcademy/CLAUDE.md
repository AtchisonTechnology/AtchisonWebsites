# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
  _partials/
    _head.erb             # <head> contents: meta, canonical/OG, favicon, assets, Fathom
    _footer.erb           # Site footer
  _components/shared/
    navbar.erb            # Navigation template
    navbar.rb             # Bridgetown::Component class (receives metadata, resource)
  _data/
    site_metadata.yml     # title, tagline, description — accessed as site.metadata
  _books/                 # -> ../../shared/_books  (symlink; 2 shown here)
  _courses/               # -> ../../shared/_courses (symlink; 8 shown here)
  images/
    logo-academy.png      # Atchison Academy logo — hero and closing CTA band
    favicon.png           # Favicon (Academy shield logo, 32×32)
    og-card.png           # Open Graph / Twitter card (1200×630)
    linkedin-learners-badge.png  # LinkedIn Learning badge (courses hero)
    pets404.png           # 404/500 page illustration
    books/                # Book cover images
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
leeatchison.com. Entries carrying `external: true` are emitted as-is with
`target="_blank"` and `rel="noopener noreferrer"`; every other entry goes through
`relative_url`, which would mangle an absolute URL. Adding a new outbound link means
setting that flag, not just pasting a URL into `path`.

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

**Adding images**: Place raw source files in `assets_inbox/`, then resize (`sips -Z <maxpx> source --out src/images/dest` on macOS) and reference via `relative_url`. `og-card.png` must stay 1200×630 — `_head.erb` declares those exact dimensions.

**Site metadata**: `src/_data/site_metadata.yml` is the single source for site title, tagline, and description. Access as `site.metadata.title`, etc. in templates.

**Analytics**: `_head.erb`'s Fathom snippet uses `data-site="QZJQFDMY"`, the same site ID
as every other site in the monorepo. Academy traffic is separated by hostname inside
Fathom, not by site ID, which is what keeps `_head.erb` copyable across sites with no
per-site edit.

**Collections**: Defined in `bridgetown.config.yml` (not in `config/initializers.rb` — the Ruby DSL doesn't support collection registration). Access in ERB as `site.collections["books"].resources`. In collection index pages or layouts, iterate with `.sort_by { |b| b.data.order_academy || 99 }`.

**Shared collections** (Spec0008): `src/_books` and `src/_courses` are **symlinks** to `../../shared/_books` and `../../shared/_courses` at the repo root — one set of files, read by this site and by `LeeAtchison`. There are 10 books and 12 courses there; this site shows the 2 books and 8 courses marked `show_academy`. Edit the files under `shared/`; never replace the symlinks with real directories, and never edit an item on the assumption it is Academy-only — leeatchison.com reads the same file. Both sites' dev watchers follow the symlink, so an edit under `shared/` live-rebuilds both.

`plugins/builders/shared_content.rb` filters the collections at `:site, :post_read` down to the items carrying `show_academy`, so this site never generates a page or sitemap entry for a non-Academy item. It also raises at build time if an item carries `feature_academy` or `order_academy` without `show_academy`. Templates therefore never filter on membership — only on featuring and order.

**Collection front matter**: Books use `layout: book`; courses use `layout: course`. Both layouts extend `default` and produce full-width pages via the `body.book` / `body.course` CSS selectors. Key book fields: `cover_image`, `amazon_url`, `book_url`, `badge`, `badge_style`, `summary`, `testimonials[]`. Key course fields: `platform`, `platform_url`, `summary`.

Because the files are shared, membership, featuring and ordering are expressed with one key per site (Spec0008) — `show_*` and `feature_*` are booleans where **absent means false**, so only `true` is ever written:

| Key | Meaning |
|---|---|
| `show_academy` | The item appears on this site |
| `show_leeatchison` | The item appears on leeatchison.com |
| `feature_academy` | Featured on this site (`index.erb`, `books.erb`, `courses.erb`) |
| `feature_leeatchison` | Featured on leeatchison.com |
| `order_academy` | Sort position on this site |
| `order_leeatchison` | Sort position on leeatchison.com |

`feature_*` and `order_*` are written only on items carrying the matching `show_*`; the builder fails the build otherwise. This site's `order_academy` values start as a subsequence of `order_leeatchison` and so have gaps — that sorts correctly, and either site can be re-sequenced without touching the other. The retired `academy`, `academy_featured`, `featured` and bare `order` keys are gone — nothing reads them.

**Amazon Associates**: Every link to amazon.com must include the query parameter `tag=leeatchison-20`. Example: `https://www.amazon.com/dp/XXXXXXXXX?tag=leeatchison-20`.

## Netlify and the retired /academy page

`netlify.toml` here has **no `[[redirects]]` section at all**, and does not need one.
The cutover is complete: `atchisonacademy.com` has its own Netlify site and resolves to
this directory rather than being an alias on the leeatchison.com site, so the two 302
rules that used to send it to `leeatchison.com/academy/` are gone from
`LeeAtchison/netlify.toml` (Spec0006).

Traffic now flows the other way. `leeatchison.com/academy` no longer exists — its page
was deleted, and `/academy` and `/academy/*` 301 to `https://atchisonacademy.com/` from
`LeeAtchison/netlify.toml`. Those rules live on that site because that is the site the
requests arrive at; nothing here needs to know about them.
