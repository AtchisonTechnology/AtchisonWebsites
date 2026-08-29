# Cross-domain canonical URLs for shared books and courses

* **ID:** Spec0009
* **Status:** Implementing
* **Date Created:** 2026-08-29
* **Date Implemented:** 2026-08-29
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy`, `shared/`
* **Pull Request:** [#11](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/11)

---

## Problem/Requirement

Spec0008 made `shared/_books` and `shared/_courses` one canonical set of files
read by both leeatchison.com and atchisonacademy.com. One consequence is that
ten items — two books and eight courses — now generate a page on **both**
sites, from the same source file, through byte-identical `book.erb` /
`course.erb` layouts:

| Type | Item | On both sites |
|---|---|---|
| Book | `the-software-conductor` | ✅ |
| Book | `business-breakthrough-3` | ✅ |
| Course | `avoiding-bad-decisions-cloud-strategy` | ✅ |
| Course | `cloud-architecture-advanced-concepts` | ✅ |
| Course | `cloud-architecture-for-scalable-systems` | ✅ |
| Course | `cloud-migration-fundamentals` | ✅ |
| Course | `framing-cloud-discussions-c-suite` | ✅ |
| Course | `scalable-availability-software-architecture` | ✅ |
| Course | `software-architecture-developer-to-architect` | ✅ |
| Course | `understanding-impact-merger-it-teams` | ✅ |

Both `_head.erb` partials currently emit a **self-referential** canonical, so
each pair tells search engines "I am the original." Search engines resolve
that themselves — there is no duplicate-content penalty — but they cluster the
pair, pick one URL on their own, and consolidate ranking signals onto it. Two
things go wrong: the wrong URL may win, and until the cluster settles, link
and relevance signals are split across two domains.

The fix is a cross-domain `rel="canonical"`: each duplicate pair names one
site as the original. Because the pages really are near-identical, this is a
hint search engines reliably honor.

Adding a seventh site, or flipping an item's `show_` flag, must not silently
recreate this problem — so the mechanism has to be enforced by the build, not
by remembering.

---

## Solution/Fix/Change

### 1. A new `canonical_site` front-matter key

Every resource in `shared/_books` and `shared/_courses` gains one key, with
the same site-suffix vocabulary as `show_`/`feature_`/`order_`:

```yaml
canonical_site: academy      # or: leeatchison
```

The key names the **site**, not a URL. Both sites publish these collections at
identical paths (`/books/:slug/`, `/courses/:slug/`), so the canonical URL is
derivable from the site key plus the resource's own `relative_url`.

The key is set on **all 22 items**, not only the ten that overlap. A key on a
single-site item is a valid statement of where that item's page belongs, and
carrying it everywhere means the rule is uniform and readable rather than a
sparse exception list. Only a key naming a site the item is *not* shown on is
an error.

### 2. Assignment rule

Books, by publisher:

- O'Reilly Media → `leeatchison`
- Independent → `academy`

Courses, by platform:

- LinkedIn Learning → `leeatchison`
- O'Reilly Media → `leeatchison`
- Coursera → `academy`

Applied to today's content, that is:

| Type | Item | Source | `canonical_site` |
|---|---|---|---|
| Book | `97-things-cloud-engineer` | O'Reilly Media | `leeatchison` |
| Book | `97-things-infosec` | O'Reilly Media | `leeatchison` |
| Book | `architecting-a-cloud-security-strategy` | O'Reilly Media | `leeatchison` |
| Book | `architecting-for-scale` | O'Reilly Media | `leeatchison` |
| Book | `business-breakthrough-3` | Independent | `academy` |
| Book | `caching-at-scale-with-redis` | O'Reilly Media | `leeatchison` |
| Book | `identity-in-modern-applications` | O'Reilly Media | `leeatchison` |
| Book | `overcoming-it-complexity` | O'Reilly Media | `leeatchison` |
| Book | `the-software-conductor` | Independent | `academy` |
| Book | `what-is-polycloud` | O'Reilly Media | `leeatchison` |
| Course | `avoiding-bad-decisions-cloud-strategy` | LinkedIn Learning | `leeatchison` |
| Course | `cloud-architecture-advanced-concepts` | LinkedIn Learning | `leeatchison` |
| Course | `cloud-architecture-for-scalable-systems` | Coursera | `academy` |
| Course | `cloud-careers-developer-to-architect` | LinkedIn Learning | `leeatchison` |
| Course | `cloud-center-of-excellence` | LinkedIn Learning | `leeatchison` |
| Course | `cloud-migration-fundamentals` | O'Reilly Media | `leeatchison` |
| Course | `framing-cloud-discussions-c-suite` | LinkedIn Learning | `leeatchison` |
| Course | `presenting-cloud-migration-benefits` | LinkedIn Learning | `leeatchison` |
| Course | `scalable-availability-software-architecture` | Coursera | `academy` |
| Course | `software-architecture-developer-to-architect` | LinkedIn Learning | `leeatchison` |
| Course | `understanding-impact-merger-it-teams` | LinkedIn Learning | `leeatchison` |
| Course | `understanding-value-cloud-native` | LinkedIn Learning | `leeatchison` |

Every assignment lands on a site the item is actually shown on — no rule
produces a validation error against today's content. Of the ten overlapping
items, six courses and no books resolve to `leeatchison`; two courses and two
books resolve to `academy`.

### 3. All logic lives in `shared_content.rb`

Each site already has a `plugins/builders/shared_content.rb` running on the
`:site, :post_read` hook, validating stray keys and filtering the collections.
It is the natural home for this, and it keeps template churn to one line per
site.

Replace the builder's three single-purpose constants with one site registry
plus the site's own key:

```ruby
SITES = {
  "leeatchison" => { show: :show_leeatchison, url: "https://leeatchison.com" },
  "academy"     => { show: :show_academy,     url: "https://atchisonacademy.com" },
}.freeze

