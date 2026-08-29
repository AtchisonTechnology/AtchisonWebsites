# atchisonacademy.com

Source code for [Atchison Academy](https://atchisonacademy.com) — Lee Atchison's books, courses, and training for software architects and technology leaders.

Built with [Bridgetown](https://www.bridgetownrb.com/) (v2.1.2), ERB templates, esbuild, and PostCSS. Deployed on Netlify.

> **Status.** Live. `atchisonacademy.com` has its own Netlify site and resolves here;
> it is no longer an alias domain on the leeatchison.com site. `leeatchison.com/academy`
> was retired in Spec0006 and now 301s to this site.

## Prerequisites

- Ruby >= 3.2 (see `.ruby-version`)
- Node >= 20
- Bundler: `gem install bundler`

## Setup

```sh
bundle install && npm install
```

## Development

```sh
bin/dev                    # Dev server on this checkout's derived port (16000 on main)
bin/bridgetown build       # One-shot build to output/
bin/bridgetown clean       # Delete output/ and .bridgetown-cache/
```

This site is index 5 in the monorepo's port scheme: `16000` on `main`, `16000 + N` in a
`spec####` worktree, `17000 + N` in a `bug####` worktree. The port is derived, never
configured — run `../bin/site-port AtchisonAcademy` to see what this checkout will use.

To rebuild frontend assets independently:

```sh
npm run esbuild-dev        # Watch mode
npm run esbuild            # One-shot minified bundle
```

## Production Build & Deployment

The site deploys automatically to Netlify on push to `main`. To run a production build locally:

```sh
rake deploy                # clean → frontend:build (minified) → build
```

Output is written to `output/`.

`config/initializers.rb` builds against the deploy's own hostname on a Netlify Deploy
Preview (`CONTEXT=deploy-preview` plus a non-empty `DEPLOY_PRIME_URL`) and against
`https://atchisonacademy.com` everywhere else — local builds, branch deploys, and
production. Do not add a `url:` key to `bridgetown.config.yml`; a YAML value would win
over the initializer and pin previews to the production hostname.

## Content

### Books (`src/_books/`)

Each book is a Markdown file with front matter. Key fields:

| Field               | Description                                            |
|---------------------|--------------------------------------------------------|
| `title`             | Book title                                             |
| `cover_image`       | Path to cover image in `src/images/books/`             |
| `amazon_url`        | Amazon link — **must include `?tag=leeatchison-20`**   |
| `book_url`          | Publisher or canonical URL                             |
| `badge` / `badge_style` | Optional badge label and CSS style                |
| `featured`          | `true` to show in the `/books` featured grid           |
| `academy` / `academy_featured` | Carried over from leeatchison.com; drives the home page's grouping |
| `order`             | Sort order on listing pages (lower = first)            |
| `summary`           | Short description                                      |
| `testimonials[]`    | Array of `{quote, name, title}` objects                |

### Courses (`src/_courses/`)

Each course is a Markdown file with front matter. Key fields:

| Field              | Description                                            |
|--------------------|--------------------------------------------------------|
| `title`            | Course title                                           |
| `platform`         | Platform name (e.g. O'Reilly Media, LinkedIn Learning) |
| `platform_url`     | Direct link to the course                              |
| `academy` / `academy_featured` | Carried over from leeatchison.com; drives the home page's grouping |
| `order`            | Sort order on listing pages (lower = first)            |
| `summary`          | Short description                                      |

Every item on this site is an Academy item, so `academy` is always `true` here. It is
kept anyway so the home page reuses `LeeAtchison/src/academy.erb`'s selection logic
unchanged and the two files stay diff-able.

### Adding Images

Place raw source files in `assets_inbox/` (never reference these directly), then resize and copy into `src/images/`:

```sh
sips -Z 500 assets_inbox/cover.jpg --out src/images/books/cover.jpg
```

Reference images in templates with `relative_url '/images/books/cover.jpg'`.

`src/images/og-card.png` must stay 1200×630 — `_head.erb` declares those dimensions in
its `og:image:width` / `og:image:height` tags.

## Architecture Notes

- **Template engine**: ERB (configured in `config/initializers.rb`)
- **Collections**: Defined in `bridgetown.config.yml`; books at `/books/:slug/`, courses at `/courses/:slug/`
- **CSS**: Single file at `frontend/styles/index.css` with CSS custom properties; compiled by PostCSS and bundled by esbuild with a content-hash filename. It is a verbatim copy of LeeAtchison's, so it carries rules for pages this site does not have — see `CLAUDE.md` for why that was the deliberate choice
- **Full-width pages**: Home, book, and course pages use `page_class: homepage` / `body.book` / `body.course` CSS selectors to bypass the default `max-width: 65rem` container
- **Site metadata**: Centralized in `src/_data/site_metadata.yml`; accessed as `site.metadata.title`, etc.
- **Navigation**: `src/_components/shared/navbar.rb` lists this site's own pages plus one outbound `external: true` link to leeatchison.com
