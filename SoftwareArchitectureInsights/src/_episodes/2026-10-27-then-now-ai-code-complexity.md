---
title: "Is AI Code Automation Contributing to Code Complexity?"
slug: then-now-ai-code-complexity
date: 2026-10-27
episode_number: 15
category: Then vs. Now
tags: [Contrarian]
description: "Two and a half years after Lee's first look at GitClear's data, a check on his own words: what he got right, what he got wrong, and what he missed completely."
captivate_episode_id: "2b6c4225-7be8-4f25-a256-916aaf98133b"
source_articles: [is-ai-code-automation-contributing-to-code-complexity]
duration: "12:13"
---

In March 2024, Lee wrote about GitClear's analysis of 153 million lines of changed code, and said the early numbers on AI-assisted code were worrying.

GitClear kept counting. The newest report covers 623 million changes. So this episode is a check on his own words — including the metric he led with, which turned out to be the least alarming one in the report.

**In this episode:**

- The churn number that didn't double, and what projections do
- What held up harder than he wanted: duplication up 81%, copy/paste from 9% to 16%, cross-file calls down 35%
- The thing he didn't see coming: refactoring collapsed from 21% of changed lines to under 4%
- Why the right question isn't whether AI writes good code
- The price change underneath it: writing got nearly free, understanding didn't
- Two fair objections, and what he'd write today instead of "use it in moderation"

**Links:**

