# Student-specific IDs, activity tracking, and course progress on AtchisonAcademyCourses

* **ID:** Spec0022
* **Status:** Hold/Deferred
* **Date Created:** 2026-09-01
* **Date Implemented:** YYYY-MM-DD
* **Systems Impacted:** AtchisonAcademyCourses (the Spec0021 site), plus —
  depending on the approach chosen — its first serverless code (Netlify
  Functions) and a datastore. **Depends on Spec0021**; nothing here can start
  until that site exists.

---

## Problem/Requirement

**This is a deliberate placeholder.** Lee wants the idea held for later
evaluation, after Spec0021 ships — it is filed now so the thinking below is
not lost, not because it is ready to build. Nothing in it is decided.

The Spec0021 site is unlisted but completely **anonymous**: once a purchaser
has a course URL, we know nothing about who visits, when they "log in" (open
the course), what they watched or read while they were there, or how far
through the course they got. Lee wants:

* **Student-specific unique IDs**, so each purchaser is individually
  distinguishable to the site;
* **Activity tracking** — which students actually show up, and what they do
  during a visit — recorded in some form of database or table (Lee's
  instinct: client-side JavaScript posting to "a Netlify database of some
  sort");
* **Progress tracking** — per student, how far through each course they are,
  ideally readable back so the site can show it.

A useful side effect worth noting: per-student IDs also make **sharing
visible**. Spec0021's secret URLs are course-level, so a leaked URL is
undetectable; one student ID appearing from many devices/locations is a
signal, and a visit with no ID at all is another.

---

## Solution/Fix/Change

Nothing chosen yet. Candidate architectures to evaluate when this spec is
picked up (product facts should be **re-verified then** — this layer of the
Netlify platform changes fast):

### A. Lightweight identity: an opaque student ID, no login

Issue each purchaser a random opaque token (a *student ID*) when they buy —
most naturally delivered as a personalized link in the Kit purchase email,
e.g. `.../<course-id>/<secret>/?sid=ab12cd34ef`. Client JS captures `sid`
into `localStorage` on first visit, and every page thereafter posts events
(page view, video start/end, lesson complete) tagged with it. No passwords,
no accounts, no change to Spec0021's URL scheme — the secret URL still grants
access; the sid only identifies. Costs: a student who clears storage or
switches devices without their link becomes anonymous again; IDs must be
minted and mailed per purchaser (Kit-side work, by hand or automated).

### B. The backend: Netlify Functions + a datastore

The site is static; the write path needs a small API. Netlify Functions fit
naturally (they live in the site directory and deploy with it — the repo's
first dynamic code). Storage candidates, roughly in ascending power:

1. **Netlify Blobs** — key-value store built into Netlify, callable from
   Functions; ideal shape for "progress per (student, course)" documents,
   weak for ad-hoc reporting queries.
2. **Netlify DB** (Neon-backed Postgres) — a real database provisioned
   through Netlify; SQL reporting ("which students finished module 2?")
   comes free. Newer product — verify maturity/pricing at evaluation time.
3. **External datastore** (e.g. Supabase, Turso) — most capable and
   portable, one more vendor.

Note: **Netlify Identity is deprecated** and is not a candidate for any part
of this.

### C. Progress tracking and read-back

Events alone give activity; progress wants explicit signals: a **"mark
complete"** button on each lesson (and/or auto-complete on video end), stored
per (sid, course, lesson). Read-back makes it visible: checkmarks on the
course outline, a per-course progress bar, and "resume where you left off"
on the course index. A `localStorage` copy keeps the UI working when the
API is unreachable, syncing when it returns.

### D. The heavier alternative: real authentication

An actual login (Clerk, Auth0, Memberstack, Supabase Auth) would give
identity, tracking, progress, *and real access control* — superseding
Spec0021's security-by-obscurity model rather than decorating it. Much
bigger change: gated pages on a static site, session handling, account
support burden. Worth an honest look at evaluation time, because if the
answer is ever "we need real gating anyway," building A first would be
throwaway.

### E. The minimal alternative: aggregate analytics only

Fathom custom events (already the family analytics tool) answer "what do
students do in there?" in aggregate with near-zero work — but give no
per-student identity and no progress. Worth naming as the floor: if
aggregate answers are enough, most of this spec dissolves.

### Cross-cutting considerations

* **Privacy:** keep the tracking datastore free of names/emails — opaque IDs
  only, with the ID→purchaser mapping living where purchaser data already
  lives (Kit). Decide data-retention and whether the privacy policy needs a
  line.
* **The Netlify boundary:** enabling Functions/Blobs/DB on the Netlify site
  is dashboard-side configuration — Lee's by hand, per the established
  process boundary; the repo half is the functions code and client JS.
* **Local dev:** Functions need `netlify dev` (or equivalent) rather than
  plain `bin/dev` — a new pattern for this monorepo, worth its own note in
  the site CLAUDE.md when built.

---

## Testing

To be defined when an approach is chosen. At minimum: events recorded per
student, progress written and read back correctly, graceful behavior with no
sid / cleared storage / API down, and nothing about tracking breaking the
plain unlisted reading experience.

---

## Summary of Steps Needed

Not yet — this is a placeholder. First real step when picked up: answer Open
Question 1, then choose among A–E.

---

## Open Questions

1. **What questions does Lee actually want answered?** Aggregate engagement
   ("do students finish module 2?"), per-student support ("how far is this
   customer?"), sharing detection, or student-facing progress UI — the mix
   decides how much machinery is justified.
2. **Lightweight sid (A) or real login (D)?** Hinges partly on whether real
   access control is ever wanted.
3. **Datastore:** Blobs vs Netlify DB vs external — re-verify product
   status, limits, and pricing at evaluation time.
4. **How does a student receive their ID?** Kit purchase email with a
   personalized link seems natural — confirm Kit can mint/merge a per-buyer
   token, and what the manual fallback is.
5. **Should progress render back into the UI** (checkmarks, resume) or is
   this tracking-only at first?
6. **Privacy/data policy** — retention, disclosure, and keeping PII out of
   the tracking store.

---

## History of Updates

* **2026-09-01** — Spec created as a deliberate placeholder at Lee's request
  ("something we would add in later — a spec placeholder to hold the idea
  for later evaluation"), filed Hold/Deferred at creation. Captured his
  framing (student-specific unique IDs; JS posting to some Netlify
  database; activity + progress tracking) plus candidate approaches A–E and
  Open Questions 1–6. Nothing decided.
