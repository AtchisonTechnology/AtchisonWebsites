---
title: "AI Didn't Break Your Risk Matrix. It Broke Your Scores."
subtitle: "The matrix works unchanged. The definitions underneath it don't."
author: "Lee Atchison"
status: published
created: 2026-08-13
drafted: 2026-09-02
promoted_to_in_progress: 2026-08-13
retitled: 2026-08-13
former_slug: same-matrix-different-scoring
date: 2026-09-29
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: ai-didnt-break-your-risk-matrix.png

internal_note: "Webinar day-before touch (Sept 30 session)"
slug: ai-didnt-break-your-risk-matrix
description: >
  AI components belong on the same risk matrix as everything else. What
  changes is how you score them: a likelihood rubric built on how often a
  person meets the failure, and a severity rubric built from reach,
  reversibility, and detection lag.
meta_description: "AI belongs on the same risk matrix as everything else. What changes is the scoring: a new likelihood rubric and a new severity rubric."
categories:
  - "Security & Risk"
  - "AI-Native Architecture"

---

# AI Didn't Break Your Risk Matrix. It Broke Your Scores.

*The matrix works unchanged. The definitions underneath it don't.*

---

Row 42 of your risk matrix warns against the AI assistant issuing a refund against the wrong order.

Nobody has ever seen it happen. The capability is real, it sits under a dollar threshold, and the team scored it Low Likelihood without much debate. Then they got to severity and the room went quiet, because the money is gone, the customer hears about it from their bank, and there is no undo.

Low Likelihood and High Severity. That's the box everyone skips until it bites them.

## The Wrong Reaction Is a Second Register

The common move, once a team ships an AI feature and realizes nobody scored it, is to start a new "AI risk" register. New document, new template, new review meeting that nobody schedules after the third one.

That failure predates AI by a couple of decades. A risk list living outside the process nobody looks at is just taking up space in a drawer.

You already have a risk matrix. Known risks, likelihood on one axis, severity on the other, low/medium/high on both, a comment column and a triggered plan. It's reviewed quarterly, monthly for the systems that matter, and after every incident.

All nine combinations of Likelihood/Severity are normal, and each one implies something different about what you do next. I talk about this extensively in my O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=body), and the matrix templates are on the book's website.

That matrix takes AI rows fine. Same two axes, same review cadence, same nine boxes.

What breaks is the scoring. The definitions underneath both axes were written for events that either happen or they don't. Not events that *might* be happening.

## Likelihood Stops Being "Will This Happen?"

An AI component doesn't fail the way a disk fails. It produces a wrong answer some fraction of the time, forever, [by design rather than by defect](https://softwarearchitectureinsights.com/posts/it-passed-the-test-that-doesn-t-mean-it-works?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=body). Asking whether that ***will*** happen isn't a useful question. It ***will*** happen, and it likely ***is*** happening right now.

The question that actually scores is how often a person meets it.

Low means most users never encounter it, and a regular user might hit it rarely. Medium means users run into it occasionally and notice, and support has seen customer comments on it more than once. High means encountering it is part of using the product, and a regular user hits it routinely.

Per person, not per request. One in a thousand sounds low until you serve a million requests a day. Then it's a thousand failures.

