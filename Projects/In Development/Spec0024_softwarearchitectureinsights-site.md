# Create the SoftwareArchitectureInsights site — move softwarearchitectureinsights.com from Kit to Bridgetown

* **ID:** Spec0024
* **Status:** Implementing
* **Date Created:** 2026-09-03
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** SoftwareArchitectureInsights (new, site index 7), plus
  repo-root shared infrastructure (`lib/worktree_env.rb`,
  `test/worktree_env_test.rb`, `Procfile`, `CLAUDE.md`,
  `Projects/services.md`, `.worktreeinclude`). **No changes to any existing
  site, and no changes to `shared/` or its builders** — this site does not
  join the shared books/courses collections (see Open Question 12).

> **Status note.** Started 2026-09-03 with no implementation date in mind.
> Later the same day Lee resolved Open Questions 1–16 in one sitting, and —
> on learning that Kit's site serves no `sitemap.xml` at all — said he now
> wants this done sooner rather than later. Question 17 (the scheduled-build
> mechanism) was decided the same evening. **No Open Questions remain.**
> Lee moved the spec to Implementing the same day, directing that — because
> this fundamentally changes how Netlify serves this domain — implementation
> happen directly on `main`, with no worktree and no PR, an explicit
> exception to this repo's usual worktree/PR process for this spec only.

---

## Problem/Requirement

Software Architecture Insights (SAI) is Lee's weekly newsletter. Today Kit.com
does two jobs: it sends the email, and it hosts the website at
**softwarearchitectureinsights.com** (article pages at `/posts/<slug>`). Kit's
website is inflexible — Lee has little control over styling and layout, its
category pages are poor, and it cannot be instrumented with Fathom Analytics
the way every other site in this repo is.

This spec moves **only the website** to an eighth Bridgetown site in this
monorepo, `SoftwareArchitectureInsights/`, deployed on Netlify at
softwarearchitectureinsights.com. **Email stays on Kit.** The email is still
composed by pasting a Markdown body into Kit's editor by hand, Lee alone
triggers any publish, and the Kit segment/broadcast workflow is untouched.

### Hard requirements (Lee, 2026-09-03)

1. **Every URL on the old site keeps working.** After cutover, every URL Kit
   serves today either renders on the new site or redirects to a valid page.
   No dead links in the wild — past emails, LinkedIn posts, and the LinkedIn
   Newsletter all point at these URLs.
2. **Article URLs are byte-identical.** For every published article, the URL,
   and therefore the slug, and therefore the article ID, is the same as it is
   on Kit today: `/posts/<slug>/`.
3. **Branding follows the conductor rebrand.** Logos, wordmark, and favicon
   come from the SAI project's `Marketing/Branding & Logos/` folder (the
   "conductor concept", Sep 2026).
4. **Colors come from the SAI palette.** Every color on the site is a token
   from `Software Architecture Insights Palette.html`, recorded in full in
   Part 3 below.
5. **A `sitemap.xml` that matches the site, and a `robots.txt`, both driven
   by per-page metadata** (Lee, 2026-09-03). The sitemap lists exactly the
   pages the site serves — every indexable page, and nothing that is
   excluded, redirected, or missing — and any page can change how it appears
   in the sitemap and in `robots.txt` through its own front matter. Kit
   serves neither file today (both 404), so this is a gap the migration
   closes rather than something to preserve. Detail in Part 4, *Sitemap and
   robots*.

### Governing documents (binding)

The SAI content workflow was aligned to Bridgetown on 2026-09-03, *ahead of*
this spec, so that publishing to the new site is a file copy with no
conversion step. That alignment is already in use by the `article-process`
skill and the SAI `Content/CLAUDE.md`. **This spec must not contradict it** —
if the site needs something the workflow does not provide, the fix is to
raise it as an Open Question here and change the workflow deliberately, not to
quietly diverge.

| Document (all under `/Professional/` in Dropbox) | What it decides for this spec |
|---|---|
| `_Active Projects/Software Architecture Insights/Reference/Bridgetown Migration — Handoff Prompt.md` | The starting brief for this spec: four decided points (file-copy publishing, ID = slug = URL, back-catalog re-keyed to Kit slugs, flat image directory), the front-matter shape, and the list of things still to analyze. Every "decided" item there is carried into this spec unchanged. |
| `…/Software Architecture Insights/Content/CLAUDE.md` | The SAI front-matter template (Bridgetown-aligned 2026-09-03), `internal_note`, `meta_description` rules (150-char hard cap), the H1-in-body rule, and the Kit-side publishing facts. |
| `…/Software Architecture Insights/Content/Category Taxonomy.md` | The nine reader-facing categories, their exact labels and URL keys, and the shared SAI/AI-ligned namespace decision. |
| `Social Media/UTM Standard.md` | Link tagging. Specifically: article-body links are tagged `sai-email`/`email` because one paste feeds email and web; on-site links outside a body are `sai-web`/`referral`; **internal links within one property are never tagged.** |
| `…/Software Architecture Insights/Content/Standard Bio.md` | The five-link author bio, with `utm_content=bio` and `utm_campaign=<article-id>`. |
| `…/Software Architecture Insights/Marketing/Branding & Logos/README.md` (+ `Favicon/README.md`) | Which brand assets exist and what each is for. |
| `…/Software Architecture Insights/Software Architecture Insights Palette.html` | The color system. Tokens transcribed in Part 3. |

### What this spec deliberately does not do (the Netlify/DNS boundary)

As with Spec0005 and Spec0021, everything at the Netlify and DNS layer is
Lee's to do by hand and out of scope: creating the Netlify site, pointing it at
`SoftwareArchitectureInsights/`, adding the custom domain, the www → apex
redirect, and moving DNS off Kit. Equally out of scope, and Kit-side: removing
the custom domain from Kit's newsletter site, creating the embeddable
subscribe form, and any Fathom site creation. The spec produces a repo
directory that builds locally, passes its own URL-coverage check against the
Kit inventory, and is ready to cut over. Per the repo's standing rule to ask
rather than assume, Open Question 14 asked what already exists on those
sides: as of 2026-09-03, the Fathom site does; the Netlify site and the Kit
inline form do not; the www → apex choice is unconfirmed.

---

## Solution/Fix/Change

Six parts: register the site, scaffold it, define the brand system, define the
content model and layouts, export the back catalog from Kit, and preserve
every old URL. A seventh section states the cutover checklist and the
one-line publish procedure the `article-process` skill will adopt.

### Part 1 — Register site index 7

Indices are permanent and a new site takes the next unused one.
`SoftwareArchitectureInsights` is index **7**, which under the existing scheme
(`8000 + (s-1) * 2000`) gives:

| Index | Site | Live URL | main | `spec####` | `bug####` |
|---|---|---|---|---|---|
| 7 | `SoftwareArchitectureInsights` | softwarearchitectureinsights.com | 20000 | 20000 + N | 21000 + N |

Files to update — the same checklist Spec0021 followed for index 6:

1. `lib/worktree_env.rb` — add `"SoftwareArchitectureInsights" => 7` to
   `SERVICES`. No change to the math.
2. `test/worktree_env_test.rb` — add the site to the `SITES` constant and the
   expected-port hashes, plus block-edge assertions for 20999 / 21999.
