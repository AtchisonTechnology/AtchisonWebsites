# Spec0024 Part 5 — Back-Catalog Export Review Report

Exported 52 of the 56 published Software Architecture Insights articles (the
remaining 4 — `don-t-worry-about-ai-taking-over-your-job`,
`7-essential-tips-for-setting-up-effective-monitoring`,
`managing-complexity-in-a-cloud-migration`,
`the-importance-of-continuous-learning-for-software-architects` — were
already exported and correctly in place before this session, per the task
brief). All 56 files now exist at `src/_articles/*.md`, and their basenames
match `published.json`'s 56 slugs exactly (verified programmatically — zero
missing, zero extra).

**Source split: 7 archive-sourced, 45 Kit-HTML-sourced** (of the 52 exported
this session).

- 7 came from the SAI project archive
  (`Content/zCompleted Articles/` in the "Software Architecture Insights"
  Dropbox project), covering articles published 2026-06-30 through
  2026-09-01. This is fewer than the spec's "roughly the nine most recent"
  estimate — only 7 of the 18 articles published since 2026-05 had a
  corresponding clean-Markdown file in the archive folder; the rest
  (`working-as-intended`, `why-i-wrote-the-software-conductor`,
  `the-line-ai-is-drawing-in-your-architecture-team`,
  `the-move-from-execution-to-origination`,
  `what-ai-ethics-actually-means-for-engineers`,
  `the-lesson-at-the-heart-of-the-software-conductor`, and all five
  `AI/ligned`-branded ethics issues) had no archive file and were pulled from
  Kit HTML instead.
