# Project Tracker

Human-readable view of every Spec/Bug in the system — the single source of
truth for workflow status. Sections are ordered for quick human scanning
(most actionable work first); within a section, rows are sorted by
**Priority** (1 = highest) — except Archived, which has no Priority column
since ordering doesn't matter there.

Priority numbers may be hand-edited in any table that has one. When that
happens, re-sort that table by the new numbers and renormalize to
consecutive integers starting at 1.

---

## Implementing

*Ready to be passed on to implementation.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| — | — | *(none)* | — |

---

## Verifying

*Review the code in the worktree/branch, test locally, then create and review the PR.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| 1 | Spec0018 | Center the featured-books grid when fewer than four books are featured | `.books-grid` is `repeat(4, 1fr)` in both stylesheets — correct only because leeatchison.com happens to feature exactly four books, while atchisonacademy.com's two hug the left edge on `/books`; replace the base rule with `auto-fit`/`minmax` plus `justify-content: center`, delete the Academy home page's duplicate override and the two responsive column overrides that specificity has always beaten — cap corrected to 240px during implementation after testing showed 260px would have broken leeatchison.com's four-across row |

---

## In Spec Development/Refinement

*Flesh out the spec/bug details so it can be passed on for implementation. When complete, move to **Implementing**.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| 1 | Spec0017 | Make the leeatchison.com home page Books section collection-driven | Replace the four hardcoded `.book-card` blocks in `index.erb` with a loop over the shared books collection, fixing the card order that disagrees with `order_leeatchison` (1, 3, 2, 4), the hand-written BB3.0 author line and the forked Software Conductor blurb, and adding the `/books` link the section never had — the open question is whether a home-page book card should go to the local book page, off-site to the book's own site, or both |
| 2 | Spec0019 | Move book and course card images into `shared/` so both sites read one copy | Spec0008 shared the books and courses collections but not the art they point at, so two covers are maintained twice today; create `shared/images/{books,courses}/` and symlink both into each site the way `_books`/`_courses` already are — no `cover_image` value changes and no rendered HTML changes, and it must land before Spec0020 adds six course images |
| 3 | Spec0020 | Show a card image on featured courses, as featured books already do | Featured books lead with a cover and featured courses lead with small uppercase platform text, because no course carries an image key at all; add `cover_image` to the six courses featured across the two sites, render it in the four featured-card templates plus Spec0016's band, and add `aspect-ratio` card CSS to both stylesheets — depends on Spec0019, and Lee supplies the art |
| 4 | Spec0021 | Create the AtchisonAcademyCourses site for actual course content at courses.atchisonacademy.com | Add a seventh Bridgetown site (site index 6, port 18000) hosting the published courses' actual content — unlisted by design: no root index page, a random-slug catalog, `/<course-id>/<secret>/` course URLs, no sitemap.xml, and a disallow-all robots.txt — with `courses` and `lessons` collections, a fail-loud validation builder, a standard lesson template rendering video, text, or resource-list content with prev/next and course-outline navigation, a do-not-share notice on every course page paired with a shareable purchase-page link derived from `course_id` onto atchisonacademy.com, full Academy-derived styling, and a placeholder course only; Netlify site and DNS are Lee's by hand, out of scope |

---

## Next in Line (For Spec Development)

*Ready to be worked on. Move to **In Spec Development/Refinement** to begin fleshing out the spec's details.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| — | — | *(none)* | — |

---

## Hold/Deferred

*Not currently being worked on, deliberately.*

| Priority | ID | Title | Short Description |
|---|---|---|---|
| 1 | Spec0022 | Student-specific IDs, activity tracking, and course progress on AtchisonAcademyCourses | Deliberate placeholder, filed to hold the idea for evaluation after Spec0021 ships: give each purchaser an opaque student ID and track visits, activity, and per-course progress in a datastore via client JS posting to Netlify Functions — candidate stores are Netlify Blobs, Netlify DB (Neon Postgres), or external; alternatives range from Fathom aggregate events up to real authentication, which would supersede the secret-URL model; nothing decided, and the first real step is deciding what questions the data should answer |