SITE_KEY = "academy"   # "leeatchison" in the other site's copy
```

The two builders then differ only in `SITE_KEY`. Everything derived from it —
`show_academy`, `feature_academy`, `order_academy` — is built from the key
rather than written out, which is also what makes a seventh site a one-entry
change in each existing builder rather than a rewrite.

For every resource, before the existing `select!` filter drops the ones this
site does not carry, the builder:

1. **Validates** (see below), raising on any violation.
2. When `canonical_site` names a *different* site than `SITE_KEY`, sets two
   data keys on the resource:
   - `resource.data[:canonical_url]` — the other site's production base URL
     plus the resource's `relative_url`
   - `resource.data[:sitemap_exclude] = true`

Setting `sitemap_exclude` reuses the reject clause already in both
`sitemap.xml.erb` files, so **the sitemap templates need no change at all**.
The page stays live, linked, and reachable — it simply stops being volunteered
for indexing, which is what search engines want when a canonical points
elsewhere.

### 4. Validation — three build-failing rules

Extend the builder's existing `validate!`:

1. *(existing)* `feature_*` or `order_*` set without the matching `show_*`.
2. **New:** a resource with `show_` true for **more than one** site and no
   `canonical_site` — a dual-site item that has not declared a winner.
3. **New:** `canonical_site` naming a site whose `show_` flag is not true on
   that resource — the item was pointed at a site it does not appear on.
   (A `canonical_site` that matches the item's only site is fine, not an
   error.)

Rules 2 and 3 are what stop a future item, or a flipped `show_` flag, from
silently re-creating duplicate pages. Both raise at build time, so the failure
surfaces in Netlify's log rather than in search results months later.

Each site's builder sees all 22 resources at `post_read`, so both rules can be
checked from either site — the validation is identical in both copies and each
deploy independently enforces it.

### 5. `_head.erb`: split canonical from `og:url`

Both partials today compute one `page_url` and use it for `<link
rel="canonical">` **and** `<meta property="og:url">`. These now diverge:

- **canonical** — `resource.data.canonical_url` when the builder set one,
  otherwise today's `absolute_url(...)` self-reference.
- **`og:url`** — always self-referential, unchanged. It drives share cards;
  pointing it at the other domain would send LinkedIn/X traffic away from the
  page that was actually shared.

The 404/500 guard (only pretty URLs ending in `/` get either tag) stays as-is.

### 6. Deploy previews keep the cross-domain override

The cross-domain canonical is emitted unconditionally, previews included, and
always points at the other site's **production** URL.

This is deliberate. Netlify serves deploy previews with an automatic `noindex`
header (the reason Spec0004 treats branch deploys differently), so a
production canonical on a preview costs nothing — and making it conditional
would mean the tag could only ever be tested on the live site.

One asymmetry follows and is accepted: on a deploy preview, self-referential
canonicals use the preview host per Spec0004, while cross-domain ones point at
production. There is no way to know the other site's preview URL, so this is
unavoidable rather than a choice.

### Out of scope

- **`/books/` and `/courses/` index pages.** Both sites list overlapping items,
  but the index pages themselves differ in composition and are genuinely
  distinct pages. No canonical relationship.
- **The three books with dedicated sites** (`architecting-for-scale`,
  `the-software-conductor`, `business-breakthrough-3` →
  architectingforscale.com, thesoftwareconductor.com, businessbreakthrough30.com).
  A summary card is not a near-duplicate of a whole book site, so `rel=canonical`
  is the wrong tool there and would likely be ignored anyway.
- **The other four sites.** No other site defines these collections; none of
  their `_head.erb` files change.
- **Netlify and DNS.** Repo work only.

---

## Testing

1. **Build both sites** (`LeeAtchison/bin/dev`, `AtchisonAcademy/bin/dev`, or a
   production build) and confirm both succeed.
2. **Cross-domain canonical, on the losing site.** For each of the ten
   overlapping items, check the non-canonical site's output:
   - `<link rel="canonical">` points at the *other* domain, same path.
   - `<meta property="og:url">` points at *this* domain.
   For example, `AtchisonAcademy/output/courses/cloud-migration-fundamentals/index.html`
   should carry `canonical` → `https://leeatchison.com/...` and `og:url` →
   `https://atchisonacademy.com/...`.
