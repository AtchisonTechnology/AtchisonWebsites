---
title: "You Didn't Change Anything. It Changed Anyway."
subtitle: "AI-Native Architecture, part four of four: the component that changes on someone else's schedule."
author: "Lee Atchison"
status: published
created: 2026-08-20
date: 2026-09-22
series: "AI-Native Architecture"
series_position: "Act I, article 4 of 4 — property 4: model lifecycle"
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: you-didnt-change-anything.png

internal_note: "AI-Native: Act I, Issue 4"
meta_description: "Models drift and get deprecated on someone else's schedule. A boundary lets you swap one. Only an evaluation harness tells you what the swap did."
slug: you-didnt-change-anything
description: >
  Services version on your schedule. Models drift, get deprecated, and improve
  on someone else's. Designing the boundary around a component you do not
  control, and the honest math on how much abstraction is worth paying for.
categories:
  - "AI-Native Architecture"
  - "Cloud Strategy & Economics"

---

# You Didn't Change Anything. It Changed Anyway.

*AI-Native Architecture, part four of four: the component that changes on someone else's schedule.*

---

There was no deploy. Nobody merged anything. The last change to that service went out five weeks ago, and it was a logging tweak.

And yet classification accuracy on the intake queue has been sliding for nine days. This morning somebody noticed the assistant has started answering a whole category of question in a different tone. Shorter. More hedged. Technically fine, and different enough that a customer commented on it.

The provider shipped an improvement. It was announced in a changelog nobody on the team subscribes to.

## The Dependency Playbook Doesn't Fit

Architects have always managed things we don't control. Third-party APIs, vendor libraries, managed services, other teams' services. We have well-worn answers. Versioning. Contracts. Deprecation windows.

Hold each one up against a model.

Versioning mostly works. Pinned model versions exist. What doesn't come with them is a behavioral guarantee. Two versions of a library with the same major number promise compatibility on an interface. Two versions of a model promise almost nothing about how a given prompt gets handled. The behavior isn't enumerable, and the vendor couldn't commit to it if they wanted to.

Contracts are thinner still. A model contract covers the shape of the response and the availability of the endpoint. It says nothing about whether the answers stay useful for what you are doing, which is the only thing you actually care about.

Deprecation windows exist, and somebody else sets them. Sixty or ninety days is common, which sounds generous right up until the thing being retired sits in a path you can't easily change and its replacement behaves differently in ways nobody has measured.

There's a fourth problem the old playbook has no name for.

With a library, "improved" and "broken" are different words. With a model, a real improvement can be indistinguishable from a regression for a system tuned around the previous behavior. A model that got better at hedging just broke your terse-answer product.

## Put It Behind a Boundary

The structural answer is unsurprising, which is a good sign. Treat the model as a replaceable component behind a boundary.

The rest of the system talks to your interface, never to a vendor SDK scattered across nine files. Prompt construction, model selection, retry behavior, response parsing. All of it lives behind that boundary. What crosses it is your types, and what the rest of the system may assume is written down and small.

None of this is novel. It's the same containment we apply to any volatile dependency. Bolt-on architectures skip it because calling the vendor SDK straight from the handler is faster on day one, and every day after that until it isn't.

A boundary alone wouldn't have helped the team in the opening, though. Nothing about wrapping the API tells you your classification accuracy is sliding.

## The Harness Is the Actual Control

The boundary is what lets you swap. The evaluation harness is what tells you what the swap did.

This is where part one pays off. That eval set, with its scored cases and agreed threshold, is the same instrument that answers whether a model change helped or hurt. You built it for a different reason. Now point it at two models instead of one.

With a harness, a vendor update is a measurable event. Run the set against the new version, compare rates, read the cases that moved, decide. Without one, a vendor update is a rumor you confirm by reading customer complaints.

A boundary without a harness is worse than it looks. It creates confidence without information. You can swap models fast and have no idea what happened when you did. Surprises just arrive more quietly.

Version pinning resolves the same way. Pinning is often right, and it isn't free. You're choosing to fall behind on capability and to face a bigger jump at deprecation. Defensible when you can measure what a move costs you. A stall when you can't.

## How Much Portability Is Worth Paying For

Here's the part I expect argument about.

Start by separating two things that get treated as one. A boundary wraps the provider you are actually using. A provider-neutral abstraction tries to support the ones you are not. The first is cheap and almost always right. The second is the one worth arguing about.

The provider-neutral abstraction layer is one of the most reflexively built and least examined pieces of architecture in this whole area. It sounds obviously correct. Don't lock yourself in. Keep your options open. Nobody has ever been criticized in a design review for proposing it.

It is frequently money spent on optionality nobody will ever exercise.

The costs are real and they compound. The abstraction tends to expose only the intersection of what every provider supports, so you give up the features that made a specific model worth using. It needs maintenance every time any provider changes anything. And it grows provider-specific escape hatches, at which point it is an abstraction in name and a maintenance burden in practice.

So ask a sharper question. What would you actually *do* differently if your provider changed something tomorrow?

For some systems the answer is concrete and the abstraction pays for itself. A regulated workload that may need to move to a self-hosted model. A product whose margin depends on shifting volume to whoever is cheapest this quarter. A contractual commitment about where inference happens.

For a lot of systems, the answer is that the team would read the changelog, run the eval set, adjust some prompts, and move on. If that's your answer, the abstraction is a cost with no matching benefit. That money would do more good funding the harness that makes the adjustment possible.

Build the harness first. Decide on the abstraction second, with a real answer to what it buys you.

## Drift and Deprecation Are Different Problems

One distinction, because these get conflated and they need different responses.

Deprecation is scheduled, announced, and visible. It's a project. Put it on a roadmap, run the harness, do the migration, complain about it in retro.

Drift is continuous and quiet. Provider updates are one source. Your inputs shift as your user base grows. Retrieved content changes underneath you. Nothing announces any of it.

Deprecation needs a plan. Drift needs a cadence.

Most of your architecture changes when *you* change it, so reviewing it on a fixed schedule feels like overhead. This part changes whenever. The review has to be regular rather than triggered.

## The Property Four Test

Could you move to a different model this quarter, and how long would it take? If you did, would you know what changed, with numbers? Is there a schedule on which somebody checks whether behavior has moved? And when it does move, who finds out first, you or your customers?

That completes the test. Probabilistic behavior. Inference economics. The context supply chain. Model lifecycle.

Take the one system where AI matters most to your business and ask yourself which of the four its architecture accounts for. The distance between that answer and all four is the work.

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. Bolt-on AI hard-codes one vendor's API and hears about behavior changes from its users. AI-native puts the model behind a boundary and a harness that says what changed.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=you-didnt-change-anything&utm_content=body).

Knowing the four properties is the easy part. What an organization has to change in order to act on them is the harder one, and that is where this series goes next.

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=you-didnt-change-anything&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=you-didnt-change-anything&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=you-didnt-change-anything&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=you-didnt-change-anything&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=you-didnt-change-anything&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
