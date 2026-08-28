# Create the standalone AtchisonAcademy site

* **ID:** Spec0005
* **Status:** In Development
* **Date Created:** 2026-08-28
* **Date Implemented:** TBD
* **Systems Impacted:** AtchisonAcademy (new, site index 5), plus repo-root
  shared infrastructure (`lib/worktree_env.rb`, `test/worktree_env_test.rb`,
  `Procfile`, `Makefile` docs, `CLAUDE.md`, `.worktreeinclude`,
  `Projects/services.md`). **No changes to `LeeAtchison`.**

---

## Problem/Requirement

`atchisonacademy.com` has no site of its own. It is an alias domain on the
leeatchison.com Netlify site, and two `[[redirects]]` rules in
`LeeAtchison/netlify.toml` send every path on it (and its www variant) to
`https://leeatchison.com/academy/`.

Spec0002 changed those rules from 301 to 302 precisely because this state is
temporary: Atchison Academy is meant to become its own site at its own domain.
That spec's comment block in `netlify.toml` says so explicitly, and says the
rules are to be **deleted, not changed**, once the standalone site exists.

This spec builds the site those rules are waiting on. It creates a sixth
Bridgetown site in the monorepo, `AtchisonAcademy/`, whose home page is the
content currently served at `leeatchison.com/academy` and whose configuration,
build pipeline, and dev-port derivation parallel `LeeAtchison`.

### What this spec deliberately does not do

Everything at the Netlify and DNS layer is out of scope, by Lee's explicit
instruction. This spec produces a repo directory that builds locally and is
ready to have a Netlify site pointed at it. It does not:

* create or configure the Netlify site, its build settings, or its domain;
* move `atchisonacademy.com` off the leeatchison.com site as an alias domain;
* remove or modify the two 302 alias redirects in `LeeAtchison/netlify.toml`;
* change, redirect, or remove `leeatchison.com/academy`.

Those are cutover work and belong to a follow-on spec. Until that cutover
happens, `atchisonacademy.com` keeps redirecting to `leeatchison.com/academy/`
and the new site is reachable only at its Netlify-generated preview/production
subdomain and in local dev. That is the intended intermediate state, and it is
safe: nothing in this spec changes any live site's behavior.

### The duplicate-content window

Once the new site is deployed at any public URL, the Academy content exists at
two addresses (`leeatchison.com/academy/` and the new site) until the cutover
spec resolves it. See Open Question 3 for how the new site should behave in the
interim, and Open Question 4 for what happens to `leeatchison.com/academy`
afterward — that decision is deliberately deferred, not forgotten.

---

## Solution/Fix/Change

Two halves: register the site with the monorepo's shared infrastructure, then
create the site directory itself.

### Part 1 — Register site index 5

Service indices are permanent and a new site takes the next unused index.
`AtchisonAcademy` is index **5**, which under the existing scheme
(`8000 + (s-1) * 2000`) gives:

| Index | Site | Live URL | main | `spec####` | `bug####` |
|---|---|---|---|---|---|
| 5 | `AtchisonAcademy` | atchisonacademy.com | 16000 | 16000 + N | 17000 + N |

Files to update:

1. **`lib/worktree_env.rb`** — add `"AtchisonAcademy" => 5` to `SERVICES`.
   The port math needs no change; index 5 falls out of the existing formula.
2. **`test/worktree_env_test.rb`** — add `AtchisonAcademy` to the `SITES`
   constant and to the three expected-port hashes (main, `spec0010`,
   `bug0003`), and add block-edge assertions for 16999 / 17999. The
   no-collisions sweep then covers the new site automatically.
3. **`Procfile`** — add `academy: AtchisonAcademy/bin/dev`.
4. **`CLAUDE.md`** (repo root) — add the site to the repo table and to the
   port-derivation table; update "Five independent Bridgetown sites" and the
   `Projects/services.md` sentence that says "five, indices 0-4".
