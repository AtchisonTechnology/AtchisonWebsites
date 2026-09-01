# courses.atchisonacademy.com

Source code for the **unlisted** course-content site behind Atchison Academy's
purchased courses — the videos, readings, and resource lists a purchaser
works through after buying a course at
[atchisonacademy.com](https://atchisonacademy.com).

Built with [Bridgetown](https://www.bridgetownrb.com/) (v2.1.2), ERB
templates, esbuild, and PostCSS. Deployed on Netlify.

> **Status.** New (Spec0021). Netlify site creation and the
> `courses.atchisonacademy.com` DNS record are Lee's to do by hand; until
> then this exists only in local dev and on ad hoc Netlify previews.

## This site is unlisted, not access-controlled

There is no login. Anyone who has a URL can open and share it — that's an
accepted trade-off, not a bug. See the site's own `CLAUDE.md` for the full
rules (no root index, random-slug catalog and course URLs, no sitemap,
disallow-all robots.txt, `X-Robots-Tag: noindex` header).

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
bin/dev                    # Dev server on this checkout's derived port (18000 on main)
bin/bridgetown build       # One-shot build to output/
bin/bridgetown clean       # Delete output/ and .bridgetown-cache/
```

This site is index 6 in the monorepo's port scheme: `18000` on `main`,
`18000 + N` in a `spec####` worktree, `19000 + N` in a `bug####` worktree.
The port is derived, never configured — run
`../bin/site-port AtchisonAcademyCourses` to see what this checkout will use.

To rebuild frontend assets independently:

```sh
npm run esbuild-dev        # Watch mode
npm run esbuild            # One-shot minified bundle
```

## Production Build & Deployment

The site deploys automatically to Netlify on push to `main` (once the
Netlify side is set up). To run a production build locally:

```sh
rake deploy                # clean → frontend:build (minified) → build
```

Output is written to `output/`.

## Content

See the site's own `CLAUDE.md` for the full content model (courses, lessons,
the standard lesson template, the validation builder) and how to add a real
course.
