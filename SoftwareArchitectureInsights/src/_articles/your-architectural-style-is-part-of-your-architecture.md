---
title: Your Architectural Style Is Part of Your Architecture
subtitle: ""
author: Lee Atchison
status: published
created: 2026-06-24
date: 2026-06-30
published_on: 2026-06-30

sai_url: https://softwarearchitectureinsights.com/posts/your-architectural-style-is-part-of-your-architecture
email_sent: 2026-06-30
linkedin_url:

hero_image: 

internal_note:
meta_description: "Conway's Law applies one level up: how an architect leads shapes the kind of system that gets built. Coupling and cohesion apply to your practice too."
slug: your-architectural-style-is-part-of-your-architecture
description: >
  Conway's Law says systems mirror communication structures. The less-discussed corollary: how an architect leads (centralized control vs. distributed judgment) shapes the coupling and evolvability of the system itself, not just the org chart.
categories:
  - "The Architect's Role"

---

Every software architect who's been in the field for more than a few years knows about Conway's Law. The observation that organizations tend to build systems that mirror their communication structures is so well-established at this point that it shows up in the opening slides of conference talks about microservices, team topologies, and domain-driven design.

But there's a version of the Conway's Law insight that gets almost no attention. This version operates a level above the organizational chart. It has concrete architectural consequences that most teams haven't thought through.

The *way* architects lead shapes the *kind of systems* that get built.

This isn't a soft organizational observation. It's an architectural claim, and it's worth treating it like one.

## What the System Absorbs

Think about two architects, working in different organizations, both designing a new order processing system.

The first architect works in what I'd call the centralized style. They gather requirements, design the system, make the calls about service boundaries and data ownership, and broadcast the design to the teams who'll build it. They're present in every significant architectural conversation. When ambiguity arises, teams know to wait for the architect's answer. The system gets built.

The second architect works differently. They establish principles and tradeoffs up front. These are explicit, documented, and reasoned. They spend most of their time in conversations that help teams develop their own judgment about architectural decisions, rather than making those decisions themselves. They create forums where teams share context with each other. They write down not just what was decided, but why.

Both systems might look similar in a diagram. But they'll behave very differently when the architect isn't in the room.

The first system has encoded its architect's working style into its structure. The coupling between services reflects the centralized decision-making that produced it. Each service boundary was drawn where the architect drew it, for reasons that live in the architect's head. When teams need to evolve the system, they hit constraints they can't fully explain. They escalate to the architect. The architect becomes the bottleneck. The system has inherited its creator's indispensability.

The second system is more self-describing. The service boundaries reflect principles that teams understand and can reason about. The reasoning is in the architecture decision records, in the design standards, in the conversations teams have learned to have with each other. When something needs to change, teams can evaluate the change against documented intent. They can make better local decisions because they have the context they need.

Same system, on paper. Very different systems in practice.

## Conway's Law, One Level Up

The standard framing of Conway's Law focuses on team structure. if you have three teams, you'll likely build a system with three major components. But the insight generalizes.

Your architecture practice, the way decisions are made, knowledge is distributed, and design intent is communicated, is itself an organizational structure. And like any organizational structure, it shapes the system it produces.

An architecture practice built around centralized control produces systems with tight coupling and hidden dependencies on the architect's ongoing presence. An architecture practice built around distributed judgment and explicit reasoning produces systems that are more loosely coupled and more capable of being evolved by people who weren't in the original conversations.

You can examine your own architectural style for the same properties you'd recognize as problems in a system design.

Is your architecture practice highly cohesive? Do architects and teams share a common understanding of what good looks like? Or is the definition of "good" mostly in one person's head?

Does your architecture practice have high coupling? Is every significant decision dependent on a single person's availability? What happens when they are on vacation, or leave the company?

Is your architecture practice self-describing? If a new team joined tomorrow, how long would it take them to understand not just what the current system is, but why it's structured the way it is, and what the principles are that should guide future decisions?

These are system design questions. They just happen to be about your architecture practice rather than your software.

## What Good Architectural Leadership Produces

In *The Software Conductor*, I use the conductor metaphor to get at this idea. A conductor doesn't play every instrument. More precisely, a good conductor creates the conditions in which each musician can find their part and play it well. The conductor's job is to make the music playable, not to play it himself.

When that works in an orchestra, you can hear it: the ensemble breathes together. When one section drifts slightly, others adjust. The music has become, in some real sense, self-regulating. It's not because the conductor controlled every note, but because the musicians have internalized enough shared understanding that they can maintain coherence themselves.

That's the same property we're trying to build into software architecture practice. It's the properties that cool architects model in their behaviors and actions.

## The Audit Your Team Should Do

Here's a practical test worth running. Pick a significant architectural decision your team made in the last twelve months. Something substantive, like a service boundary call, a data ownership decision, or a choice about how two systems integrate.

Now ask this question, "If the architect who made that decision were unavailable tomorrow, how would teams handle questions that arise from that decision?"

If the answer is "they'd figure it out," your architecture practice has distributed enough judgment. If the answer is "they'd wait," or "they'd guess and probably get it wrong," you've found your coupling problem. And it's not in the code.

The fix isn't more documentation. Documentation is execution. It captures what was decided. What you need is a change in how architectural decisions get made, so that the reasoning travels with the decision and lives in the team's shared understanding rather than in a single architect's memory.

Your architectural style is part of your architecture. The good news is that means it's something you can deliberately design.

---

*The conductor metaphor and what it means to lead without controlling are central themes in my new book, [The Software Conductor](https://www.amazon.com/dp/B0GZWZ64WM?tag=leeatchison-20). If you're thinking about how architects build the conditions for great systems rather than just specifying them, it's written for you.*