5. **`Projects/services.md`** — add the row for index 5.
6. **`.worktreeinclude`** — the `bundle install` / `npm install` loop in the
   comment currently lists only four sites (it never picked up
   `ArchitectingForScale`). Bring it to all six while adding the new one.

### Part 2 — Create `AtchisonAcademy/`

Copy `LeeAtchison`'s scaffold and change what is site-specific. The following
files are copied verbatim (they are the standard Bridgetown 2.1.2 scaffold plus
this monorepo's port-derivation glue, and are byte-identical across the
existing sites):

```
.gitignore  .ruby-version  Gemfile  Gemfile.lock  Rakefile  config.ru
package.json*  package-lock.json  esbuild.config.js  postcss.config.js
jsconfig.json  bin/bridgetown  bin/bt  bin/dev  config/esbuild.defaults.js
config/puma.rb  plugins/site_builder.rb  plugins/builders/.keep
server/roda_app.rb  tmp/pids/.keep  frontend/javascript/index.js
frontend/styles/syntax-highlighting.css
```

`* package.json` changes only its `"name"` field to `AtchisonAcademy`.

`bin/dev` and `config/puma.rb` need no edit at all: both derive the port from
the checkout directory name via `lib/worktree_env.rb`, so registering index 5
in Part 1 is the entire port configuration.

Site-specific files:

| File | What changes |
|---|---|
| `bridgetown.config.yml` | The `books` and `courses` collection definitions and permalinks **only**. No `url:` key — Spec0004 removes the redundant one from `LeeAtchison`, and this site must not reintroduce the problem it removes (see "Conforming to Spec0004" below) |
| `config/initializers.rb` | `template_engine "erb"` plus Spec0004's context-aware `url` block, with `https://atchisonacademy.com` as the production literal — otherwise the stock commented file |
| `netlify.toml` | `LeeAtchison`'s file **minus** the two `atchisonacademy.com` alias redirects and the two `/ai-native` path redirects, **plus** Spec0004's `[context.deploy-preview]` and `[context.deploy-preview.environment]` blocks. Keeps `[dev]`, `[build]`, `[build.environment]`, `[build.processing.html]`, and both `[[headers]]` blocks unchanged. The new file has no `[[redirects]]` section at all |
| `src/_data/site_metadata.yml` | `title: Atchison Academy`, plus a tagline and description for the Academy (see Open Question 6) |

### Content: `src/`

**`src/index.erb`** is the body of `LeeAtchison/src/academy.erb`, with:

* front matter `layout: default`, `page_class: homepage`, `title: Home` — the
  `title: Home` matters, because `_head.erb` only produces the
  `"<title> | <site title>"` form for non-index pages and the
  `"<site title>: <tagline>"` form otherwise. Matching `LeeAtchison/src/index.erb`
  keeps that logic behaving the same way.
* The `<h1>Atchison Academy</h1>` in `.academy-hero` retained — on this site it
  is the page's real `h1`, which it currently is not.
* The two commented-out `https://atchisonacademy.com` CTA blocks (in
  `.academy-hero` and `.academy-cta`) **removed**, not carried over. On
  atchisonacademy.com they would point at the page they are on. The
  `.academy-cta` section keeps its heading and logo; see Open Question 7 for
  what, if anything, replaces the CTA button.
* `View All Books` / `View All Courses` buttons pointing at this site's own
  `/books` and `/courses` (see Open Question 1).

**Collections.** `src/_books/` and `src/_courses/` carry only the
academy-flagged resources — the same set the page renders today:

* Books (`academy: true`): `the-software-conductor.md`,
  `business-breakthrough-3.md` (both also `academy_featured: true`).
* Courses (`academy: true`): eight files —
  `cloud-architecture-for-scalable-systems`, `scalable-availability-software-architecture`,
  `software-architecture-developer-to-architect`, `cloud-migration-fundamentals`
  (the four `academy_featured`), plus `avoiding-bad-decisions-cloud-strategy`,
  `cloud-architecture-advanced-concepts`, `framing-cloud-discussions-c-suite`,
  `understanding-impact-merger-it-teams`.

