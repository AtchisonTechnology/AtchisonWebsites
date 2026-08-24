# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

A Bridgetown static site for Lee Atchison's book *The Software Conductor*. The site drives visitors to purchase the book on Amazon and other retailers.

**Live URL:** thesoftwareconductor.com
**Stack:** Bridgetown 2.1.2 (Ruby), ERB templates, plain CSS (no Tailwind, no external CSS framework), deployed on Netlify

---

## Commands

```bash
bin/bridgetown start    # dev server at localhost:4000 with live reload
bin/bridgetown build    # production build to output/
bin/bridgetown deploy   # clean build + frontend optimization (used by Netlify)
bin/bridgetown console  # Ruby IRB with site context loaded
rake clean              # remove output/ directory
```

There is no test suite.

---

## Architecture

### Build Pipeline

Bridgetown orchestrates two parallel pipelines that both write into `output/`:

1. **Ruby/ERB** -- processes `src/` via Bridgetown's SSG engine. Templates use ERB (configured in `config/initializers.rb`; Liquid and Serbea are not used).
2. **Frontend (esbuild + PostCSS)** -- `frontend/javascript/index.js` is the entry point. It imports `frontend/styles/index.css` and `syntax-highlighting.css`, then dynamically globs all `src/_components/**/*.{js,css}` files. PostCSS runs autoprefixer and `postcss-preset-env` on the output. Custom esbuild options live in `esbuild.config.js`.

The dev server is a Rack/Roda app (`server/roda_app.rb` + `config.ru`) that serves both pipelines together.

### Template Hierarchy

```
src/_layouts/default.erb          # outer HTML shell: renders _head partial, navbar component, footer partial
  src/_partials/_head.erb         # <head>: meta, OG tags, Google Fonts, favicon links, CSS/JS assets
  src/_components/shared/navbar.erb  # sticky nav; receives metadata + resource from navbar.rb
  src/_partials/_footer.erb       # copyright, email link
```

`default.erb` renders the navbar via `<%= render Shared::Navbar.new(metadata:, resource:) %>`. The component class (`navbar.rb`) only stores those two ivars; all logic is in the ERB template.

### Site Data

All site-level metadata (title, tagline, description, author) comes from `src/_data/site_metadata.yml` and is available in templates as `metadata`. The base URL is set in `config/initializers.rb`.

### Homepage

`src/index.erb` is a single file containing all page sections in order: Hero, Problem (`#the-problem`), What's Inside (`#the-book`), Endorsement, About (`#about`), Newsletter (`#newsletter`), and Buy (`#buy`). The navbar anchor links target these IDs.

### CSS

All styles are in `frontend/styles/index.css` (roughly 500 lines, no framework). Design tokens are CSS custom properties defined at `:root`. Single responsive breakpoint at 680px -- everything collapses to one column.

```css
--color-ink:        #1a1a2e;
--color-accent:     #4a90e2;
--color-accent-dark:#2c6fbe;
--color-bg:         #ffffff;
--color-bg-alt:     #f5f7fa;
--color-muted:      #6b7280;
--font-body:        'Inter', sans-serif;
--font-heading:     'Merriweather', Georgia, serif;
--max-width:        900px;
--section-padding:  4rem 1.5rem;
```

### Favicons

Generated from `src/images/square-logo.png`. Files live at the site root (`src/`): `favicon.ico` (16/32/48px multi-size), `favicon-16x16.png`, `favicon-32x32.png`, `apple-touch-icon.png` (180px), `android-chrome-192x192.png`, `android-chrome-512x512.png`, and `site.webmanifest`. All linked in `_head.erb`.

---

## Book Details

- **Amazon link:** https://www.amazon.com/dp/B0GZWZ64WM?tag=leeatchison-20 (Kindle buy button points here)
- **Amazon Associates tag:** `leeatchison-20` -- every Amazon.com URL must include `?tag=leeatchison-20` (or `&tag=leeatchison-20` if the URL already has query params)
- **Softcover:** $24.99, ISBN 979-8-9960196-0-1
- **Kindle eBook:** $9.99, ISBN 979-8-9960196-1-8
- **Hardcover:** $34.99, ISBN 979-8-9960196-2-5
- **Publisher:** Atchison Academy
- **Full subtitle:** *A journey of discovery from software developer to architect*

---

## Content and Voice Rules

- Never use em-dashes. Use commas, parentheses, or short sentences instead.
- Author location is always "Seattle" (not Renton).
- Publisher imprint is **Atchison Academy** (distinct from Lee's consulting practice, Atchison Technology).
- The full subtitle is: *A journey of discovery from software developer to architect*. Use this when showing the complete title.
- Do not invent endorsements, statistics, or book copy. Use only what is written in this file or provided by the user.