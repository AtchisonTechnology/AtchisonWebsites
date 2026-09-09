---
title: It Passed the Test. That Doesn't Mean It Works.
subtitle: "AI-Native Architecture, part one of four: correct is now a distribution."
author: Lee Atchison
status: published
created: 2026-08-20
date: 2026-09-01
published_on: 2026-09-01

sai_url: https://softwarearchitectureinsights.com/posts/it-passed-the-test-that-doesn-t-mean-it-works
email_sent: 2026-09-01
linkedin_url:

hero_image: it-passed-the-test-that-doesn-t-mean-it-works.png

internal_note:
meta_description: Your test suite assumes same input, same output. An LLM removes that. What replaces it is evaluation, thresholds, and verification somebody owns.
slug: it-passed-the-test-that-doesn-t-mean-it-works
description: >
  Every testing, monitoring, and reliability practice you own rests on one assumption: same input, same output. An LLM in the call path removes it. What replaces it is evaluation, thresholds, and verification as an explicit architectural layer with a cost and an owner.
former_slug: it-passed-the-test
categories:
  - "AI-Native Architecture"
  - "Availability & Resilience"
series: "AI-Native Architecture"
series_position: "Act I, article 1 of 4 \u2014 property 1: probabilistic behavior"

---

# It Passed the Test. That Doesn't Mean It Works.

*AI-Native Architecture, part one of four: correct is now a distribution.*

---

The regression suite has been green for six weeks. Every build passes. The dashboard has settled into the kind of calm that makes people stop looking at it.

Support has been collecting tickets that whole time. The summarizer keeps getting things wrong. Nothing garbled, nothing that looks like a crash. Just answers that are fluent, specific, and false, in ways somebody only caught by reading the source document.

Those two facts finally meet in a Thursday meeting.

The tests are green because the tests check that the summarizer returns a summary. They were written back when that was the only thing that could go wrong.

## The Assumption Nobody Wrote Down

*Same input, same output.*

That property is so ordinary that most of us have never said it out loud. It would feel silly written on a whiteboard. We built an enormous amount on top of it anyway.

Unit tests rest on it. So do regression suites, canary comparisons, and the whole practice of asking whether a change broke anything. So does incident response. The first thing anyone does with a production bug is try to reproduce it, and reproduction works only because the system does the same thing every time.

*Every single time.*

Put a model in the call path and the assumption is gone. Nothing warns you. Nothing in the codebase ever said it was there.

## What Actually Breaks

The usual framing is that models are sometimes wrong. That doesn't help much. Ordinary software is sometimes wrong too, and we have thirty years of practice catching it.

Something more specific broke. Pass and fail stopped being properties of the system. They became properties of a single run.

A green test tells you the system produced an acceptable answer *once*. It says almost nothing about the next call, because the next call may sample differently. Run the same case ten times and you might get nine good answers and one that invents a refund policy your company has never offered and your CFO would like to hear more about. The suite ran it once, drew one of the nine, and went green.

Debugging breaks for the same reason. You lost reproduction. And a bug you can't reproduce is a bug you can't confirm you fixed.

## From Assertions to Thresholds

What replaces the test suite is an evaluation suite. That's a bigger change than the word swap suggests.

A **test** asserts. It compares output against an expected value and returns a boolean. Passed or failed.

An **evaluation** samples. It runs representative cases, scores each against a definition of acceptable, and reports a rate. "94 of 100 acceptable, against a threshold of 90."

Three decisions fall out of that, and each one needs a human name attached.

*Somebody* builds the eval set. That means choosing cases that represent what users actually ask. Teams skip this part, and it is the part that holds most of the value. An eval set drawn from cases the builders imagined will always score better than production. They picked inputs they already understood.

*Somebody* sets the threshold. Ninety percent acceptable is either fine or a catastrophe, depending entirely on what the output touches. Ninety percent on suggested tags is fine. Ninety percent on dosage instructions is a lawsuit. Engineering shouldn't be making that call alone.

*Somebody* decides what happens when the rate moves. A number nobody acts on is a number nobody should collect.

Sampling ends arguments, too. When the team that built the feature says it works and everyone else says it doesn't, both sides are right about what they've seen and neither has the data. Pull fifty real interactions and read them. One afternoon settles what three more meetings won't.

## Verification Is a Layer

Now the architecture question.

If a component can't guarantee its own output, something else has to check it. That checker is a real component. It sits somewhere specific in the request path, costs money, takes time, and can fail on its own.

Those are architectural properties, and they need architectural decisions.

Does the check run inline, so the user waits for it? Or asynchronously, which is cheaper and faster and lets some wrong answers reach people first? For a draft email, asynchronous is fine. For anything that moves money, it isn't.

What is verification allowed to cost? If checking an answer takes a second model call, the inference bill just doubled. That's a budget conversation, and it's next week's article.

What if the checker itself is uncertain? Verification built on a probabilistic component inherits the same property. Turtles all the way down is not an architecture. The chain has to end somewhere deterministic, or in a person, and where you put that ending is one of the more consequential decisions in the system.

And who owns it? A verification layer with no owner degrades quietly. It just gets a little worse at its job every month, politely, without ever firing an alert.

## Let the Component Say It Doesn't Know

You can ask most models how sure they are. Many APIs will hand back token probabilities alongside the answer. Neither is a clean measure of correctness, and both beat what most systems do, which is take the answer, discard everything around it, and carry on as though the model were certain.

That's a strange thing to do.

A component that can say it doesn't know is architecturally different from one that always answers. It gives you a branch. Uncertain cases can go to a person, to a deterministic fallback, to a slower path, or to a plain "I couldn't answer that," which is often the best available product behavior and almost never the one that ships.

Teams who later say there's no way to build a fallback path often had a usable signal available. Nobody asked for it, so nobody had to decide what to do with it.

## The Property One Test

Four questions.

Do you have an evaluation set drawn from what users actually do, rather than what the team imagined they'd do? Is there an acceptance threshold somebody outside engineering agreed to? Does the system have a written behavior for low confidence? And does a named person own the verification layer?

Where the answer is no, the architecture is treating a probabilistic component as though it were deterministic. The tests keep going green while the behavior moves underneath them.

Start with the eval set. Everything else needs it first.

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. For AI, that comes down to four properties: probabilistic behavior, inference economics, the context supply chain, and model lifecycle. Bolt-on AI keeps running a test suite while the behavior moves underneath it. AI-native builds the eval set, the threshold, and the verification layer that tell it what the behavior is actually doing.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift).

*Next Tuesday: what an inference call actually costs you.*