Front matter is copied as-is, including `academy` / `academy_featured` /
`order`. The `academy` flag is redundant on a site where every item is an
Academy item, but keeping it means the index page's `select` logic is copied
unchanged and stays diff-able against `LeeAtchison/src/academy.erb`.

**Layouts, partials, components.**

* `_layouts/default.erb`, `page.erb`, `book.erb`, `course.erb` — copied. Drop
  `post.erb`; there is no posts collection here.
* `_partials/_head.erb` — copied verbatim. It is already fully generic (it
  derives everything from `site.metadata`, the resource, and `absolute_url`),
  and Spec0003 standardized it across all five sites, so the sixth site should
  not fork it. It expects `/images/og-card.png` and `/images/favicon.png` to
  exist (see Images below), and its Fathom snippet — including
  `data-site="QZJQFDMY"` — is copied unchanged, per Lee's decision that all
  sites report to one Fathom site ID.
* `_partials/_footer.erb` — copied, with its `/contact` link repointed to
  `https://leeatchison.com/contact` since this site has no contact page.
* `_components/shared/navbar.rb` / `navbar.erb` — copied, with the brand text
  changed to "Atchison Academy" and `LINKS` reduced to what this site actually
  has, plus one outbound link home:

  ```ruby
  LINKS = [
    { label: "Home",         path: "/" },
    { label: "Books",        path: "/books" },
    { label: "Courses",      path: "/courses" },
    { label: "Lee Atchison", path: "https://leeatchison.com", external: true },
  ].freeze
  ```

  `navbar.erb` wraps every path in `relative_url`, which would mangle an
  absolute URL, so the template needs a small change: emit `link[:path]`
  directly for `external: true` entries (with `target="_blank"` and
  `rel="noopener noreferrer"`), and `relative_url` for the rest. `active?`
  already returns false for a non-matching path, so no change there.

**Listing pages.** `src/books.erb` and `src/courses.erb` copied from
`LeeAtchison` and retitled/retrimmed for the Academy: the `courses.erb` hero
loses its "Atchison Academy &rarr;" button (self-referential here) and its
copy is rewritten for this site. Both then list only what this site's
collections contain, which is already the academy-flagged subset, so no
filtering change is needed.

**Static pages and files.** `404.html`, `500.html`, `robots.txt.erb`,
`sitemap.xml.erb`, `favicon.ico` — copied. The two ERB files reference
`site.config.url` and pick up the new domain automatically.

**Not copied:** `about.erb`, `contact.erb`, `courses.erb`'s LinkedIn badge
section is reviewed (see below), `schedule.erb`, `ainative.erb`,
`academy.erb`, `src/_posts/`, and `assets_inbox/`.

### CSS

`frontend/styles/index.css` (2,658 lines) is copied whole. Every selector the
Academy pages use — `.academy-*`, `.book-*`, `.course-*`, `.section-*`,
`.btn*`, `.nav-*`, `.site-footer`, `.collection-hero`, `.error-page-*` — lives
in that one file alongside styles for pages this site does not have. Trimming
it is possible but is a separate exercise with its own regression risk; see
Open Question 2.

### Images

`src/images/` needs, at minimum:

| File | Used by | Source |
|---|---|---|
| `logo-academy.png` | index hero + CTA | copy from `LeeAtchison/src/images/` |
| `favicon.png` | `_head.erb` | generate 32x32 from `LeeAtchison/assets_inbox/logo-academy-512.png` |
| `og-card.png` | `_head.erb` OG/Twitter tags | new 1200x630 card built from the same logo — see below |
| `books/the-software-conductor.png` | book card + detail | copy |
| `books/business-breakthrough-3.jpg` | book card + detail | copy |
| `pets404.png` | 404 page | copy |
| `linkedin-learners-badge.png` | `courses.erb` hero, if that block is kept | copy |