3. `Procfile` — add `sai: SoftwareArchitectureInsights/bin/dev`.
4. `CLAUDE.md` (repo root) — add the site to the repo table and the
   port-derivation table; "Seven independent Bridgetown sites" → eight,
   "indices 0–6" → 0–7. Note in the repo table that this site does **not**
   join `shared/`.
5. `Projects/services.md` — add the row for index 7.
6. `.worktreeinclude` — extend the `bundle install` / `npm install` comment
   loop to the new site.

### Part 2 — Create the `SoftwareArchitectureInsights/` scaffold

Copy `LeeAtchison`'s scaffold (Bridgetown 2.1.2, ERB, esbuild + PostCSS,
Puma with the worktree-derived port, Netlify config with deploy previews per
Spec0004) and change what is site-specific:

* `src/_data/site_metadata.yml` — title "Software Architecture Insights",
  tagline "Architecture thinking you can actually use. Every Tuesday
  morning." (the live Kit byline), author, description, and the subscriber
  line currently on the Kit home page ("Join 1,700+ architects & engineering
  leaders" — **a number that goes stale; see Open Question 13**).
* `config/initializers.rb` — production `url` `https://softwarearchitectureinsights.com`,
  preview-aware exactly as the other sites (Spec0004).
* `netlify.toml` — copied; **no `ignore` override** (this site reads nothing
  from `shared/`, so Netlify's default base-directory diff is correct, as
  Spec0021 established for `AtchisonAcademyCourses`). Plus the redirect
  rules from Part 6.
* `_head.erb` — Fathom snippet with this domain's own Fathom site ID (**the
  Fathom site already exists** — Lee confirmed 2026-09-03; he supplies the
  ID at implementation). Favicon `<link>` set per Part 3.
* **Nothing from `shared/`**: no `src/_books` / `src/_courses` symlinks, no
  `shared_content.rb`, no `SITES` entry in the two existing builders. SAI is
  a publication, not a marketing site for the books and courses; where it
  links to them it links out to leeatchison.com or the book sites, tagged
  per the UTM Standard. (Open Question 12 confirms this.)
* Delete the copied pages that do not apply (`books.erb`, `courses.erb`,
  `schedule.erb`, `ainative.erb`) and add the pages in Part 4.

### Part 3 — Brand system

#### Color tokens (transcribed from `Software Architecture Insights Palette.html`, 2026-09-03)

The palette file is a Claude Design bundle; its tokens are packed inside the
file and are not readable as plain HTML, so they are recorded here verbatim.
The palette's own description: *"A warm-paper, long-form reading palette
anchored on your brand blue and cyan — technical, trustworthy, and built to
be read."* Its usage rules are carried into the CSS custom properties below,
which become `:root` tokens in `frontend/styles/index.css`.

| Group | Token | Hex | Palette's stated use |
|---|---|---|---|
| Core | `--paper` | `#F6F3EC` | Page canvas |
| Core | `--ink` | `#1A2330` | Headlines · body |
| Core | `--brand-blue` (Brand Blue 700) | `#1E5FA8` | Links · wordmark |
| Core | `--steel` | `#3F5B7C` | Bylines · labels |
| Core | `--muted-cyan` | `#0C8FA8` | Section markers — inline emphasis, never large fills |
| Neutral | `--stone-600` | `#5A5347` | Warm captions |
| Neutral | `--rule` | `#D9D2C5` | Hairlines |
| Neutral | `--card` | `#FFFDF8` | Article surface |
| Neutral | `--highlight` | `#DCE9F0` | Callout / pull-quote tint |
| Semantic | `--success` | `#2F8F6B` | Positive |
| Semantic | `--warning` | `#B9791E` | Caution |
| Semantic | `--error` | `#BC4A40` | Failure |
| Brand anchor | `--brand-cyan` | `#06B6D4` | Secondary brand anchor (the palette lists it alongside Brand Blue; also its selection highlight) |

Rules the palette states, which the CSS must follow: Paper is the canvas and
pairs with Ink for body text; Brand Blue is for links and the wordmark; Steel
for bylines and labels; Muted Cyan for inline emphasis and section markers
and never for large fills; warm neutrals keep the page feeling like print;
Highlight tints callouts and pull-quotes. There is no dark theme in the
palette, so the site ships light-only (no `prefers-color-scheme` variant).

#### Logos and marks (from `Marketing/Branding & Logos/`)

| Asset | Use on the site |
|---|---|
| `sai-banner-conductor.svg` (editable source; PNG exports at 1200×400 and 2400×800) | Site header / wordmark band. The SVG is preferred for the web; the PNGs are the email header and are not needed here. |
| `sai-square-conductor.svg` (PNG at 600 / 1500) | Default `og:image` fallback for pages without a hero, and the social/profile square. |
| `Conductor Only (transparent, brand blue).png` | Small inline mark (footer, section dividers) on paper-colored surfaces. |
| `Conductor Scene (transparent, brand blue).png` | Optional home-page illustration. |
| `Favicon/` — `favicon.ico`, `favicon-16/32/48/64.png`, `apple-touch-icon.png` (180), `favicon-192x192.png`, `icon-512.png` | Copied as-is to `src/` root. `_head.erb` emits the three `<link>` lines the favicon README specifies (`icon` any → `favicon.ico`; `icon` 32×32 png; `apple-touch-icon`). |

**Typeface (decided 2026-09-03, Open Question 6):** **Lora** for headings
and the wordmark — the face the brand SVGs use — self-hosted as woff2 under
`frontend/fonts/` (no Google Fonts call); body text in a **system serif
stack** (`Charter, Georgia, "Times New Roman", serif`), so there is no body
web font to download. The site's only third-party request is Fathom. (The
palette's own preview is set in IBM Plex; that was the preview's choice, not
a brand rule.)

Raw brand files go in `assets_inbox/` per the repo convention and are copied
into `src/images/brand/` (and `src/` root for the favicon set) at the sizes
the site actually uses.

### Part 4 — Content model and layouts

#### The `articles` collection

A custom collection, not Bridgetown's built-in `posts`:

```yaml
# bridgetown.config.yml
collections:
  articles:
    output: true
    permalink: /posts/:slug/
    sort_by: date
    sort_direction: descending
defaults:
  - scope:
      collection: articles
    values:
      layout: article
```

Why not `_posts`: Bridgetown's built-in posts collection conventionally
derives the date from a `YYYY-MM-DD-` filename prefix, and the whole point
of the SAI workflow is that the article file is `<id>.md` with the date in
front matter. A custom collection sidesteps the question entirely (the
handoff flagged it as unverified; Open Question 1 records the one remaining
check). The URL prefix is still `/posts/` — the collection's *name* is
internal, the *permalink* is what the world sees.

`:slug` resolves to the file's basename, which by the SAI rule equals the
front-matter `slug:` and the article ID. The build **fails** if a file's
`slug:` differs from its basename (builder check), so the invariant cannot
drift.

Files live at `src/_articles/<id>.md`. Publishing an article is copying the
file there unchanged (Part 7). **`layout:` is never written per file** — the
collection default above supplies it, exactly as `Content/CLAUDE.md` promises.

#### Front matter the site reads

All of it is already emitted by the SAI template (Bridgetown-aligned
2026-09-03). Bridgetown ignores the workflow-only keys.

