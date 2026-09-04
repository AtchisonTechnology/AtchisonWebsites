---
title: "Someone Has to Own Evaluation"
subtitle: "AI-Native Architecture: what the org chart has to change, and what it should leave alone."
author: "Lee Atchison"
status: published
created: 2026-09-02
date: 2026-10-27
series: "AI-Native Architecture"
series_position: "Act II, article 4 of 4 — org design"
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: someone-has-to-own-evaluation.png

internal_note: "AI-Native: Act II, Issue 4"
meta_description: "Cloud-native forced DevOps. AI-native opens three ownership gaps, and a new title on the org chart is usually how a company avoids filling them."
slug: someone-has-to-own-evaluation
description: >
  Cloud-native forced DevOps into existence because the old split between
  building and running stopped working. AI-native opens three ownership
  gaps: evaluation, the context supply chain, and the routing and cost
  decisions. A new title is usually how an organization avoids a change
  rather than makes one. Here is who should own each gap, and the one role
  that might actually be new.
categories:
  - "AI-Native Architecture"
  - "The Architect's Role"

---

# Someone Has to Own Evaluation

*AI-Native Architecture: what the org chart has to change, and what it should leave alone.*

---

The evaluation set was built in March. Two hundred scored cases, a threshold the product manager signed off on, a dashboard everyone looked at for a month.

It is October. The engineer who built it moved teams in June, and the cases still reflect what users were asking in March. Nobody ran the set against the model swap in August, because nobody was sure whose job that was.

The measurement instrument still exists. It just has no owner, and a measurement instrument with no owner means you have no instrument.

It's a number on a dashboard that everyone has stopped trusting.

## What Cloud-Native Forced

Cloud-native changed who did what, and it did that by force.

The old split had one group build software and a different group run it. The cloud made that split unworkable, because the people writing the code were now the people deciding how many instances it ran on and what happened when one died.

Operations knowledge had to move into the team that built the thing. We called the result DevOps, argued about the name for a decade, and did it anyway.

The point is that the reorganization was not a choice. The platform's properties made the old boundaries stop working, and the org chart caught up.

AI-native has the same path. Each of the four properties creates work that nobody in the current structure owns. The first article in this series named three of those gaps and did not have room to open them.

## Gap One: Evaluation

Testing has an owner. Every team knows who writes the tests, who keeps them green, and who gets paged when the suite breaks. That ownership took twenty years to become boring, which was the goal.

Evaluation has none of that. The eval set gets built by whoever cared most during the prototype, and it decays the moment that person's attention moves. Nobody adds cases as usage shifts, re-runs it when the vendor ships an update, or revisits the threshold.

The tempting answer is to create an evaluation team, and you should resist it. Testing became reliable when the team that owned the feature owned its tests, with shared tooling underneath. A testing department never got it there.

Evaluation belongs in the same place. The feature team owns its eval set the way it owns its test suite, with the same expectation that a red number blocks a release. What is shared is the harness, and I will come back to that.

## Gap Two: The Context Supply Chain

Data has owners, and they are almost never the people building the AI feature.

The customer record belongs to one team, the policy documents to another, the ticket history to a third. The retrieval layer reads from all of them and hands the result to a model that will answer a customer with it. None of the three owners knows that is happening.

We solved this once for data pipelines, with contracts. A consuming team states what it needs and how fresh it has to be. The producer commits to it, and a change on either side is a conversation instead of a surprise.

The context supply chain needs exactly that, plus one addition. The consumer is a model, and a model will repeat whatever it is given to whoever asks. So the contract has to cover permissions as well as freshness.

The team that owns the data decides who may see it. The team that owns the feature makes sure the retrieval layer enforces that decision today, rather than the day the index was built.

Neither of those is a new role. Both are existing owners, given a contract they did not know they needed.

## Gap Three: Routing and Cost

Somebody chose the model. It was probably the largest one available at the time, chosen during the prototype, and it has not been revisited since. The bill goes to a cost center that has no idea what generates it.

This decision is architectural, and the second article in this series made the case for why. Which model handles which request, what the cache key is, and what one transaction costs carry the same weight as choosing a database. They belong with whoever owns the architecture of the system.

The decision does get made eventually. Finance makes it, six months late, by asking why the bill tripled, and by then the only lever left is turning the feature off.

Put the number in front of the architect every week. The decision will follow.

## The One Thing That Might Be New

Three gaps, and the answer to each was an existing owner with a new responsibility. I said I would come back to the harness.

Every feature team owning its own eval set is correct. Every feature team building its own harness to run those sets is how you get five harnesses that disagree with each other.

The runner, the scoring, the comparison of one model against another, the report that says what changed. That is one piece of shared infrastructure, and it needs an owner the way the CI system does.

This is the one role I would create, and it is small. One team, possibly one person, who owns the harness as a product with internal customers. The feature teams bring the cases, and the harness owner makes sure running them is fast, consistent, and boring.

If that sounds like a platform team, it is, and that is the subject of a later article.

## Why a New Title Is Usually Avoidance

When an organization is not sure how to change, it hires someone and puts the change in their title. Chief AI Officer, Head of AI Transformation, Director of Responsible AI.

Sometimes those roles do real work. More often, the title is a place to put the anxiety so that nobody else has to change what they do.

The feature teams keep shipping without eval sets. The data owners still do not know where their data goes, and the architect still never sees the bill. Somebody is paid to be worried about all of that on the company's behalf.

Cloud-native had this too. Plenty of companies hired a VP of Cloud and kept running data-center architecture underneath. The ones that got there were the ones where the existing teams changed what they owned.

The test of any AI role is whether it moves work into the teams or absorbs it away from them.

## The Ownership Test

Take the one system where AI matters most. For each of these, write a person's name. A team name does not count.

Who owns the eval set, and when did they last add a case? Who owns the freshness and permission contract for each context source? Who sees the inference cost every week and can change the routing? Who owns the harness that all of that runs on?

Four names or four blanks. Each blank is an existing role that has not yet been told this is now part of their job.

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. Bolt-on AI leaves the four properties with no owner and hires a title to worry about it. AI-native puts a name beside each one: probabilistic behavior, inference economics, the context supply chain, and model lifecycle.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=someone-has-to-own-evaluation&utm_content=body).

That closes out the practice half of this series: a maturity model, an anti-pattern catalog, a migration path, and an org chart. What is left is the edges of the idea, including where the cloud-native analogy stops holding. That is where this series goes when it returns.

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=someone-has-to-own-evaluation&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=someone-has-to-own-evaluation&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=someone-has-to-own-evaluation&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=someone-has-to-own-evaluation&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=someone-has-to-own-evaluation&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
