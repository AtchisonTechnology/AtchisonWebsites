# SoftwareArchitectureInsights — CLAUDE.md

Site notes for softwarearchitectureinsights.com. Read the repo-root
`CLAUDE.md` first.

## Fathom

The Fathom script tag in `src/_partials/_head.erb` carries
`data-canonical="false"`: without it, Fathom records the canonical URL (no
query string) and drops every `utm_` tag (WEB-35). **Keep it** while pages
have canonical links.