**Favicon and OG card (Lee's decisions, 2026-08-28).** The favicon is the
Atchison Academy logo, not Lee's headshot. `logo-academy-512.png` in
`LeeAtchison/assets_inbox/` is the correct source for both assets; copy it into
this site's own `assets_inbox/` so the source lives with the site that uses it.

* **Favicon:** `sips -Z 32 assets_inbox/logo-academy-512.png --out src/images/favicon.png`,
  checked at actual size — a logo that reads fine at 512px can turn to mud at
  32px, and if it does, a cropped or simplified mark is the fix rather than
  shipping an illegible favicon.
* **OG card:** a new 1200x630 image at `src/images/og-card.png`, built from
  the same logo on a solid brand-colored ground with the "Atchison Academy"
  wordmark. Spec0003 established 1200x630 landscape as the standard across all
  sites (it replaced portrait images that cropped badly), and `_head.erb`
  already declares those exact dimensions, so anything else will render wrong
  in every social preview. Lee reviews the card before it ships.

### Conforming to Spec0004

**Spec0004 lands first — Lee's decision, 2026-08-28.** This spec must not be
implemented against a `main` that predates it, and the new site must carry
Spec0004's pattern from its first commit rather than being retrofitted. That
makes Spec0004 a hard prerequisite, not a scheduling preference: this site's
metadata is the whole reason both specs exist, and a sixth site that quietly
opts out of the preview-URL fix would be the one site where deploy-preview
metadata still lies.

Three things must be true of `AtchisonAcademy/` at implementation. Each is
copied from Spec0004's final implementation on `main`, not from its spec text —
if refinement changed the shape of the code, the code is what gets copied.

1. **`config/initializers.rb` reads the deploy context.** The context-aware
   `url` block, with `https://atchisonacademy.com` as the production literal:

   ```ruby
   preview_url = ENV["DEPLOY_PRIME_URL"].to_s
   url(ENV["CONTEXT"].to_s != "production" && !preview_url.empty? ? preview_url : "https://atchisonacademy.com")
   ```

   The `CONTEXT` test is what keeps production canonicals pinned to the repo
   literal instead of to Netlify's domain configuration, and the empty-string
   guard covers a present-but-blank `DEPLOY_PRIME_URL`. Both are load-bearing;
   neither should be simplified away while copying.

2. **`bridgetown.config.yml` sets no `url:` key.** Spec0004 removes the
   redundant one from `LeeAtchison` specifically because a YAML value that wins
   over the initializer would silently defeat the context-aware `url`. A new
   site created by copying `LeeAtchison`'s config file is the most likely way
   for that line to come back. It must not.

3. **`netlify.toml` carries the `[context.deploy-preview]` blocks**, in the
   same form and position (immediately after `[build.environment]`) and with
   the same explanatory comment as the other five files.

Whether Spec0004 keeps element 3 is itself one of its open questions — the
blocks change no behavior and exist as documentation. Whatever Spec0004
concludes, this site matches the other five; the goal is six identical files,
not six files that each made their own call.

Verification that this actually worked is Testing step 10, and it is a
deploy-preview check, not a file-diff check: the file being right and the
preview emitting the right hostname are different claims, and Spec0003's whole
problem was assuming the first implies the second.

---

## Testing

Steps 1 through 9 are local and touch no deployed site. Step 10 requires a
deploy preview and is the one check that cannot be faked locally.

1. **Port registration.**

   ```bash
   make test                        # worktree derivation unit test, now 6 sites
   bin/site-port AtchisonAcademy    # 16000 on main
   bin/site-port --all              # six rows
   ```

   In a `spec0005` worktree, `bin/site-port AtchisonAcademy` must print
   `16005`, and the no-collision sweep in `make test` must still pass.

2. **Dependencies install cleanly.**

   ```bash
   cd AtchisonAcademy && bundle install && npm install
   ```

3. **Dev server boots on the derived port.**

   ```bash
   AtchisonAcademy/bin/dev          # ==> AtchisonAcademy [main] http://localhost:16000
   make dev                         # all six start, no port conflicts
   ```

4. **Production build succeeds.**

   ```bash
   cd AtchisonAcademy && rake deploy
   ```

5. **Page-by-page check** against the built `output/`:
   * `/` renders the Academy hero, the books grid (2 cards), the courses grid
     (8 cards, 4 featured), and the closing CTA band — visually equivalent to
     `leeatchison.com/academy` today.
   * `/books/the-software-conductor/`, `/books/business-breakthrough-3/`, and
     all eight course detail pages render.
   * `/books/` and `/courses/` listing pages render.
   * `/404.html` and `/500.html` render.

6. **Link audit.** Grep the built HTML for every `href`. There must be no link
   to a path this site does not have (`/about`, `/contact`, `/academy`,
   `/ainative`, `/schedule`), and no absolute link to `leeatchison.com` other
   than the deliberate ones (navbar "Lee Atchison", footer contact).

7. **Metadata.** In the built HTML, confirm per Spec0003's standard:
   `<link rel="canonical">` and `og:url` present on every pretty-URL page and
   absolute against `https://atchisonacademy.com`; absent on `404.html` and
   `500.html`; `og:image` resolves to a file that exists.

8. **`sitemap.xml` and `robots.txt`.** Sitemap lists every pretty URL with the
   `atchisonacademy.com` host and excludes itself and `robots.txt`; robots'
   `Sitemap:` line points at `https://atchisonacademy.com/sitemap.xml`.

9. **No regression in the other five sites.** `make ports` still shows the
   original five ports unchanged (this is the point of permanent indices), and
   `git status` shows no modified files under `LeeAtchison/`.

10. **Spec0004 conformance, verified on a deploy preview.** File-level first:
    diff `AtchisonAcademy/config/initializers.rb` and `netlify.toml` against
    `LeeAtchison`'s post-Spec0004 versions — the only differences should be the
    production URL literal and LeeAtchison's redirect rules — and confirm
    `AtchisonAcademy/bridgetown.config.yml` has no `url:` key.

    Then, on the deploy preview for this spec's own PR (which is a Deploy
    Preview, so Netlify sets `CONTEXT=deploy-preview` and a real
    `DEPLOY_PRIME_URL`), confirm on the new site's preview:

    * `<link rel="canonical">` and `og:url` on `/` and on a book and a course
      detail page all carry the **preview** hostname, not
      `atchisonacademy.com`;
    * every `<loc>` in `/sitemap.xml` carries the preview hostname;
    * `robots.txt`'s `Sitemap:` line carries the preview hostname;
    * `og:image` resolves — fetch the URL and confirm it returns the new OG
      card, at 1200x630, and not a 404;
    * the response carries Netlify's automatic `X-Robots-Tag: noindex`
      (Spec0004 established this is applied to Deploy Previews and cannot be
      overridden — worth confirming rather than assuming, since it is what
      makes shipping without a disallow-all `robots.txt` safe).

    Then confirm the production build is unaffected: after merge, the live
    site's canonical and `og:url` must read `https://atchisonacademy.com`. A
    preview that describes itself but a production build that also describes
    the preview is the failure mode the `CONTEXT` test exists to prevent, and
    it is invisible until production.