- 45 came from `Kit_SAI__get_post` (Kit's email HTML), cleaned with
  `script/import_post.py`'s `strip_kit_chrome`/`html_to_markdown`, per the
  tested pipeline.

## Build verification

`bin/bridgetown build` (after `bundle install`) completes with **no errors
and no warnings** — all front-matter validation in
`plugins/builders/sai_content.rb` (slug-matches-basename, required `date`,
category labels against `categories.yml`, series labels against
`series.yml`, no future-dated articles) passes for all 56 articles. Output
directory shows 56 rendered post pages.

## Article table (52 exported this session, chronological)

| # | Date | Slug | Source | Categories | Meta description |
|---|---|---|---|---|---|
| 1 | 2023-12-05 | `why-you-should-use-a-microservice-architecture` | kit-html | Scalability & System Design | Why monolithic apps turn into an unmanageable 'muck' as they grow, and how a microservice architecture with clear, single-team service ownership fixes it. |
| 2 | 2023-12-26 | `don-t-stop-your-migration` | kit-html | Cloud Strategy & Economics | Migrations get worse before they get better. Why giving up in the "Valley of Pain" costs more than pushing through to the benefits on the other side. |
| 3 | 2024-01-09 | `planned-outages-are-still-outages` | kit-html | Availability & Resilience | A weekly two-hour maintenance window caps your availability at 98.8% — no matter how reliable the app is otherwise. Planned downtime is still downtime. |
| 4 | 2024-01-30 | `why-increasing-complexity-actually-can-decrease-complexity` | kit-html | Scalability & System Design | A system made of hundreds of microservices looks more complex than a monolith. For the developers working in it, the opposite is often true. Here's why. |
| 5 | 2024-02-20 | `you-can-t-afford-not-to-be-in-the-cloud` | kit-html | Cloud Strategy & Economics | Comparing cloud server cost to on-prem server cost misses the real savings: dynamic resource allocation and swapping capital expense for cost of goods sold. |
| 6 | 2024-03-05 | `is-ai-code-automation-contributing-to-code-complexity` | kit-html | Scalability & System Design | GitClear's 153-million-line study finds AI code assistants write faster, but code churn and copy/pasted (non-DRY) code are both climbing sharply. |
| 7 | 2024-04-09 | `the-big-cloud-migration-misstep` | kit-html | Cloud Strategy & Economics | Lift-and-shift promises a quick cloud migration, but static resource allocation often ends up costing more than the data center it replaced. |
| 8 | 2024-04-30 | `open-source-ai-unlocking-the-power-of-collaboration-and-innovation` | kit-html | AI Strategy & Adoption | 65.7% of 2023's foundation models were open-source, per Stanford's AI Index. What that shift means for access, transparency, and the risk of misuse. |
| 9 | 2024-05-21 | `ai-is-advancing-yet-still-falls-short-of-human-intelligence` | kit-html | AI Strategy & Adoption | Stanford's 2024 AI Index shows AI still trails humans on advanced math and visual commonsense reasoning. Why AI augments intelligence rather than replacing it. |
| 10 | 2024-10-22 | `the-art-of-influence-how-software-architects-shape-product-development` | kit-html | The Architect's Role | Architects shape products the way a conductor shapes an orchestra — without writing most of the code. How breadth, coaching, and framework-setting do it. |
| 11 | 2024-11-19 | `the-art-of-influence-navigating-technical-debt-driving-innovation-and-shaping-success` | kit-html | The Architect's Role, Scalability & System Design | Architects are risk managers, not just technical decision makers. How they manage technical debt as a strategic lever, not just a burden to pay down. |
| 12 | 2024-12-10 | `five-best-practices-for-managing-configurations-in-cloud-native-applications-1` | kit-html | Scalability & System Design | Configuration is everywhere in a cloud-native app. Five practices — single source of truth, automation, revision control — that tame the mess. |
| 13 | 2025-01-28 | `beyond-the-basics-making-configuration-management-work-at-scale` | kit-html | Scalability & System Design | Centralizing configuration isn't enough at scale. Configuration-as-a-service, hierarchies, dynamic management, and a real configuration testing strategy. |
| 14 | 2025-03-03 | `don-t-let-your-services-become-trojan-horses-1` | kit-html | Security & Risk | A single compromised microservice can become the entry point that takes down your entire application, even inside a supposedly safe private network. |
| 15 | 2025-03-11 | `beyond-the-tab-key-the-true-value-of-human-developers-in-an-ai-world` | kit-html | Scalability & System Design | GitClear's 2025 report: copy/pasted code now exceeds refactored (moved) code for the first time ever. Why humans still own refactoring and system thinking. |
| 16 | 2025-03-27 | `who-s-responsible-understanding-the-principle-of-shared-responsibility` | kit-html | Security & Risk | The Principle of Shared Responsibility splits security duties between cloud provider and customer — and the dividing line moves depending on the service. |
| 17 | 2025-04-16 | `fortress-in-the-cloud-how-security-zones-shield-your-data-from-cyber-attacks` | kit-html | Security & Risk | A flat security model means one breach reaches everything. Isolation zones — public, private, and DMZ — contain a breach before it becomes a catastrophe. |
| 18 | 2025-05-15 | `architecting-ai-prompts-a-new-skill-for-modern-developers` | kit-html | Books & Courses | Writing effective AI prompts is now part of architecting an application. Clarity, context, relevance, and conciseness — plus a new short course on the skill. |
| 19 | 2025-06-03 | `less-is-more-the-principle-of-least-privilege` | kit-html | Security & Risk | The Principle of Least Privilege: grant each service only the permissions it needs, nothing more, to keep its blast radius as small as possible. |
| 20 | 2025-06-30 | `get-rid-of-your-users-the-role-of-transactional-vs-experiential-applications` | kit-html | Scalability & System Design | Experiential apps want users to stay. Transactional apps want them in and out fast. The two demand opposite architectural priorities. |
| 21 | 2025-08-13 | `ai-hype-vs-application-reality-how-architects-can-keep-their-products-on-track-in-2025` | kit-html | AI Strategy & Adoption, The Architect's Role | AI is a tool, not a product strategy. A practical checklist for architects translating "We need AI!" into a realistic, sustainable decision. |
| 22 | 2025-09-17 | `the-new-reality-of-software-development-ai-s-impact-on-code-quality` | kit-html | Scalability & System Design | The first episode of the Software Architecture Insights podcast covers the 2025 GitClear report on AI's downward pressure on code quality. |
| 23 | 2025-10-01 | `from-finance-to-healthcare-navigating-the-shift-with-michi-kono` | kit-html | The Architect's Role | Garner Health CTO Michi Kono on moving from finance (Capital One, Stripe) to healthcare data modernization, on the Software Architecture Insights podcast. |
| 24 | 2025-10-15 | `why-exactly-should-i-care-about-ai` | kit-html | AI Strategy & Adoption, AI-Native Architecture | AI isn't new, but it's now unavoidable for architects. Why data pipelines, model lifecycle, probabilistic behavior, and ethics all become architectural concerns. |
| 25 | 2025-11-04 | `the-hidden-performance-tax-of-media-files-with-igor-debatur-ceo-of-uploadcare` | kit-html | Scalability & System Design | Uploadcare CEO Igor Debatur on the hidden complexity of file uploads — security, compliance, and scalability — on the Software Architecture Insights podcast. |
| 26 | 2025-11-11 | `managed-file-transfer-in-the-modern-era` | kit-html | Security & Risk | A GoAnywhere CVE sat unpatched for weeks on customer servers while attackers exploited it. Why patch latency makes SaaS the safer architecture for MFT. |
| 27 | 2025-11-25 | `when-your-ai-can-t-say-no` | kit-html | AI Ethics & Responsibility | AI is trained to sound confident, not to be right. Real cases — Air Canada, sanctioned lawyers, Google's AI Overview — where sycophancy caused real damage. |
| 28 | 2025-12-09 | `navigating-ai-development-with-inworld-s-kylan-gibbs` | kit-html | AI Strategy & Adoption | InWorld AI CEO Kylan Gibbs joins the Software Architecture Insights podcast to discuss conversational AI and the role of AI in modern applications. |
| 29 | 2026-01-06 | `we-need-an-ai-strategy-what-your-boss-really-means` | kit-html | AI Strategy & Adoption, The Architect's Role | "We need an AI strategy" usually means "make sense of this for us." How architects turn that directive into real questions about goals, data, and cost. |
| 30 | 2026-01-20 | `your-google-account-is-a-single-point-of-failure-and-what-to-do-about-it` | kit-html | Security & Risk, Availability & Resilience | "Sign In with Google" turns your Google account into a single point of failure for every linked service. Password managers and passkeys avoid that risk. |
| 31 | 2026-02-10 | `the-hidden-costs-of-vibe-programming-why-ai-generated-code-isn-t-the-shortcut-you-think-it-is` | kit-html | Scalability & System Design | Vibe programming doesn't reduce your need for developers. It multiplies the burden: security risk, unmaintainable code, and a vicious cycle of dependency. |
| 32 | 2026-02-24 | `ai-promised-10x-developers-the-reality-is-far-more-complicated` | kit-html | Scalability & System Design, The Architect's Role | GitClear's 2,000-developer-week study finds AI gives a real but modest ~25% boost, mostly to already-strong engineers — and 10x more code churn. |
| 33 | 2026-03-17 | `when-the-bill-comes-due-amazon-s-ai-bet-and-the-engineers-it-let-go` | kit-html | The Architect's Role, Scalability & System Design | Amazon cut 30,000 jobs citing AI efficiency gains, then convened an internal review of high-severity outages tied to AI-assisted code. A pattern worth questioning. |
| 34 | 2026-04-22 | `prompt-injection-isn-t-a-bug-it-s-a-property` | kit-html | Security & Risk, AI-Native Architecture | Unlike SQL injection, prompt injection has no prepared-statement fix. The architectural answer is blast radius: least privilege for every AI agent. |
| 35 | 2026-05-18 | `working-as-intended` | kit-html | AI Ethics & Responsibility | Five AI systems that caused real harm without a single bug: Amazon's biased hiring tool, a healthcare algorithm, COMPAS, facial recognition, and Apple Card. |
| 36 | 2026-06-02 | `why-i-wrote-the-software-conductor` | kit-html | Books & Courses | Why Lee Atchison scrapped two lifeless drafts and wrote The Software Conductor as a story instead of a framework-driven architecture book. |
| 37 | 2026-06-16 | `the-line-ai-is-drawing-in-your-architecture-team` | kit-html | AI Strategy & Adoption, The Architect's Role | AI is good at execution, not origination. What that asymmetry means for how architecture teams should be structured and staffed going forward. |
| 38 | 2026-06-23 | `the-move-from-execution-to-origination` | kit-html | AI Strategy & Adoption, The Architect's Role | Programmer employment fell 27% in two years while design-oriented roles grow. The real dividing line for your career is execution vs. origination. |
| 39 | 2026-06-30 | `your-architectural-style-is-part-of-your-architecture` | archive | The Architect's Role | Conway's Law applies one level up: how an architect leads shapes the kind of system that gets built. Coupling and cohesion apply to your practice too. |
| 40 | 2026-07-07 | `ai-closes-the-ticket-but-who-builds-the-system` | archive | Scalability & System Design, The Architect's Role | GitClear's 623-million-change study finds AI-assisted teams ship faster while refactoring falls 70% and duplicated code climbs 81%. What that costs you. |
| 41 | 2026-07-14 | `what-ai-ethics-actually-means-for-engineers` | kit-html | AI Ethics & Responsibility | AI ethics isn't philosophy or compliance for engineers — it's an engineering discipline with measurable properties. The three zones you operate in. |
| 42 | 2026-07-21 | `the-lesson-at-the-heart-of-the-software-conductor` | kit-html | Books & Courses, The Architect's Role | A conductor who grabs a violin makes the music worse. Why the Hero Trap — architects jumping in to fix things themselves — is the lesson at the book's core. |
| 43 | 2026-07-22 | `the-five-ethical-risks-every-ai-system-carries` | kit-html | AI Ethics & Responsibility | Bias, opacity, accountability gaps, privacy exposure, and harm potential — every AI system carries all five, even a simple product recommendation engine. |
| 44 | 2026-07-28 | `the-single-architect-availability-problem` | archive | Availability & Resilience, The Architect's Role | Apply the single-point-of-failure test to your architecture practice, not just your systems. Concentrated architectural knowledge is a reliability risk. |
| 45 | 2026-07-30 | `why-the-algorithm-decided-is-never-an-acceptable-answer` | kit-html | AI Ethics & Responsibility | "The algorithm decided" shifts responsibility from a person to a system. What real accountability architecture requires: explanation, human authority, logs, escalation. |
| 46 | 2026-08-06 | `fairness-in-ai-is-fairness-even-possible` | kit-html | AI Ethics & Responsibility | Six definitions of AI fairness exist, and several are mathematically proven incompatible. Every system that makes decisions has already chosen one. |
| 47 | 2026-08-11 | `bolting-ai-onto-your-app-is-the-new-lift-and-shift` | archive | AI-Native Architecture | Bolting an LLM call onto an existing app is the new lift-and-shift. The four-properties test for what actually makes an architecture AI-native. |
| 48 | 2026-08-13 | `the-difference-between-ai-safety-ai-ethics-and-ai-governance` | kit-html | AI Ethics & Responsibility | AI safety, AI ethics, and AI governance get treated as synonyms, but they're three distinct questions requiring different expertise and different owners. |
| 49 | 2026-08-18 | `scalability-thinking-has-a-new-dimension` | archive | Scalability & System Design | Scalability used to mean throughput. AI-augmented teams add a second dimension: can this system be safely evolved at AI velocity? |
| 50 | 2026-08-20 | `what-the-eu-ai-act-actually-requires-and-what-it-doesn-t` | kit-html | AI Ethics & Responsibility | The EU AI Act applies based on output use, not company location. A plain-language breakdown of the four risk tiers and what high-risk systems must do. |
| 51 | 2026-08-25 | `when-everything-is-critical-nothing-is` | archive | Availability & Resilience, The Architect's Role | Most reliability failures are ownership failures. Two decisions sit underneath every reliable system. Which services matter, and who is accountable. |
| 52 | 2026-09-01 | `it-passed-the-test-that-doesn-t-mean-it-works` | archive | AI-Native Architecture, Availability & Resilience | Your test suite assumes same input, same output. An LLM removes that. What replaces it is evaluation, thresholds, and verification somebody owns. |

## Findings for human review

### (a) Category assignments that felt like a genuine toss-up

- **`open-source-ai-unlocking-the-power-of-collaboration-and-innovation`**
  — assigned "AI Strategy & Adoption" (landscape/adoption-trend framing),
  but the article spends real weight on transparency/accountability of
  open models, which could argue for "AI Ethics & Responsibility" instead.
- **`ai-is-advancing-yet-still-falls-short-of-human-intelligence`** —
  assigned "AI Strategy & Adoption" for consistency with the sibling
  already-exported article `don-t-worry-about-ai-taking-over-your-job`
  (same theme, same calibration precedent), but it's a general
  capability-limits piece that doesn't map cleanly onto any of the 9 labels.
- **`from-finance-to-healthcare-navigating-the-shift-with-michi-kono`** —
  a podcast-guest interview about a CTO's career move and healthcare data
  modernization. Assigned "The Architect's Role" as the closest fit, but
  it's a weak fit — none of the 9 labels really cover a guest-interview
  format.
- **`the-difference-between-ai-safety-ai-ethics-and-ai-governance`** —
  assigned "AI Ethics & Responsibility" (the article's own framing and
  newsletter context), though "AI Safety" content specifically could also
  argue for "Security & Risk" per that category's stated scope ("...
  including AI security").
- **`ai-closes-the-ticket-but-who-builds-the-system`** and
  **`ai-promised-10x-developers-the-reality-is-far-more-complicated`** —
  both dual-tagged "Scalability & System Design" + "The Architect's Role";
  could reasonably have been single-tagged either way.

### (b) The two `former_slug` remap cases

Both were found and handled as specified:

- **2026-09-01 / id 14491521**: archive file was
  `2026-09-01-it-passed-the-test.md` (own slug/id `it-passed-the-test`).
  Exported as `it-passed-the-test-that-doesn-t-mean-it-works.md` with
  `slug: it-passed-the-test-that-doesn-t-mean-it-works` and
  `former_slug: it-passed-the-test`. Also carries `series: "AI-Native
  Architecture"` and `series_position`, both present in the archive file
  and preserved verbatim (matches `series.yml`'s one entry).
- **2026-08-11 / id 14256448**: archive file was
  `2026-08-11-from-cloud-native-to-ai-native.md` (own slug
  `from-cloud-native-to-ai-native`). Exported as
  `bolting-ai-onto-your-app-is-the-new-lift-and-shift.md`.

  **Deviation**: per the task's explicit instruction, `former_slug` was
  **NOT** set for this one, even though its old id differs from the Kit
  slug the same way case 1 does. Reasoning: `former_slug` exists to
  generate a `/posts/<old>/* → 301` redirect for a URL that used to be
  *live*. `from-cloud-native-to-ai-native` was only ever the archive's
  internal working filename — Kit's own `public_url` for this post was
  always `bolting-ai-onto-your-app-is-the-new-lift-and-shift`, so there is
  no old live URL to redirect from. Setting `former_slug` here would
  fabricate a redirect for a URL that never existed. If Lee disagrees,
  adding `former_slug: from-cloud-native-to-ai-native` to that one file is
  a one-line fix.

  **A third, previously-unflagged slug-remap case was found and NOT given a
  `former_slug`, for the same reasoning**: the archive file for
  `ai-closes-the-ticket-but-who-builds-the-system` (id 13776468, published
  2026-07-07) has its own internal `slug:` field set to
  `ai-closes-the-ticket-who-builds-the-system` (missing "but") — a third
  archive/Kit-slug mismatch beyond the two named in the task brief. Since
  Kit's own `public_url` for this post was always the "-but-" version,
  there was no live URL under the archive's spelling to redirect from, so
  no `former_slug` was added. Flagging this explicitly since the task
  described only two remap cases as sanctioned and this is a third
  instance of the same underlying pattern (archive working-filename ≠ Kit
  slug) that Lee should be aware exists in the SAI archive folder more
  broadly than assumed.

### (c) Hero images — resolved after this report was first written

At export time, `hero_image: null` was set on every one of the 52 exported
articles — Kit's image CDN (`embed.filekitcdn.com`) is blocked from the
sandbox that ran this export, so no images could be downloaded then. That
manifest (`script/needs_hero_image.json`, 39 `{slug, thumbnail_url}`
entries — one per post in `published.json` with a non-null `thumbnail_url`,
matching the spec's own count) is committed alongside
`script/download_hero_images.rb`, written to consume it from a machine that
can actually reach Kit's CDN.

Since then, two rounds have filled in most of the gap:

1. Lee ran `script/download_hero_images.rb` himself, pulling 37 images from
   Kit's CDN (2 of the 39 URLs, both S3-hosted rather than Kit-CDN-hosted,
   turned out to 404 — confirmed dead on Kit's/S3's side, not a download
   failure).
2. Lee separately pushed 17 images from the SAI project's Dropbox
   `zArchive` folder. 11 of those were matched to specific articles (7 by
   an exact date-prefixed filename correspondence to the archive source
   articles, 4 by title/theme) and used in place of the Kit-CDN version
   where one existed, on the reasoning that the archive originals are
   higher quality than Kit's own resized copies. One of the 11
   (`ai-hype-vs-application-reality-how-architects-can-keep-their-products-on-track-in-2025`)
   had no Kit thumbnail at all and got its first hero image this way. The
   other 6 pushed images (2 `-alt.png` variants, a duplicate crop, and 3
   low-confidence title guesses that turned out unnecessary once the real
   Kit-sourced images were found) were left unused and have since been
   deleted from the now-empty `assets_inbox/article_images/`.

**Current state: 38 of 56 articles have a `hero_image`.** The other 18: 16
are among the 17 articles Kit never had a `thumbnail_url` for at all
(expected and accepted per the spec — Part 4's fallback to a default
`og:image` covers these), and 2
(`why-you-should-use-a-microservice-architecture`, `don-t-stop-your-
migration`) have the confirmed-dead S3 links noted above and still need a
source image found some other way if Lee wants one for them.

### (d) Category-sourcing deviation from the spec — material

The spec's original plan was to scrape category tags off the live site's
HTML for the 32 articles Kit had already back-filled with taxonomy
categories, leaving only 24 needing manual assignment. **That live-scrape
was not possible from this sandboxed environment** — egress to
`softwarearchitectureinsights.com` and Kit's own domains is blocked here,
confirmed by earlier `curl` failures. So **all 52 articles in this batch
had categories assigned by hand**, by reading each article's actual content
against the 9 category descriptions in `categories.yml` — not just the 24
the spec anticipated. This is a real, material deviation from the plan: the
manual-assignment surface area more than doubled (24 → 52). Seven archive-
sourced articles did carry real `categories:`/`series:` front matter
already matching the taxonomy exactly (`when-everything-is-critical-
nothing-is`, `it-passed-the-test-that-doesn-t-mean-it-works`) — those two
were used verbatim rather than reassigned; the other five archive files had
no `categories:` field and were assigned by hand like the Kit-HTML ones.

### (e) Articles needing a hand spot-check for chrome the automated cleaner might have missed

All 45 Kit-HTML-sourced articles were either (i) hand-transcribed to clean
Markdown by reading the raw HTML directly (34 articles — the safest path,
used for most of the catalog), or (ii) run through the tested
`strip_kit_chrome` + pandoc pipeline on lightly-edited raw HTML (11
articles, all from 2026 — `the-hidden-costs-of-vibe-programming...`,
`ai-promised-10x-developers...`, `when-the-bill-comes-due-amazon...`,
`prompt-injection-isn-t-a-bug...`, `working-as-intended`,
`why-i-wrote-the-software-conductor`,
`the-line-ai-is-drawing-in-your-architecture-team`,
`the-move-from-execution-to-origination`,
`what-ai-ethics-actually-means-for-engineers`,
`the-lesson-at-the-heart-of-the-software-conductor`, and the five
`AI/ligned`-branded articles from `the-five-ethical-risks...` through
`what-the-eu-ai-act...`). For the second group, a real bug in the
transcription step was caught and fixed mid-session: four of them
(`the-hidden-costs-of-vibe-programming...`,
`ai-promised-10x-developers...`, `when-the-bill-comes-due-amazon...`,
`prompt-injection-isn-t-a-bug...`) used `<div>`-wrapped paragraphs (Kit's
newer "trix-content" editor format) rather than `<p class="">`-wrapped
ones; pandoc passes bare `<div>` through as literal raw HTML in its GFM
output instead of converting it to a Markdown paragraph, so the first pass
left literal `<div>`/`</div>` lines in the rendered Markdown body. Caught by
grepping the output, fixed by converting the source `<div>` tags to `<p>`
before re-running the importer, and verified clean by a full grep sweep
across all 56 files afterward (zero leftover HTML tags anywhere).

Recommend Lee spot-check, in order of confidence-of-transcription:

1. **`managed-file-transfer-in-the-modern-era`** — the longest and most
   heavily-formatted of the run-through-the-cleaner articles (8 numbered
   `###` subsections, 2 blockquote callouts, an external-link-heavy Files.com
   case study). Cross-checked visually against the source but worth a full
   read-through given its length.
2. The 5 `AI/ligned`-branded articles (`the-five-ethical-risks...` through
   `what-the-eu-ai-act...`) and `what-ai-ethics-actually-means-for-
   engineers` — these carried a duplicated inline `<style>` block and, in
   three cases, a second book-ad `ck-layout-block` (two "Take a Look!" CTAs
   instead of one) in the raw HTML; both ad blocks should have been
   stripped automatically, and spot-checks of the rendered `.md` confirm
   they were, but it's the kind of double-nested structure worth a second
   look.
3. **A YAML front-matter bug was found and fixed live**: two articles
   (`we-need-an-ai-strategy-what-your-boss-really-means`'s
   `meta_description`, and `your-google-account-is-a-single-point-of-
   failure-and-what-to-do-about-it`'s `title` and `meta_description`) had
   values that begin with a literal `"` character. `import_post.py`'s
   `yaml_scalar()` helper only adds quoting when a string contains `:` or
   `#` — it doesn't check for a leading quote character, so these were
   emitted as invalid unquoted YAML and broke the Bridgetown build
   ("did not find expected key while parsing a block mapping"). Both were
   hand-fixed in the output `.md` files (wrapped in properly-escaped
   double-quoted YAML scalars) and the build now passes clean.
   **Fixed since**: `import_post.py`'s `yaml_scalar()` now also quotes a
   value that starts with any YAML indicator character (`"`, `'`, `-`,
   `?`, `:`, `,`, `[`, `]`, `{`, `}`, `#`, `&`, `*`, `!`, `|`, `>`, `%`,
   `@`, `` ` ``), not just one containing `:` or `#` — so this class of
   bug shouldn't resurface on a future re-run.
4. Three articles had a duplicate byline (`*By: Lee Atchison*`, distinct
   from the standard bio) or a leading `# Title` heading that the site's
   `post_read` strip hook would NOT auto-remove (it only strips a leading
   H1 when immediately followed by a matching italic subtitle and `---`,
   which none of these three had) — `ai-closes-the-ticket-but-who-builds-
   the-system`, `the-single-architect-availability-problem`, and
   `bolting-ai-onto-your-app-is-the-new-lift-and-shift` (all archive-
   sourced). These were hand-stripped before writing the Markdown; verified
   clean by inspection.
5. Two thin **podcast-episode announcement posts**
   (`the-hidden-performance-tax-of-media-files-with-igor-debatur-ceo-of-
   uploadcare`, `navigating-ai-development-with-inworld-s-kylan-gibbs`) and
   one already-thin article
   (`don-t-let-your-services-become-trojan-horses-1`, 4 short paragraphs)
   have very little body content — this is genuinely what Kit stored for
   these posts (a teaser paragraph plus a "Read/Watch online" link, in
   Kit's case pointing at fuller content on the live site that this export
   didn't have access to), not an artifact of over-aggressive cleaning.
   Worth Lee's awareness that these three pages will look thin on the new
   site.

## Counts summary

- **52 exported** this session (7 archive-sourced, 45 Kit-HTML-sourced).
- **56 total** now in `src/_articles/` (52 + 4 pre-existing), matching
  `published.json`'s 56 published-post slugs exactly.
- **38 of 56** now have a `hero_image` (27 from `download_hero_images.rb`'s
  Kit-CDN pull, 11 from Lee's Dropbox `zArchive` push, some overlapping and
  resolved in the Dropbox version's favor — see (c) above). The other 18
  are 16 articles Kit never had a thumbnail for (expected, the site's
  fallback covers them) and 2 with confirmed-dead thumbnail links.
- **Build passes clean**: `bin/bridgetown build` — 0 errors, 0 warnings,
  all 56 articles render, no future-dated articles.

---

*Updated 2026-09-03 (night) to reflect the hero-image reconciliation and
the `import_post.py` fix, after the original version of this report was
sent to Lee in chat only. Everything above section (c) is unchanged from
the original; see this repo's git history for
`script/export_review_report.md` if the earlier wording matters.*
