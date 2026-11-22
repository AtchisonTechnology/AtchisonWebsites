# CLAUDE.md

Guidance for Claude Code when working in the **Orcarra** site.

# orcarra.com

A one-page Bridgetown site for the Orcarra demand test (WEB-33): a real
page, a real price and a signup form, before anything gets built, with
traffic from a small Google Ads test. Orcarra is a planned product of
Atchison Technology, owned by the Orcarra GM.

**Live URL:** https://orcarra.com
**Stack:** Bridgetown 2.x (Ruby), ERB templates, plain CSS, esbuild. The
skeleton (Gemfile, Gemfile.lock, bin/, config/, esbuild and PostCSS config)
is copied from `stosa`, so it builds exactly like the other sites.
**Dev port:** 22000 (`bin/dev`).

It does not join `shared/`. **No Lee bio and no link to Lee's sites**
(Lee, 2026-11-20): club officers don't know Lee.

---

## Development

```bash
bin/dev                     # dev server at localhost:22000 with live reload
bin/bridgetown deploy       # production build to output/ (what Netlify runs)
```

Netlify: base directory `Orcarra`, build command and publish directory from
`netlify.toml`.

---

## What's here

- `src/index.erb` — the one page. Sections in the copy file's order: hero,
  the problem, what Orcarra will do, who it's for, the price (with the
  two-row table), the form. Copy is "Orcarra page copy.md" ("The page:
  orcarra.com"), word for word. No nav, no other pages.
- `src/_partials/_reserve_form.erb` — the "Reserve a spot for your club" form.
- `src/_layouts/default.erb` — wordmark header, `main`, footer.
- `src/_partials/_head.erb` — title, description, canonical, Open Graph,
  favicon, fonts, the Fathom script.
- `src/_data/site_metadata.yml` — title, description, **Fathom site ID**,
  **Kit form ID**.
- `frontend/styles/index.css` — all CSS. Tokens on `:root`. One breakpoint
  at 680px.
- `frontend/javascript/index.js` — Fathom click events and the form submit.
- `src/favicon.svg` — the favicon (an orca mark). No images otherwise.

## The form

Our own HTML, posting straight to one Kit form's subscribe endpoint
(`https://app.kit.com/forms/<id>/subscriptions`, SAI Kit account, form
10221601), because Kit's form builder only does text fields. Field names:

| Field | Name sent to Kit |
|---|---|
| Name | `fields[first_name]` |
| Email | `email_address` |
| Type of club | `fields[orcarra_club_type]` |
| Number of members | `fields[orcarra_members]` |
| Your role | `fields[orcarra_officer_role]` |
| What the club uses today | `fields[orcarra_tool_today]` |
| Talk OK (Yes/No) | `fields[orcarra_talk_ok]` |

A Kit rule tags every signup Orcarra and no-auto-sai, so the page sends no
tags and signups never join the SAI list. The JavaScript posts in the
background and swaps in the thank-you text in place, with no page change,
so the ad-click tags stay on the visit. Without JavaScript it's a plain
post to Kit.

## Fathom

Its own Fathom site; the ID is `fathom_site_id` in
`src/_data/site_metadata.yml`, the only place it appears. Events:

- `orcarra-reserve-click` — any "Reserve a spot for your club" button that
  jumps to the form (`data-fathom-click` on the link).
- `orcarra-signup` — a successful submit.

Fathom reads `utm_content` from the ad links, so visits and signups split
by ad group. The script tag carries `data-canonical="false"`: without it,
Fathom records the canonical URL (no query string) and drops every `utm_`
tag. **Keep it** while the page has a canonical link. Nothing on the page depends on the ad-group values.

## Redirects

`www.orcarra.com` 301s to `orcarra.com`, keeping the path and the query
string, so ad clicks keep their UTM tags (`netlify.toml`). **Any redirect
added later must keep the query string too.**