| Key | Site behaviour |
|---|---|
| `title`, `subtitle` | Rendered by the layout as `<h1>` and a subtitle line; `title` in `<title>` and `og:title`. |
| `author` | Byline. |
| `date` | Sort key and the displayed date. Required; the build fails on an article without it. **An article whose `date` is after the build date is dropped from the build** (not rendered, not in listings, feed, or sitemap) — this is what makes copying at Ready safe (Open Question 3; the Tuesday scheduled build is Open Question 17). The comparison is on the date, not the clock time, in the site's timezone (`America/Los_Angeles`) — any build that runs any time on Tuesday already sees that day's article as current. |
| `published_on` | Displayed if present (it will differ from `date` only when a send slipped). Never `published:` — Bridgetown treats that key as a visibility switch. |
| `slug` | Must equal basename (checked). |
| `hero_image` | Bare filename; the layout prepends `/images/posts/`. Emitted as the article `<img>`, as **absolute** `og:image` and `twitter:image`. |
| `meta_description` | `<meta name="description">`, `og:description`, `twitter:description`. Fallback chain when blank: `description` truncated at a word boundary ≤150 chars → site description. Never empty. |
| `description` | Listing-card excerpt and feed summary. |
| `categories` | Exact taxonomy labels; resolved to keys via `src/_data/categories.yml`. Rendered as links to category pages. Build fails on a label not in the data file. |
| `series`, `series_position` | Rendered as a "Part of the series …" line linking to the series page, and the article appears on `/series/<key>/` (decided 2026-09-03, Open Question 15). Series keys come from `src/_data/series.yml` (label → key, one-paragraph blurb); an unknown `series` label fails the build, like categories. `series_position` is free text and is displayed as written; ordering within a series is by `date`. |
| `former_slug` | Generates a `/posts/<former_slug>/* → /posts/<slug>/ 301` redirect (Part 6). |
| `status`, `created`, `drafted`, `internal_note`, `sai_url`, `email_sent`, `linkedin_url`, `retitled`, `target_date` | Ignored by the site. **Builder warning** (not failure) if `status` is anything other than `published` — a draft copied in by mistake should be visible in the build log. |

#### The three body rules

The article body as it leaves the SAI workflow is written for Kit's editor,
so three things about it need a decision here. The handoff asked for each to
be stated explicitly. **All three were decided by Lee on 2026-09-03 (Open
Questions 2–4), as written here.**

1. **The body carries a single H1 (the title) plus an italic subtitle line
   and a `---`.** Decided: the *layout* owns the title block (it needs
   `title`, `subtitle`, byline, date, categories, and the hero in one styled
   unit), and a builder hook at `resource :post_read` strips from the body a
   leading `# <title>` heading, and an immediately following `*<subtitle>*`
   paragraph and `---` rule *only when they match the front matter exactly*.
   Anything that does not match is left alone and shows up in the page. The
   file on disk is never modified.
2. **UTM tags in the body say `utm_source=sai-email&utm_medium=email`**
   because one paste feeds both email and web. Decided: a builder pass over
   the rendered HTML rewrites, on every link to one of Lee's domains, exactly
   those two parameters to `utm_source=sai-web&utm_medium=referral`, leaving
   `utm_campaign` and `utm_content` untouched. **Links to
   softwarearchitectureinsights.com itself are an internal link** under the
   UTM Standard's 2026-08-21 rule and are rewritten to a bare relative path
   with the whole query string removed — so a reader who arrived from the
   email is not re-attributed to the site on their first internal click.
   The pass runs on output HTML, so `&amp;`-escaped ampersands are handled
   and Markdown link syntax is irrelevant.
3. **The standard bio is appended to the body at packet time.** Decided: the
   layout renders the bio itself from `src/_data/bio.yml` (the five links and
   text from `Standard Bio.md`, with `utm_campaign` set from the article's
   slug and the web channel values), and the same `post_read` hook strips
   the body's trailing bio — recognised as the final paragraph beginning
   `*Lee Atchison is a software architect` after a `---`. If the pattern is
   not found, nothing is stripped and the layout still renders its bio, so
   the failure mode is a visible duplicate, never a missing bio.

#### Images

`src/images/posts/<slug>.png` for the hero, `<slug>-alt.png` and any others
beside it — a flat directory keyed by slug, per handoff decision 4. Nothing
under `shared/images/`. A folder-per-article can be adopted later for an
article that accumulates diagrams; not now.

The builder checks that `hero_image` names a file that exists. If it does
not (17 of the 56 live posts have no image in Kit — see Part 5), the layout
renders **no hero** and the `og:image` falls back to the square conductor
mark at 1200×630 (a purpose-made `og-card.png` exported from
`sai-square-conductor.svg`). **Decided 2026-09-03 (Open Question 8): the 17
ship without a hero**; art can be added later one article at a time by
dropping in a PNG.

Hero images are large (the recent ones are 1.5–3 MB PNGs). The build must
not ship them at that size. **Decided 2026-09-03 (Open Question 9): the
publish procedure web-sizes the image at copy time, 1600px wide** (`sips -Z
1600`, the convention the other sites use), so the repo holds the web copy
and the build needs no image tooling. The original stays in the SAI
project folder.

#### Pages

| URL | Page | Notes |
|---|---|---|
| `/` | Home | Header/wordmark, the tagline, subscribe form (Part 4, below), latest articles (paginated or a fixed 9 + "all posts"), category shelf. Replaces Kit's `/profile`. |
| `/posts/` | Archive | All articles, newest first, paginated with `bridgetown-paginate` (already in the Gemfile). Replaces Kit's `/profile/posts`. |
| `/posts/<slug>/` | Article | The `article` layout. |
| `/series/<key>/` | Series pages | One per entry in `src/_data/series.yml`, generated by the same builder mechanism as categories (decided 2026-09-03, Open Question 15). Lists the series' articles oldest-first with the blurb on top, so a reader can read a run in order. |
| `/service-ownership-diagnostic/` | Lead magnet | ~~A real page replacing Kit's hosted landing page of the same path, with the same Kit form (uid `2e2d7fc0c1`) embedded.~~ **Reverted 2026-09-03 (night):** that uid turned out to be a hosted landing page, not an embeddable form (Open Question 14 follow-on), so the embed was dead. Lee had `src/service-ownership-diagnostic.erb` removed; `netlify.toml` now redirects this path straight to Kit's hosted page instead (temporary — see Part 6 and that file's own comment). A real page can come back once a matching embed-type Kit form exists. |
| `/architecting-with-ai/` | Webinar page | ~~A real page replacing Kit's hosted landing page, same Kit form (uid `4cad4660e5`) embedded.~~ **Reverted 2026-09-03 (night), same reason and same fix** as the diagnostic page above: `src/architecting-with-ai.erb` removed, `netlify.toml` redirects here temporarily instead. The "kept regardless of the webinar date" framing (Lee: it's the gate for slides and recording) still applies to Kit's own hosted page, which is what's actually serving this path now. |
| `/categories/<key>/` | Category pages | One per taxonomy key (`ai-native`, `ai-strategy`, `security-risk`, `availability`, `scalability`, `cloud`, `architect-role`, `books-courses`, `ai-ethics`), generated by a builder from `_data/categories.yml` so a new category is a data change. Lists that category's articles with the taxonomy's one-paragraph description at the top. This is the feature Kit did badly. |
| `/about/` | About | Content from the current Kit `/profile/about` page (Lee's bio, books, courses, publications), rewritten in the house style. Replaces `/profile/about`. |
| `/links/` | Links | The current `/profile/links` list (The Software Conductor, Architecting for Scale, leeatchison.com, LinkedIn, Atchison Academy, Coursera, LinkedIn Learning), each tagged `sai-web`/`referral`/`evergreen`/`cta` where the destination is Lee's domain and untagged where it is not — exactly what the live page does today. |
| `/subscribe/` | Subscribe | A page whose only job is the Kit form. Replaces Kit's hosted `/subscribe` landing page (form "SAI", uid `f0fbebfd67`). |
| `/feed.xml` | Atom feed | Generated; 20 most recent, full `description` as summary. Kit exposes no feed URL that could be found (`/rss` is 404); Open Question 10 asks whether a Kit feed exists to redirect. |
| `/sitemap.xml`, `/robots.txt` | Metadata-driven | See *Sitemap and robots* below. `permalink:` set on both (the BB30 sitemap bug in `_Projects.md` is the cautionary tale). |
| `/404.html` | Not found | Branded. |

#### Sitemap and robots (requirement 5)

Both files are ERB resources built from the site's own resource list, so they
cannot drift from what is actually served, and both read per-page front
matter, so any page — an article, a category page, a static page — can
change its own treatment without touching the templates. The starting
point is `LeeAtchison`'s `sitemap.xml.erb` / `robots.txt.erb` (which already
honour `sitemap_exclude` and `published: false`), extended as follows.

