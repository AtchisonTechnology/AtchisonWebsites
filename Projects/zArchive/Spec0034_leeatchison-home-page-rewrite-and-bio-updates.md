# leeatchison.com home page rewrite, new bio across all sites, Person structured data, and redirects for old URLs

* **ID:** Spec0034
* **Status:** Closed
* **Date Created:** 2026-10-13
* **Date Implemented:** 2026-10-13
* **Systems Impacted:** LeeAtchison, SoftwareArchitectureInsights, TheSoftwareConductor, ArchitectingForScale, stosa, BusinessBreakthrough30, AtchisonAcademy

---

## Problem/Requirement

Lee approved a new standard bio on 2026-10-13 as part of his Visibility effort (getting named more often, especially in AI assistant answers). The approved text lives in `_Active Projects/Visibility/Identity.md`. The core sentence is used word for word as the first sentence everywhere:

> Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale.

The four target topics are: architecting AI-powered SaaS at scale, AI cost architecture, operating AI reliably in production, and scalability and high availability.

**Decided (Lee, 2026-10-13):** leeatchison.com gets more than a bio swap. The home page is rewritten substantially to match the new messaging.

Today the sites say something else. The leeatchison.com home page leads with "Modernize the Enterprise" and "leading cloud strategist." Every site's bio opens with a different first sentence ("CTO, Chief Software Architect…", "recognized voice on cloud computing…", "technology thought leader…"). None of them mention AI-powered SaaS. Consistency is the point of the exercise: one picture of Lee, repeated everywhere.

Two technical gaps were found on 2026-10-13 and belong here because they live in this repo:

- **No structured data.** Neither leeatchison.com nor softwarearchitectureinsights.com has any JSON-LD. A `Person` block tells search engines and AI crawlers, in machine-readable form, who Lee is and which profiles are his.
- **43 old URLs return 404** on leeatchison.com, per Google Search Console (iCloud Google account, Pages report, 2026-10-13). They are old WordPress-era blog posts, old course and book slugs, and a few retired pages. Google keeps crawling them, and any links pointing at them are wasted.

---

## Solution/Fix/Change

### Part 1. leeatchison.com home page (`LeeAtchison/src/index.erb`)

Keep the page's layout, CSS and the collection-driven sections (What's New, Books, Courses). Change the copy, and replace the three "pillars" with the four topics. All public copy follows `lees-voice` (no em dashes, short sentences).

**Copy (approved by Lee, 2026-10-13):**

