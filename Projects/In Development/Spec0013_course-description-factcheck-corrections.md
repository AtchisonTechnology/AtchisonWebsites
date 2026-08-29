# Correct the course descriptions against their live platform pages

* **ID:** Spec0013
* **Status:** Implementing
* **Date Created:** 2026-08-29
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy` (content lives in `shared/_courses/`, read by both)

---

## Problem/Requirement

Spec0010 rewrote the descriptions for all 16 courses in `shared/_courses/`,
and Spec0011 added `platform:` to the four Academy-native ones. The prose that
came out of that work is good. What it was never checked against is the
courses themselves.

A fact-check on 2026-08-29 compared all 16 files against their live platform
pages — LinkedIn Learning course pages and Lee's instructor page read while
signed in, both Coursera pages, and the O'Reilly marketing page plus the
O'Reilly catalog API. Twelve courses are published; four are Academy-native
(two pre-launch, two hidden drafts) and have no live counterpart to check.

The finding: several **What You'll Learn** lists describe a course Lee could
plausibly teach rather than the one that shipped. In three cases the mismatch
is large enough that a visitor who buys on the strength of the page gets
something different. There is also one title that does not match the
platform's, one invented framework, and one specialization claim that a
visitor can disprove in a single click.

This is a trust problem before it is a marketing problem. Every one of these
pages ends in a button that takes money.

### Live facts (verified 2026-08-29)

| Course | Platform | Length | Level | Released / Updated | Rating | Learners |
|---|---|---|---|---|---|---|
| Scalable Availability in Software Architecture | Coursera | ~8 hrs · 5 modules · 14 assignments | Advanced | Updated Apr 2026 | — | — |
| Cloud Architecture for Scalable Systems | Coursera | ~10 hrs · 5 modules · 10 assignments | Advanced | Updated Aug 2026 | — | — |
| Cloud Migration Fundamentals | O'Reilly | 1h 28m · 18 lessons | Beginner (O'Reilly's label) | Jun 2024 | — | — |
| Software Architecture: From Developer to Architect | LinkedIn | 57m | Beginner | Updated Dec 2025 | 4.6 (1,961) | 4,978 likes |
| Cloud Architecture: Advanced Concepts | LinkedIn | 2h 30m · 10 chapters | Advanced | Apr 2025 | 4.7 (82) | — |
| Understanding the Value of Cloud-Native Architecture | LinkedIn | 52m | Intermediate | Apr 2023 | 4.7 (348) | 9,707 |
| Framing Cloud Discussions for the C-Suite | LinkedIn | 1h 1m | Intermediate | Updated Jun 2025 | 4.7 (207) | 8,500 |
| Cloud for Business: Developing a Cloud Center of Excellence | LinkedIn | 48m | Intermediate | Jun 2022 | 4.7 (102) | 5,221 |
| Presenting Cloud Migration Benefits to the C-Suite | LinkedIn | 37m | Intermediate | Nov 2021 | 4.8 (59) | 3,637 |
| Understanding the Impact of a Merger for IT Teams | LinkedIn | 35m | Intermediate | Sep 2022 | 4.7 (78) | 3,235 |
| Avoiding Bad Decisions in Your Cloud Strategy | LinkedIn | 48m | Beginner | Updated Apr 2024 | 4.8 (18) | 2,006 |
| Cloud Careers: From Developer to Architect | LinkedIn | 48m | Beginner | Mar 2023 | 4.7 (42) | — |

All 12 `platform_url`s resolve. Both `prelaunch_url`s resolve, including
Spec0012's new `/architecting-with-ai`. The "Wednesday, September 30" webinar
date on `architecting-systems-with-ai.md` is correct — the registration page
reads "Wednesday, September 30 · 10:00 am Pacific · 30 minutes · Live on
LinkedIn".

### Verified correct, no change needed

- `scalable-availability-software-architecture.md` — title, platform, URL, five
  modules, module topics, Advanced level, ~8 hours, shareable certificate, and
  the audience line ("software architects, operations architects, and aspiring
  architects") all match the live page. Only §2a applies.
- `cloud-architecture-for-scalable-systems.md` — module names match exactly and
  the What You'll Learn bullets are word-for-word the live Coursera
  description. **This file is the model the other fifteen should follow.** Only
  §2a and §2b apply.
- `software-architecture-developer-to-architect.md` — "One of Lee's most popular
  courses" holds up: 4,978 likes and 1,961 ratings, and LinkedIn itself flags
  it *Popular*; his next-highest course has 348 ratings. All five bullets are
  defensible against the chapter list. Only the §1e omission applies.
- `architecting-systems-with-ai.md`, `service-ownership.md` — pre-launch copy is
  honest about being in development, both CTAs resolve, webinar date correct.
- `cloud-cost-architecture.md`, `velocity-safe-architecture.md` — `hidden: true`
  drafts, correctly excluded from production builds by `shared_content.rb`.
  Copy is appropriately non-committal.

---

## Solution/Fix/Change

### §1 — Course-content corrections

Each of these rewrites `summary:`, the **About This Course** paragraphs, and
the **What You'll Learn** bullets of one file in `shared/_courses/`, from the
real chapter list recorded here. No front matter changes except where noted.

#### §1a `cloud-architecture-advanced-concepts.md` — describes a different course

The page promises event-driven design, multi-region and multi-AZ architecture,
service mesh, circuit breakers, bulkheads, chaos testing, cost at scale, and
"designs built for remote-first and hybrid teams."

The live course's ten chapters are:

1. Cloud Types and Structures
2. Microservices
3. Data and Data Management
4. Serverless Computing
5. Cloud Security
6. Constructing a Cloud Infrastructure
7. Managing the Cloud
8. AI and the Cloud
9. The Edge of the Cloud
10. Cloud Sustainability and Green Computing

Not one of the six bullets maps to a chapter. "Remote-first and hybrid teams"
appears nowhere in the course. Meanwhile the page omits the content that
actually sells a cloud architecture course in 2026 — AI and the cloud, edge
computing, sustainability and green computing, serverless, security, data
management.

The `summary:` line is wrong for the same reason, and so is the About section's
"picks up where beginner and intermediate cloud training stops" framing, which
is a positioning claim rather than a description.

This is also Lee's longest and newest LinkedIn course (2h 30m, Apr 2025,
Advanced). The page should say so.

**Change:** rewrite `summary:`, About, and all six bullets from the chapter
list above. Keep the "already past the basics" audience framing — the course
genuinely is labelled Advanced.

#### §1b `cloud-migration-fundamentals.md` — the 6 R's are not in the course

The first bullet reads:

> Choosing the right migration approach for a given workload, from the 6 R's:
> rehost, replatform, repurchase, refactor, retire, retain

None of those seven terms appears anywhere in the course. The actual lesson
list is:

- 1.1 Two Migration Methods · 1.2 Single, Multicloud & Polycloud
- 2.1 What Are KPIs? · 2.2 Determining KPIs · 2.3 Measuring KPIs · 2.4 Baselining KPIs
- 3.1 Migration Architect · 3.2 All-at-Once vs Service-by-Service · 3.3 Inside Out vs Outside In
- 4.1 Cloud-Ready Analysis · 4.2 Data Migration: Part 1 · 4.3 Data Migration: Part 2 · 4.4 Scheduling Your Migration
- 5.1 Risk and Complexity · 5.2 Resource Optimization · 5.3 Cloud Costing · 5.4 Course Conclusion

The course's migration-approach framing is **All-at-Once vs Service-by-Service**
and **Inside Out vs Outside In** — more distinctive than the 6 R's, which every
vendor blog already covers.

Also missing from the page: the KPI module is 4 of 18 lessons and goes
unmentioned; so do the migration-architect role, single/multi/polycloud,
resource optimization, and cloud costing.

**Change:** replace the 6 R's bullet with the two real framings; add bullets for
KPIs and the migration-architect role. Keep the execution-not-strategy framing —
it is correct and it is what distinguishes this from §1c.

#### §1c `avoiding-bad-decisions-cloud-strategy.md` — reframed into a different premise

The page says this covers "the strategic decisions that go wrong before a cloud
migration even starts," and lists provider choice, workload readiness, tracing
strategy to a business objective, and migration-specific risk.

The live course is about mistakes made *while using* the cloud: misunderstanding
security requirements, poorly defining roles, mismanaging cost, underestimating
cloud capabilities, and building a weak cloud team — then the antidotes:
thinking long term, making decisions dynamically, and defining success criteria
up front. Its structure is two content chapters in 48 minutes:

1. Top Bad Decisions to Avoid
2. How to Avoid These Mistakes

Five specific bullets oversell a 48-minute Beginner course.

**Change:** rewrite `summary:`, About, and bullets against the real premise.
Trim to four bullets to match the course's actual scope. Drop the
"before you commit to a migration plan" framing — the course is explicitly for
both migrations and greenfield cloud-native builds.

#### §1d `cloud-center-of-excellence.md` — title does not match the platform

| | |
|---|---|
| Site title | Creating and Leveraging a Cloud Center of Excellence in Your Organization |
| Live title | **Cloud for Business: Developing a Cloud Center of Excellence** |

Anyone who searches the site's title on LinkedIn Learning finds nothing. The
same mismatch means the page cannot rank for the course's own name.

Content: the "approval bottleneck / gate every project has to clear" framing and
the "recognizing the common ways a CCoE fails" bullet are not in the live
description, which covers deciding *whether* a CCoE benefits the organization at
all, typical CCoE organization models, who to include (inclusion and
representation across the business), and measuring success with data analytics.

**Change (decided 2026-08-29):** adopt LinkedIn's title. Set
`title: "Cloud for Business: Developing a Cloud Center of Excellence"` and
**keep the existing slug**, `shared/_courses/cloud-center-of-excellence.md` →
`/courses/cloud-center-of-excellence/`. The slug is still readable, no inbound
link breaks, and no Netlify redirect is needed — which matters, since redirects
are Lee's manual step and not something a spec can carry.

Then correct the About framing (drop the "approval bottleneck / gate every
project has to clear" premise) and the two unsupported bullets.

Note the knock-on: this title is long, and it lands in the `<h1>` on the course
page and in the `<h3>` of every course card on both sites' `/courses` pages and
the Academy home page. Check the card grid at mobile width before calling this
done.

#### §1e Remaining bullet-level corrections

| File | Correction |
|---|---|
| `presenting-cloud-migration-benefits.md` | Drop "Following up after the meeting to keep the decision from stalling" — not in the course; what follows the yes is presenting the migration *plan* and how you'll execute it. Drop "Managing the room during the actual presentation." Add the course's real three lenses: impact on customers, financial considerations, impact on operations. |
| `framing-cloud-discussions-c-suite.md` | Add the organizing principle the page omits — a segment per executive (CFO, CTO, CSO, CIO). Add that the course now includes **AI-powered Role Play**, an interactive CFO-conversation simulation; no other Lee course has this. Drop "vendor dependency" from the objections bullet and drop "a narrative that holds up across more than one meeting" — both unsupported. |
| `understanding-value-cloud-native.md` | The page calls this a pure value/business-case course and says it is "not the implementation patterns covered in Cloud Architecture: Advanced Concepts." The live course *does* cover implementation — designing, constructing, operating and reconfiguring workloads, plus services, microservices and containerization. Fix the contrast line (see §2c) and drop the three unsupported bullets: real costs and organizational change, per-workload evaluation, making the case to a skeptic. At 16,004 bookmarks and 9,707 learners this is Lee's most-saved LinkedIn course and the page undersells it. |
| `understanding-impact-merger-it-teams.md` | Drop "drawn from ones that didn't [go well]" — unsupported. Add company culture and supporting end users through the transition, and how staffing changes; both are explicit in the live description. Soften "changes very little about the code" — the course does cover which tools and systems get impacted. |
| `cloud-careers-developer-to-architect.md` | Live copy distinguishes the cloud architect from other architecture roles and specifically the cloud *developer*; "cloud engineer" is the site's own addition. Cut "portfolio work … and which are noise" down to what is a tips-on-certification-options segment. |
| `software-architecture-developer-to-architect.md` | Optional addition only: the course also covers agile architecture process, dev and ops working together, scale and availability, and closes with how to raise the move with your manager. Nothing on the page is wrong. |

### §2 — Cross-cutting content corrections

#### §2a The Coursera specialization claim — both Coursera files

Both files assert membership in the *Architecting Scalable Systems Like Meta,
Google, and Amazon* specialization — first course and second course
respectively.

Neither live Coursera page shows any specialization. The instructor panel on
both reads "Atchison Technology · 2 Courses · 70 learners." A Coursera search
for that specialization name returns nothing of Lee's.

The sequencing itself is sound and worth keeping. The word "specialization" is
the part a visitor can check and disprove.

**Decided 2026-08-29:** the specialization is **in review with Coursera** — real,
but not yet live and not yet approved. Until it is, both pages use
"companion courses, best taken in this order" and drop the specialization name
entirely. Naming an unapproved specialization is worse than naming none: if
Coursera comes back with a different title, the pages are wrong twice.

Restore the specialization framing — with whatever title Coursera actually
approves — once it is live. That is a one-paragraph change to two files and is
recorded in `_Projects.md` at this spec's archival, so it is not lost while the
review runs.

#### §2b `cloud-architecture-for-scalable-systems.md` — "16 video lessons"

The Course Structure line claims "16 video lessons plus readings, discussion
prompts, and assignments." The live page states 5 modules and 10 assignments;
the video count reads as 15, and "discussion prompts" are not listed anywhere.

**Change:** replace with a count-free line — "five modules of video lessons,
readings, and graded assignments — about 10 hours" — so the page stops carrying
a number that drifts every time the course is updated. (It was updated Aug
2026; the sibling course was updated Apr 2026.)

#### §2c Sibling-course differentiator lines

Three pages define themselves against another course:

- `software-architecture-developer-to-architect.md` → "Unlike Cloud Careers: From Developer to Architect…"
- `understanding-value-cloud-native.md` → "…not the implementation patterns covered in Cloud Architecture: Advanced Concepts"
- `presenting-cloud-migration-benefits.md` → "Where a general communication course teaches the skill…"

The second is now known to be inaccurate in both directions, and the third
depends on §1e landing first. **Re-check all three after §1 is complete** —
these lines are the easiest thing in the set to leave stale.

### §3 — Surface the platform facts on the page

Right now the two Coursera pages carry a Level / Platform / Certificate line
and the other fourteen carry a bare `**Platform:** …`. Every fact needed to fix
that is in the table above.

**Change:**

1. Add optional `duration:`, `level:` and `updated:` front-matter keys, populated
   from the verified table.
2. Render them as one stat line in both copies of `_layouts/course.erb`, beside
   the existing platform badge, omitting any key that is absent.
3. Delete the hand-written `**Level:** … **Platform:** … **Certificate:**` and
   `**Platform:**` footers from the sixteen markdown bodies, so the facts live
   in front matter and render from one place.

The keys are optional and additive: a course without them renders exactly as it
does today, so the four Academy-native files need no changes.

### §4 — Site mechanics found during the audit

| # | Issue | Fix |
|---|---|---|
| 4a | ~~`feature_leeatchison` is set on **zero** courses, so the Featured section on `LeeAtchison/src/courses.erb` never renders.~~ | **No change (decided 2026-08-29).** The empty Featured block is deliberate and reserved for future use. Leave both the block and the unused flag in place. Recorded here so a later audit does not re-flag it as a bug. |
| 4b | `AtchisonAcademy/src/index.erb` lines 88–101 render `course.data.platform` directly, with no `availability == "prelaunch"` branch. `courses.erb` has one. The two pre-launch courses therefore show a plain "Atchison Academy" badge on the home page and look shippable, but "Coming Soon" one click later. | Copy the conditional from `courses.erb` into both card loops in `index.erb`. |
| 4c | Three files point `platform_url` at a specific *lesson* rather than the course landing page: `avoiding-bad-decisions-cloud-strategy`, `cloud-architecture-advanced-concepts`, `cloud-center-of-excellence`. All three resolve today (verified), but a lesson slug or numeric ID can change underneath them, and a signed-out visitor lands in a player rather than the page that sells the course. | Repoint all three at the course root. |
| 4d | `shared/_data/platforms.yml` promises, for Coursera: "Audit the course for free, or enroll for graded assignments and a shareable certificate." Neither live page shows an audit path. | **Confirmed 2026-08-29: audit is gone.** Rewrite the Coursera `access_note` to describe what the pages actually offer — enrollment, Coursera Plus, a free trial, and financial aid — and drop the audit promise. This is a live promise the platform can no longer keep, so it ships with §1 rather than after it. |

### §5 — Documentation drift

Not caused by this work, but found by it and cheap to fix in the same change:

- Root `CLAUDE.md` line 32 says `_courses/ # 12 course resources`. There are **16**.
- Both copies of `plugins/builders/shared_content.rb`, header line 3, say "reads
  all 22 items". It is now **26** (10 books + 16 courses). Root `CLAUDE.md`
  line 56 repeats the same figure.