---

## Summary of Steps Needed

1. Resolve the Open Questions below.
2. **Confirm Spec0004 is implemented and merged to `main`**, and read its final
   implementation (not its spec text) before starting. It is a prerequisite.
3. Decide branching mode (Open Question 10) and set up the worktree if used.
4. Register index 5: `lib/worktree_env.rb`, `test/worktree_env_test.rb`,
   `Procfile`, `Projects/services.md`, root `CLAUDE.md`, `.worktreeinclude`.
5. Create `AtchisonAcademy/` with the copied scaffold; edit the site-specific
   files (`package.json` name, `bridgetown.config.yml`,
   `config/initializers.rb`, `netlify.toml`, `site_metadata.yml`).
6. Build `src/`: `index.erb` from `academy.erb`, the two collections, layouts,
   partials, the reduced navbar, listing pages, static pages, CSS.
7. Produce the two new image assets — 32x32 favicon and 1200x630 OG card from
   `logo-academy-512.png` — and get Lee's sign-off on the OG card.
8. Write `AtchisonAcademy/CLAUDE.md` and `README.md`, parallel to
   `LeeAtchison`'s, describing this site's own structure and conventions.
9. Run Testing steps 1 through 9 locally.
10. Request permission to commit; create a PR on request.
11. Run Testing step 10 against the PR's deploy preview, and again against
    production after merge.