Front-matter keys every page may carry:

| Key | Effect on `sitemap.xml` | Effect on `robots.txt` / page |
|---|---|---|
| `sitemap_exclude: true` | Page omitted. (Existing repo convention; the sitemap and robots resources set it on themselves.) | None. |
| `noindex: true` | Page omitted. | `_head.erb` emits `<meta name="robots" content="noindex">`; `robots.txt` gains a `Disallow: <path>` line for it. Use for thin or utility pages (subscribe confirmation, 404, the unlinked-but-live). |
| `sitemap_priority: 0.0–1.0` | Emitted as `<priority>`. Defaults per kind: home 1.0, articles 0.8, category pages 0.6, other pages 0.5. | — |
| `sitemap_changefreq: <value>` | Emitted as `<changefreq>`. Defaults: home and archive `weekly`, articles `monthly`, others `yearly`. | — |
| `updated: YYYY-MM-DD` | `<lastmod>`; falls back to `published_on`, then `date`, then omitted. An article that is corrected after publishing gets an honest `lastmod` by adding this one key. | — |
| `robots_disallow: true` | (implies omitted) | `Disallow: <path>` only — for a page that should stay out of crawlers' fetch queue but need not carry a `noindex` meta. Rarely needed; exists so the file can express both halves independently. |

None of these keys is required on an article; the SAI template does not emit
them and Bridgetown ignores them when absent. They are opt-in overrides.

What the sitemap contains, exactly: every resource whose URL ends in `/`
(i.e. a real page; `404.html`, `500.html`, and file resources such as
`/feed.xml` and `/_redirects` are not pages), minus anything carrying
`sitemap_exclude`, `noindex`, or `published: false`, minus any article the
builder dropped. Category pages generated by the builder are ordinary
resources and appear. Redirect sources never appear because they are not
resources. Generated in a stable order (by URL) so diffs between deploys are
readable.

`robots.txt` always emits `User-agent: *`, `Allow: /`, one `Disallow:` per
page that asked for it, and `Sitemap: <site url>/sitemap.xml` — the URL is
preview-aware exactly as the canonical tag is (Spec0004), so a deploy
preview's robots file points at the preview's own sitemap.

**"Matches" is enforced, not hoped for.** `script/check_urls.rb` (Part 6)
gains a second job: parse the built `sitemap.xml` and assert (a) every
`<loc>` corresponds to an `index.html` in `output/`, and (b) every
`index.html` in `output/` whose page is indexable — no `sitemap_exclude`,
no `noindex` — appears in the sitemap. Either direction failing fails the
check. The builder additionally fails the build if a `sitemap_priority`
is outside 0–1 or a `sitemap_changefreq` is not one of the seven values the
sitemaps protocol allows.

#### Subscribe form

Kit remains the list. The site embeds a Kit **inline form** (Kit's `embed_js`
snippet, served from `softwarearchitectureinsights.kit.com/<uid>/index.js`)
on the home page, the subscribe page, and at the foot of every article. The
account's current inline forms are all archived except "Creator Network";
**a new (or un-archived) inline form is Kit-side work for Lee**, and its uid
is a value in `site_metadata.yml`, not hard-coded in templates (Open
Question 14). The form's post-confirmation redirect should point at the new
site's home with the `sai-lifecycle` tags the UTM Standard specifies.

The Kit landing page's "Newsletter feed" widget — the thing that shows the
mid-word "…" excerpts `Content/CLAUDE.md` complains about — is replaced by
the site's own listing, which uses `description`, so that problem goes away
with the migration.

### Part 5 — Back-catalog export from Kit

Verified against the live Kit account on 2026-09-03 via the Kit API
(`list_posts`, two pages, 176 records total):

| Status | Count | Notes |
|---|---|---|
| `published` | **56** | Live on the site today, 2023-12-05 → 2026-09-01. These are the pages that must survive. |
| `scheduled` | 4 | Sept 8, 15, 22, 29 2026. Will be `published` by any realistic cutover date — the live count grows by one a week, so the export is re-run at cutover, not once now. |
| `draft` + `unpublished` | **116** | 2021–2023 "MDB Weekly" / "Modern Digital Business" era sends and test messages. Almost all carry a `public_url` under `/posts/`. (The handoff counted 100 records because Kit's API paginates at 100; the second page holds 76 more, all non-live.) |

**The 116 non-live records do not resolve.** Two were spot-checked on
2026-09-03 (`/posts/mdb-weekly-making-microservices-just-the-right-size`,
`/posts/does-using-low-code-mean-your-application-will-become-overly-complex-1`)
and both return 404 on the live site. They need no redirects. The cutover
checklist still sweeps every `public_url` in the inventory with a HEAD
request and redirects only what actually answers 200, so this conclusion is
re-verified rather than trusted.

Other facts about the 56 that shape the export:

* **Hero images:** 39 have a `thumbnail_url` (37 on `embed.filekitcdn.com`,
  2 on an S3 bucket); **17 have none.** The 17 all fall between January 2024
  and October 2025; every post since November 2025 has one.
* **`meta_description`:** set on only a handful (Lee decided 2026-08-20 not
  to back-fill it in Kit). The export must supply one per article or 50+
  pages ship with an empty description — see the fallback chain in Part 4
  and Open Question 7.
* **Slugs** run up to 93 characters and include Kit's apostrophe-splitting
  (`don-t-`, `isn-t-`). They are kept exactly. Do not tidy them.
* **Duplicate-title slugs** exist (`…-1` suffixes on three re-sent
  articles). Each is its own live URL and is kept as its own article.
* **Categories are not in the API.** Kit exposes no category field on any
  endpoint. 32 of the 56 were back-filled to the new taxonomy in Kit on
  2026-08-20 (the back-fill is paused there at Lee's request); the other 24
  still carry the retired publication categories. The export reads each
  live page's category tags from the HTML (they are rendered in the page
  header) and, for the 24, assigns taxonomy categories by hand in the
  exported front matter. Open Question 5.
* **Body HTML** from `get_post` is Kit email HTML: table-wrapped, with
  `class="ck-link"` anchors, `<strong style="font-weight:bolder">`, an
  embedded house-ad snippet block (a `ck-layout-block` table with a cover
  image and an `email-button`), a `<hr>`, and the appended bio. All of that
  is Kit chrome to strip before converting.

#### Two sources, one rule

There are two sources for an article's Markdown, and the export prefers the
better one:

1. **The SAI project archive** (`Content/zCompleted Articles/<date>-<id>.md`)
   — the clean Markdown Lee actually wrote. It exists for roughly the nine
   most recent articles (mid-2026 onward). Use it when it exists.
2. **Kit's HTML** via `get_post`, converted to Markdown (pandoc, `gfm`
   output), for everything older.