Spec0009 set `canonical_site` on 22 items; four course files have been added
since. Prefer wording that does not need updating again — "every book and
course" rather than a count.

### §6 — Outside this spec's scope (Lee's own platform actions)

Repo work cannot fix these. Recorded so they are not lost:

1. **`Cloud Careers: From Developer to Architect` is not attributed to Lee on
   LinkedIn Learning.** His instructor page lists **8** courses and this is not
   among them, though the course page itself credits him and the direct URL
   works. It is costing discovery on the one surface where a browsing learner
   would find it. Worth raising with LinkedIn.
2. **The Coursera specialization** (§2a) — *answered 2026-08-29: in review.* The
   remaining action is Lee's: when Coursera approves it, bring the approved
   title back to both course files.
3. ~~The Coursera audit option (§4d)~~ — *answered 2026-08-29: audit is gone.*
   Now in scope as a `platforms.yml` change.

---

## Testing

Content correctness is the point here, so most of the testing is reading, not
running:

1. **Per-file diff review against the live page.** For each of the ten files
   changed in §1–§2, open the live platform page beside the diff and confirm
   every remaining bullet maps to something a visitor would actually get. This
   is the test; nothing automated substitutes for it.
2. `cd <Site> && bin/dev` for both `LeeAtchison` and `AtchisonAcademy` (ports
   3000 + N and 16000 + N in a worktree). Walk `/courses` and all sixteen
   `/courses/:slug/` pages on both sites.
