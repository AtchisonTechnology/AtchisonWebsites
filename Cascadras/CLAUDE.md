# CLAUDE.md

Guidance for Claude Code when working in the **Cascadras** site.

# cascadras.com

A one-page Bridgetown site for the Cascadras demand test (WEB-32): a real
page, a real price and a signup form, before anything gets built. Cascadras
is a planned product of Atchison Technology, owned by the Cascadras GM.

**Live URL:** https://cascadras.com
**Stack:** Bridgetown 2.x (Ruby), ERB templates, plain CSS, esbuild. The
skeleton (Gemfile, Gemfile.lock, bin/, config/, esbuild and PostCSS config)
is copied from `stosa`, so it builds exactly like the other sites.
**Dev port:** 18000 (`bin/dev`).

It does not join `shared/`: no books, no courses, no builder.

---

## Development

```bash
bin/dev                     # dev server at localhost:18000 with live reload
bin/bridgetown deploy       # production build to output/ (what Netlify runs)
```

Netlify: base directory `Cascadras`, build command and publish directory
from `netlify.toml`.

---

## What's here

- `src/index.erb` — the one page. Sections in the copy file's order: hero,
  the problem, what Cascadras will do, who it's for, the price, from Lee
  Atchison, the form. Copy is "Cascadras page copy.md" (Page 1), word for
  word. No nav, no other pages.
- `src/_partials/_reserve_form.erb` — the "Reserve a founding seat" form.
- `src/_layouts/default.erb` — wordmark header, `main`, footer.
- `src/_partials/_head.erb` — title, description, canonical, Open Graph,
  favicon, fonts, the Fathom script.
- `src/_data/site_metadata.yml` — title, description, **Fathom site ID**,
  **Kit form ID**.
- `frontend/styles/index.css` — all CSS. Tokens on `:root`. One breakpoint
  at 680px.
- `frontend/javascript/index.js` — Fathom click events and the form submit.
- `src/favicon.svg` — the favicon (a mountain mark). No images otherwise.

## The form

Our own HTML, posting straight to one Kit form's subscribe endpoint
(`https://app.kit.com/forms/<id>/subscriptions`, SAI Kit account, form
10221598), because Kit's form builder only does text fields. Field names:

| Field | Name sent to Kit |
|---|---|
| Name | `fields[first_name]` |
| Email | `email_address` |
| Your role | `fields[cascadras_role]` |
| Team size | `fields[cascadras_team_size]` |
| Decisions today | `fields[cascadras_decisions_today]` |
| Risk today | `fields[cascadras_risk_today]` |
| Call OK (Yes/No) | `fields[cascadras_call_ok]` |

A Kit rule tags every signup Cascadras and no-auto-sai, so the page sends no
tags and signups never join the SAI list. The JavaScript posts in the
background and swaps in the thank-you text in place; without JavaScript it's
a plain post to Kit.

The SAI site has the same form, field for field, at
`softwarearchitectureinsights.com/free/cascadras/`
(`SoftwareArchitectureInsights/src/_partials/_cascadras_form.erb`). **Keep
the two in step.**

## Fathom

Its own Fathom site; the ID is `fathom_site_id` in
`src/_data/site_metadata.yml`, the only place it appears. Events:

- `cascadras-reserve-click` — any "Reserve a founding seat" button that
  jumps to the form (`data-fathom-click` on the link).
- `cascadras-signup` — a successful submit.

## Redirects

`www.cascadras.com` 301s to `cascadras.com`, keeping the path and the query
string, so UTM tags survive (`netlify.toml`).