Either way, the result is written as `<kit-slug>.md` in the SAI front-matter
shape, with `slug:` = the Kit slug. **The back catalog is re-keyed to Kit's
slugs** (handoff decision 3): where the working ID differs from the Kit slug
— it does for at least two of the nine archived articles,
`it-passed-the-test` → `it-passed-the-test-that-doesn-t-mean-it-works` and
`from-cloud-native-to-ai-native` → `bolting-ai-onto-your-app-is-the-new-lift-and-shift`
— the exported file, its images, and its `slug:` all take the Kit slug. This
is the one sanctioned exception to "article IDs never change." Renaming the
files in the SAI project archive and updating its `Content Management.md`
to match is **SAI-project work, coordinated with this spec but done there**,
not in this repo.

#### The export script

A one-off Ruby script at `SoftwareArchitectureInsights/script/export_kit.rb`
(committed — it documents how the catalog was produced and is re-run at
cutover). Inputs: the Kit API (v4, read-only, an API key Lee supplies via
environment variable, never committed) and the SAI archive folder. Outputs:
`src/_articles/*.md` and `src/images/posts/*.png`. Steps per published post:

1. Fetch the post; skip unless `status == "published"`.
2. Choose the source (archive Markdown if a file with matching `sai_url` or
   slug exists, else Kit HTML).
3. For Kit HTML: unwrap the outer table; remove `<style>`, the house-ad
   `ck-layout-block` table(s), the trailing bio paragraph, and the
   `{{ ck.ad_slot }}` placeholders; drop `class`/`style`/`target`/`rel`
   attributes; convert `<hr>`-separated body to Markdown with pandoc; strip
   the H1 if the conversion produced one.
4. Write front matter: `title`, `subtitle` (from the first italic line if
   the article has one, else blank), `author: "Lee Atchison"`,
   `status: published`, `created`/`date`/`published_on` from Kit's
   `published_at`, `sai_url` = `public_url`, `email_sent` = `published_at`,
   `hero_image: <slug>.png` (only if a thumbnail exists),
   `meta_description` (Kit's if set, else generated — Open Question 7),
   `slug`, `description` (Kit's `description` if set, else the first two
   sentences), `categories` (Part 5 above), and `former_slug` where the
   archive file's old ID differs from the Kit slug. Block-form YAML lists,
   one blank line each side of the closing `---`, per the SAI iPad rule.
5. Download `thumbnail_url` (stripping Kit's `?w=800&fit=max` resize
   parameters to get the original), convert to PNG if it is not one, save
   as `<slug>.png`.
6. Print a per-article report line, and at the end a summary: count
   exported, count missing hero, count with generated `meta_description`,
   count needing manual categories.

The script is idempotent and safe to re-run; it overwrites its own outputs
and touches nothing else.

### Part 6 — Every old URL keeps working

The complete inventory of URLs Kit serves on this domain today (verified
2026-09-03 by fetching the live site and listing the account's pages and
forms), and what each becomes:

| Old URL | Kind | New behaviour |
|---|---|---|
| `/posts/<slug>` (56, growing weekly) | Article | **Served.** Same path. Kit uses no trailing slash; Bridgetown's pretty URL is `/posts/<slug>/`, and Netlify's `pretty_urls` 301s the slashless form to it. |
| `/` | Home | Served by the new home page. |
| `/profile` | Kit creator profile | `301 → /` |
| `/profile/posts` | Kit archive | `301 → /posts/` |
| `/profile/about` | About | `301 → /about/` |
| `/profile/links` | Links | `301 → /links/` |
| `/profile/recommendations` | Kit Creator Network recommendations | Kit-specific with no equivalent. `301 → /` (decided 2026-09-03). |
| `/subscribe` (also `www.…/subscribe`) | Kit hosted landing page "SAI" | Served by the new `/subscribe/` page. |
| `/architecting-with-ai` | Kit hosted landing page (webinar registration, form uid `4cad4660e5`, named UTM campaign `architecting-systems-with-ai-webinar`) | ~~Served by a real page at the same path.~~ **302 redirect to Kit's own hosted page (temporary, 2026-09-03 night)** — the real Bridgetown page's embed turned out to be dead (Open Question 14 follow-on); see Part 4. |
| `/service-ownership-diagnostic` | Kit hosted landing page (lead magnet, form uid `2e2d7fc0c1`) | ~~Served by a real page at the same path.~~ **302 redirect to Kit's own hosted page (temporary, 2026-09-03 night)**, same reason as the webinar page above. |
| `/posts/<slug>` for the 116 non-live records | 404 today | Verified 404 on Kit; nothing to preserve. Re-swept at cutover. |
| Kit category filters | Client-side, no URLs | Nothing to redirect. New category pages are additive. |
| Kit's RSS/Atom feed | Not found (`/rss` → 404) | Nothing to preserve (decided 2026-09-03). The site ships `/feed.xml`. |

Mechanics:

* Static rules live in `netlify.toml` `[[redirects]]`, 301 and `force = true`,
  with a comment per rule saying what it replaced — the convention Spec0006
  set for `/academy`.
* **`former_slug` redirects are generated**, not hand-written: an ERB
  resource `src/_redirects.erb` (permalink `/_redirects`) iterates the
  articles collection and emits `/posts/<former_slug>/* /posts/<slug>/ 301!`
  for each one that has the key. Netlify reads `_redirects` from the publish
  directory alongside `netlify.toml`. This is what makes a retitle "free",
  as the handoff put it.
* **A URL-coverage check is part of the build**, not a one-time cutover
  task: `script/check_urls.rb` takes the Kit inventory (a JSON snapshot
  from the export script), and for every `public_url` that answered 200 on
  Kit, asserts the same path exists in `output/` or matches a redirect
  rule. It runs against the local build and against the Netlify deploy
  preview before cutover. Any miss is a hard failure.

### Part 7 — Cutover checklist and the publish procedure

#### Cutover (in order)

1. Lee confirms every Open Question is resolved and the spec moves to
   Implementing (on his say-so, per process).
2. Build the site; run the export against the live Kit account; run
   `check_urls.rb` locally — zero misses.
3. Lee creates the Netlify site pointed at `SoftwareArchitectureInsights/`
   (base directory, `bin/bridgetown deploy`, `output`), gets a
   `*.netlify.app` URL, creates a build hook and sets it as the
   `BUILD_HOOK_URL` environment variable so `netlify/functions/weekly-publish.mts`
   can fire it every Tuesday (Open Question 17), and creates the Kit inline
   form. The Fathom site already exists.
4. Run `check_urls.rb` against the Netlify URL. Spot-check `og:image`,
   `og:description`, and canonical on five articles with a link-card
   debugger; confirm the `content-social` skill's `og:image` read works
   against the preview.
5. Freeze: the Tuesday send happens on Kit as usual and the scheduled
   build publishes that week's article; re-run the export the same day so
   the catalog and the live site agree; deploy.
6. Lee moves DNS (apex + www) to Netlify and removes the custom domain from
   Kit's site settings. Kit's site continues to exist at
   `softwarearchitectureinsights.kit.com`, which keeps every hosted landing
   page and form reachable at its Kit URL.
7. Verify live: `check_urls.rb` against the production domain; a real
   subscribe through the embedded form lands in the SAI segment; Fathom
   receives a pageview.
8. Update the SAI project: `Content/CLAUDE.md` Publishing table (Platform
   row), the `article-process` skill's Stage 8 (the publish procedure
   below), and `UTM Standard.md`'s "Links You Cannot Tag" list (the two Kit
   entries come off it, because the new listing pages *can* tag — though
   internal links are not tagged anyway).