3. Confirm the §3 stat line renders on all twelve published courses and is
   cleanly absent on the four Academy-native ones, at mobile and desktop
   breakpoints.
4. Confirm §4b: the two pre-launch courses show "Coming Soon" on the Academy
   **home page** as well as on `/courses`.
5. Click through every `platform_url` and both `prelaunch_url`s, signed out,
   and confirm each lands on the course's own landing page (§4c).
6. `rake test` in both sites, and a production build of each, to confirm the
   `shared_content.rb` validators still pass — §3 adds front-matter keys and
   those validators reject stray site keys.
7. Confirm the two `hidden: true` drafts stay out of a production build and
   still appear in a deploy preview.

---

## Summary of Steps Needed

1. ~~Resolve the Open Questions below.~~ **All five resolved 2026-08-29.**
2. §1a–§1d — rewrite the four materially wrong files, including the CCoE
   retitle (slug unchanged).
3. §1e — apply the bullet-level corrections to six files.
4. §2a–§2b — fix the specialization claim and the lesson count.
5. §2c — re-check the three sibling-course differentiator lines against the
   rewritten copy.
6. §3 — add `duration:` / `level:` / `updated:` to twelve files, render them in
   both `course.erb` copies, remove the hand-written footers from all sixteen.
7. §4b–§4d — site mechanics. **§4a is deliberately excluded** — the empty
   Featured block stays.
