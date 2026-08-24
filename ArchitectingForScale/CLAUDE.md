# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Architecting for Scale Website

A Bridgetown static site for Lee Atchison's O'Reilly book *Architecting for Scale* (2nd Edition). The site drives visitors to purchase the book on Amazon and O'Reilly Learning.

**Live URL:** https://architectingforscale.com  
**Stack:** Bridgetown 2.x (Ruby), ERB templates, plain CSS (no Tailwind, no external CSS framework), esbuild for JS/CSS bundling

---

## Development

```bash
bin/bridgetown start    # dev server at localhost:4000 with live reload
bin/bridgetown build    # production build to output/
rake deploy             # clean → npm run esbuild → bridgetown build
```

The `output/` folder is the built site. Netlify config is in `netlify.toml`.

---

## Architecture

### Template Rendering

Bridgetown uses Ruby-based components and ERB templates:

- `src/_layouts/default.erb` -- root HTML shell; renders head partial, navbar component, `yield`, footer partial
- `src/_partials/_head.erb` -- `<head>` with OG meta tags, Google Fonts (Inter + Merriweather), `asset_path` helper for CSS/JS
- `src/_partials/_footer.erb` -- site footer
- `src/_components/shared/navbar.rb` -- Ruby component class (`Shared::Navbar < Bridgetown::Component`)
- `src/_components/shared/navbar.erb` -- sticky nav; links anchor to homepage sections (`/#the-book`, `/#endorsements`, `/#about`, `/#buy`)
- `src/_data/site_metadata.yml` -- title, tagline, description, author; accessed via `site.metadata` in templates
- `config/initializers.rb` -- sets `url` and `template_engine :erb`

### Frontend Assets

- `frontend/styles/index.css` -- all site CSS (hand-written, ~600 lines)
- `frontend/styles/syntax-highlighting.css` -- code block styles
- `frontend/javascript/index.js` -- imports CSS files and glob-imports component JS/CSS
- `esbuild.config.js` -- esbuild bundler (uses Bridgetown defaults + glob)
- `postcss.config.js` -- PostCSS with postcss-preset-env (stage 3) and autoprefixer

### CSS Design Tokens

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

Single responsive breakpoint at 680px: all multi-column layouts collapse to one column.

---

## Homepage Sections

`src/index.erb` contains all sections in order:

1. **Hero** -- edition label "O'Reilly Media — 2nd Edition", H1 "Build systems that stay up while they scale.", cover image (`cover-600.png`, max-width 280px, drop-shadow), two CTA buttons
2. **Recognition Strip** -- Thinkers360 Top 50, Network Computing #3 Pick, O'Reilly 2nd Edition
3. **Problem** (`id="the-problem"`) -- H2 "Growth should be a good problem. It usually isn't."
4. **What's Inside** (`id="the-book"`) -- pull quote (Colin Bodell, VP Engineering Shopify Plus), benefits list with SVG checkmark circles
5. **Endorsements** (`id="endorsements"`) -- 2-column grid of 4 endorsement blocks (Ken Gavranovic, Patrick Franklin, Ekaterina Novoseltseva, Colin Bodell)
6. **About** (`id="about"`) -- two-column layout, circular author photo (`lee-atchison.jpeg`), bio, links to leeatchison.com and newsletter
7. **Newsletter Callout** (`id="newsletter"`) -- dark ink background, subscribe CTA
8. **Buy** (`id="buy"`) -- three cards: Paperback (Amazon), Kindle eBook (Amazon), O'Reilly Learning

---

## Book Details

- **Amazon link:** https://www.amazon.com/dp/B0859P45K9/?tag=leeatchison-20 (affiliate; used in buy buttons)
- **Paperback:** $24.99
- **Kindle eBook:** $9.99
- **Publisher:** O'Reilly Media
- **Full title:** *Architecting for Scale: How to Maintain High Availability and Manage Risk in the Cloud* (2nd Edition)

---

## Content and Voice Rules

- Never use em-dashes. Use commas, parentheses, or short sentences instead.
- Author location is always "Seattle" (not Renton).
- Do not invent endorsements, statistics, or book copy. Use only what is in this file or provided by the user.
- Every Amazon.com link must include the Associates tag: `?tag=leeatchison-20` (or `&tag=leeatchison-20` if the URL already has query params). Never add an Amazon link without it.