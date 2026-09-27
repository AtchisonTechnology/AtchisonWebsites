---
title: "The Platform Under Your AI"
subtitle: "AI-Native Architecture: what belongs in a shared layer, and what a platform team should refuse to build."
author: "Lee Atchison"
status: published
created: 2026-09-02
date: 2026-11-03
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: the-platform-under-your-ai.png

internal_note: "AI-Native: Standalone (held from Act II)"
meta_description: "Every team is rebuilding the same AI gateway, harness, and prompt store. Which of those belong in a platform, and the cloud-era rule for deciding."
slug: the-platform-under-your-ai
description: >
  Cloud-native produced a shared substrate because every application team
  was rebuilding the same primitives badly. The same consolidation is
  starting for AI: the gateway, the evaluation harness, the retrieval
  plumbing, the prompt registry, the routing controls. Which of those belong
  to a platform team, which belong to the feature teams, and the rule that
  separates them.
categories:
  - "AI-Native Architecture"
  - "The Architect's Role"

---

# The Platform Under Your AI

*AI-Native Architecture: what belongs in a shared layer, and what a platform team should refuse to build.*

---

Three teams, three AI features, three of everything.

Each team has its own gateway wrapper around the vendor SDK, with its own retry logic, and a script it calls an evaluation harness. Prompts live somewhere different in each one, from a code file to a shared document with tracked changes.

There are three separate line items on the bill and nobody can add them up.

None of the three teams did anything wrong. Each built what it needed in the sprint it needed it. The fourth team is about to do the same thing.

## We Have Watched This Consolidate Before

Cloud-native went through exactly this. Every application team built its own deployment pipeline, its own service discovery, its own logging shim, its own secrets handling.

The duplication was invisible for a while because each copy was small. Then there were forty copies, no two alike, and every security fix had to be applied forty times.

Platform teams came out of that. A shared substrate, owned by one group, that the application teams built on instead of rebuilding. Done well, it was the single biggest productivity gain of the cloud era.

Done badly, it was the internal PaaS nobody adopted, and most large organizations have at least one of those in the closet. The platform team built what it imagined the application teams needed, eighteen months before any of them asked. The application teams kept using their own scripts, because the scripts worked.

Both outcomes are available for AI. The difference is in what the platform team decides to own.

## What the Copies Have in Common

Look at what the three teams in the opening each built. Strip away the differences and the same five things appear.

- A gateway between the application and the vendor, handling authentication, retries, timeouts, and logging
- An evaluation harness, or something that wants to be one
- A place where prompts live
- Retrieval plumbing that chunks, embeds, and indexes a source and hands back the relevant pieces
- Somewhere, usually inside the gateway, the decision about which model gets which request

These are the AI primitives, in the sense that deployment and discovery were cloud primitives. Each team will build all five. A platform lets the organization build each one once.

## Share the Mechanism, Keep the Decision

The cloud era's answer to "what belongs in the platform" was learned the expensive way, and it transfers directly.

The platform owns the mechanism. The team owns the decision.

The deployment pipeline was shared, and what got deployed and when was always the team's call. Service discovery was shared, and which services a team talked to was its own business. Every time a platform team crossed that line and started making application decisions, adoption collapsed.

The gateway belongs in the platform. Authentication, rate limits, retries, and cost attribution are the same for everyone, and the cost number has to be one number that finance and the architects both trust. Three gateways means three bills that cannot be reconciled.

The evaluation harness belongs in the platform: the runner, the scoring, the comparison of two models, the report that says what changed. The eval sets do not. Each team's cases describe its own users and its own threshold, and a platform team that tries to write them will write the wrong ones.

The prompt registry belongs in the platform, but only the versioning and the storage. The prompts are the team's. The platform's job is to make sure that when a prompt becomes a load-bearing interface, which it will, it has a version number and a history.

Retrieval plumbing is shared, because chunking, embedding, indexing, and the query path are the same engineering problem for every team. The freshness bound on a source and the decision about who may see it belong to the data owner. The platform enforces whatever the owner decides and never decides for them.

Routing follows the same split. The platform provides the mechanism to send a request to a smaller model, to cache on a semantic key, and to fall back when a provider is slow. Which requests take which path is a decision the owning architect makes, because it is a quality and cost tradeoff for their product.

## Build From the Second Copy

Build the platform from the second copy. Never before the first.

The internal PaaS that nobody adopted was built from a whiteboard. The platforms that worked were extracted from something a team had already built and a second team wanted to use.

The first copy proves the need and the second proves the shape. A platform designed before either exists is a guess about what teams want, and platform teams guess wrong at roughly the rate everyone else does.

For AI this is a live question right now, because most organizations are between the first copy and the third. That is the right moment to extract.

Take the gateway the most mature team already built, generalize the parts that are actually general, and hand it to the next team. Do the same with the harness, and leave the prompts and the eval cases exactly where they are.

If your platform team is proposing an AI platform and no feature team has shipped anything yet, the proposal is the whiteboard PaaS.

## Who Owns It

I argued earlier in this series that the evaluation harness needs an owner the way a CI system has one. This is that owner, and the gateway, the registry, and the retrieval plumbing sit beside the harness on the same team.

Keep it small. A platform team's size should track the number of feature teams it serves.

Two feature teams need a shared gateway and a shared harness, and probably one person keeping them working. Ten feature teams need a real team. Nobody needs the platform before the feature teams exist.

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. Bolt-on AI rebuilds the same five primitives per feature and pays for each copy. AI-native shares the mechanism once, so every team can spend its effort on the four properties that matter: probabilistic behavior, inference economics, the context supply chain, and model lifecycle.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=the-platform-under-your-ai&utm_content=body).

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=the-platform-under-your-ai&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=the-platform-under-your-ai&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=the-platform-under-your-ai&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=the-platform-under-your-ai&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=the-platform-under-your-ai&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
