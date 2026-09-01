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

### Requirements clarification (2026-09-01)

Lee narrowed what this is actually for. This answers Open Question 1 and
reorders everything below:

1. **Primary — student-visible progress tracking.** Students see how far
   through a course they are. This is a *feature students rely on*, not
   telemetry.
2. **Primary — rollup statistics for Lee.** Aggregate progress across
   students and courses ("how many finished module 2?").
3. **Secondary — sharing prevention.** Useful, and it grows in importance
   **if/when an enterprise buys multiple copies** of a product.

Two consequences fall straight out of that, and they invalidate parts of the
candidate list below:

* **Progress must survive a device change.** A student who moves from laptop
  to phone, or clears storage, must still see their progress. That rules out
  approach A (browser-held token) as the primary mechanism — not because it
  fails to identify, but because losing a promised feature turns into support
  mail. It also rules out E (aggregate only), which gives students nothing.
* **Enterprise multi-seat breaks "one purchase = one student."** Kit sells a
  quantity, but all N seats land on one buyer email. Kit yields the
  *transaction*, never the *roster*. Any model where the student identity is
  derived from the Kit purchaser cannot represent ten students at one
  company.

---

## Solution/Fix/Change

### Current direction (2026-09-01)

**Do nothing yet — stay on Spec0021's unlisted-URL model, and revisit when
course revenue justifies the spend.** Lee's call after reviewing the
options: paying roughly $950/year to add student management to four courses
is not justified at today's Academy volume, and building it (F) is worse
value still.

**When it is revisited, the leaning is to buy, not build — LearnWorlds
Pro Trainer.** See the platform evaluation under G. Recorded as a leaning,
not a commitment.

**Trigger to reopen this spec:** Atchison Academy course revenue comfortably
covers a platform subscription, *or* a concrete enterprise/multi-copy sale
appears. Either one changes the arithmetic; until then nothing here is worth
building or buying.

Note that both paths remain open because Spec0021 costs nothing to keep
running — it is static files on a site already deployed.

---

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

### F. Accounts on our own site — the build path, sketched

*Added 2026-09-01. Refines and largely supersedes A-D. Not decided.*

Identity is an **account keyed to an email address**, not a token keyed to a
browser. The student signs in with a **magic link** — enter email, click the
link that arrives, hold a long-lived session cookie (say 90 days). No
passwords, so no password resets and no account-recovery support burden.
This is the piece that makes cross-device progress work at all.

**Kit's role shrinks to entitlement.** A purchase fires Kit's webhook
(`purchase.purchase_create`, or the per-product `subscriber.product_purchase`);
a Netlify Function writes a row saying "this email may access this course."
Kit is the store, not the roster, and not the ID minter.

**Storage is Postgres, not key-value.** The rollup requirement is a SQL
question. Netlify Database (Neon-backed) reached general availability
2026-04-28, so it is no longer the unproven option the original B2 note
worried about — re-verify pricing at build time regardless. Netlify Blobs
would serve per-student progress adequately and then leave the reporting to
be written by hand.

Roughly four tables: `students`, `licenses`, `enrollments`,
`lesson_progress`.

**Model a license with a seat count from day one, even when every license
has one seat.** A purchase creates a license; a student claims a seat
against it. Today that is invisible plumbing. Later it is the difference
between adding a seat-claim page and re-modelling everything already stored
— and it is the only structure that can represent the enterprise case above.

Sharing then comes almost free: seats are countable, so ten is ten, and
enforcement is a later switch (sessions already exist, capping them is
configuration) rather than a rebuild. Watch the signal — distinct devices
per student, overlapping sessions — before enforcing anything.

Build order if this path is chosen: accounts and magic-link sign-in, the
license/seat tables, lesson-complete write plus read-back. That alone
delivers the student progress bar and Lee's rollups. Finer-grained activity
events, sharing enforcement and an admin dashboard all read from the same
tables whenever they are wanted.

**Honest cost:** this is a small web application, with an ongoing
maintenance and security burden, on a repo that today has no dynamic code at
all. That cost is the whole reason G exists.

### G. Buy instead of build — a hosted course platform

*Lee's question, 2026-09-01: "Is this all harder than having, for example,
Kit integrated with Teachable, and let Teachable do all the student
management?" Recorded as an idea, not a decision.*