#### The publish procedure the `article-process` skill adopts

> **Publish to the site (at 🚀 Ready):** copy `<id>.md` into
> `SoftwareArchitectureInsights/src/_articles/`, and `<id>.png` (plus any
> `<id>-alt.png`) web-sized to 1600px wide (`sips -Z 1600`) into
> `SoftwareArchitectureInsights/src/images/posts/`; commit on `main`; push.
> The article stays hidden until its `date`; the Tuesday scheduled build
> (around 6 am Pacific, an hour or more ahead of the 7 am Kit send — Lee's
> preference, see Open Question 17) makes it live before the send.

Decided 2026-09-03 (Open Question 3): Lee chose copying **at Ready** with
automatic Tuesday publication over copying after the send. Three things the
skill must state:

* **The `date` is the switch.** The builder hides any article dated after
  the build day, so an early copy is safe; and because `date` is set when
  the article reaches Ready, a slipped send means moving `date` (and
  `published_on` when it ships), which is already the workflow's rule.
* **The scheduled build is what makes it appear on time.** Without it, the
  article would appear on the next push after Tuesday. It is a Netlify
  Scheduled Function (`netlify/functions/weekly-publish.mts`) firing a
  build hook Lee configures (Open Question 17).
* **Lee alone publishes.** As with Kit, Claude prepares; Lee copies, commits,
  and pushes (or explicitly tells Claude to). The repo-wide rule that
  nothing is committed or pushed without permission applies unchanged.

---

## Testing

* **Build:** `bin/bridgetown build` in `SoftwareArchitectureInsights/`
  succeeds; the builder's four checks fire on purpose-built fixtures (slug ≠
  basename → fail; unknown category label → fail; missing `date` → fail;
  `status` not `published` → warning), then the fixtures are removed.
* **URL coverage:** `script/check_urls.rb` reports zero misses against the
  Kit inventory, locally and on the Netlify preview.
* **Body rules:** on a known article (e.g. `it-passed-the-test-that-doesn-t-mean-it-works`),
  the rendered page has exactly one `<h1>`, no duplicated subtitle, one bio
  block, every link to a Lee domain carrying `utm_source=sai-web&utm_medium=referral`
  with `utm_campaign` unchanged, and every link to the site itself relative
  and untagged.
* **Metadata:** `<meta name="description">`, `og:description`, `og:image`
  (absolute), `og:type article`, `twitter:card`, and canonical are present
  and correct on an article with a hero, an article without one, a category
  page, and the home page.
* **Redirects:** each `netlify.toml` rule and one generated `former_slug`
  rule return 301 to the right place on the Netlify preview.
* **Ports:** `make test` passes with index 7 added; `bin/site-port --all`
  shows 20000.
* **Visual:** every color in the compiled CSS is one of the Part 3 tokens
  (grep the built stylesheet for `#` values and diff against the token list).
* **Feed:** `/feed.xml` validates.
* **Sitemap and robots:** `check_urls.rb`'s sitemap pass reports zero
  misses in both directions on the local build and the Netlify preview.
  Fixture pages exercise each key — `sitemap_exclude`, `noindex`,
  `sitemap_priority`, `sitemap_changefreq`, `updated`, `robots_disallow` —
  and the built `sitemap.xml` and `robots.txt` show exactly the expected
  effect for each before the fixtures are removed. An out-of-range priority
  and a bogus changefreq each fail the build. `sitemap.xml` validates
  against the sitemaps.org schema.

---

## Summary of Steps Needed

1. Lee moves the spec to Implementing (all Open Questions are resolved).
2. Register index 7 across the six repo-root files.
3. Scaffold the site from `LeeAtchison`; strip what does not apply.
4. Bring in brand assets and the palette tokens; pick the typeface.
5. Build the `articles` collection, the `article` layout, the builder
   (checks, future-date filter, H1/bio strip, UTM rewrite, category and
   series pages), listing pages, about/links/subscribe, the diagnostic and
   webinar pages with their Kit forms, feed, sitemap/robots, 404. (The
   Tuesday trigger is `netlify/functions/weekly-publish.mts` firing a
   build hook Lee configures in Netlify — see Open Question 17.)
6. Write and run `script/export_kit.rb`; draft categories for the 24 and
   `meta_description` for the ~50 for Lee's approval; the 17 without a hero
   ship without one.
7. Write `netlify.toml` redirects and `_redirects.erb`; write and run
   `script/check_urls.rb`.
8. Netlify preview; verify; cut over per Part 7; update the SAI project
   docs and the `article-process` skill.

---

## Open Questions

Numbered so they can be referred to. **Questions 1–16 were resolved by Lee on
2026-09-03** in a walk-through of the whole list; each is recorded below with
its decision and the section it changed. Question 17 is new and open.

1. **Custom `articles` collection vs Bridgetown's `posts`.** ~~Open.~~
   **Decided 2026-09-03: custom collection**, `permalink: /posts/:slug/`.
   One implementation-time check remains — that `:slug` honours the
   front-matter `slug:` key in Bridgetown 2.1.2 — but the builder's
   slug-equals-basename rule makes the outcome the same either way.
2. **Who renders the title.** **Decided 2026-09-03: the layout.** The
   builder strips a matching leading H1 / italic subtitle / `---` from the
   body at read time; the file on disk is never changed. This also settles
   the "decided then, not now" note in the SAI `Content/CLAUDE.md`, which
   should be updated at cutover (Part 7, step 8).