12. File the cutover work (Netlify site, domain move, redirect removal, the
   `leeatchison.com/academy` decision) as a new entry in `Projects/_Projects.md`
   so it is not lost when this spec archives.

---

## Open Questions

1. **`/books` and `/courses` listing pages — include them, or drop the "View
   All" buttons?** The copied index page ends each section with a
   `View All Books &rarr;` / `View All Courses &rarr;` button pointing at
   `/books` and `/courses`. With the chosen scope (home page plus both
   collections), the detail pages exist, so the listing pages are cheap to
   include and the buttons keep working. The alternative is a single-page site
   with the buttons removed and the cards linking straight to detail pages.
   *Recommendation: include both listing pages, copied and retrimmed. A
   404 behind a prominent button on the home page is the worse failure, and
   the pages are two files.*

2. **Copy the whole 2,658-line stylesheet, or trim it to what this site
   uses?** A full copy is exact and fast, and carries dead rules for pages this
   site does not have. A trim is smaller but risks removing a rule some copied
   partial quietly depends on, and any later fix has to be applied to two
   diverged files instead of two identical ones.
   *Recommendation: copy whole now. Note the divergence risk in the site's
   CLAUDE.md and treat trimming as a possible later cleanup spec, once the
   site's page set has settled.*

3. **Should the new site be `noindex` until cutover?**
   **Resolved 2026-08-28 (Lee): no.** Ship `robots.txt` as-is, copied from
   `LeeAtchison`. The interim state will not last long enough for the
   duplicate-content window to matter, and a disallow-all that has to be
   remembered and removed at cutover is its own failure mode — a forgotten
   `Disallow: /` is a far worse outcome than a few days of duplication.

   Two things make this safe rather than merely acceptable, and both were
   established during Spec0004's research: Netlify sends
   `X-Robots-Tag: noindex` on Deploy Previews automatically and it cannot be
   overridden, so PR previews are never indexed regardless of `robots.txt`; and
   the production build of the new site is not reachable at
   `atchisonacademy.com` until the cutover, because the alias redirect still
   sends that domain to `leeatchison.com/academy/`. The only exposed surface in
   the interim is the site's `*.netlify.app` production subdomain.

   Note the boundary Spec0004 also recorded: **branch deploys do not get the
   automatic noindex**, only Deploy Previews do. If this work is ever pushed as
   a long-lived branch deploy rather than a PR preview, that gap applies.

4. **What eventually happens to `leeatchison.com/academy`?** Deliberately
   deferred — Lee's decision, 2026-08-28: leave it alone for now and decide at
   cutover. Recorded here so the cutover spec inherits the question rather than
   rediscovering it. The realistic options are: keep it as a promotional page
   linking out to the Academy; 301 it to `atchisonacademy.com`; or delete it.
   Whatever is chosen, the navbar entry in `LeeAtchison/src/_components/shared/navbar.rb`
   and the `courses.erb` hero button both point at `/academy` and would need to
   follow.

