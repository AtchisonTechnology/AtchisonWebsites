# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# STOSA Website

A Bridgetown static site for STOSA (Single Team Oriented Service Architecture), a framework created by Lee Atchison for large organizations managing service-based applications across multiple development teams.

**Live URL:** https://stosa.org  
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
- `src/_partials/_footer.erb` -- site footer (Atchison Technology LLC copyright)
- `src/_components/shared/navbar.rb` -- Ruby component class (`Shared::Navbar < Bridgetown::Component`)
- `src/_components/shared/navbar.erb` -- sticky nav; links anchor to homepage sections (`/#what-is-stosa`, `/#ownership`, `/#organization`, `/#about`)
- `src/_data/site_metadata.yml` -- title, tagline, description, author; accessed via `site.metadata` in templates
- `config/initializers.rb` -- sets `url` and `template_engine :erb`

### Frontend Assets

- `frontend/styles/index.css` -- all site CSS (hand-written); includes STOSA-specific styles at the bottom
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

1. **Hero** (`.stosa-hero`) -- dark ink background, centered; "A Framework for Scalable Organizations" label, H1 "Single Team Oriented Service Architecture", tagline, two CTA buttons
2. **Key Facts Strip** (`.recognition-strip`) -- "Created by Lee Atchison", "Covered in Depth / Architecting for Scale", "3-8 engineers per service team"
3. **What is STOSA?** (`id="what-is-stosa"`) -- definition paragraph + 7-item criteria checklist with blue circle checkmarks
4. **STOSA vs. Non-STOSA** -- two CSS diagrams side by side: STOSA (services A-L assigned across four teams) vs. non-STOSA (services C/D shared between teams, service I unowned)
5. **Advantages** (`id="advantages"`) -- 5-item benefits list of STOSA organizational advantages
6. **Service Ownership** (`id="ownership"`) -- 12-card grid covering all service ownership responsibilities (API Design, Development, Data, Deployments, Deployment Windows, Production Infrastructure, Environments, SLAs, Monitoring, Incident Response, Reporting, Shared Infrastructure)
7. **STOSA Organization** (`id="organization"`) -- accountability text + 3-card "often-delegated functions" grid (Servers/Hardware, Tooling, Databases)
8. **About** (`id="about"`) -- circular author photo (`lee-atchison.jpeg`), bio, links to leeatchison.com, architectingforscale.com, and newsletter

---

## STOSA Framework Details

STOSA requires:
- Service-based/microservice architecture with multiple dev teams
- Every service assigned to exactly one team (no shared ownership)
- Teams responsible for all service management aspects
- Strong service boundaries with documented APIs
- Services own their data; others access data via APIs
- Services maintain and monitor internal SLAs
- Teams of 3-8 engineers

---

## About the Author

- **Lee Atchison** created STOSA and wrote about it in *Architecting for Scale* (O'Reilly)
- Author location is always "Seattle" (not Renton)
- Do not invent STOSA rules, responsibilities, or content not documented here
- Links: leeatchison.com, architectingforscale.com, softwarearchitectureinsights.com

---

## Content and Voice Rules

- Never use em-dashes. Use commas, parentheses, or short sentences instead.
- Author location is always "Seattle" (not Renton).
- Do not invent STOSA rules, team structures, or framework details not already in this file or provided by the user.
- Do not add endorsements or statistics that aren't provided by the user.