3. **When is an article copied to the site.** **Decided 2026-09-03: at
   Ready, with automatic publication on Tuesday morning** — Lee chose the
   automated option over copy-after-send. Consequences, now in Part 4 and
   Part 7: the builder drops any article whose `date` is after the build
   date; a scheduled build fires every Tuesday morning, ahead of the 7 am
   Kit send (Lee's preference — see Open Question 17), so the article is
   already live before the send; the publish procedure becomes "copy at
   Ready". The *mechanism* for the scheduled build is Open
   Question 17.
4. **Bio.** **Decided 2026-09-03: layout-rendered** from `_data/bio.yml`;
   the body's pasted copy is stripped when recognised.
5. **Categories for the back catalog.** **Decided 2026-09-03: assign in the
   export only.** Scrape the 32 already back-filled from their live pages;
   Claude drafts categories for the other 24, Lee approves, they go into
   the exported front matter. Kit is not touched.
6. **Typeface.** **Decided 2026-09-03: Lora for headings and the wordmark,
   system serif (Charter / Georgia stack) for body text, no web-font
   downloads.** Lora is self-hosted as woff2 under `frontend/fonts/` for
   headings only. The site's only third-party request is Fathom.
7. **`meta_description` for the ~50 articles without one.** **Decided
   2026-09-03: generate one per article.** Claude drafts all of them in one
   batch (≤150 characters, written for a stranger, per `Content/CLAUDE.md`);
   Lee skims and approves; the export writes them into front matter.
8. **Hero images for the 17 posts without one.** **Decided 2026-09-03: no
   hero; the square conductor mark is the `og:image` fallback.** Art can be
   added later one article at a time.
9. **Image sizing.** **Decided 2026-09-03: at copy time, 1600px wide**
   (`sips -Z 1600`, the repo's existing convention). No build-time image
   tooling. The publish procedure in Part 7 states it.
10. **RSS/Atom.** **Decided 2026-09-03: nothing to preserve; ship
    `/feed.xml`** with a `<link rel="alternate">` in the head.
11. **The three Kit-hosted pages on this domain.** **Decided 2026-09-03:**
    `/service-ownership-diagnostic` → a real page with the Kit form
    embedded; `/architecting-with-ai` → **a real page too, regardless of
    the webinar date** — Lee: it is the gate through which people get the
    slides and recording afterwards, so it is a standing page, not a
    time-boxed one; `/profile/recommendations` → 301 to `/`. Part 6 table
    updated.
12. **Both publications or SAI alone.** **Decided 2026-09-03: host all 56
    as SAI articles.** Nothing on the site names AI/ligned. Confirmed in
    the same answer: the site does **not** join `shared/`.
13. **Subscriber count on the home page.** **Decided 2026-09-03: keep it,
    hand-maintained** as a value in `site_metadata.yml`. Lee bumps it when
    it moves.
14. **What already exists outside the repo.** **Answered 2026-09-03: a
    Fathom site for this domain already exists.** The Netlify site and the
    Kit inline subscribe form ("Basic Form", uid `c448363077`) were both
    created by Lee later the same night — `site.metadata.fathom_site_id`
    and `kit_inline_form_uid` are both set. Still open: the www → apex
    decision (Lee did not select it; treat as *not yet decided* and
    confirm at cutover rather than assume).

    **Follow-on found while wiring this in, since resolved:** the
    diagnostic and webinar pages' uids (`2e2d7fc0c1`/`4cad4660e5`) turned
    out to be Kit *hosted landing pages* (`type: "hosted"`,
    `embed_js: null`), not embeddable forms — confirmed via Kit's API.
    Unlike the inline subscribe form, a hosted page's form is baked into
    that page's own design and has no standalone script-tag embed.
    `subscribe.erb` was switched to embed `kit_inline_form_uid` instead,
    which works. For the diagnostic and webinar pages, Lee chose removal
    over a fix: `src/service-ownership-diagnostic.erb` and
    `src/architecting-with-ai.erb` are deleted, and `netlify.toml`
    redirects both paths straight to Kit's hosted pages (temporary — see
    Part 4 and Part 6). Rebuilding these as real Bridgetown pages again
    needs matching embed-type Kit forms first (reproducing the job title/
    company/tag-dropdown fields the webinar page collects).
15. **Series pages.** **Decided 2026-09-03: include them now.** Part 4
    gains `/series/<key>/` pages generated from `series` front matter.
16. **Sitemap/robots key set.** **Decided 2026-09-03: the six keys and the
    per-kind defaults stand; back-port to the other seven sites in a
    follow-on**, parked in `_Projects.md` at implementation.
17. **Mechanism and timing for the Tuesday scheduled build** (raised by the
    answer to Q3). ~~Decided 2026-09-03: Netlify's own scheduled-build
    feature, for Tuesdays at 7:05 am Pacific (just after the 7 am Kit
    send).~~ **Superseded 2026-09-03 (night), twice the same night:**
    first the *mechanism* — a Netlify build hook plus a Netlify Scheduled
    Function, at Lee's direction, since Netlify's native scheduled-builds UI
    feature (this spec's original choice) is no longer how Netlify
    recommends doing this — then the *timing*, when Lee said he'd rather the
    article go live before the Kit send (a few minutes to an hour before)
    than after it, reversing the original "just after" design.
    The repo carries `SoftwareArchitectureInsights/netlify/functions/weekly-publish.mts`,
    a Scheduled Function (cron `0 13 * * 2`, UTC) that `fetch`es a Netlify
    build hook URL read from the `BUILD_HOOK_URL` environment variable.
    Creating the build hook and setting that env var are Lee's side of the
    Netlify boundary, same as before. `13:00 UTC` is 6:00 am PDT (spring
    through fall — one hour before the 7 am send) and 5:00 am PST (winter —
    two hours before); the cron is UTC and fixed, so it cannot track
    Pacific's DST switch on its own, and this is deliberately biased toward
    *more* lead time in winter rather than any risk of drifting past the
    send into "after," which is the one outcome ruled out. The future-date
    filter in `plugins/builders/sai_content.rb` compares dates, not clock
    times, so this is a pure lead-time tuning question, not a correctness
    one — any build that runs after midnight Pacific on the article's
    Tuesday already shows it, however early in the morning. See the
    function file's header comment for the full reasoning and the
    Netlify-side setup steps. (Alternatives considered at the original
    2026-09-03 decision and not taken then: a GitHub Actions cron hitting a
    build hook, a Netlify Scheduled Function — the option superseding this
    entry ended up choosing — and a Claude scheduled task.)

---

## History of Updates

* **2026-09-03** — Spec created at Lee's request, in refinement, with no
  implementation date: "we are in no hurry to make this change." Inputs:
  the Bridgetown Migration Handoff Prompt (written the same day by the SAI
  project session), `Content/CLAUDE.md`, `Category Taxonomy.md`,
  `UTM Standard.md`, `Standard Bio.md`, the Branding & Logos README and
  favicon README, and the Palette file (unpacked from its Claude Design
  bundle; all thirteen tokens transcribed into Part 3). Kit inventory
  re-verified live: 176 post records, 56 published, 4 scheduled, 116 not
  live; two non-live URLs confirmed 404; the five `/profile*` pages, the
  `/subscribe` landing page, and the two hosted landing pages
  (`/architecting-with-ai`, `/service-ownership-diagnostic`) catalogued;
  `/rss` confirmed 404. Lee's four hard requirements recorded. Fifteen Open
  Questions raised with recommendations; nothing decided beyond what the
  handoff already marks as Lee's decisions (file-copy publishing, ID = slug
  = URL, re-key the back catalog to Kit slugs, flat image directory).
* **2026-09-03 (later)** — Lee added requirement 5: a `sitemap.xml` that
  matches the site, and a `sitemap.xml` and `robots.txt` that per-page
  metadata can influence. Verified Kit serves neither file today (both
  404). Added the *Sitemap and robots* section to Part 4 (six opt-in
  front-matter keys, per-kind defaults, exact inclusion rule, preview-aware
  `Sitemap:` line), extended `check_urls.rb` to enforce sitemap ⇄ output in
  both directions, added the Testing bullet, and raised Open Question 16 on
  the key set and a possible back-port to the other sites.
* **2026-09-03 (evening)** — Lee walked through and resolved Open Questions
  1–16 in one sitting; each decision is recorded in place under Open
  Questions and applied to the Solution: layout renders title and bio; copy
  at Ready with a future-date filter and a Tuesday 7:05 am scheduled build
  (new Open Question 17 for the mechanism); Lora headings + system serif
  body; generated `meta_description` for the back catalog; no hero for the
  17 without one; 1600px web copies at copy time; categories assigned in
  the export only; ship `/feed.xml` with nothing to redirect; the
  diagnostic **and** the webinar page rebuilt as real pages (the webinar
  page is a permanent gate for slides and recording), recommendations →
  home; all 56 articles hosted as SAI, no `shared/` join; subscriber count
  kept and hand-maintained; Fathom site already exists (Netlify site, Kit
  inline form, www decision still to do); series pages added to scope;
  sitemap key set confirmed with the back-port as a follow-on. Lee also
  noted, on learning Kit serves no sitemap, that he wants the migration
  sooner rather than later; the status note at the top reflects that.
* **2026-09-03 (evening, later)** — Open Question 17 decided: the Tuesday
  scheduled build uses Netlify's own scheduled-build feature, configured by
  Lee. No Open Questions remain.
* **2026-09-03 (night)** — Lee moved the spec to Implementing, directing
  that this spec be built directly on `main` with no worktree and no PR
  (an explicit, one-time exception to the repo's usual process, made because
  this is the first change to how Netlify serves a domain in this repo and
  is easier to land without a worktree in the way). Part 1 (registering
  site index 7 across `lib/worktree_env.rb`, `test/worktree_env_test.rb`,
  `Procfile`, root `CLAUDE.md`, `Projects/services.md`, `.worktreeinclude`)
  implemented and `make test` passing.
* **2026-09-03 (night, later)** — Parts 2–4 and 6 implemented and verified
  with a real local build (`bundle install` + `npm install` succeed;
  `bin/bridgetown deploy` and `script/check_urls.rb` both pass clean).
  Scaffolded `SoftwareArchitectureInsights/` from `LeeAtchison`; brought in
  the real conductor-concept brand assets from the SAI project's Dropbox
  folder (both SVG marks, the full favicon set rasterized from the square
  mark via cairosvg since the pre-made favicon PNGs could not be downloaded
  this session — binary downloads from `dropboxusercontent.com` are blocked
  by this session's egress policy, text/SVG fetches through the Dropbox MCP
  tool were not; a generated `og-card.png`; self-hosted Lora 400/700 woff2
  subsets from Google Fonts) and all 13 palette tokens into
  `frontend/styles/index.css`. Built the `articles`/`categories`/`series`
  collections, the `article`/`category`/`series` layouts, and
  `plugins/builders/sai_content.rb` — slug/date/category/series validation,
  the title-block and bio strip (verified against a real Kit-published
  article's actual body shape, fetched from the SAI Dropbox archive), the
  future-date filter, category/series page generation, and a sitewide
  output-HTML UTM rewrite pass (verified end to end: an in-body link to
  another Lee domain correctly becomes `sai-web`/`referral`, and a link to
  softwarearchitectureinsights.com itself correctly becomes a bare relative
  path with its whole query string dropped). All four Testing-section build
  fixtures (bad slug, unknown category, missing date, non-published status)
  confirmed to fail/warn the build as specified, then removed. Wrote every
  page in Part 4's table with real Kit-sourced copy where one existed (the
  webinar, diagnostic, and subscribe pages' copy came from Kit's own landing
  page API via the Kit MCP connection, not invented); sitemap.xml/robots.txt
  implement the full six-key set including the sitemap⇄pagination interplay
  bridgetown-paginate's own resource-replacement behavior created (page 1 of
  `/posts/` is a `GeneratedPage`, not a `Resource`, after pagination runs —
  handled explicitly rather than silently dropped from the sitemap). Wrote
  `netlify.toml`'s Part 6 redirects, `_redirects.erb` for `former_slug`, and
  `script/check_urls.rb` (sitemap⇄output coverage, tested; Kit-inventory
  coverage, written but only usable once Part 5 produces an inventory).
  Wrote `script/export_kit.rb` per Part 5's design (category scraping from
  live pages, archive-Markdown-over-Kit-HTML preference, pandoc conversion)
  but did **not** run it against the real 56-article back catalog — this
  session's sandbox cannot reach `api.kit.com` (egress-blocked) to exercise
  the standalone script, and populating real front matter for the 24
  uncategorized/~50-missing-`meta_description` articles is Lee's approval
  step by the spec's own design, not something to do unattended. Still
  open before cutover: Fathom site ID, the Kit inline subscribe form uid,
  and the www→apex decision (all Lee's side of the Netlify/DNS boundary,
  Part 7); the back-catalog export itself; and the Testing section's
  remaining checks (metadata-on-populated-articles, redirect-return-codes
  against a live preview, `/feed.xml` validation) that need real content or
  a live deploy to check meaningfully.
