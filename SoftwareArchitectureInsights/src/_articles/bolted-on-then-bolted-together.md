---
title: "Bolted On, Then Bolted Together"
subtitle: "AI-Native Architecture: the anti-patterns that look like progress."
author: "Lee Atchison"
status: published
created: 2026-09-02
date: 2026-10-13
series: "AI-Native Architecture"
series_position: "Act II, article 2 of 4 — the anti-pattern catalog"
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: bolted-on-then-bolted-together.png

internal_note: "AI-Native: Act II, Issue 2"
meta_description: "Cloud-native had the distributed monolith. AI has five equivalents, each one built from work that looked correct at the time. How to spot them."
slug: bolted-on-then-bolted-together
description: >
  The distributed monolith was the cloud-native failure that looked like
  success. AI already has its own catalog: the load-bearing prompt, the eval
  that tests the model instead of the system, RAG on a data model never meant
  to be retrieved from, the agent with tool access, and the special-case
  integration. Each one, and the check that finds it.
categories:
  - "AI-Native Architecture"
  - "Scalability & System Design"

---

# Bolted On, Then Bolted Together

*AI-Native Architecture: the anti-patterns that look like progress.*

---

The team did everything on the list. They split the monolith into fourteen services, containerized each one, put them behind a gateway, and stood up a service mesh. Eighteen months of work, and the migration deck got a standing ovation.

Then a deploy to the pricing service took down checkout, because every service called every other service synchronously and none of them could start without the rest. They had built a monolith with network calls in it.

We named that one. The distributed monolith. Naming it mattered, because until it had a name every team that built one thought they were the first.

AI has its own version, and it already has more than one shape. Here are the five I keep running into. Each one was built from work that looked correct at the time, and each one has a check that finds it.

## The Load-Bearing Prompt

Somebody wrote a prompt to get the model to return a summary in a particular shape, and it worked. A second team noticed the shape and parsed it. A third built a dashboard on the parsed fields.

Now the prompt is an interface. Nobody documented it as such. Nobody versions it. But it has three consumers that will break if a single sentence changes.

The engineer who wrote the prompt has no idea. Neither does the engineer who's about to make a change.

Alter one word in your most-used prompt on a branch and run everything downstream. If something you did not expect breaks, the prompt is an undocumented contract. It's a contract you must enforce or your application will break. Give it the treatment any contract gets: a version, an owner, and a test.

## The Eval That Tests the Model

The team has an AI prompt evaluation set, which puts them ahead of most teams. It scores the model's raw answer to each case.

The user never sees the raw answer. They see what comes out after retrieval fills the context, after the parser extracts the fields, after the fallback fires on low confidence, and after the formatting layer rewrites it.

The eval is measuring a component. Meanwhile production is running an entire system.

This is the AI equivalent of a hundred percent unit coverage on services that fail in integration.

Try checking to see whether the eval runs through the same path a real request takes. If it calls the model directly, it is testing the vendor.

You'd be much better off pointing it at your own front door.

## Retrieval From a Model Never Meant for It

The fastest way to add retrieval is to chunk whatever you already have. The wiki, the ticket history, the product database exported to text. Index it, wire it into the prompt using RAG, ship.

Six weeks later a customer gets an answer sourced from a draft page that was never published. Another gets a figure from a table that was correct for a different region. Nobody can say which chunk produced either answer, and nobody can say whether the user was allowed to see it.

The data model was designed to be queried by people who understood its structure and its permissions. Retrieval threw both away.

The check is a single bad answer. Trace it to its source document, its version, and the permission that let this user see it. If any of the three is missing, the retrieval layer was bolted onto data never designed to feed a model.

## The Agent With Tool Access

Giving an AI agent a tool is one line of configuration, which is exactly the problem.

Because it was easy, the agent got the ticket API, the calendar, the customer record, and a deploy hook, each one added by someone solving a demo that afternoon. Nobody reviewed the set. Nobody asked what the worst outcome of the whole set combined would be, which is a different question from the worst outcome of any one, single tool.

The ticket API and the deploy hook are each reasonable. Together they let an agent close a complaint by shipping code.

Write down every tool the agent can call and, beside each, the most expensive thing it could do with it. Then write who approved that.

At the bolt-on stage the second column is blank, and the approval column says "whoever merged it."

## One Integration Per Feature

My original parent article named this one directly. Every new AI capability requires another special-case integration.

The summarizer calls the vendor one way. The classifier calls it another way, with its own retry logic. The chat feature has a third copy, from a different quarter, on a different model version.

Three prompts, three parsers, three bills nobody can separate, and three places to change when the vendor deprecates something.

The check is the same search from last week. Count the vendor SDK call sites. More than one, each written independently, is architecture debt accumulating one feature at a time.

## What They Have in Common

None of these was a mistake when it was made. Each one was the shortest path to a working feature, and each one shipped.

That is what makes them dangerous. The distributed monolith was also built by people doing sensible things one step at a time.

Every one of them skips a property. The load-bearing prompt and the model-only eval ignore probabilistic behavior. The integration sprawl ignores inference economics and lifecycle, and the retrieval and the agent ignore the context supply chain.

I wrote a few weeks ago that [scalability has a second dimension](https://softwarearchitectureinsights.com/posts/scalability-thinking-has-a-new-dimension?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=body), which is how well the system absorbs change. These five anti-patterns are what it looks like when a system cannot. Each one turns the next AI feature into a bigger project than the last.

## The Catalog Check

Five checks, one afternoon.

Change one word in your busiest prompt and see what breaks. Ask whether your eval takes the same path a user's request takes. Trace one bad answer to its source, its version, and its permission, and list the agent's tools with the worst outcome of each. Count the vendor SDK imports.

What you get back is a list of the places where the next feature will cost more than this one did.

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. Bolt-on AI accumulates these five one feature at a time and discovers them together. AI-native designs against all four properties before the second feature ships: probabilistic behavior, inference economics, the context supply chain, and model lifecycle.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=body).

Next Tuesday: why most of your systems should stay bolted on forever, and how to find the few that should not.

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=bolted-on-then-bolted-together&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
