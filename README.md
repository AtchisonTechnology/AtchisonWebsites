# Atchison Websites

One repo, nine independent [Bridgetown](https://www.bridgetownrb.com) static sites. Bridgetown is a Ruby static site generator, not Jekyll. Each site is built with its own Ruby, ERB templates and esbuild, and each is deployed on its own to Netlify.

## Sites

| Directory | Site | Live URL |
|---|---|---|
| `LeeAtchison` | Lee Atchison's personal site | leeatchison.com |
| `AtchisonAcademy` | Atchison Academy: courses, quote page | atchisonacademy.com |
| `SoftwareArchitectureInsights` | Software Architecture Insights: the weekly newsletter's articles and podcast pages | softwarearchitectureinsights.com |
| `TheSoftwareConductor` | The Software Conductor | thesoftwareconductor.com |
| `stosa` | STOSA framework | stosa.org |
| `ArchitectingForScale` | Architecting for Scale, the book site | architectingforscale.com |
| `BusinessBreakthrough30` | Business Breakthrough 30 | businessbreakthrough30.com |
| `Cascadras` | Cascadras demand-test page | cascadras.com |
| `Orcarra` | Orcarra demand-test page | orcarra.com |

`shared/` holds the book and course content that `LeeAtchison` and `AtchisonAcademy` both read, through symlinks. An edit there lands on both sites.

## Requirements

- Ruby 3.2.2 (every site's `.ruby-version`), with Bundler.
- Node and npm, for esbuild.
- Optional: `foreman`, to run every site at once.

## Install a site

Run these inside the site's directory:

```bash
bundle install
npm ci
```

## Run a site

```bash
<Site>/bin/dev        # from the repo root: starts that site on its own dev port
make dev              # from the repo root: starts every site at once (needs foreman)
```

Each site has a fixed dev port, so all of them can run together:

| Site | Port | Site | Port |
|---|---|---|---|
| `LeeAtchison` | 3000 | `ArchitectingForScale` | 14000 |
| `TheSoftwareConductor` | 8000 | `AtchisonAcademy` | 16000 |
| `stosa` | 10000 | `Cascadras` | 18000 |
| `BusinessBreakthrough30` | 12000 | `SoftwareArchitectureInsights` | 20000 |
| | | `Orcarra` | 22000 |

Set `BRIDGETOWN_PORT` to use a different port.

## Build a site

Run inside the site's directory. Use `deploy`, not `build`. `deploy` runs esbuild, so CSS and JavaScript are built, and it is the same command Netlify runs. `build` skips esbuild.

```bash
bin/bridgetown deploy
```

The result goes to the site's `output/` folder.

## Test a site

```bash
bundle exec rake test     # builds the site with BRIDGETOWN_ENV=test
```

There is no separate test suite. A clean build is the test, and Netlify's deploy preview on each pull request is the check before merging.

## More

Read the root [`CLAUDE.md`](CLAUDE.md) for how the repo and the shared content work, and the development process (Linear issues, branches, pull requests; Lee merges). Each site's own `CLAUDE.md` covers its layouts, styles and content rules. Read it before changing anything in that site.