* **2026-09-03 (night, later still)** — Fathom site ID set to `QZJQFDMY`,
  the same property every other site in this repo uses (confirmed by Lee;
  he began Netlify site creation the same session). Separately, Lee asked
  to switch the Tuesday scheduled-build mechanism from Netlify's native
  scheduled-builds UI feature to a build hook fired by a Netlify Scheduled
  Function, since that is now Netlify's recommended pattern — **Open
  Question 17 superseded** (see that entry for the full reasoning). Added
  `netlify/functions/weekly-publish.mts` (cron `5 15 * * 2` UTC, reads
  `BUILD_HOOK_URL`), `[functions]` in `netlify.toml`, `.netlify` to
  `.gitignore`, and `@netlify/functions` as a devDependency; bundle-checked
  the function with esbuild and re-verified the Bridgetown build is
  unaffected. Creating the build hook and setting `BUILD_HOOK_URL` in
  Netlify are Lee's side, same boundary as before.
* **2026-09-03 (night, later still)** — Lee finished the Netlify-side setup
  from the previous entry (site created, build hook created, `BUILD_HOOK_URL`
  set), then asked for the opposite of this spec's original timing: the
  article should go live a few minutes to an hour **before** the 7 am Kit
  send, not just after it. Changed `weekly-publish.mts`'s cron from
  `5 15 * * 2` to `0 13 * * 2` (6:00 am PDT / 5:00 am PST — before the send
  in both DST states, deliberately erring toward more lead time in winter
  rather than any risk of landing after the send) and rewrote its header
  comment and Open Question 17 to match. Re-verified the function still
  bundles cleanly with esbuild.
* **2026-09-03 (night, later still)** — Lee created the Kit inline
  subscribe form ("Basic Form"); read its uid (`c448363077`) directly via
  the Kit connection rather than asking him to relay it, and set
  `kit_inline_form_uid`. Embedded it on the home page, the subscribe page
  (replacing the non-embeddable hosted-page uid `subscribe.erb` had been
  pointed at), and — a gap against Part 4's own spec — added it to the
  foot of every article, which had been missing entirely. Discovered in
  the process that the diagnostic and webinar pages' uids are the same
  kind of non-embeddable hosted page (Open Question 14 follow-on).
  Lee asked for a temporary 302 from both paths to Kit's hosted versions
  (`netlify.toml`, `force = true`, clearly commented as temporary), then
  asked for the two now-dead `.erb` source files to be removed outright.
  Deleted `src/service-ownership-diagnostic.erb` and
  `src/architecting-with-ai.erb`, cleaned up the now-unused uid keys and
  CSS selectors, updated Part 4's and Part 6's tables and Open Question 14
  to match, and reverified with a full rebuild — `check_urls.rb` reports
  0 misses, the sitemap no longer lists either page, and both paths return
  the redirect. Real pages here again need matching embed-type Kit forms
  first.
