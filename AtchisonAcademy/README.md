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

> **These files are shared.** `src/_books` and `src/_courses` are symlinks to
> `shared/_books` and `shared/_courses` at the repo root, which
> `LeeAtchison` reads too. There are 10 books and 17 courses there; this site
> shows the 2 books and 13 courses marked `show_academy`. Edit the files under
> `shared/` — an edit lands on both sites — and never replace the symlinks
> with real directories.

### Per-site keys

Which site shows an item, features it, and in what order, is set entirely in
front matter (there is one key per site, and `show_*`/`feature_*` are booleans
where **absent means false**, so only `true` is ever written):

| Field                 | Description                                          |
|-----------------------|------------------------------------------------------|
| `show_academy`        | The item appears on this site                        |
| `show_leeatchison`    | The item appears on leeatchison.com                  |
| `feature_academy`     | Highlight on this site's home, books and courses pages |
| `feature_leeatchison` | Highlight on leeatchison.com                         |
| `order_academy`       | Sort order on this site (lower = first)              |
| `order_leeatchison`   | Sort order on leeatchison.com                        |

`plugins/builders/shared_content.rb` drops everything without `show_academy`
when the collections are read, so a non-Academy item generates no page and no
sitemap entry here. Writing `feature_academy` or `order_academy` on an item
without `show_academy` fails the build. This site's `order_academy` values are
a subsequence of `order_leeatchison` and so have gaps — that sorts correctly,
and either site can be re-sequenced without touching the other.

### Books (`src/_books/`)

Each book is a Markdown file with front matter. Key fields, alongside the
per-site keys above:

| Field               | Description                                            |
|---------------------|--------------------------------------------------------|
| `title`             | Book title                                             |
| `cover_image`       | Path to cover image in `src/images/books/`             |
| `amazon_url`        | Amazon link — **must include `?tag=leeatchison-20`**   |
| `book_url`          | Publisher or canonical URL                             |
| `badge` / `badge_style` | Optional badge label and CSS style                |
| `summary`           | Short description                                      |
| `testimonials[]`    | Array of `{quote, name, title}` objects                |

### Courses (`src/_courses/`)

Each course is a Markdown file with front matter. Key fields, alongside the
per-site keys above:

| Field              | Description                                            |
|--------------------|--------------------------------------------------------|
| `title`            | Course title                                           |
| `platform`         | Platform name (e.g. O'Reilly Media, LinkedIn Learning) |
| `platform_url`     | Direct link to the course                              |
| `summary`          | Short description                                      |

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
