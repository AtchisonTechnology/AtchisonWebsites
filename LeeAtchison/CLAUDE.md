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
  academy.erb             # Atchison Academy landing page
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
    _head.erb             # <head> contents: meta, favicon, CSS/JS asset links
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

**Collections**: Defined in `bridgetown.config.yml` (not in `config/initializers.rb` — the Ruby DSL doesn't support collection registration). Access in ERB as `site.collections["books"].resources`. Collection items live in `src/_books/` and `src/_courses/`. In collection index pages or layouts, iterate with `.sort_by { |b| b.data.order || 99 }`.

**Collection front matter**: Books use `layout: book`; courses use `layout: course`. Both layouts extend `default` and produce full-width pages via the `body.book` / `body.course` CSS selectors. Key book fields: `cover_image`, `amazon_url`, `book_url`, `badge`, `badge_style`, `summary`, `testimonials[]`, `featured` (boolean, highlights on Academy page). Key course fields: `platform`, `platform_url`, `summary`, `academy` (boolean, shown on Academy page), `academy_featured` (boolean, featured slot on Academy page).

**Amazon Associates**: Every link to amazon.com must include the query parameter `tag=leeatchison-20`. Example: `https://www.amazon.com/dp/XXXXXXXXX?tag=leeatchison-20`.