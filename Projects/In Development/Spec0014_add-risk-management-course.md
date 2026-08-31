# Add the Risk Management for Scalable Systems course to both sites

[PR #17](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/17)

* **ID:** Spec0014
* **Status:** Verifying
* **Date Created:** 2026-08-31
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** `LeeAtchison`, `AtchisonAcademy` (content lives in `shared/_courses/`, read by both)

---

## Problem/Requirement

*Risk Management for Scalable Systems* is live on Coursera
(`https://www.coursera.org/learn/risk-management-for-scalable-systems`) and is
the third Coursera course, alongside *Scalable Availability in Software
Architecture* and *Cloud Architecture for Scalable Systems*. Neither
leeatchison.com nor atchisonacademy.com knows it exists.

It is the newest course and the one Lee most wants in front of visitors, so it
needs to be:

1. Added as a new resource in `shared/_courses/`, shown on **both** sites.
2. **First in sort order on both sites** (`order_leeatchison: 1`,
   `order_academy: 1`), which pushes every existing course down.
3. **Featured on Atchison Academy** (`feature_academy: true`), replacing
   *Cloud Migration Fundamentals* (O'Reilly Media) in the featured set, so the
   Academy featured count stays at four.
4. **Featured on leeatchison.com** (`feature_leeatchison: true`), together with
   *Cloud Architecture for Scalable Systems* — which brings that site's
   deliberately-empty Featured block into use for the first time.

Adding it also makes two existing statements wrong, which is why this is more
than one new file:

- `shared/_courses/cloud-architecture-for-scalable-systems.md` opens its About
  section with *"This is the second of two companion courses"*, and
  `scalable-availability-software-architecture.md` with *"the first of two"*.
  With three Coursera courses live, both are false.
- The course counts written into `CLAUDE.md`, `AtchisonAcademy/CLAUDE.md` and
  the two site READMEs all say 16 shared courses / 12 Academy courses. Adding
  one makes those 17 and 13. (`AtchisonAcademy/README.md` is separately stale —
  it still says 12 shared and 8 Academy, from before Spec0010's four Academy-
  native additions.)

Page copy for the new course is already written, voice-audited, and
fact-checked against the live Coursera page on 2026-08-31. It lives in Dropbox
at `Coursera/Courses/Risk Management for Scalable Systems/_Academy Page.md` and
is the source of truth for everything in the Solution section below.

---

## Solution/Fix/Change

### 1. New file: `shared/_courses/risk-management-for-scalable-systems.md`

Front matter, matching the shape of the other two Coursera courses:

```yaml
---
layout: course
title: "Risk Management for Scalable Systems"
platform: Coursera
platform_url: "https://www.coursera.org/learn/risk-management-for-scalable-systems"
show_leeatchison: true
order_leeatchison: 1
feature_leeatchison: true
show_academy: true
order_academy: 1
feature_academy: true
canonical_site: academy
duration: "~12 hrs · 6 modules · 12 assignments"
level: "Advanced"
updated: "Aug 2026"
summary: "Risk as a portfolio you manage on purpose. Build a matrix for your own systems, then use it to win the arguments that decide the roadmap."
---
```

Notes on the front-matter choices:

- `canonical_site: academy` follows the Spec0009 assignment rule — Coursera
  courses are canonically Academy pages. The item is on both sites, so this key
  is mandatory; the builder fails the build without it.
- `platform: Coursera` already resolves in `shared/_data/platforms.yml` to the
  exact access note, info link and CTA label the Dropbox draft specifies, so the
  hero enrollment note and the closing CTA come out right with no data change.

Body, from the Dropbox draft, in the four `##` sections the `course` layout
expects (`About This Course`, `What You'll Learn`, `Who This Is For`,
`Course Structure`). Three points of care:

- The hero eyebrow, meta line, H1, button, enrollment note and the repeat CTA
  block in the draft are all **rendered by `course.erb`** from front matter and
  `platforms.yml`. Do not write them into the body; they would render twice.
- The Dropbox draft's card description has two variants. Use the **em-dash-free**
  one (quoted above as `summary:`), matching Lee's voice rules, even though the
  neighbouring cards on the index still use em dashes.
- The draft's About section says *"This is the third course in the
  specialization, following …"*. That is ordinal framing, which §4 below
  removes from the other two courses — so it comes out of this file too, in the
  same pass and in the same style. See §4.

### 2. Re-sort every existing course

`order_leeatchison` — dense today (1–12); increment all twelve by one so the
new course takes 1:

| File | old | new |
|---|---|---|
| `cloud-architecture-for-scalable-systems` | 1 | 2 |
| `scalable-availability-software-architecture` | 2 | 3 |
| `software-architecture-developer-to-architect` | 3 | 4 |
| `cloud-migration-fundamentals` | 4 | 5 |
| `avoiding-bad-decisions-cloud-strategy` | 5 | 6 |
| `cloud-architecture-advanced-concepts` | 6 | 7 |
| `cloud-careers-developer-to-architect` | 7 | 8 |
| `cloud-center-of-excellence` | 8 | 9 |
| `framing-cloud-discussions-c-suite` | 9 | 10 |
| `presenting-cloud-migration-benefits` | 10 | 11 |
| `understanding-impact-merger-it-teams` | 11 | 12 |
| `understanding-value-cloud-native` | 12 | 13 |

`order_academy` — already sparse (1–6, 9, 11–15; the gaps are courses not shown
on Academy). Increment all twelve by one, **preserving the existing gaps**
(decided 2026-08-31):

| File | old | new |
|---|---|---|
| `cloud-architecture-for-scalable-systems` | 1 | 2 |
| `scalable-availability-software-architecture` | 2 | 3 |
| `software-architecture-developer-to-architect` | 3 | 4 |
| `cloud-migration-fundamentals` | 4 | 5 |
| `avoiding-bad-decisions-cloud-strategy` | 5 | 6 |
| `cloud-architecture-advanced-concepts` | 6 | 7 |
| `framing-cloud-discussions-c-suite` | 9 | 10 |
| `understanding-impact-merger-it-teams` | 11 | 12 |
| `architecting-systems-with-ai` | 12 | 13 |
| `service-ownership` | 13 | 14 |
| `cloud-cost-architecture` (hidden) | 14 | 15 |
| `velocity-safe-architecture` (hidden) | 15 | 16 |

Sort keys are only ever compared, never displayed, so the gaps cost nothing.

### 3. Featuring

**On Atchison Academy** — remove `feature_academy: true` from
`shared/_courses/cloud-migration-fundamentals.md`. Its `show_academy` and
`order_academy` stay; it simply moves from the *Featured Courses* grid into
*More Courses*, on both `AtchisonAcademy/src/courses.erb` and the featured row
on `AtchisonAcademy/src/index.erb` (both read the same flag).

| | Before | After |
|---|---|---|
| 1 | Cloud Architecture for Scalable Systems (Coursera) | **Risk Management for Scalable Systems (Coursera)** |
| 2 | Scalable Availability in Software Architecture (Coursera) | Cloud Architecture for Scalable Systems (Coursera) |
| 3 | Software Architecture: From Developer to Architect (LinkedIn) | Scalable Availability in Software Architecture (Coursera) |
| 4 | Cloud Migration Fundamentals (O'Reilly) | Software Architecture: From Developer to Architect (LinkedIn) |

Four featured courses before, four after. Nothing in the templates caps the
count; holding it at four is a deliberate choice, not a constraint.

**On leeatchison.com** — add `feature_leeatchison: true` to the new course and
to `shared/_courses/cloud-architecture-for-scalable-systems.md`. Those two, and
only those two (decided 2026-08-31).

This is a visible change to that site beyond the new course. `feature_leeatchison`
is currently set on **zero** courses, so the Featured block in
`LeeAtchison/src/courses.erb` renders nothing at all and the page is a single
flat grid. Spec0013 §4a examined that and decided the empty block was
deliberate and reserved for future use; this spec is that future use, and
supersedes it. After the change, `leeatchison.com/courses/` gains a *Featured
Courses* section above a *More Courses* grid — the same two-section shape the
Academy courses page already has, and the same shape `LeeAtchison/src/books.erb`
already produces for books, which do carry `feature_leeatchison`.

Because that block has never rendered on this site, its styling is unproven
here. Verify it visually rather than assuming; see Testing step 4.

### 4. Remove the companion-course framing from all three Coursera courses

**Decided 2026-08-31: drop the ordinal framing entirely.** The affected files:

| File | Current | Change |
|---|---|---|
| `scalable-availability-software-architecture.md` | "This is the first of two companion courses, best taken in this order, followed by *Cloud Architecture for Scalable Systems*." | Cross-reference the sibling courses without counting or sequencing them |
| `cloud-architecture-for-scalable-systems.md` | "This is the second of two companion courses, best taken in this order, following *Scalable Availability in Software Architecture*." | Same |
| `risk-management-for-scalable-systems.md` (new) | Draft copy: "This is the third course in the specialization, following *Scalable Availability…* and *Cloud Architecture…*." | Same — written this way from the start, not written then rewritten |

Rationale: this line has now broken twice — once when it said "companion
course" singular, again now at three courses. A cross-reference that names the
sibling courses without ordering or counting them stays true the next time a
Coursera course ships. Each page keeps its existing "it stands on its own"
reassurance, which is the part actually doing work for a visitor.

Note the `summary:` fields as well as the About sections — Spec0013 §2a/§6
touched both when it removed the specialization claim.

Draft the replacement wording with `lees-voice` and confirm it before writing.
This is copy on three live pages, not a mechanical edit.

**Explicitly not in scope:** naming the Coursera specialization. Lee confirmed
2026-08-31 that it is still unapproved and the final title is unknown, so the
queued `_Projects.md` idea *"Restore the Coursera specialization framing once
approved"* stays open and is not folded in here. This spec makes the
correctness fix only. Whoever implements that idea later will find these three
paragraphs already consistent and only needs to add the title.

### 5. Update the counts

| File | Change |
|---|---|
| `CLAUDE.md` (repo root) | `_courses/  # 16 course resources` → 17 |
| `AtchisonAcademy/CLAUDE.md` | "10 books and 16 courses … shows the 2 books and 12 courses" → 17 and 13 |
| `AtchisonAcademy/README.md` | "10 books and 12 courses … the 2 books and 8 courses" → 17 and 13 (this one was already stale by four; fix it fully rather than incrementing) |
| `LeeAtchison/CLAUDE.md`, `LeeAtchison/README.md` | Grep for course counts; correct any found |

No change to either `shared_content.rb` — the `SITES` registry and every
validation rule already cover this course as written.

---

## Testing

1. `AtchisonAcademy/bin/dev` and `LeeAtchison/bin/dev` both build clean. A
   missing or wrong `canonical_site`, or a `feature_`/`order_` key without its
   `show_`, fails the build loudly — a clean build is the first assertion.
2. `atchisonacademy.com/courses/` — the new course is the first card in
   *Featured Courses*, badged `Coursera`; *Cloud Migration Fundamentals* has
   moved down into *More Courses*; four featured cards total.
3. Academy home page (`index.erb`) — same featured row, same order.
4. `leeatchison.com/courses/` — **the Featured Courses section now renders for
   the first time**, with exactly two cards: Risk Management first, Cloud
   Architecture second, both badged `Coursera`. Check this visually at desktop
   and mobile widths: a two-card row in a grid sized for more may leave an
   awkward gap, and this block has never been seen on this site. Compare
   against `leeatchison.com/books/`, which uses the same featured/secondary
   pattern. The remaining eleven courses appear below under *More Courses*.
5. `/courses/risk-management-for-scalable-systems/` on **both** domains:
   - Hero shows `~12 hrs · 6 modules · 12 assignments`, `Advanced`,
     `Updated Aug 2026` in the stat line.
   - The Coursera access note and both "Get the Course on Coursera" CTAs
     (hero and page footer) render, linking to the Coursera URL.
   - No duplicated hero/CTA copy leaking out of the body.
6. Canonical: the Academy page emits a self-referential canonical; the
   leeatchison.com page emits
   `<link rel="canonical" href="https://atchisonacademy.com/courses/risk-management-for-scalable-systems/">`
   and is absent from `leeatchison.com/sitemap.xml`. `og:url` is
   self-referential on both.
7. Both sitemaps otherwise contain the new URL exactly where expected.
8. Read the three Coursera course pages' About sections and summaries side by
   side and confirm they cross-reference each other consistently, with no
   ordinal or count language left anywhere.

---

## Summary of Steps Needed

1. Draft the three replacement cross-reference paragraphs with `lees-voice`;
   confirm with Lee before writing (§4).
2. Write `shared/_courses/risk-management-for-scalable-systems.md` from the
   Dropbox draft, using the confirmed §4 wording in its About section.
3. Bump `order_leeatchison` on all twelve existing leeatchison courses.
4. Bump `order_academy` on all twelve existing Academy courses, keeping gaps.
5. Remove `feature_academy` from `cloud-migration-fundamentals.md`.
6. Add `feature_leeatchison: true` to `cloud-architecture-for-scalable-systems.md`.
7. Apply the confirmed §4 wording to the two existing Coursera course files.
8. Update course counts in the four doc files.
9. Build both sites and walk the test list, paying particular attention to
   step 4.

---

## Open Questions

1. ~~**Renormalize `order_academy`, or keep the gaps?**~~ **Decided
   2026-08-31 (Lee):** keep the gaps, straight +1 on every existing value.
   Sort keys are compared, never displayed.

2. ~~**How should the companion-course paragraphs read?**~~ **Decided
   2026-08-31 (Lee):** drop the ordinal framing entirely; cross-reference the
   sibling courses without counting or sequencing them. Applies to all three
   Coursera courses including the new one. See §4.

3. ~~**Fold in the queued Coursera-specialization idea?**~~ **Decided
   2026-08-31 (Lee):** no — the specialization is still unapproved and its
   final title unknown. The `_Projects.md` entry stays queued; this spec makes
   the correctness fix without naming the specialization.

4. ~~**Which courses go in the leeatchison.com Featured block?**~~ **Decided
   2026-08-31 (Lee):** exactly two — Risk Management for Scalable Systems and
   Cloud Architecture for Scalable Systems. Not *Scalable Availability*, and
   not a mirror of Academy's four.

5. ~~**Course art.**~~ **Decided 2026-08-31 (Lee): no artwork.** The new
   course ships text-only, exactly like every other course on both sites. See
   the History entry below for what was investigated and why it was dropped.

6. ~~**Does the Coursera specialization itself need a page?**~~ **Decided
   2026-08-31 (Lee):** not now — the specialization has not launched. Revisit
   once it does, alongside the queued `_Projects.md` idea for its title. No
   `_Projects.md` entry written for the page itself yet.

**No open questions remain.** Status is unchanged pending Lee's go-ahead.

---

## History of Updates

- **2026-08-31** — Spec created. Source copy read from Dropbox
  `Coursera/Courses/Risk Management for Scalable Systems/_Academy Page.md`
  (verified against the live Coursera page 2026-08-31, no open items). Repo
  state surveyed: 16 shared courses, 12 on leeatchison.com, 12 on Academy, four
  `feature_academy`, zero `feature_leeatchison` on courses.

- **2026-08-31** — **Decided (Lee):** the featured slot on Academy comes from
  *Cloud Migration Fundamentals* (O'Reilly Media), not from *Software
  Architecture: From Developer to Architect*. The Dropbox draft had suggested
  demoting the latter so the three Coursera courses would sit together at the
  top of the featured row; Lee's instruction supersedes that. Recorded because
  the draft still carries the other recommendation and a later reader will
  otherwise think it was missed.

- **2026-08-31** — **Decided (Lee):** the new course sorts first on **both**
  sites, not only on Academy.

- **2026-08-31** — **Decided (Lee):** feature the new course *and* *Cloud
  Architecture for Scalable Systems* on leeatchison.com — those two only. This
  reverses Spec0013 §4a, which examined the never-rendered Featured block on
  `LeeAtchison/src/courses.erb` and decided the emptiness was deliberate and
  reserved. It was reserved for exactly this. Options considered and declined:
  all three Coursera courses (would make the block read as the full
  specialization), and mirroring Academy's four (one rule across both sites
  instead of two). Noted as a visible layout change to a live page whose
  featured styling has never been exercised — hence the added emphasis in
  Testing step 4.

- **2026-08-31** — **Decided (Lee):** drop ordinal/companion framing from all
  three Coursera course descriptions rather than restating it as "three."
  The line has broken twice already; a cross-reference that does not count
  survives the next addition. Extended to the new course's own About copy,
  which arrived from the Dropbox draft carrying "the third course in the
  specialization" — writing it right the first time rather than shipping it
  and rewriting it.

- **2026-08-31** — **Decided (Lee):** the Coursera specialization is still
  unapproved with no final title, so the queued `_Projects.md` idea *"Restore
  the Coursera specialization framing once approved"* is **not** folded into
  this spec. Cross-reference added to that entry so the overlap is visible from
  both sides.

- **2026-08-31** — **Decided (Lee):** keep `order_academy`'s existing gaps;
  +1 on every value rather than renormalizing to a dense 1–13.

- **2026-08-31** — **Decided (Lee): no course artwork.** Investigated at Lee's
  prompting after the spec first dismissed it too quickly. Findings, recorded
  so this is not re-opened without new information:

  - Art does exist, in Dropbox at `Coursera/Marketing/` (a folder shared across
    all Coursera courses, not per-course). Each of the three Coursera courses
    has a parallel set: `… - Marketing.png` (~830 KB, banner-shaped),
    `… Logo.png` (~950 KB, square), `… - Navigation Branding.png` (~6 KB).
  - Nothing exists for the nine LinkedIn Learning courses, the O'Reilly course,
    or the four Academy-native ones — 3 of 17 courses have art.
  - Neither site renders any image on a course page or course card.
    `course.erb` is byte-identical across the two sites and contains no image
    markup; no course carries an image key. Adding art is new template plus CSS
    work in both sites, not a front-matter addition.
  - Books show what the pattern would have to be: a `cover_image` key, and the
    image files **duplicated into each site's own `src/images/`** — only the
    collection markdown is symlinked, not the images. `LeeAtchison/src/images/books/`
    and `AtchisonAcademy/src/images/books/` already hold byte-identical copies.
  - Repo weight is a live concern: images are ~24.7 MiB of the 43 MB `.git`.
    Any art would have gone through `assets_inbox/` and been resized into
    `src/images/` per each site's CLAUDE.md, never committed at source size.

  **Lee's call:** no artwork, because no other Coursera course on the site has
  any. Consistency across the course pages beats art on one of them. If art is
  ever added it should be added for all three Coursera courses at once, as its
  own spec, with the card-vs-hero placement question and the 14 art-less
  courses settled first.

- **2026-08-31** — **Decided (Lee):** the Coursera specialization has not
  launched, which settles two things at once — the framing fix in §4 names no
  specialization, and no specialization page is proposed for either site.
  Both wait for launch.

- **2026-08-31** — Moved to Implementing. §4 cross-reference wording drafted
  with `lees-voice` and confirmed by Lee before writing:

  - *Scalable Availability in Software Architecture*: "*Cloud Architecture for
    Scalable Systems* and *Risk Management for Scalable Systems* cover related
    ground. It stands on its own if availability is the problem in front of
    you right now."
  - *Cloud Architecture for Scalable Systems*: "*Scalable Availability in
    Software Architecture* and *Risk Management for Scalable Systems* cover
    related ground. It stands on its own if the cloud decisions are already on
    your desk."
  - *Risk Management for Scalable Systems* (new): "*Scalable Availability in
    Software Architecture* and *Cloud Architecture for Scalable Systems* cover
    related ground. Service tiers and internal SLAs from the availability
    course show up throughout this one. It stands on its own if the risk
    conversations are already landing on your desk."

- **2026-08-31** — Moved to Verifying; [PR #17](https://github.com/AtchisonTechnology/AtchisonWebsites/pull/17) opened.
