# leeatchison.com

Source code for [leeatchison.com](https://leeatchison.com) — the personal website of Lee Atchison, software architect, author, and cloud computing expert.

Built with [Bridgetown](https://www.bridgetownrb.com/) (v2.1.2), ERB templates, esbuild, and PostCSS. Deployed on Netlify.

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
bin/bridgetown start       # Dev server with live reload at http://localhost:4000
bin/bridgetown build       # One-shot build to output/
bin/bridgetown clean       # Delete output/ and .bridgetown-cache/
```

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
| `featured`          | `true` to highlight on the books and courses pages     |
| `order`             | Sort order on listing pages (lower = first)            |
| `summary`           | Short description                                      |
| `testimonials[]`    | Array of `{quote, attribution}` objects                |

### Courses (`src/_courses/`)

Each course is a Markdown file with front matter. Key fields:

| Field              | Description                                            |
|--------------------|--------------------------------------------------------|
| `title`            | Course title                                           |
| `platform`         | Platform name (e.g. O'Reilly Media, LinkedIn Learning) |
| `platform_url`     | Direct link to the course                              |
| `academy`          | Inert here — read only by the `AtchisonAcademy` site   |
| `academy_featured` | Inert here — read only by the `AtchisonAcademy` site   |
| `order`            | Sort order on listing pages (lower = first)            |
| `summary`          | Short description                                      |

### Adding Images

Place raw source files in `assets_inbox/` (never reference these directly), then resize and copy into `src/images/`:

```sh
sips -Z 500 assets_inbox/cover.jpg --out src/images/books/cover.jpg
```

Reference images in templates with `relative_url '/images/books/cover.jpg'`.

## Architecture Notes

- **Template engine**: ERB (configured in `config/initializers.rb`)
- **Collections**: Defined in `bridgetown.config.yml`; books at `/books/:slug/`, courses at `/courses/:slug/`
- **CSS**: Single file at `frontend/styles/index.css` with CSS custom properties; compiled by PostCSS and bundled by esbuild with a content-hash filename
- **Full-width pages**: Homepage, book, and course pages use `page_class: homepage` / `body.book` / `body.course` CSS selectors to bypass the default `max-width: 65rem` container
- **Site metadata**: Centralized in `src/_data/site_metadata.yml`; accessed as `site.metadata.title`, etc.