3. **Self-canonical, on the winning site.** The same ten items on their
   canonical site keep a self-referential canonical, byte-identical to today.
4. **Single-site items unchanged.** Spot-check several of the twelve
   single-site items — canonical and `og:url` both self-referential, as before.
5. **Sitemaps.** `AtchisonAcademy/output/sitemap.xml` contains no `<loc>` for
   the six courses canonical to leeatchison; `LeeAtchison/output/sitemap.xml`
   contains none for the two books and two courses canonical to academy. Every
   remaining URL in each sitemap has a self-referential canonical on its page —
   this is the invariant worth asserting, and it should hold for the whole
   sitemap, not just books and courses.
6. **Validation fires.** Temporarily, without committing:
   - Remove `canonical_site` from a dual-site item → both builds fail with a
     message naming the file and the missing key.
   - Set `canonical_site: academy` on an O'Reilly book → both builds fail with
     a message naming the file and the site it is not shown on.
   - Restore both files and confirm the builds pass again.
7. **404/500 pages** still emit neither `canonical` nor `og:url`.
8. **Deploy preview** on the PR: confirm an overlapping item's page shows a
   preview-host `og:url` alongside a production cross-domain `canonical`.

---

## Summary of Steps Needed

1. Add `canonical_site` to all 22 files in `shared/_books` and `shared/_courses`
   per the assignment table.
2. Rewrite `AtchisonAcademy/plugins/builders/shared_content.rb`: `SITES`
   registry + `SITE_KEY`, the two new validation rules, and the
   `canonical_url` / `sitemap_exclude` assignment.
3. Mirror it into `LeeAtchison/plugins/builders/shared_content.rb` (identical
   but for `SITE_KEY`).
4. Update both `src/_partials/_head.erb`: split `canonical` from `og:url`.
5. Update both sites' `CLAUDE.md` key documentation, and the repo-root
   `CLAUDE.md` section describing the shared collections, to cover
   `canonical_site` and its validation rules.
6. Run through Testing above.

---

## Open Questions

**1. Where should the site → base-URL map live? — RESOLVED 2026-08-29.**

**Decided: duplicate the `SITES` constant in each site's builder.** The
alternative considered was a shared `shared/canonical_sites.yml` read by both
builders via a relative path to the repo root — one source of truth, but a new
cross-directory read that would have to keep working in worktrees and on
Netlify.

