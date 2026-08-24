# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Business Breakthrough 3.0 Website

A Bridgetown static site for Lee Atchison and Ken Gavranovic's book *Business Breakthrough 3.0*. The site drives visitors to purchase the book on Amazon.

**Live URL:** businessbreakthrough30.com
**Stack:** Bridgetown 2.1.2 (Ruby), ERB templates, plain CSS (no Tailwind, no external CSS framework)

---

## Development

```bash
bundle install && npm install   # first-time setup (requires Ruby >= 3.2, Node >= 20)
bin/bridgetown start            # dev server at localhost:4000
bin/bridgetown build            # production build to output/
bin/bridgetown console          # IRB console with site context loaded
```

`config/initializers.rb` is **not** hot-reloaded; restart the server after changing it.

The `output/` folder is the built site, suitable for static hosting (Netlify, Render, GitHub Pages, etc.).

---

## Project Structure

```
src/
  _layouts/default.erb          # root HTML shell (head, nav, footer via partials)
  _partials/_head.erb           # <head> with meta tags, Google Fonts, OG tags, CSS/JS links
  _partials/_footer.erb         # site footer
  _components/shared/navbar.erb # sticky nav component
  _components/shared/navbar.rb  # Bridgetown component class for navbar
  _data/site_metadata.yml       # title, tagline, description, authors
  images/                       # cover-1000.png, cover-600.png, cover-thumb.png, etc.
  index.erb                     # homepage (all six sections)
config/initializers.rb          # Bridgetown config (sets url, template_engine)
frontend/styles/index.css       # all CSS, written from scratch
frontend/javascript/index.js    # JS entry point (minimal)
esbuild.config.js               # frontend bundler config
```

---

## Configuration

Site metadata (title, tagline, description, authors) lives in `src/_data/site_metadata.yml`. The base URL is set in `config/initializers.rb`.

---

## Homepage Sections

`src/index.erb` contains all six sections in order:

1. **Hero** -- H1 "Break free from the patterns holding your company back.", subheadline, cover image (`cover-600.png`), two CTA buttons (Buy on Amazon + Learn More anchor)
2. **Problem** (`id="the-problem"`) -- "You can feel it stalling." (`.section.alt` background)
3. **What's Inside** (`id="the-book"`) -- pull quote, five breakthrough processes as a benefits list
4. **Endorsements** -- six endorsement blockquotes in `.endorsements-grid` (two columns desktop, one mobile)
5. **About** (`id="about"`) -- two `.author-entry` divs side by side (Lee Atchison and Ken Gavranovic), no photos
6. **Buy** (`id="buy"`) -- single "Buy on Amazon" button (`.btn-large`)

---

## CSS Design Tokens

Defined as custom properties in `frontend/styles/index.css`:

```css
--color-ink:        #1a1a2e;   /* near-black for body text */
--color-accent:     #4a90e2;   /* brand blue */
--color-accent-dark:#2c6fbe;   /* hover state */
--color-bg:         #ffffff;
--color-bg-alt:     #f5f7fa;   /* light grey for alternating sections */
--color-muted:      #6b7280;   /* secondary text */
--font-body:        'Inter', sans-serif;
--font-heading:     'Merriweather', Georgia, serif;
--max-width:        900px;
--section-padding:  4rem 1.5rem;
```

Single responsive breakpoint at 680px: everything stacks to a single column.

---

## Book Details

- **Amazon link:** https://www.amazon.com/dp/B0C8BLS6GN?tag=leeatchison-20 (all buy buttons point here; always include `?tag=leeatchison-20` on every Amazon URL)
- **Publisher:** Executive Book Publishing
- **Authors:** Lee Atchison and Ken Gavranovic

---

## Content and Voice Rules

- Every Amazon.com link must include the Associates tag: `?tag=leeatchison-20` (e.g. `https://www.amazon.com/dp/B0C8BLS6GN?tag=leeatchison-20`).
- Never use em-dashes. Use commas, parentheses, or short sentences instead.
- Do not invent endorsements, statistics, or book copy. Use only what is written in this file or provided by the user.
- Author location for Lee Atchison is "Seattle."
- The book tagline: *An accessible, no-nonsense guide for transforming your company and implementing sustainable change.*