---

## Archived (Closed and Cancelled)

*Completed (Closed) or abandoned (Cancelled) items. Files live in `zArchive/`.*

| ID | Title | Short Description | Status | Date Completed |
|---|---|---|---|---|
| Spec0001 | STOSA site: book CTA, refreshed bio, and Atchison Academy hero | Add an Architecting for Scale CTA band, update the About bio, verify no Soundings references remain, and add an Atchison Academy hero above the footer on stosa.org — [PR #1](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/1) | Closed | 2026-08-28 |
| Spec0002 | Change the atchisonacademy.com alias redirect from permanent to temporary | Switch the two atchisonacademy.com rules in LeeAtchison/netlify.toml from 301 to 302, since the domain will become its own site and a permanent redirect is cached indefinitely by browsers — [PR #2](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/2) | Closed | 2026-08-28 |
| Spec0003 | Standardize head metadata across all five sites | Add canonical and per-page Open Graph tags to all five head partials, fix the stosa og:image 404, add the missing OG set to leeatchison.com, and replace portrait social images — [PR #2](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/2) | Closed | 2026-08-28 |
| Spec0004 | Configure Netlify Deploy Previews across all five sites | Make preview builds emit their own hostname in canonical, og:url and the sitemap by reading CONTEXT/DEPLOY_PRIME_URL in each site's config/initializers.rb — [PR #4](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/4) | Closed | 2026-08-28 |
| Spec0005 | Create the standalone AtchisonAcademy site | Add a sixth Bridgetown site, AtchisonAcademy (site index 5, port 16000), paralleling LeeAtchison's configuration and structure, with the current leeatchison.com/academy page as its home page and the academy-flagged books and courses as its collections — [PR #6](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/6) | Closed | 2026-08-29 |
| Spec0006 | Retire leeatchison.com/academy and point all Academy links at atchisonacademy.com | Delete `LeeAtchison/src/academy.erb`, 301 `/academy` to `https://atchisonacademy.com/`, repoint the navbar entry and the two `courses.erb` buttons at the new domain, and remove the now-dead alias redirects — repo work only; the domain move is already done — [PR #7](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/7) | Closed | 2026-08-29 |
| Spec0007 | Cross-property menu links should not open a new window | Split the navbar's `external:` flag into `external:` plus a new opt-in `new_tab:`, so the **Academy** and **Lee Atchison** menu entries cross between leeatchison.com and atchisonacademy.com in the same tab — two files, one line each; the `courses.erb` buttons and stosa's Academy button deliberately keep `target="_blank"` — [PR #9](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/9) | Closed | 2026-08-29 |
| Spec0008 | Share the books and courses collections between leeatchison.com and atchisonacademy.com | Move `_books` and `_courses` to one canonical `shared/` folder symlinked into both sites, and replace the `academy` / `featured` / `academy_featured` / `order` keys with parallel per-site `show_`, `feature_` and `order_` keys, filtered per site by a `:site, :post_read` builder — [PR #10](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/10) | Closed | 2026-08-29 |
| Spec0009 | Cross-domain canonical URLs for shared books and courses | Add a `canonical_site` front-matter key to all 22 shared books and courses, resolve it in each site's `shared_content.rb` into a cross-domain `rel=canonical` plus a sitemap exclusion on the non-canonical site, keep `og:url` self-referential, and fail the build when a dual-site item declares no canonical or names a site it is not on — [PR #11](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/11) | Closed | 2026-08-29 |
| Spec0010 | Course descriptions, "get the course" links, pre-launch courses, and a hidden flag | Add `shared/_data/platforms.yml` platform access facts, an access note + closing CTA on `course.erb`, a `hidden:` flag, `availability: prelaunch` courses with UTM-tagged links, and rewritten descriptions for all 12 shared courses plus 4 new pre-launch course files — [PR #13](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/13) | Closed | 2026-08-29 |
| Spec0011 | Rework the Academy courses hero, and give Academy-native courses a platform | Drop the outbound button from both sites' courses heroes, replace the LinkedIn learners badge on both `AtchisonAcademy` and `LeeAtchison` with one neutral, transparent, on-palette `180,000+` badge, correcting the stale learner figure everywhere it appears; add `platform: Atchison Academy` to the four Academy-native courses plus a build-time guard requiring `platform` on every non-prelaunch course; and complete the `LeeAtchison` home-page platform cards to all four destinations — [PR #14](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/14) | Closed | 2026-08-29 |
| Spec0012 | Point the pre-launch webinar link at the new /architecting-with-ai URL | Change `prelaunch_url` in `shared/_courses/architecting-systems-with-ai.md` from `/webinar-architecting-systems-with-ai` to `/architecting-with-ai` — one line, rendered by both CTAs on the Academy course page; the file name and therefore `utm_campaign` stay put, and the Kit-side redirect is already in place so there is no merge gate — [PR #15](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/15) | Closed | 2026-08-29 |
| Spec0013 | Correct the course descriptions against their live platform pages | Fix the four course files whose What You'll Learn lists describe a materially different course from the one that shipped (`cloud-architecture-advanced-concepts`, `cloud-migration-fundamentals`, `avoiding-bad-decisions-cloud-strategy`, `cloud-center-of-excellence`), plus bullet-level corrections to six more, the unverifiable Coursera specialization claim, and the "16 video lessons" count; then surface the verified duration/level/updated facts via new front-matter keys and a stat line in both `course.erb` copies, fix the missing `feature_leeatchison` and the un-badged pre-launch cards on the Academy home page, repoint three lesson-deep-link `platform_url`s at their course roots, and correct the 12-courses/22-items counts in `CLAUDE.md` and both builder headers — [PR #16](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/16) | Closed | 2026-08-29 |
| Spec0014 | Add the Risk Management for Scalable Systems course to both sites | Add the new Coursera course to `shared/_courses/`, sort it first on both sites, feature it on Academy (replacing Cloud Migration Fundamentals) and on leeatchison.com (with Cloud Architecture for Scalable Systems), drop the now-inaccurate "companion course" ordinal framing from all three Coursera courses, and correct the stale course counts in four doc files — [PR #17](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/17) | Closed | 2026-08-31 |
| Bug0001 | Netlify skips a site's production build when only shared/ content changes | Add a custom `[build] ignore` command to `LeeAtchison/netlify.toml` and `AtchisonAcademy/netlify.toml` so Netlify's diff-based build-skip check also considers `shared/`, not just each site's own directory — [PR #18](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/18) | Closed | 2026-08-31 |
| Spec0015 | Add the Architecting Scalable Applications and Systems specialization page and rebuild the Academy Featured row | Add the Coursera specialization as a new shared course resource with its own `Coursera Specialization` platform entry, feature it alongside one course per non-Coursera platform (revised during review), rewrite Course 2's sequence paragraph to name its neighbors rather than number itself, and correct the shared-course counts — [PR #19](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/19) | Closed | 2026-08-31 |
| Bug0002 | Netlify deploy-preview ignore command always skips on a new branch | Bug0001's `[build] ignore` command ran from each site's base directory, where its repo-root-relative pathspecs matched nothing — so the diff was always empty and every automatic build in every context (Deploy Previews *and* production) skipped, which is why the earlier `$CACHED_COMMIT_REF` theory and its fix explained nothing; fixed by anchoring the pathspecs with git's `:(top)` magic in `LeeAtchison/netlify.toml` and `AtchisonAcademy/netlify.toml`, verified live on real push-triggered builds in both contexts | Closed | 2026-09-01 |
| Spec0016 | Raise the new courses and the new book on the leeatchison.com home page | Add a new `spotlight_leeatchison` front-matter key (validated in both builders) that decides membership of a new "What's New" band between the hero and the pillars — today *The Software Conductor* and the two Aug 2026 Coursera courses — and rebuild the home page's Courses section from the shared collection in place of its four hardcoded platform cards, which name the specialization wrongly, keeping the `180,000+` stat card and adding the `/courses` and Academy links the section never had — [PR #21](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/21) | Closed | 2026-09-01 |