**Hero**
- Eyebrow: Software Architect &amp; Author
- H1: AI-Powered SaaS That Holds Up at Scale
- Subtitle (core sentence, word for word): Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale.
- Description: Adding AI to a product is the easy part. Keeping it fast, affordable and reliable once real customers arrive is where most teams get stuck.
- Buttons: "Work with Lee" (→ #contact) and "Read the Newsletter" (→ softwarearchitectureinsights.com)

**What's New** (unchanged, collection-driven)

**Four topics** (replaces the three pillars; section label "What Lee Works On", title "Four Problems Lee Helps Solve")

1. **Architecting AI-powered SaaS at scale.** Most AI features start bolted onto the side of the app. That works for a demo. At scale, the model needs a real place in the architecture. Link: "The five levels of AI-native architecture" → `/ainative`
2. **AI cost architecture.** A function call used to be free. A model call isn't, and the bill grows with every customer. Cost has to be part of the design, because the invoice is a bad place to find out. Link: "Your Function Call Was Free. This One Isn't." → softwarearchitectureinsights.com/posts/your-function-call-was-free/
3. **Operating AI reliably in production.** An AI feature can be up and still be wrong. Reliability now means knowing how often it's wrong, who it affects, and how fast you'll notice. Link: "AI Didn't Break Your Risk Matrix. It Broke Your Scores." → softwarearchitectureinsights.com/posts/ai-didnt-break-your-risk-matrix/
4. **Scalability and high availability.** Your system worked fine at a thousand users. Then it didn't. Lee has done this work since Amazon, and wrote the O'Reilly book on it. Link: "Architecting for Scale" → architectingforscale.com

**About Lee** (label "About Lee", title "From Amazon and New Relic to AI")
- Body: the approved short bio, word for word. Link "More about Lee" → `/about`
- Credential badges: Software Architect · Author · Former AI Company CTO · Advisor
- Company tags: Amazon.com · AWS · New Relic · Product Genius

**Books, Courses** (unchanged, collection-driven)

**Software Architecture Insights**
- Description: Lee's weekly newsletter and podcast on building AI into SaaS, what it costs to run, keeping it reliable, and designing for scale.
- Topic tags: AI-Native (link to `/ainative`, as today) · AI Cost · AI Reliability · Scalability · High Availability · Tech Leadership

**Work with Lee** (`#contact`)
- Section label: Work with Lee
- Title: Let's Look at Your Architecture (Lee, 2026-10-13)
- Intro: Usually something ran fine until it didn't, or an AI feature is about to ship. Either way, the earlier we talk, the cheaper the fix.
- List: Architecture reviews for AI-powered SaaS platforms · AI cost and reliability assessments · Scalability and availability reviews · Fractional chief architect and advisory roles
- **Primary button directly under the list:** "Talk With Lee" → `/contact` (`btn btn-primary`). This is the section's call to action.
- The existing "Send a Message" and "LinkedIn" contact cards stay below it as secondary options.

**Site metadata** (`src/_data/site_metadata.yml`): tagline → "AI-Powered SaaS at Scale"; description → the core sentence.

### Part 2. leeatchison.com about page (`LeeAtchison/src/about.erb`)

- Hero paragraph → the core sentence.
- Background section body → the approved long bio, word for word (four paragraphs). The about page uses the full long bio, not a first-sentence swap.
- Credential badges and company tags as on the home page, keeping Blameless and Hewlett Packard in the company tags.
- CTA title "Ready to Modernize Your Organization?" → "Work with Lee". Keep the rest of the page (books, media, clients) as is.

The current about page says Lee is "co-founder of Product Genius." The approved bio says "CTO of AI company Product Genius." The approved bio wins.

### Part 3. Bios on the other sites

Rules (Lee, 2026-10-13):

- **About pages and "About Lee" callouts use the standard bio verbatim:** the long bio on an about page, the short bio on a callout.
- **The Software Conductor and Architecting for Scale** author bios → the approved short bio, word for word. Their current bios are generic and nothing in them is book-specific.
- **STOSA and Business Breakthrough 3.0** → the core sentence plus one site-specific line. STOSA's bio exists to tie Lee to the framework; Business Breakthrough's is a two-line card beside Ken Gavranovic's, so the full short bio would be lopsided.

| Site | File | Change |
|---|---|---|
| LeeAtchison | `src/ainative.erb` (author box) | First sentence → core sentence; keep the rest |
| TheSoftwareConductor | `src/index.erb` | Replace with the approved short bio, word for word |
| ArchitectingForScale | `src/index.erb` | Replace with the approved short bio, word for word |
| stosa | `src/index.erb` | First paragraph → core sentence + "He created Single Team Oriented Service Architecture (STOSA) and covers it in depth in *Architecting for Scale* (O'Reilly), his guide to building systems that stay available as they grow." Keep the second paragraph |
| BusinessBreakthrough30 | `src/index.erb` (author tagline) | "Cloud strategist, author, and recognized voice…" → "Software architect and author who helps companies architect and operate AI-powered SaaS at scale." Keep the two sentences that follow |
| AtchisonAcademy | `src/index.erb` ("About Lee") | Replace with the approved short bio, word for word |
| SoftwareArchitectureInsights | `src/about.erb` | Front-matter description → core sentence. Opening bio paragraph → the approved long bio, word for word. Keep the rest of the page (newsletter paragraph, Academy, books, publications) |
| SoftwareArchitectureInsights | `src/_data/bio.yml` (article-footer bio) | First sentence → core sentence; keep the rest, links and UTM tags unchanged. Must match `Standard Bio.md` exactly (see below) |

**SAI article-footer bio.** `sai_content.rb` strips the bio paragraph pasted at the end of each article (matching `strip_match: "Lee Atchison is a software architect"`) and renders `bio.yml` in its place. So changing `bio.yml` updates the bio on **every existing article** at the next build, with no per-article edits. The new first sentence still starts with "Lee Atchison is a software architect", so `strip_match`, `import_post.py` and `export_kit.rb` keep working unchanged. Podcast episode pages carry no Lee bio (only guest bios), so they need no change. The show description on Captivate was updated separately on 2026-10-13.

The article bio keeps its five links and their order, which Lee set on 2026-08-21 (Software Conductor first, consulting line last, AI in the consulting line). Only the first sentence changes. The SAI project's `Email and Website/Standard Bio.md` was updated to the same text on 2026-10-13 (Lee's OK), so Kit emails and the website match.