Duplication matches established practice here (Spec0006 and Spec0007 both
hardcode the cross-property URL in each site's own files) and keeps each
builder self-contained with no new load-path plumbing. The cost — a URL change
means editing two files, with nothing enforcing that they agree — is
acceptable: these domains change roughly never, and a divergence surfaces
immediately in the canonical tag of the first page you look at.

Implementation note: add a comment above `SITES` in both files stating that the
two copies must stay in sync, so the next reader is not left guessing whether
the duplication is deliberate.

**2. Should the ten losing pages eventually be differentiated instead?**

A canonical concedes that the two pages are the same page. The alternative is
making them genuinely different — a distinct intro and CTA per site — so both
earn their own place in search. That is more content to write and maintain for
pages this thin, so canonical is the right call now. Worth revisiting only if
one of these pages becomes a significant landing page in its own right.

---

## History of Updates

**2026-08-29 — Spec created.**

Originated from a question about whether cross-domain `rel=canonical` was the
right answer to the duplication Spec0008 introduced, and whether a front-matter
key was the right way to drive it. Both confirmed.

Decisions made during spec development, all confirmed by Lee:

- **Key name and values:** `canonical_site`, taking `leeatchison` or `academy`
  — the site-suffix vocabulary already used by `show_`/`feature_`/`order_`.
  The key names a site, not a URL, since both sites publish these collections
  at identical paths.
- **Assignment rule:** books by publisher (O'Reilly → `leeatchison`,
  Independent → `academy`); courses by platform (LinkedIn Learning and
  O'Reilly → `leeatchison`, Coursera → `academy`).
- **The rule is baked in for all 22 items,** including the eight O'Reilly books
  that appear only on leeatchison.com and so need no canonical to function.
  Noted during refinement that the books half of the rule matches no
  overlapping item today; Lee chose to encode it anyway so the rule is complete
  and holds if an O'Reilly book is later added to the academy site.
- **`canonical_site` is required on dual-site items** — a missing key fails the
  build.
- **`canonical_site` is *not* forbidden on single-site items.** Considered and
  rejected: the original proposal was to treat any key on a single-site item as
  an error, by analogy with the existing stray-`feature_`/`order_` check. Lee's
  correction — a key that matches the item's only site states something true and
  harmless; only a key pointing at a site the item is *not* on is wrong. That is
  the rule, and it is also what makes assigning the key to all 22 items coherent.
- **`og:url` stays self-referential** on both sites, always.
- **Sitemaps list canonical URLs only** — the losing site drops the page from
  its sitemap while keeping it live and linked.
- **Deploy previews keep the cross-domain override.** The alternative
  considered was suppressing it on previews so that preview builds never claim
  production URLs. Rejected: it would make the tag untestable anywhere but the
  live site, and Netlify's automatic `noindex` on deploy previews makes the
  production canonical harmless there.

**2026-08-29 — Open Question 1 resolved.** The site → base-URL map is
duplicated as a `SITES` constant in each site's `shared_content.rb` rather than
centralized in a shared YAML file, matching how Spec0006 and Spec0007 already
handle cross-property URLs. Both copies carry a sync comment. No open questions
remain that block implementation; Open Question 2 is a deliberate
revisit-later note, not a blocker.

**2026-08-29 — Moved to Implementing and implemented.** All six steps done on
branch `claude/spec0009-implementation-664py7`: `canonical_site` added to all 22
shared files per the assignment table; both `shared_content.rb` builders rewritten
around the `SITES` registry + `SITE_KEY` (identical but for that one line, with the
sync comment from Open Question 1); both `_head.erb` partials split `canonical` from
`og:url`; both site `CLAUDE.md` files and the repo-root `CLAUDE.md` updated. The
sitemap templates were unchanged, as the spec predicted.

Two implementation details not spelled out in the spec:

- The builder also raises on a `canonical_site` value that names no known site
  (a typo). Without that guard the rule-3 check would `NoMethodError` on the
  registry lookup instead of failing usefully.
- `feature_*`/`order_*` are derived from `SITE_KEY` by interpolation, while
  `show_*` comes from the `SITES` entry — that keeps the registry exactly as the
  spec wrote it without restating the show flag twice.

Testing: both sites build clean; all 22 items verified for canonical/`og:url` on
every site they appear on; both sitemaps verified to contain only self-canonical
URLs (25 on leeatchison, 7 on academy) with the six leeatchison-canonical courses
absent from academy's and the two books + two courses canonical to academy absent
from leeatchison's; 404/500 still emit neither tag; both new validation rules
confirmed to fail both builds with the file named, then restored. Step 8 of the
spec's Testing (deploy-preview check on the PR) is the only item outstanding — it
can only be run once a PR exists.