8. §5 — documentation drift in `CLAUDE.md` and both builder headers.
9. Testing pass per above, on both sites.
10. §6 — hand back to Lee as platform actions, not repo work.

---

## Open Questions

*All resolved 2026-08-29. Kept here as the record of what was considered.*

1. ~~**The CCoE title (§1d).**~~ Options were: (a) adopt LinkedIn's title,
   *Cloud for Business: Developing a Cloud Center of Excellence*; (b) keep the
   current title and add a `platform_title:` key rendering "Listed on LinkedIn
   Learning as …"; (c) leave as-is. Recommendation was (b).
   **Decided: (a) — adopt LinkedIn's title, keep the existing slug.** The
   `platform_title:` key is not added; no course currently needs it, and a key
   with one hypothetical future user is a key that rots. See §1d.

2. ~~**The Coursera specialization (§2a).**~~
   **Decided: in review with Coursera** — real but unapproved. Both pages drop
   the specialization name and keep the sequencing until it is live. See §2a.

3. ~~**`feature_leeatchison` (§4a).**~~ Options were: feature the same four the
   Academy features, feature a different set, or drop the block.
   **Decided: none of these — leave it exactly as it is.** The empty Featured
   block is reserved for future use, not an oversight. §4a is struck from
   scope.

4. ~~**The Coursera audit claim (§4d).**~~
   **Decided: audit is gone.** `platforms.yml` is corrected in this spec. See
   §4d.