Short answer: **yes, F is materially harder.** Teachable, Podia, Thinkific,
Kajabi and similar ship accounts, progress tracking, completion reporting,
bulk/team enrollment and payment handling on day one. Every requirement in
the clarification above is a checkbox on an existing product rather than a
thing to build and then own forever. Teachable list pricing in 2026 runs
roughly $29-$309/month by tier, plus transaction fees on lower tiers —
almost certainly less than the value of the time F would consume.

Kit itself is not a candidate here: it has product delivery and commerce,
but no lesson/progress model, which is why the ecosystem is full of
Kit-to-LMS integrations.

What buying costs instead:

* **Spec0021 was just built to serve this content ourselves.** Choosing G
  makes some of that work redundant. Worth naming plainly rather than
  letting sunk cost decide.
* **Gated content leaves the monorepo.** Lessons would live in the platform,
  not in git, outside the `shared/` architecture and the existing editing
  workflow. Marketing pages on AtchisonAcademy and leeatchison.com stay put
  either way — only the gated delivery moves.
* **Vendor lock-in**, and a migration cost if the platform is ever left.
* **Look and feel** falls back to the platform's, not the family of sites'.

**A middle path exists and may be the real answer:** keep all marketing and
public content on our own sites, and use a platform *only* for gated
delivery and student management. That preserves the site architecture,
skips the entire build, and confines lock-in to course bodies.

**The question that decides it** is not technical. It is how much Lee wants
to own the delivery experience, weighed against months of build plus
permanent maintenance. If owning it is not itself a goal, G wins on effort
by a wide margin.

#### Platform evaluation (researched 2026-09-01)

Eight platforms compared against this spec's requirements. Verify pricing at
decision time — these move.

| Platform | Progress rollups | Multi-seat / B2B | API for progress | Duplicates Kit? | Realistic entry |
|---|---|---|---|---|---|
| **LearnWorlds** | **Best** — Reports Center, Training Matrix, scheduled exports | **Best** — Seat Manager with its own dashboard; buyer's staff self-claim | Yes, User Progress endpoints | **No** — no email tool at all | **$79/mo** (Pro Trainer, annual) |
| **Thinkific** | Good, but **nothing below the Grow tier** | Very good — Group Orders, Seat Manager, Group Analyst | Yes, Grow-gated | Light | $164/mo (Grow, annual) |
| **Teachable** | Decent and apparently ungated | **None** — coupon/cap workarounds only | Yes, good completion webhooks | Light | $69/mo (Builder, annual) |
| Kajabi | Moderate — per-student table, roll up by hand | Effectively none: *"25 units does not create 25 logins"* | Pro-only or $25/mo add-on | **Heavy** | $143/mo annual |
| Podia | Weak, click-based self-report | None — manual invoicing + email import | **None at all** | **Heavy** | $42/mo |
| Circle | Weak — community analytics, not learning | None found | Business+, no course-progress endpoints found | Partial | $89-199/mo |
| Disco | Adequate | Unverified | **Enterprise-only** | — | $399/mo annual |
| SchoolMaker | Completion-focused, decent | None documented | Yes, from $99 | Yes | $99/mo |

**Three findings that matter more than the table:**

1. **Not one of these platforms prevents password sharing.** No concurrent
   session limits, no device limits, no IP restrictions — anywhere.
   Thinkific states it in writing; the rest simply lack it. Buying does
   **not** solve the secondary requirement. What accounts and seats buy is
   *visibility and countability*: seats are finite and logins are logged.
   Real enforcement is a third-party bolt-on (Rupt is the common one) on any
   platform, including a build.
2. **Kit duplication is a real cost.** Kajabi and Podia price their plans on
   contact counts — buying either means paying for a second email platform
   alongside Kit. LearnWorlds has no native email marketing at all and
   delegates to Kit, which makes it the cheapest true cost despite not being
   the cheapest sticker price.
3. **Scale check: only 4 of the 18 courses in `shared/_courses/` are
   Atchison Academy courses.** The rest are LinkedIn Learning (9), Coursera
   (4) and O'Reilly (1), hosted by those platforms. So any platform here is
   ~$950/year to host **four** courses — and `AtchisonAcademyCourses`
   currently holds one sample course. Course-count limits are a non-issue;
   revenue-per-course is the whole question.