This is also the one score on the page that gets checked against reality later. Build an evaluation set (sample input that's run and checked routinely) and the estimate turns into a number.

You don't get a "Yes" or "No", you get a percentage. It occurs "sometimes".

Almost nothing else in risk scoring gets that.

What do you put in the matrix before you have useful measurements? Start with the signals you already have, meaning tickets, corrections, and escalations. Those give you a floor.

Then hand-sample fifty real interactions, which takes an hour and always shows something surprising. And ask support, who usually already know.

Write down what methods you used. "Medium from a fifty-item sample" and "Medium from a hallway conversation" are not the same score, and in six months nobody will remember which one this was.

## Severity's Inputs

Severity has three distinct inputs now.

***Reach*** is the first. Does the result of the AI run stay internal, reach a customer, or trigger a business action like a refund?

***Reversibility*** is the second. A wrong summary somebody catches is a reversible mistake. An issued customer refund probably is not. An email that's sent on behalf of your company is not.

***Detection lag*** is the third. A failure caught within the hour may impact only a few people. The same failure running for a week before it's noticed has a much greater impact.

Mark it Low if the reach is internal, or if a human reviews it and a mistake shows immediately. Mark it Medium if it reaches customers, or if detection takes days. Mark it High if the action is irreversible and expensive, if customers act on the output, or if it can run undetected for weeks.

Any one of the three inputs can carry a row to High on its own. Irreversible is High even when it's rare, and even when the model is usually right.

The useful part is that whichever input drove the score also names the fix. Detection lag says build measurement. Reversibility says add limits to what the AI can do, or put a human in front of the action. Reach says ask whether that output should be going where it's going at all.

## Three Rows From the Same Store

In my book I build a T-shirt store and walk through its risks. Now let's add a chatbot to the store. Here are the new rows 41 through 43.

**Row 41 is the assistant giving a customer the wrong order status.** Fifty sampled conversations had three wrong ones, support has raised it twice, and nothing in the system flags a wrong status when it goes out. Medium Likelihood and Medium Severity.

**Row 42 is the refund** from the top of this article. Low Likelihood and High Severity.

**Row 43 is the AI assistant answering policy questions** out of help articles that editors change without review. That article was edited twice last quarter and nobody involved thought about the assistant. An incorrect policy statement is arguably a commitment the company just made. Detection is close to zero, because from the system's point of view nothing is broken. High Likelihood and High Severity.

Same AI model. Same error rate. Three rows, three different responses.

## If You're Arguing About the Model, You're in the Wrong Argument

The problem isn't that you selected the wrong model. All AI models fail in similar ways.

The matrix does not care how good the model is. Rows 41 and 42 run on the identical model, at the identical error rate. They are prioritized very differently, though, because one writes text on a screen and the other transfers money.

Score the consequence.

There are three other mistakes we make with AI in our risk matrix.

The first is treating one wrong answer as the unit of success/failure. Most software components are deterministic. Predictable input, predictable output, and one failure is enough to say it's broken.

AI is non-deterministic. Make the same call twice and you get two different answers, and neither one tells you anything about the other.

Another is scoring likelihood off the demo, which ran on inputs the builders picked. Instead of this, use real production inputs from customers.

The third is making the whole AI feature one row. That leaves you with "the AI might be wrong" sitting at High and High forever. A completely useless row.

Split rows by what the output touches. If a row won't take exactly one mitigation, it's more than one row.

## Solve the Argument with Sampling

Your risk scoring meetings deadlock in a predictable pattern. The people who built the thing score low, because they've watched it work thousands of times with their own input. Everyone else scores high, because they've watched the AI fail, and fail confidently.

Both sides have evidence. Neither side has data.

Fifty sampled production interactions settle the issue immediately.

---

## Tomorrow: What Happens When the AI Service Is Down, Slow, or Wrong

Wednesday, September 30, at 10:00 am Pacific, I'm running a free thirty-minute session live on LinkedIn. Twenty minutes of talk, ten of questions.

It's six questions to ask about any AI dependency before it ships. Two of them go deep, and they're the two this article keeps bumping into. How would you know an answer was wrong? And what can the model actually reach?

[Save your seat](https://softwarearchitectureinsights.com/architecting-with-ai?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=cta)

Slides go to everyone who registers, whether you make it or not.

---

## AI Rows Move While You're Looking Somewhere Else

One last difference.

The rest of your matrix changes when you change something. Ship a release, add a dependency, revisit the affected rows. AI rows change whenever, randomly.

The provider updates the model. Your inputs shift as the user base grows. The retrieval content grows. Somebody edits an article.

So review the AI rows more often than the rest of the matrix.

How do you get started enumerating your AI risk? Take the feature where AI matters most to your business and write down what its output touches. Every screen it lands on, every customer who reads it, every action it can take.

That list is your rows. Most teams find one that looks like Row 42, where nobody has ever seen it happen and nobody could undo it either.

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=ai-didnt-break-your-risk-matrix&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