5. ~~**Scope.**~~ Options were: split §3 into its own spec, split §4–§5 out, or
   keep as one.
   **Decided: keep as one spec.** §3 is what makes the verified facts visible
   to a visitor rather than merely correct in the repo, and §4–§5 are small
   enough that a second spec would cost more overhead than it saves.

---

## History of Updates

**2026-08-29 — Spec created.** Written from a fact-check of all 16 files in
`shared/_courses/` against their live platform pages, performed the same day:
nine LinkedIn Learning course pages plus Lee's instructor page read in a
signed-in browser, both Coursera course pages and the Coursera catalog search,
and the O'Reilly marketing page plus the O'Reilly catalog API. The four
Academy-native courses have no live counterpart and were checked only for
internal consistency and working CTAs.

Three files came through clean and are recorded as such rather than silently
omitted — `scalable-availability-software-architecture.md`,
`cloud-architecture-for-scalable-systems.md` (the model for the rest), and
`software-architecture-developer-to-architect.md`.

§4 and §5 were found incidentally during the audit and are carried here rather
than into `_Projects.md`, on the grounds that §4b and §4c are visitor-facing
today and §5 is two lines. Open Question 5 exists to let that call be reversed.

No status changes and no content changes have been made to any course file;
this spec only records what should change.

**2026-08-29 — All five Open Questions resolved.** Decisions recorded in place
in §1d, §2a, §4a, §4d and the Open Questions section:

- **CCoE title:** adopt LinkedIn's exact title, keep the existing slug. This
  went against the recommendation of adding a `platform_title:` key — the
  simpler call is the right one here, since a key introduced for a single
  hypothetical future course is a key nobody maintains. The cost is a long
  title in the card grid, which §1d now flags for testing.
- **Coursera specialization:** in review, not live. Both Coursera files drop
  the specialization name and keep the sequencing. The restore is deliberately
  *not* left as a dangling TODO in the spec — it goes to `_Projects.md` at
  archival, so it survives this spec closing.
- **`feature_leeatchison`:** no change. The empty Featured block is intentional
  and reserved. §4a is struck rather than deleted, so a future audit sees the
  decision rather than re-finding the "bug".
- **Coursera audit option:** confirmed gone. The `platforms.yml` access note is
  now in scope — it is a live promise the platform can no longer honour, which
  makes it the most urgent single line in this spec.
- **Scope:** one spec, as proposed.

With every Open Question resolved, the spec is implementable. **Status is
unchanged and stays in Spec Development/Refinement** until Lee says to move it.

**2026-08-29 — Superseded working file removed.** The standalone audit,
`Projects/_Course_Description_Factcheck_2026-08-29.md`, was deleted; its
evidence is carried in full by the Problem/Requirement and §1 sections above.

**2026-08-29 — Moved to Implementing.** All Open Questions were already
resolved; Lee gave the explicit go-ahead to move to Implementing and begin
work.