- [The original 2024 article](https://softwarearchitectureinsights.com/posts/is-ai-code-automation-contributing-to-code-complexity/)
- [GitClear: Coding on Copilot (the 2024 report)](https://softwarearchitectureinsights.com/exlnk/gitclear-research)
- [GitClear: The Maintainability Gap (the new report)](https://www.gitclear.com/the_ai_code_quality_maintainability_gap)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. In March of 2024, I wrote about a report from a company called GitClear. They had analyzed 153 million lines of changed code, looking at what happened to code quality as AI assistance went mainstream. In that article, I said the early numbers were worrying and that AI-generated code needed human moderation. That was two and a half years ago. GitClear kept counting.

Their newest report covers 623 million changes running through the first half of this year. So today, a check on my own words, what I got right, what I got wrong, and the thing I missed completely Here's what the 2024 article I wrote argued. There's a link to the original article in the show notes. GitHub had published research saying developers write code 55% faster with Copilot. My question was whether faster also meant better. The report gave two answers, and neither one of them was good. First, code churn was climbing. Churn meaning code that gets changed or reverted within two weeks of being written.

GitClear projected it would double in 2024 against the 2021 baseline. Second, code was getting less dry. More copy and paste, less reuse. My conclusion was that AI code generation works when it's balanced against the humans who have to maintain what it produces. Use AI in moderation. I'd give that a passing grade, barely, and not for the reasons I expected Starting with the part I got wrong, since I led the original article with this point. Churn. I put it first because doubling is a dramatic number, and it was easy to explain.

Well, it didn't double. The newer data has two-week churn up about 15% against 2022.

Now, that's real, and it's worth watching, but it was nowhere near the story that I made of it at the time Projections do that sometimes. A curve that's steep for two years gets drawn out to four and then ends up being something completely different. So the metric I led with turned out to be the least alarming one in the entire report But the dry concern held up. It held up harder than I wanted it to. Duplicated blocks are up 81% from the 2023 baseline. Copy and paste has gone from about 9% of changed lines in 2022 to nearly 16% in the first half of this year alone.

And there's a number in the new report I had no way to see back then. Calls to functions in other files are down 35% since 2023. Now, the last one is the clearest signal in the whole report. A cross-file function call is what reuse looks like in a code base. Somebody needs something, found it already written, and called it. Down one-third in three years, which means people are finding it easier to have an AI model write a new function rather than find an existing one that does the same work. Now, the thing I didn't see coming at all back then, refactoring has collapsed.

In 2022, about 21% of changed lines of code were moved code. Moving code is the signature of a cleanup operation. Pulling something into a shared place, splitting a file, reorganizing what's already there. That's what refactoring looks like. This year, it's under 4%. 21% now down to 4%. Copy and paste is now about four times more common than refactoring. Four years ago, it was the other way around. Refactoring ran more than twice the copy and paste rate. There's a matching number. Updates to code that hasn't been touched in a year or more are down 74% since 2023.

Whatever landed in your code base last year is mostly still just sitting there. I spent the 2024 article asking whether AI writes good code, and almost everyone in the industry is asking that question as well. But that's actually the wrong question. The code AI writes is fine. It compiles, it passes reviews, it does its thing. What's stopped happening is everything that goes around the code. The mechanism isn't mysterious once you look at it as a price change. AI made writing new code nearly free. It did not make refactoring any cheaper because refactoring means understanding what's already there, and understanding is the part that hasn't gotten any faster.

Change the relative price of two activities, and you get more of the cheaper one every time. So a developer under schedule pressure hits a problem that a shared helper would solve. The old cost of finding that helper, reading it, and adapting it was maybe 20 minutes. Generating a fresh one is 20 seconds. Nobody made a bad decision there. They made the cheap one 40 times a week for three years.

That's how a code base gets 81% more duplication without a single engineer ever deciding to write duplicate code Two objections to this, and I think one of them is a fair objection. The first is about the metric. GitClear counts lines and line-level measures have never been a great proxy for quality. A duplicated block might be the right call. Some copy and paste is actually cheaper than the wrong abstraction. All of that is true, and it's why I'd focus less on the absolute numbers and more on the direction of the arrow.

Every signal in the report moves the same way over three years. Duplication's up, reuse down, refactoring down, old code untouched. When six measurements that could disagree all agree, something real is happening underneath them. The second objection is the interesting one. If AI made writing code nearly free, why can't it do the refactoring as well? Well, it can, sometimes. I've watched it do a good job on a mechanical extraction across a handful of files.

But refactoring isn't mostly a typing problem. It's a decision about what the code should have been made by someone who knows what the system is for and what other changes might be coming in the next two quarters. The model doesn't know any of that, and the person under schedule pressure isn't going to stop and explain it So the AI code tooling is getting better at the part that was already fast, and it isn't helping at all for the parts that are tough. Which means use it in moderation was too soft of a statement.

It puts the weight on individual restraint, and this isn't an individual discipline problem. If I wrote that article today, I'd say things differently. Here's what I'd say instead. Three things. One, measure your own ratio. Take a month of commits in one repository and compare lines added to lines moved. If moved is under five percent, you have the industry-wide problem in your own code base, and now you have a number to watch and support it. Two, put cleanup on the roadmap as a real line item, not as something teams do when there's slack, because there hasn't been any slack since nineteen ninety-eight.

If refactoring is the activity whose price didn't fall, it's the one that needs to be budgeted more than ever. And three, change what code review is looking for. Code reviews are good at catching a bad line of code. Code reviews are bad at catching the third copy of a function that already exists twice Because the third copy looks perfectly fine on its own. It's only wrong in the context of a code base nobody is reading as a whole. I'd rather see a team reject one duplicate a week than install another linter.

What I'd keep from my twenty twenty-four article is the ending. AI generation is a tool that assists developers in building better systems, And the assist only works when somebody, some person owns the result. Two and a half years of data hasn't changed that. In fact, it's made it even more expensive to ignore. We're several years into a stretch where code bases are growing faster than anyone is maintaining them. The bill for that doesn't show up as an outage. It shows up as a team that can't ship a change to a system nobody understands anymore.

And that's a slow failure, which is why it doesn't get a postmortem of its own Here's something you can start with this week. Pull the last month's commit for one repository. Compute two numbers, lines added and lines moved. Look at the ratio of those two numbers and decide whether you're comfortable with it.

If you're not, you don't need a policy. You need one recurring item on the roadmap And a reviewer who's allowed to say, "We already have one of those The original 2024 article is linked in the show notes along with both GitClear reports, the one I read then and the new one Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