5. **Favicon and OG card for the new site.**
   **Resolved 2026-08-28 (Lee):** the favicon is the Atchison Academy logo, and
   an OG card is to be created. `logo-academy-512.png` is the correct source for
   both. Details in the Images section above. One thing still to check at
   implementation rather than decided here: whether the logo stays legible when
   reduced to 32x32. If it does not, a cropped or simplified mark is the fix —
   raise it rather than shipping a muddy favicon.

6. **Site metadata copy.** `site_metadata.yml` needs a `title`, `tagline`, and
   `description` for the Academy. The index hero's existing sentence
   ("Exclusive books, courses, and training directly from Lee Atchison — for
   software architects and technology leaders who want to build, scale, and
   lead with confidence.") is a natural starting point for the description.
   *Recommendation: `title: Atchison Academy`; tagline and description drafted
   from the hero copy and approved by Lee before implementation, since this
   text lands in every page title, meta description, and social card.*

7. **The closing CTA band.** The `.academy-cta` section's button and paragraph
   are currently commented out on leeatchison.com because they pointed at
   atchisonacademy.com. On the new site they cannot point there either.
   Options: leave the band as heading + logo only (what the commented-out
   version effectively renders today); repoint the CTA at `/courses`; or
   replace it with a mailing-list signup.
   *Recommendation: heading + logo only for this spec, and treat a real CTA
   (signup, catalog, or purchase path) as its own spec once the Academy has
   something to convert to.*

8. **Fathom analytics.**
   **Resolved 2026-08-28 (Lee): one Fathom site ID for all sites.** Copy
   `_head.erb`'s snippet verbatim, `data-site="QZJQFDMY"` included. Academy
   traffic lands in the same Fathom property as everything else and is
   separated by hostname there rather than by site ID. This makes `_head.erb`
   fully copyable across sites with no per-site edit, which is consistent with
   Spec0003's aim of one standard head partial.

9. **Ordering against Spec0004.**
   **Resolved 2026-08-28 (Lee): Spec0004 is implemented first**, and this spec
   must verify that its pattern is correctly carried into the new site rather
   than assuming it. Spec0004 is therefore a hard prerequisite. The three things
   that must be true of the new site are listed under "Conforming to Spec0004"
   above, and verification is Testing step 10 — a deploy-preview check, since a
   correct-looking file is not evidence that the preview emits the right
   hostname.

   One consequence for Spec0004 itself, worth raising with it while it is still
   in refinement: its title and text say "all five sites". Once this site
   exists, that phrasing is a trap for whoever reads it next. Either Spec0004
   is generalized to "all sites" before it is implemented, or Spec0005 records
   — as it now does — that the sixth site adopts the pattern separately.

10. **Branching mode.** `main`, or a `spec0005` worktree? The change is a new
    directory of ~60 files plus six shared-infrastructure edits, and it needs a
    running dev server to verify.
    *Recommendation: a worktree (or a Claude Code remote session branch, as
    Spec0002 and Spec0003 used). This is too large for main, and the port
    derivation means a `spec0005` worktree runs the new site on 16005 without
    disturbing anything on 16000.*

---

## History of Updates

* **2026-08-28** Spec created at Lee's request: build `atchisonacademy.com` as
  its own site in the monorepo, paralleling `LeeAtchison`'s configuration and
  structure, with the current `leeatchison.com/academy` page as its home page.
  Lee scoped it explicitly to creating the site — the Netlify configuration is
  his to do by hand afterward, and removing the alias redirect is a later step.
* **2026-08-28** Scope decisions taken with Lee at creation:
  * **Page scope:** home page plus the `books` and `courses` collections,
    carrying only the academy-flagged resources, so card links and detail
    pages resolve on the new domain instead of pointing back at
    leeatchison.com.
  * **Navigation:** the navbar lists exactly the pages this site has, plus an
    outbound "Lee Atchison" link to leeatchison.com; brand text becomes
    "Atchison Academy".
  * **`leeatchison.com/academy`:** left alone, decision deferred to the
    cutover spec (Open Question 4).
* **2026-08-28** Established from the codebase that `bin/dev` and
  `config/puma.rb` need no site-specific edits — both re-derive their port from
  `lib/worktree_env.rb` keyed on the checkout directory name — so registering
  index 5 is the whole of the port configuration. Confirmed index 5 yields
  16000 / 16000+N / 17000+N under the existing formula, with no change to the
  other five sites' ports (permanent indices working as designed).
* **2026-08-28** Audited what the Academy page actually depends on: two
  academy-flagged books, eight academy-flagged courses, the `.academy-*`,
  `.book-*`, `.course-*`, `.section-*`, and `.btn*` CSS families, and
  `logo-academy.png`. Recorded the two self-referential
  `https://atchisonacademy.com` CTA blocks (commented out today) as things to
  remove rather than copy.
* **2026-08-28** Identified `_head.erb`'s hardcoded Fathom site ID and its
  `favicon.png` / `og-card.png` requirements as the two things that cannot be
  copied verbatim without being wrong on the new domain (Open Questions 5
  and 8).
* **2026-08-28** Recorded the overlap with Spec0004, which is still in
  refinement and edits `config/initializers.rb` and `netlify.toml` across all
  five sites. No hard ordering dependency; whichever lands second absorbs the
  other (Open Question 9).
* **2026-08-28** Noted that `.worktreeinclude`'s dependency-install loop lists
  only four sites and never picked up `ArchitectingForScale`; folded that fix
  into this spec's Part 1 since the file is being edited anyway.
* **2026-08-28** Four Open Questions resolved by Lee, and the spec updated to
  match rather than merely recording the answers:
  * **Fathom (OQ8):** one site ID across all sites. `_head.erb` is now copied
    verbatim, `data-site="QZJQFDMY"` included, with no per-site edit at all.
  * **Favicon and OG card (OQ5):** favicon is the Academy logo, not Lee's
    headshot; an OG card is to be created; `logo-academy-512.png` is the source
    for both. Folded into the Images section with the 1200x630 constraint
    Spec0003 established and `_head.erb` already declares. Left open at
    implementation: whether the logo survives reduction to 32x32.
  * **Interim indexing (OQ3):** do not ship a disallow-all `robots.txt` — the
    interim state is short. Recorded why this is safe rather than just
    accepted: Netlify's automatic, non-overridable `X-Robots-Tag: noindex` on
    Deploy Previews (a Spec0004 finding), and the fact that the alias redirect
    keeps `atchisonacademy.com` pointed at leeatchison.com until cutover, leave
    only the `*.netlify.app` production subdomain exposed. Also carried over
    Spec0004's boundary: branch deploys get no automatic noindex.
  * **Ordering (OQ9):** Spec0004 lands first, and this spec verifies its
    pattern is correct on the new site. Upgraded from "no hard dependency" to a
    hard prerequisite, with a new "Conforming to Spec0004" section naming the
    three things that must be true — the context-aware `url` block with this
    site's own production literal, **no** `url:` key in
    `bridgetown.config.yml`, and the `[context.deploy-preview]` blocks.
* **2026-08-28** Caught while folding in Spec0004: that spec removes the
  redundant `url:` line from `LeeAtchison/bridgetown.config.yml` precisely
  because a YAML value winning over the initializer would silently defeat the
  context-aware URL. Copying `LeeAtchison`'s config file into a new site is the
  single most likely way for that line to come back, which would reintroduce
  the bug on the newest site while the fix sat in the other five. Called out
  explicitly in both the config table and the conformance section.
* **2026-08-28** Added Testing step 10, which verifies Spec0004 conformance on
  an actual deploy preview (canonical, `og:url`, sitemap `<loc>`, robots
  `Sitemap:`, `og:image` fetch, and the `X-Robots-Tag` header), and then
  re-checks production after merge. Deliberately not a file diff alone:
  Spec0003's unrun verification steps are the precedent for why "the file looks
  right" is not evidence the build emits the right thing.