**Preferred platform if/when we buy: LearnWorlds, Pro Trainer tier.** It
wins on all three of this spec's requirements at roughly half Thinkific's
usable price, and it is the only one that does not charge for an email tool
we already have. Teachable is cheaper still but has no multi-seat purchase
at all, which the enterprise requirement rules out.

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

Deliberately none right now — see Current direction. The spec stays parked
until its trigger condition fires (Academy revenue covers a subscription, or
an enterprise sale appears).

When it fires, the first steps are: re-verify LearnWorlds pricing and the
2,000 active-learners/month cap; confirm the Kit integration and the Seat
Manager flow against a trial account; then plan the content move for the
four Academy courses, keeping marketing on atchisonacademy.com and pointing
courses.atchisonacademy.com at the platform.

---

## Open Questions

1. ~~**What questions does Lee actually want answered?**~~ **Answered
   2026-09-01** — see Requirements clarification above. Student-visible
   progress and Lee's rollups are primary; sharing prevention is secondary
   and rises with enterprise sales.
2. ~~**Lightweight sid (A) or real login (D)?**~~ **Superseded.** A is out:
   it cannot hold progress across devices. The live question is now 6.
3. **Datastore, if we build (F):** Netlify Database vs external. GA status
   confirmed 2026-04-28; re-verify limits and pricing at build time.
4. ~~**How does a student receive their ID?**~~ **Superseded** by F — the
   student is identified by their own email plus a magic link, not by a
   token we mail them.
5. **Should progress render back into the UI** (checkmarks, resume)? Now
   effectively yes — it is the primary requirement — but the shape of that
   UI is undecided.
6. ~~**Build (F) or buy (G)?**~~ **Leaning settled 2026-09-01** — buy, and
   LearnWorlds Pro Trainer is the preferred platform. But **not yet**: see
   Current direction. The live question is now only *when*, per the trigger
   condition there.
7. **Privacy/data policy** — retention, disclosure, and keeping PII out of
   the tracking store. Note this changes shape under F, which now stores
   email addresses by design rather than opaque IDs only.
8. **Enterprise model:** how does a company actually buy N seats through
   Kit, and who distributes them to employees? Unanswered under both F and
   G.

---

## History of Updates

* **2026-09-01** (third update) — Researched eight course platforms
  (LearnWorlds, Thinkific, Teachable, Kajabi, Podia, Circle, Disco,
  SchoolMaker) against this spec's requirements; table and findings added
  under G. Three findings stand out: **no platform prevents password
  sharing** (so buying does not solve the secondary requirement, only makes
  it countable); Kajabi and Podia would duplicate Kit and charge for it;
  and **only 4 of the 18 courses in `shared/_courses/` are Atchison Academy
  courses**, so any platform is ~$950/year for four courses. Added a
  **Current direction** section recording Lee's call: **stay on Spec0021's
  unlisted-URL model for now**, with **LearnWorlds Pro Trainer** as the
  preferred option if/when revenue or an enterprise sale justifies it.
  Trigger condition for reopening recorded. Open Question 6 closed to a
  leaning. **Still Hold/Deferred.**
* **2026-09-01** (second update) — Lee clarified requirements: student-visible
  progress tracking and rollup statistics are **primary**; sharing prevention
  is **secondary**, rising in importance with enterprise multi-copy
  purchases. Added the Requirements clarification section, which retires
  approach A (browser-held token cannot carry a promised progress feature
  across devices) and E (gives students nothing). Added candidate **F**, an
  account-based build on our own site (email identity, magic-link sign-in,
  Postgres, licenses with seat counts modelled from day one), and candidate
  **G**, buying a hosted course platform instead — raised by Lee's question
  about Kit + Teachable, and answered honestly: buying is materially less
  work, at the cost of some of Spec0021's purpose and of keeping gated
  content in git. Named the middle path (own the marketing, platform for
  gated delivery only). Reworked the Open Questions accordingly; the live
  one is now build vs buy. **Still Hold/Deferred, still nothing decided.**
* **2026-09-01** — Spec created as a deliberate placeholder at Lee's request
  ("something we would add in later — a spec placeholder to hold the idea
  for later evaluation"), filed Hold/Deferred at creation. Captured his
  framing (student-specific unique IDs; JS posting to some Netlify
  database; activity + progress tracking) plus candidate approaches A–E and
  Open Questions 1–6. Nothing decided.
