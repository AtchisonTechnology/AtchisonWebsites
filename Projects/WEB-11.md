# SAI: Questions pages (problem-focused pages for search)

* **Linear:** [WEB-11](https://linear.app/atchison-technlology/issue/WEB-11)
* **Date Created:** 2026-10-21
* **Systems Impacted:** SoftwareArchitectureInsights

---

## Problem/Requirement

From Todoist (2026-09-28): SEO-optimized pages on topics of concern to
readers, not topics Lee wants to talk about. Not "STOSA," but the problem
readers have that STOSA solves.

Today (checked 2026-10-21) the series and category pages have good titles,
meta descriptions, canonicals and share tags. But they are named in Lee's
vocabulary ("Availability Blind Spots"), and each is a sentence or two
followed by a list of posts. Nothing on the site is named after a reader's
problem, and nothing answers one on the page itself.

Requirements (Lee, 2026-10-21):

- Model it on series. Working name: **Questions**.
- Expandable the same way series are. Adding a question is content work
  only: one new file, plus a front-matter line on each related article. No
  code or template change.
- Pages that give readers real value go on the menu.
- This issue builds the feature. The questions themselves (answer text,
  titles, article lists) are content, tracked in the SAI team as
  `Question:` issues (Lee, 2026-10-21). First release: SAI-115 through
  SAI-119.

---

## Solution/Fix/Change

**Decided (Lee, 2026-10-21)** except where marked open.

### How series work today (for reference)

- `src/_data/series.yml` — one entry per series: `key`, `order`, `label`,
  `description`.
- Article front matter: `series: "<label>"` — one series per article.
- `plugins/builders/sai_content.rb` — fails the build on an unknown label;
  generates `/series/<key>/` only for a series with at least one live
  (not future-dated) article (WEB-10).
- `src/_layouts/series.erb` — header, description, article list.
- `src/series.erb` — the `/series/` index, sorted by `order`.
- `src/_layouts/article.erb` — "Part of the series ..." line.
- `src/_components/shared/navbar.rb` — menu links.

### How questions would differ

Two real differences from series:

1. **A question page needs a written answer.** A few hundred words in Lee's
   voice, above the article list. That on-page answer is what search engines
   rank. A series only has a one-paragraph description.
2. **An article can answer more than one question.** So `questions:` is a
   list, where `series:` is a single value.

### Proposed design

**A `questions` collection** (Lee, 2026-10-21). One Markdown file per question, at
`src/_questions/<key>.md`. Front matter holds what `series.yml` holds for a
series; the body is the answer.

```yaml
---
title: "Why Does Our Cloud Bill Keep Growing?"   # the page H1 and <title>
order: 3                                          # position on /questions/
description: >-                                   # meta description + index blurb
  ...
---
The answer, in Markdown. Links to series, courses or other
sites (stosa.org) are written into the body by hand.
```

Adding a question = create that one file, then add its key to each article
that answers it. That is the expandability requirement.

**Article front matter:** `questions: [cloud-bill-keeps-growing, ...]`,
by key, not title (Lee, 2026-10-21). Question titles are long and will be
reworded; keys stay put. (Series match by label.)

**Builder (`sai_content.rb`):**
- Fail the build on an article `questions:` entry with no matching file,
  same as series and categories.
- Drop a question that has no live article from production builds, same
  rule as series (WEB-10). Dev and deploy previews still show it.
- Set `sitemap_priority` / `sitemap_changefreq` on question pages
  (proposed 0.7 / weekly — higher than series, since these are the pages
  meant to rank).

**Layout `src/_layouts/question.erb`:** H1 (the question), the answer body,
then "Go deeper" with the article list (reusing the series list markup),
then the standard subscribe block.

**Index `src/questions.erb`:** `/questions/`, sorted by `order`, same shape
as `/series/`.

**Article layout:** a line under the series line — "Answers the question:
<link>" — for each question the article carries.

**Menu:** add "Questions" to `navbar.rb`, and to the footer next to Series
(Lee, 2026-10-21). Whether to drop the AI Ethics link at the same time is
open until the new menu can be seen (Open Question 1).

**Docs to update in the same change:** the front-matter field list in
`_Active Projects/Software Architecture Insights/Email and Website/CLAUDE.md`
(add `questions`), and the series-article note in that file, so new
articles get tagged as part of publishing.

### First-release content

Not part of this spec. The five questions, their titles, answers and
article lists live in the SAI team:

- SAI-115 — Why Are Our Microservices Slowing Us Down?
- SAI-116 — Why Does Our Site Keep Going Down?
- SAI-117 — Why Does Our Cloud Bill Keep Growing?
- SAI-118 — Is AI Making Our Code Worse?
- SAI-119 — My Boss Wants an AI Strategy. Where Do I Start?

To test the feature before that content is ready, build with one or two
placeholder question files on a branch; they are not shipped.

---

## Testing

- Build succeeds; `/questions/` and each placeholder `/questions/<key>/` page render.
- Each question page lists exactly the articles tagged with its key.
- A bad key in an article's `questions:` fails the build with a clear message.
- A question with only future-dated articles is absent from a production
  build and the sitemap, and present in dev.
- Each article tagged with a question shows the "Answers the question" link.
- "Questions" appears in the menu and footer and highlights on question pages.
- Question pages appear in `sitemap.xml` with the expected priority, and
  have correct title, meta description, canonical and og tags.
- Mobile layout check.

---

## Summary of Steps Needed

1. Resolve the Open Questions. Done 2026-10-21, except the menu trim (step 8).
2. Add the `questions` collection to `bridgetown.config.yml`.
3. Builder: validation + live-article filter + sitemap values.
4. `question.erb` layout and `questions.erb` index.
5. Article layout line; navbar and footer links.
6. Update the SAI front-matter docs.
7. Build and test with placeholder questions.
8. Decide the AI Ethics menu link once the new menu is visible.

The five real questions ship through their SAI issues (SAI-115 to SAI-119).

---

## Open Questions

1. **Drop the AI Ethics menu link?** Lee leans yes; leave open until the
   menu with "Questions" added can be seen (Lee, 2026-10-21).

Resolved (Lee, 2026-10-21):

- One file per question, in a `questions` collection — not a YAML list.
- Articles name questions by key, not title.
- Answers, titles and article lists are content, tracked as SAI
  `Question:` issues (SAI-115 to SAI-119), not in this spec.
- "Questions" goes on the menu.
- Name stays "Questions." The overlap with the podcast segment "Questions
  I Get Asked" is acceptable ("Problems" was the alternative).
- SAI only. STOSA is reached by a link in the microservices answer.

---

## History of Updates

- 2026-10-21: Issue created from Todoist task. Lee picked the five
  first-release questions, the series-style model, the "Questions" name,
  and the expandability requirement. Design proposed after reading the
  series implementation.
- 2026-10-21: Lee resolved Open Questions 1–7 except the menu trim (see
  Open Questions). Content split out to SAI-115 through SAI-119; the
  article-assignment list moved to those issues. SAI team got a
  `Question Issue` label and one `Q:` label per question.
- 2026-10-21: Moved to Implementing (Lee). Implementation handed to Claude Code; branch vs. main is Lee's call there.
- 2026-10-21: Open Question 1 (AI Ethics link) stays open: Lee chose to decide once the new menu can be seen. Implementation done on branch `lee/web-11-sai-questions-pages-problem-focused-pages-for-search`, uncommitted: `questions` collection, builder validation/live-article filter/sitemap values, `question.erb` layout, `/questions/` index, article line, navbar and footer links. Tested with placeholder questions (removed).
