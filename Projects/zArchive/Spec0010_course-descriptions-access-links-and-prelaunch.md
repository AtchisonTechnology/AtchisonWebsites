# Course descriptions, "get the course" links, pre-launch courses, and a hidden flag

* **ID:** Spec0010
* **Status:** Closed
* **Date Created:** 2026-08-29
* **Date Implemented:** 2026-08-29
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy`, `shared/`
* **PR:** [#13](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/13)

> **Program link.** This spec is the repo half of **PW1** in the Atchison Academy
> `_Program Tracker.md` ("Course descriptions + 'get the course' links"). PW1's two
> scope questions were settled by Lee on 2026-08-29 and are recorded under
> *Open Questions* below. When this spec is archived, PW1's row and next action must
> be updated to match.

---

## Problem/Requirement

The 12 shared course resources under `shared/_courses/` are the weakest content on
either site, in three separate ways.

**1. The descriptions are thin and inconsistent.** Two of the three Coursera courses
(`cloud-architecture-for-scalable-systems`, and to a lesser degree
`scalable-availability-software-architecture`) carry a real description: two-paragraph
positioning, specific learning outcomes, an explicit audience, a *Course Structure*
section, and a closing meta line. The other ten are a generic three-section stub — one
short "About This Course" paragraph, five bullets, one "Who This Is For" sentence — with
no structure, no length, no level, and no sense of what makes that course different from
the two next to it in the grid. The `summary:` values that drive the course cards vary in
length and voice for the same reason.

**2. A reader who wants the course cannot tell how to get it.** Every course page has
exactly one link: a hero button reading **"Take This Course →"** pointing at
`platform_url`. It never says that the destination is a subscription platform, never says
what a subscription costs or whether there is a free trial or free audit, and disappears
above the fold the moment the reader scrolls into the description they were actually
reading. Nine of the twelve courses are LinkedIn Learning, one is O'Reilly, three are
Coursera — all three are subscription platforms with materially different access models,
and the site currently flattens them into one unlabeled button.

This is the gap the books do not have. `shared/_books/*.md` carry both a `book_url` and an
`amazon_url`, and `book.erb` renders them as a two-button group ("Learn More" +
"Buy on Amazon"), so a book page always ends in a place to get the book. Courses need the
same completeness, adjusted for the fact that a course is not bought — it is *reached*
through a subscription.

**3. There is no way to stage an unreleased course.** Four Academy courses are in flight
(`service-ownership`, `cloud-cost-architecture`, `velocity-safe-architecture`,
`architecting-systems-with-ai`). The collections model has no representation for a course
that exists but is not yet purchasable, and no way to hold a finished page in the repo,
review it on a dev server, and ship it later. Today the only choices are "publish it" or
"do not write it," which is why none of the four has a page and why the AI webinar — a
live, public registration page with a hard date of **Wed 2026-09-30** — is reachable from
Kit and LinkedIn but from neither website.

---

## Solution/Fix/Change

Five changes, all additive. No existing key changes meaning, and every course that is not
edited renders exactly as it does today.

### 1. Platform access data — `shared/_data/platforms.yml`

Access facts are properties of the *platform*, not of the course, and repeating them
across nine LinkedIn Learning files guarantees drift. Add a single data file at
`shared/_data/platforms.yml`, reached from each site by the same symlink pattern
Spec0008 established for the collections:

```
AtchisonAcademy/src/_data/platforms.yml -> ../../../shared/_data/platforms.yml
LeeAtchison/src/_data/platforms.yml     -> ../../../shared/_data/platforms.yml
```

Keyed by the exact string used in each course's `platform:` field:

```yaml
"LinkedIn Learning":
  access_note: "Available exclusively on LinkedIn Learning, and included with a LinkedIn Learning subscription."
  info_url:    "https://www.linkedin.com/learning/subscription/products"
  info_label:  "LinkedIn Learning pricing & free trial"
  cta_label:   "Get the Course on LinkedIn Learning"

"Coursera":
  access_note: "Available exclusively on Coursera. Audit the course for free, or enroll for graded assignments and a shareable certificate."
  info_url:    "https://www.coursera.org/courseraplus"
  info_label:  "Coursera pricing & Coursera Plus"
  cta_label:   "Get the Course on Coursera"

"O'Reilly Media":
  access_note: "Available exclusively on the O'Reilly learning platform, and included with an O'Reilly subscription."
  info_url:    "https://www.oreilly.com/online-learning/pricing"
  info_label:  "O'Reilly pricing & free trial"
  cta_label:   "Get the Course on O'Reilly"

"Atchison Academy":
  access_note: "Offered directly through Atchison Academy."
  info_url:    ~
  info_label:  ~
  cta_label:   "Get the Course"
```

Any of the four values may be overridden per course by an optional front-matter key of the
same name (`access_note:`, `info_url:`, `info_label:`, `cta_label:`). A course whose
`platform:` is not a key in this file falls back to today's generic
`"Take This Course →"` and emits **no** access note — an unknown platform must not
produce a wrong claim about how to get the course.

⚠️ **The three outbound pricing URLs are the only externally-owned links this repo will
carry besides the books' Amazon links.** They live in one file precisely so a dead link is
one edit, not twelve.

### 2. Course layout — access note, and a closing CTA

`course.erb` (identical in both sites) gains three things:

- **Hero, under the existing button:** the platform's `access_note` as a single line of
  small type, followed by the `info_url` rendered as a plain text link labelled
  `info_label`. The hero button's text becomes `cta_label`.
- **A closing CTA block after `yield`,** before the "More Courses by Lee" strip: the
  course title, the access note, the primary button (`cta_label`), and the info link.
  This is the button Lee asked for — the reader who has just finished the description
  should not have to scroll back up.
- Both buttons keep `target="_blank" rel="noopener noreferrer"`.

New CSS (`.course-cta`, `.course-access-note`, `.course-access-link`, and the pre-launch
classes below) goes into `frontend/styles/index.css`. ⚠️ **Per each site's CLAUDE.md, the
two `index.css` files are kept byte-identical — the same rules must be added to both.**

### 3. Pre-launch courses

A new front-matter key on a course resource:

```yaml
availability: prelaunch      # default when absent: "available"
prelaunch_url:      "https://softwarearchitectureinsights.com/webinar-architecting-systems-with-ai"
prelaunch_cta:      "Save Your Seat — Free Live Webinar"
prelaunch_note:     "This course is in development. The ideas behind it get their first public airing in a free live webinar on Wednesday, September 30."
```

When `availability: prelaunch`:

- The platform badge is replaced by a **"Coming Soon"** pill, on the detail page hero and
  on the course card in both `courses.erb` grids and the "More Courses" strip.
- `prelaunch_note` renders where the access note would be.
- Both the hero button and the closing CTA point at `prelaunch_url` with the text
  `prelaunch_cta`.
- `platform_url` is ignored if present, and **no** platform access note is emitted — a
  course nobody can take yet must never carry a "how to subscribe" line.

**Validation, in `shared_content.rb`, in the fail-loud style the builders already use:**

- `availability:` may only be `available` or `prelaunch`.
- `availability: prelaunch` **requires** both `prelaunch_url` and `prelaunch_cta`, and
  **forbids** `platform_url`. A "Coming Soon" page with no destination is the failure this
  spec exists to prevent, so it fails the build rather than rendering a dead end.
- `availability: available` forbids all three `prelaunch_*` keys.

**Per Lee (2026-08-29): pre-launch courses are Academy-only.** They carry
`show_academy: true` and `canonical_site: academy`, and never `show_leeatchison`.
`leeatchison.com` continues to list only shipped courses.

#### 3a. UTM tagging on pre-launch links

*Added 2026-08-29 per Lee: the pre-launch link exists to feed the validation analysis, so a
click arriving from a course page must be distinguishable from one arriving from Kit,
LinkedIn or the newsletter.*

`prelaunch_url` stores the **clean** URL, with no query string. The layout appends the UTM
parameters at render time, because the same stored URL is rendered in two places on
(potentially) two sites and hardcoding them in front matter cannot express that:

| Parameter | Value | Source |
|---|---|---|
| `utm_source` | `atchisonacademy.com` / `leeatchison.com` | the builder's own `SITES[SITE_KEY][:url]` host — **not** a fourth hardcoded copy of the domain |
| `utm_medium` | `course-page` | constant |
| `utm_campaign` | `<resource-slug>-prelaunch`, e.g. `service-ownership-prelaunch` | the resource slug |
| `utm_content` | `hero` or `footer` | which of the two buttons was clicked |

So the diagnostic link in the closing CTA on the Academy course page resolves to:

```
https://softwarearchitectureinsights.com/service-ownership-diagnostic
  ?utm_source=atchisonacademy.com&utm_medium=course-page
  &utm_campaign=service-ownership-prelaunch&utm_content=footer
```

Implemented as one small helper — take the stored URL, merge the four parameters into any
query string already present rather than blindly appending `?`, and return it. Front matter
stays clean and unambiguous, and the two buttons can never disagree about their tagging.

**Platform links are deliberately *not* UTM-tagged.** Coursera, LinkedIn Learning and
O'Reilly report nothing back to Lee, so the parameters would be noise on a URL a reader
may well copy and share.

> ⚠️ **The repo half of this is inert without a Kit change — verified 2026-08-29.**
> Both `prelaunch_url` destinations are Kit landing pages, and the Kit account has **no
> UTM custom fields**: its 21 fields are `job_title`, `company`, `role`, `webinar_question`,
> `site_interest`, `referred`, the nine `rh_*` referral fields, and the rest. Nothing
> captures a query parameter today. As things stand the UTMs would reach the landing page
> and be dropped at submit, so the *responder log* — which is the analysis Lee asked these
> parameters to serve — would still not show which arrivals came from a course page.
> Closing that needs `utm_source` and `utm_campaign` custom fields plus hidden inputs on
> both forms. **That is Kit work, outside this repo — see Open Question 1.**

### 4. The `hidden:` flag — books and courses

`hidden: true` on any resource in either shared collection keeps the file in the repo and
in the dev site, and removes it from the production build entirely.

Implemented in `shared_content.rb` as one more `select!` at `post_read`, alongside the
existing `show_*` filter. Because that filter runs before anything reads the collection,
one line removes the item from every surface at once: its `/courses/:slug/` or
`/books/:slug/` page is never generated, and it vanishes from both index grids, the
"More Courses" strip, and the sitemap. That is the same mechanism the `show_*` flags
already rely on, and it is why no template needs a `hidden` check.

**Visibility rule (proposed — see Open Question 1):**

| Build | `BRIDGETOWN_ENV` | `CONTEXT` | Hidden items |
|---|---|---|---|
| `bin/dev` / local build | development | unset | **shown** |
| `rake test` | test | unset | **shown** |
| Netlify deploy preview | production | `deploy-preview` | **shown** |
| Netlify branch deploy | production | `branch-deploy` | hidden |
| Netlify production | production | `production` | **hidden** |

i.e. drop when `Bridgetown.env.production?` **and** `ENV["CONTEXT"] != "deploy-preview"`.

⚠️ **Deploy previews are the load-bearing case.** Spec0004 deliberately made previews
build exactly like production, so a naive `production?` check would make a hidden course
invisible on the one URL Lee could use to review it before shipping. Netlify serves
previews with an automatic `noindex` header, so a hidden item on a preview is not
indexable. Branch deploys get **no** such header, which is why they are on the hidden side
of the line.

Validation of `canonical_site`, `show_*` and `availability` runs **before** the hidden
filter, so a hidden item's front matter is still checked on every production build. A
draft cannot rot into an invalid state while nobody is looking at it.

### 5. Rewrite all 12 existing descriptions

Every file in `shared/_courses/` is brought to the shape
`cloud-architecture-for-scalable-systems.md` already demonstrates:

| Section | Requirement |
|---|---|
| `summary:` (front matter) | One sentence, ≤ 180 characters, specific enough to distinguish it from its neighbors in the grid. Drives every course card. |
| **About This Course** | Two paragraphs. First: the problem the course addresses and the angle Lee takes on it. Second: where it sits relative to his other work — series position, prerequisite, or what it deliberately is not. |
| **What You'll Learn** | 5–7 outcomes, each a capability the reader gains, not a topic the course covers. |
| **Who This Is For** | Named roles, plus what the course assumes the reader already has. |
| **Course Structure** | Module and lesson counts, format, and approximate runtime. **Currently present on only 3 of 12 and is the single biggest gap.** |
| Closing meta line | `**Level:** … • **Platform:** … • **Certificate:** …` |

> ### ⚠️ No invented facts — Lee, 2026-08-29
>
> **Lesson counts, module counts, runtimes, levels, certificate availability and learner
> numbers are facts, and every one of them must come from a source.** The permitted
> sources are the platform's own public course page, the repo, and the Academy course
> folder. Nothing may be estimated, interpolated from a sibling course, inferred from a
> module count, or rounded into a claim.
>
> **Where a fact cannot be sourced, the sentence containing it is dropped and the
> Course Structure section is omitted for that course.** An inconsistent template across
> the twelve is the correct outcome; a plausible invented runtime is not. The same rule
> governs the closing meta line — omit `**Level:**` rather than guess a level.
>
> This applies equally to the four pre-launch pages, where there is no platform page to
> read and correspondingly little that can truthfully be said.

⚠️ Write in Lee's voice (`lees-voice` skill), and check the result (`lees-voice-checker`).
The existing Coursera descriptions are the in-repo reference for tone.

### 6. Create the four pre-launch course files

New files under `shared/_courses/`, Academy-only, all four created in this spec:

| File | Title | `hidden:` | Destination |
|---|---|---|---|
| `architecting-systems-with-ai.md` | Architecting Systems That Use AI | **false — public** | Webinar: `https://softwarearchitectureinsights.com/webinar-architecting-systems-with-ai` (verified live) |
| `service-ownership.md` | Service Ownership and Criticality at Scale | **false — public** | Diagnostic: `https://softwarearchitectureinsights.com/service-ownership-diagnostic` (verified live) |
| `cloud-cost-architecture.md` | Cloud Cost Architecture | **true** | none yet |
| `velocity-safe-architecture.md` | Velocity-Safe Architecture | **true** | none yet |

Per Lee (2026-08-29): all four files exist, the two with a live public destination ship,
the two without stay hidden until they have somewhere to send a reader.

⚠️ **These four courses are in Phase 1 — Validate, and three of them are ungreenlit.**
Their pages must not describe an outline that has not been approved. See Open Question 2.

---

## Testing

**Build-level, both sites:**

1. `bin/bridgetown build` in `AtchisonAcademy` and `LeeAtchison` — both clean.
2. `rake test` (BRIDGETOWN_ENV=test) in both — both clean, hidden items present.
3. **Deliberately break each new validation rule** and confirm the build fails with a
   readable message naming the file and the key: `availability: soon`;
   `prelaunch` with no `prelaunch_url`; `prelaunch` alongside `platform_url`;
   `prelaunch_cta` on an `available` course. Restore after each.
4. Confirm the Spec0009 canonical rules still fail correctly on a hidden item — proving
   validation runs before the hidden filter.

**Hidden-flag matrix** — build and grep `output/` for each row of the table in §4:

- dev build → `output/courses/cloud-cost-architecture/index.html` **exists**, appears in
  `output/courses/index.html` and in `output/sitemap.xml`.
- `BRIDGETOWN_ENV=production` with `CONTEXT` unset → the directory **does not exist**, and
  the slug appears nowhere in `output/` — index grids, "More Courses" strips and sitemap
  included. ⚠️ Grep the whole tree, not just the sitemap.
- `BRIDGETOWN_ENV=production CONTEXT=deploy-preview` → present again.

**Visual, on both dev servers** (`AtchisonAcademy` :16000, `LeeAtchison` :3000):

- One course per platform (LinkedIn Learning, Coursera, O'Reilly): correct access note,
  correct CTA label in both hero and closing block, both buttons open the right URL in a
  new tab, info link points at the right pricing page.
- A pre-launch course: "Coming Soon" pill on the detail hero, on its card in the grid, and
  in the "More Courses" strip; both buttons hit the webinar/diagnostic URL.
- `leeatchison.com` shows **12** courses and no "Coming Soon" anywhere.
- `atchisonacademy.com` shows its `show_academy` set **plus the two public pre-launch
  courses**, and neither hidden one.
- Closing CTA renders correctly at mobile width.

**UTM check:**

- Both pre-launch buttons on both sites carry all four parameters, with `utm_content`
  differing between hero and footer and `utm_source` matching the site actually serving
  the page.
- `prelaunch_url` values in front matter contain **no** query string.
- Add a temporary `?foo=bar` to a `prelaunch_url` and confirm the helper merges rather
  than producing a second `?`. Remove after.
- Submit the diagnostic form from a UTM-tagged link and check the resulting Kit subscriber
  record — this is the test that proves whether step 11 has actually been done.

**Fact check (§5):** before the PR, every module count, lesson count, runtime, level and
certificate claim across all 16 course files is checked against its named source. Anything
without one is deleted, not softened.

**Link check:** every `platform_url`, every `info_url`, and both `prelaunch_url`s resolve
200 by hand before the PR.

---

## Summary of Steps Needed

1. Create `shared/_data/platforms.yml`; add the two symlinks; verify both dev servers pick
   the file up and that `netlify.toml`-driven builds resolve it (Spec0008 proved the
   pattern for collections, not for `_data`) — **verify this first, it gates §1**.
2. Extend `shared_content.rb` in **both** sites: `availability` validation, the
   `prelaunch_*` rules, and the `hidden:` filter with the CONTEXT-aware production test.
   ⚠️ The two copies are hand-synced — diff them when done.
3. Update `course.erb` in both sites: access note + info link in the hero, `cta_label` on
   the hero button, the closing CTA block, and the pre-launch branch.
3a. Add the UTM helper (§3a) and apply it to both pre-launch buttons, deriving
   `utm_source` from the builder's own site URL rather than a new hardcoded domain.
4. Update `courses.erb` in both sites and the "More Courses" strip: "Coming Soon" pill in
   place of the platform badge for pre-launch courses.
5. Add the new CSS to both `frontend/styles/index.css` files, identically.
6. Gather per-course structure data from each platform's public course page — recording,
   per course, which facts were sourced and which could not be. ⚠️ **Omit, never
   estimate** (§5).
7. Rewrite all 12 descriptions and `summary:` values to the §5 shape.
8. Write the four pre-launch course files, two public and two `hidden: true`.
9. Run the full test plan above.
10. Update PW1's row and next action in the Academy `_Program Tracker.md`.
11. **Kit, outside this repo:** create the `utm_source` / `utm_campaign` custom fields and
    add hidden capturing inputs to the `service-ownership-diagnostic` and
    `webinar-architecting-systems-with-ai` forms, so the UTMs survive to the responder
    log. Without this, step 3a is decorative — see Open Question 1.

---

## Open Questions

**1. Kit-side UTM capture — who creates the fields, and when?** *(New, 2026-08-29.)*
Verified against the live Kit account on 2026-08-29: there is **no** `utm_source`,
`utm_campaign` or equivalent custom field, and nothing on either form captures a query
parameter. The UTMs this spec adds will therefore reach the landing page and be discarded
at submit, so the responder log — the analysis Lee asked for — still will not show which
arrivals came from a course page. Closing it needs two custom fields plus a hidden input
on each of the two forms. *Proposed (not decided):* do the Kit half **before** the
`service-ownership` page ships, since its gate reads ~Sept 15–22 and an untagged arrival
cannot be re-attributed afterwards. ⚠️ **Time-sensitive. Lee's call, and Lee's Kit
account — this spec cannot do it.**

---

### Answered

- ✅ **Which surfaces does PW1 cover?** — `leeatchison.com` and `atchisonacademy.com`, i.e.
  the 12 shared course resources plus the new pre-launch files. *(Lee, 2026-08-29)*
- ✅ **Where do pre-launch courses appear?** — **Academy only.** `show_academy` +
  `canonical_site: academy`; never `show_leeatchison`. *(Lee, 2026-08-29)*
- ✅ **What do pre-launch courses link to?** — the waitlist / diagnostic / webinar
  associated with the course, via `prelaunch_url`. *(Lee, 2026-08-29)*
- ✅ **Which pre-launch courses now?** — all four files created; the two with a live public
  destination ship, `cloud-cost-architecture` and `velocity-safe-architecture` are
  `hidden: true`. *(Lee, 2026-08-29)*
- ✅ **How explicit is the access info?** — an access note stating the platform exclusivity
  plus a link to that platform's pricing / free-trial page. Not a full "how to get this
  course" section. *(Lee, 2026-08-29)*
- ✅ **Hidden items on deploy previews?** — **Yes, shown.** Drop only when
  `Bridgetown.env.production?` **and** `ENV["CONTEXT"] != "deploy-preview"`, per the table
  in §4. Branch deploys stay hidden, since unlike previews they carry no automatic
  `noindex`. *(Lee, 2026-08-29)*
- ✅ **How much may a pre-launch page claim?** — **About This Course and Who This Is For
  only.** No "What You'll Learn", no Course Structure, no module or lesson counts. Nothing
  on the website hardens a scope decision the gate has not licensed. *(Lee, 2026-08-29)*
- ✅ **Does publishing `service-ownership` during its gate window affect the read?** — Not
  a concern. **The page ships, and its pre-publish link points at the diagnostic** so that
  interested readers feed the analysis rather than bypassing it, **with clear UTMs** —
  mechanism in §3a. *(Lee, 2026-08-29)*
- ✅ **Where does per-course structure data come from?** — **Public information, and
  nothing else.** Take whatever each platform's public course page yields; where a fact
  cannot be sourced, omit it. ⚠️ **Nothing may be invented** — the rule is written into §5
  as a build-blocking editorial constraint, not a preference. *(Lee, 2026-08-29)*
- ✅ **Who retires the AI webinar CTA after 2026-09-30?** — Folded into the post-webinar
  task scope (**W7.7**), alongside the evergreen recording swap that already targets the
  same page. ⚠️ **Retire is the wrong default: Lee expects the pre-launch CTA to keep its
  value after the event** — a recording plus slides is still a real destination for a
  course page, and the registrations still count toward the gate under C28. So W7.7 revises
  `prelaunch_cta` and `prelaunch_note` to evergreen wording rather than removing the block.
  *(Lee, 2026-08-29)*

## History of Updates

**2026-08-29 (implementation) — Steps 1–9 done; steps 10–11 need Lee.**

All five changes from the Solution section are implemented on both sites:

- `shared/_data/platforms.yml` created and symlinked into both sites at
  `src/_data/platforms.yml`, exactly as specified. Verified `site.data.platforms`
  resolves correctly through the symlink in both dev builds.
- `shared_content.rb` extended in both copies (kept in sync by hand, per the
  existing convention): `availability`/`prelaunch_*` validation, the `hidden:`
  filter with the `CONTEXT`-aware production test, and the `prelaunch_cta_url`
  template helper for UTM tagging (merges into the four params into the stored
  clean URL at render time, deriving `utm_source` from the builder's own `SITES`
  entry).
- `course.erb` updated identically in both sites: hero access note + info link,
  `cta_label` on both buttons, the closing CTA block, and the pre-launch
  "Coming Soon" branch (badge, note, both buttons retargeted, no access note).
  `courses.erb`'s grid cards and the "More Courses" strip also show the
  "Coming Soon" pill in place of the platform badge.
- New CSS added identically to both `frontend/styles/index.css` files (the new
  blocks only — the two files were already non-identical before this spec, per
  AtchisonAcademy's own CLAUDE.md, so "byte-identical" was read as "the same
  new rules," not a retroactive merge of the pre-existing divergence).
- All 12 existing course files rewritten to the target shape. The `hidden:`
  flag and the four new pre-launch files are implemented per §3–§6.

**All four validation rules, the hidden-flag matrix (dev/production/deploy-preview/
branch-deploy), the canonical-runs-before-hidden check, both `rake test` builds,
the UTM merge (including the no-double-`?` case), and the visual rendering on
both dev servers (desktop and mobile, one course per platform plus a pre-launch
course) were all verified working exactly as specified — see the Testing
section for what each check confirmed.**

Two things could not be completed in this implementation session and need
Lee or a network-enabled session before this ships:

1. **§5's fact check, and the Testing section's link check, were not possible.**
   This session's network egress is blocked entirely to linkedin.com,
   coursera.org, and oreilly.com (and to softwarearchitectureinsights.com, so
   even the two pre-launch destination URLs could not be re-verified here,
   though the spec already verified them live on 2026-08-29). Per §5's own
   rule — omit a fact rather than invent it — the rewritten descriptions for
   the 10 non-Coursera courses carry no Course Structure section and no
   Level/Certificate line; only **Platform:** (a front-matter fact, not a
   platform-page fact) appears in their closing line. `scalable-availability-software-architecture.md`
   keeps its pre-existing Course Structure line untouched, since that content
   predates this session and this session has no way to re-verify or
   contradict it. Before the PR: source Course Structure/Level/Certificate
   facts for the 10 courses from each platform's public page (or confirm they
   should ship without one), and hand-verify that `platform_url`, `info_url`,
   and both `prelaunch_url`s resolve 200.
2. **Step 10 (updating PW1's row in the Academy `_Program Tracker.md`) was not
   done.** That tracker lives outside this repo and this session has no access
   to it.

Also worth flagging: the pre-existing `cloud-architecture-for-scalable-systems.md`
summary is 203 characters (over the 180-character target in §5) and uses an em
dash. It was left untouched since the spec names it as the in-repo reference
this rewrite matches everything else to — but if Lee wants it trimmed to be
consistent with the other 11, that's a one-line fix.

Not yet done, deliberately: the branching-mode question (worktree vs. direct
branch) wasn't asked, since this implementation ran on the branch this remote
session was already given rather than a `spec-bug-process` worktree. No commit
or push has been made — that needs explicit go-ahead per the process rules.

**2026-08-29 — Spec created.** Written from PW1 in the Atchison Academy
`_Program Tracker.md` ("Course descriptions + 'get the course' links", Lee 2026-08-26),
whose recorded next action was to settle two scope questions before inventorying the
catalog. Both were settled the same day and are recorded under *Answered* above.

Inventory taken before drafting: 12 course resources in `shared/_courses/` — 9 LinkedIn
Learning, 2 Coursera + 1 more Coursera, 1 O'Reilly Media — read by `LeeAtchison` and
`AtchisonAcademy` through the Spec0008 symlinks and filtered by the `show_*` flags. All 12
share one `course.erb`, duplicated verbatim between the two sites, whose only outbound link
is a single hero button.

Design decisions taken while drafting:

- **Platform facts in a data file, not in front matter.** Nine of twelve courses are
  LinkedIn Learning; putting the same access note and pricing URL in nine files
  guarantees they drift apart. `shared/_data/platforms.yml` behind the symlink pattern
  keeps it to one copy, matching what Spec0008 did for the collections themselves.
  Per-course override keys are still allowed for the exceptions.
- **`availability:` as an enum rather than a boolean `coming_soon:`.** An enum leaves room
  for a future `retired` state without a second flag, and reads correctly in the
  validation error messages.
- **A missing pre-launch destination fails the build.** The entire point of the pre-launch
  state is to give a reader somewhere to go; a "Coming Soon" page with a dead end is worse
  than no page. This matches the fail-loud posture Spec0009's `canonical_site` validation
  already established.
- **`hidden:` filters at `post_read`, not in templates.** Spec0008's builder comment is
  explicit that a resource left in the collection generates its own page and sitemap entry
  regardless of what any template renders. Filtering in the same place as the `show_*`
  flags means one `select!` covers the detail page, both index grids, the "More Courses"
  strip and the sitemap.
- **Hidden is keyed on `CONTEXT`, not on `BRIDGETOWN_ENV` alone.** Spec0004 made deploy
  previews build exactly like production, so an env-only check would hide drafts from the
  one URL that exists to review them. Branch deploys stay on the hidden side because,
  unlike previews, they get no automatic `noindex`.
- **Pre-launch courses are Academy-only** *(Lee)*, which also keeps them out of
  Spec0009's two-site canonical machinery entirely — a single-site item with
  `canonical_site: academy` is already valid under the existing rules, so no change to
  Spec0009's contract is needed.

Both destination URLs were verified live on 2026-08-29 before being written into this
spec, as were the three platform pricing URLs.

**Deliberately out of scope:** the books' own descriptions (only the `hidden:` flag reaches
`shared/_books/`); any change to the Academy or LeeAtchison home pages; and the PW2
website page designs, which are tracked separately in the program tracker.

**2026-08-29 (later the same day) — all five open questions answered by Lee; spec revised.**

- **Deploy previews show hidden items** (OQ1), confirming the `CONTEXT`-aware rule over a
  plain `production?` check.
- **Pre-launch pages carry About + Who only** (OQ2), as proposed.
- **UTMs added — a new requirement, not just an answer** (OQ3). Lee is not concerned about
  the gate-window question as asked, but redirected the point: the pre-launch link should
  feed the analysis, so it must be attributable. Added §3a. The design decision worth
  recording is that the UTMs are **composed at render time from the stored clean URL**
  rather than baked into front matter — one `prelaunch_url` is rendered by two buttons on
  up to two sites, and only a render-time helper can vary `utm_source` and `utm_content`
  correctly. `utm_source` is derived from the builder's existing `SITES` registry so this
  spec adds no fourth hardcoded copy of either domain.
- ⚠️ **Checked the Kit account rather than assuming, and found the gap:** no UTM custom
  field exists and neither form captures query parameters, so the tags would be dropped at
  submit and the responder log would gain nothing. Raised as the spec's only remaining open
  question, and flagged time-sensitive against the ~Sept 15–22 gate read. Deliberately
  **not** silently scoped into this spec — it is Kit configuration, outside this repo.
- **No invented facts** (OQ4) is recorded in §5 as a hard editorial constraint with an
  explicit omit-don't-estimate rule and a pre-PR fact check, rather than as guidance. It
  reaches the pre-launch pages too, where there is no platform page to read.
- **The webinar CTA goes into W7.7's scope** (OQ5), but with the framing corrected: Lee
  expects the pre-launch CTA to retain value after Sept 30, so W7.7 **revises** the CTA
  copy to evergreen wording rather than retiring the block. The URL itself already survives
  via W7.7's existing recording-and-slides swap.

**2026-08-29 (closed) — PR [#13](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/13)
merged; spec archived.** Lee reviewed the implementation and approved it as-is. The two
items noted as outstanding in the previous entry remain genuinely outstanding, not
resolved by closing this spec:

- The Course Structure/Level/Certificate fact check for the 10 non-Coursera courses
  (§5) still needs a pass with real access to linkedin.com, coursera.org, and
  oreilly.com — this session's network egress was blocked to all three throughout,
  including after Lee attempted to grant access, and he chose to skip chasing it
  further rather than block the merge on it.
- **PW1's row and next action in the Academy `_Program Tracker.md` still need updating**
  to match, per the Program link callout at the top of this file — that tracker is
  outside this repo and nothing in this session could reach it.