### Part 4. Structured data (Lee, 2026-10-13)

JSON-LD, one master `Person` record that everything else points to by `@id`, so search engines and AI see one Lee Atchison behind all the work.

**Person (master record).** leeatchison.com, home and about pages only, emitted from `_head.erb`.

- `@id`: `https://leeatchison.com/#person`
- `name`: Lee Atchison · `url`: https://leeatchison.com/ · `image`: the headshot
- `jobTitle`: Software Architect · `description`: the core sentence
- `worksFor`: Organization "Atchison Technology"
- `knowsAbout`: the four target topics
- `sameAs`: linkedin.com/in/leeatchison, github.com/leeatchison, x.com/leeatchison, threads.com/@leeatchison, amazon.com/author/leeatchison, softwarearchitectureinsights.com, atchisonacademy.com, thesoftwareconductor.com, architectingforscale.com, stosa.org

**Person (short reference).** softwarearchitectureinsights.com about page: the same `@id`, name, url, description and `sameAs`, so the SAI site carries the identity too.

**Article.** softwarearchitectureinsights.com, every article page (`article.erb` layout): `headline`, `datePublished`, `dateModified` if present, `url`, `image` (the article's OG image), `publisher` (SAI), and `author` → `{"@id": "https://leeatchison.com/#person", "name": "Lee Atchison", "url": "https://leeatchison.com/"}`.

**Book.** Home page of thesoftwareconductor.com, architectingforscale.com and businessbreakthrough30.com: `name`, `url`, `image` (cover), `isbn` where known, `publisher`, `author` → the Person `@id` (Business Breakthrough also lists Ken Gavranovic as a second author).

**Course.** atchisonacademy.com, each course page for a course offered on Atchison Academy: `name`, `description`, `url`, `provider` → Organization "Atchison Academy", `instructor` → the Person `@id`. Courses hosted on Coursera, LinkedIn Learning or O'Reilly are skipped, since those platforms publish their own course records.

Validate every record type with Google's Rich Results Test and validator.schema.org after deploy.

### Part 5. Redirects for the 43 old URLs (`LeeAtchison/netlify.toml`)

Permanent (301) redirects, added to the existing `[[redirects]]` block. Netlify matches on path, so the old `utm_*` query strings don't need separate rules.

| Old path(s) | Redirect to |
|---|---|
| `/home`, `/home/` | `/` |
| `/follow`, `/media` | `/about/` |
| `/calendar` | `/schedule/` |
| `/architecting-for-scale` | `/books/architecting-for-scale/` |
| `/business-breakthrough-3`, `/books/business-breakthrough-30` | `/books/business-breakthrough-3/` |
| `/books/97-things-every-cloud-engineer-should-know` | `/books/97-things-cloud-engineer/` |
| `/books/97-things-every-information-security-professional-should-know` | `/books/97-things-infosec/` |
| `/courses/understanding-the-impact-of-a-merger-for-it-teams` | `/courses/understanding-impact-merger-it-teams/` |
| `/courses/understanding-the-value-of-cloud-native-architecture` | `/courses/understanding-value-cloud-native/` |
| `/courses/cloud-careers-from-developer-to-architect` | `/courses/cloud-careers-developer-to-architect/` |
| `/courses/presenting-cloud-migration-benefits-to-the-c-suite` | `/courses/presenting-cloud-migration-benefits/` |
| `/courses/cloud-migration-fundamentals-best-practices-for-moving-to-the-cloud` | `/courses/cloud-migration-fundamentals/` |
| `/courses/software-architecture-from-developer-to-architect` | `/courses/software-architecture-developer-to-architect/` |
| `/courses/framing-cloud-discussions-for-the-c-suite` | `/courses/framing-cloud-discussions-c-suite/` |
| `/courses/avoiding-bad-decisions-in-your-cloud-strategy` | `/courses/avoiding-bad-decisions-cloud-strategy/` |
| `/courses/creating-and-leveraging-a-cloud-center-of-excellence-in-your-organization` | `/courses/cloud-center-of-excellence/` |
| `/courses/cloud-security/` | `/courses/` |
| `/what-is-a-stosa-organization/` | `https://stosa.org/` |
| Old blog posts: `/2016/*`, `/app-architectures/*`, `/complexity/*`, `/cloud/*`, `/scale-availability/*`, `/mdb-weekly/*`, `/tech-trends/*`, `/blog/*`, `/lp/*`, `/is-it-sla-or-slo/` | The matching Software Architecture Insights article where one exists (matched by title during implementation, listed here for review), otherwise `https://softwarearchitectureinsights.com/` |

**Old blog post matches (implemented 2026-10-13, for Lee's review).** The 43
Search Console URLs weren't saved anywhere, so the old post paths came from
the Wayback Machine's index of leeatchison.com: 188 paths under the prefixes
above. Eight matched a republished SAI article by title and topic. Most are
the old MDB Weekly security series. Each rule also covers that path's
WordPress `/NNN/` sub-URL.

| Old path | SAI article |
|---|---|
| `/mdb-weekly/best-practices-for-managing-configurations-in-cloud-native-applications/` and `…-mdb-weekly/` | `/posts/five-best-practices-for-managing-configurations-in-cloud-native-applications-1/` |
| `/complexity/is-ai-code-automation-contributing-to-code-complexity/` | `/posts/is-ai-code-automation-contributing-to-code-complexity/` |
| `/mdb-weekly/principle-of-shared-responsibility-in-cloud-native-applications-mdb-weekly/` | `/posts/who-s-responsible-understanding-the-principle-of-shared-responsibility/` |
| `/mdb-weekly/isolation-zones-cloud-native-application-security/` | `/posts/fortress-in-the-cloud-how-security-zones-shield-your-data-from-cyber-attacks/` |
| `/mdb-weekly/keep-microservices-secure-even-from-themselves-mdb-weekly/` | `/posts/don-t-let-your-services-become-trojan-horses-1/` |
| `/mdb-weekly/just-in-time-permissions-in-microservices-based-applications-mdb-weekly/` | `/posts/less-is-more-the-principle-of-least-privilege/` |
| `/mdb-weekly/choice-vs-complexity-in-modern-applications-mdb-weekly/` | `/posts/why-increasing-complexity-actually-can-decrease-complexity/` (weakest match; topic, not title) |

Everything else goes to the SAI home page through a catch-all for each prefix
(`/2016`, `/app-architectures`, `/complexity`, `/cloud`, `/scale-availability`,
`/mdb-weekly`, `/tech-trends`, `/blog`, `/lp`, `/is-it-sla-or-slo`). The
catch-alls come after the specific rules, so the specific rules win.

After deploy, Lee (or Claude) presses "Validate fix" on the 404 report in Search Console.

### Part 6. Remaining old messaging on leeatchison.com (Lee, 2026-10-13)

Found 2026-10-13 while checking for gaps:

- **Link-share image (`src/images/og-card.png`).** It shows on every LinkedIn, X or Slack share of any leeatchison.com page, and it still says "Software Architecture & Cloud" and "Cloud strategist, software architect, author, and technology leader with three decades of industry experience." Regenerate it at the same size (1200×630) and layout, with the eyebrow "Software Architect & Author" and the core sentence in place of the old line.
- **Contact page (`src/contact.erb`).** The service list leads with "Cloud modernization consulting and strategy." Match it to the home page's four services, keeping "Speaking and conference appearances" and "Media and press inquiries."

---

## Testing

- Build each changed site locally (`bin/bridgetown build`) and confirm it builds clean.
- Run leeatchison.com locally and view the home and about pages at desktop and phone widths. Screenshot both for Lee.
- Grep the built output of every site for the core sentence, and for the old first sentences, to confirm none survive.
- Validate the JSON-LD (parse it; Rich Results Test after deploy).
- Check every redirect target exists in the built output (internal targets) or returns 200 (external).
- Run the public copy through `lees-voice-checker`.

---

## Summary of Steps Needed

1. ~~Lee approves the home page copy and answers the open questions.~~ Done 2026-10-13.
2. Lee moves the Spec to Implementing.
3. Implement Parts 1 to 6.
4. Build, view and check (Testing above).
5. Lee reviews. Commit, push and PR only on Lee's say-so.
6. After deploy: Rich Results Test, and "Validate fix" on the 404 report in Search Console.

---

## Open Questions

1. ~~Home page copy (Part 1).~~ **Decided (Lee, 2026-10-13):** approved, with the Work with Lee section changed: title "Let's Look at Your Architecture", a new intro, and a "Talk With Lee" button as the call to action. Atchison Technology dropped from the title.
2. ~~Other sites (Part 3).~~ **Decided (Lee, 2026-10-13):** about pages and callouts get the standard bio verbatim (long on about pages, short on callouts). The Software Conductor and Architecting for Scale get the short bio; STOSA and Business Breakthrough get the core sentence plus one site-specific line.
3. ~~SAI article-footer bio.~~ **Decided (Lee, 2026-10-13):** update it, update `Standard Bio.md` to match, and make sure every existing article shows the new bio. `bio.yml` handles all existing articles (see Part 3).
4. ~~Where to build.~~ **Decided (Lee, 2026-10-13):** on `main`.
5. ~~Structured data scope.~~ **Decided (Lee, 2026-10-13):** Person, Article, Book, and Course (Atchison Academy courses), as in Part 4.
6. ~~Part 6.~~ **Decided (Lee, 2026-10-13):** include both the share image and the contact page.

---

## History of Updates

- 2026-10-13: Closed at Lee's direction after verifying the live sites. Core sentence on all seven sites, no old phrasing left. Structured data checked live: Person (leeatchison.com home and about, SAI about), Article (SAI articles), Book (three book sites), Course (Academy courses). Schema.org validator: Person 0 errors, 0 warnings. Google Rich Results Test: Article valid, with one optional note (`datePublished` has no time or time zone). 42 of 43 old URLs tested and redirect to a live page (the www variant couldn't be tested from Claude's network). New share image live. Search Console 404 validation started 2026-10-13.

- 2026-10-13: Moved to Implementing and built on `main`, Parts 1 to 6. All seven sites build clean. The core sentence appears on every site, including all 68 SAI articles through `bio.yml`, and none of the old opening lines survive in built output. JSON-LD parses: Person on the leeatchison.com home and about pages, Person reference on the SAI about page, Article on all 68 SAI articles, Book on the three book sites, and Course on the four Atchison Academy-hosted courses. Architecting for Scale and Business Breakthrough have no ISBN in the repo, so their Book records leave it out. 57 redirects in `netlify.toml`; every internal target exists in the build and every external target returns 200. Old blog matches are listed under Part 5 for review. Share card regenerated in the original layout with headless Chrome. The generator stays out of the repo, as in Spec0003. Not done yet: Rich Results Test and "Validate fix" (both after deploy), and the `Identity.md` tracking rows in the Visibility project.

- 2026-10-13: Part 6 approved (share image and contact page). All open questions resolved; ready for Implementing on Lee's go-ahead.
- 2026-10-13: Book-site bios revised (short bio on Software Conductor and Architecting for Scale; core sentence plus one line on STOSA and Business Breakthrough). Structured data expanded from Person-only to Person, Article, Book and Course. Part 6 proposed after a sweep found the old tagline on the link-share image and the contact page.
- 2026-10-13: Home page copy approved. Work with Lee section reworked at Lee's direction: "Advisory Work Through Atchison Technology" was passive and had no call to action. New title "Let's Look at Your Architecture", new intro, primary "Talk With Lee" button.
- 2026-10-13: Lee's answers recorded. SAI about page and Academy "About Lee" switched to the standard bio verbatim. SAI article bio: first sentence only, keeping the 2026-08-21 link structure; `Standard Bio.md` updated to match. Confirmed `bio.yml` renders on every existing article and podcast pages have no Lee bio. Build on `main`.
- 2026-10-13: Created from the Visibility project (Growth). Research: current home, about and bio text on all seven sites; 43 old 404 URLs pulled from Search Console; four topic links checked live. Copy proposed, not yet approved.
