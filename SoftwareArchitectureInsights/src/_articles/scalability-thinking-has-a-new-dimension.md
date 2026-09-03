---
title: Scalability Thinking Has a New Dimension
subtitle: The role of evolvability in modern application development.
author: Lee Atchison
status: published
created: 2026-05-07
date: 2026-08-18
published_on: 2026-08-18

sai_url: https://softwarearchitectureinsights.com/posts/scalability-thinking-has-a-new-dimension
email_sent: 2026-08-18
linkedin_url:

hero_image: 

internal_note:
meta_description: "Scalability used to mean throughput. AI-augmented teams add a second dimension: can this system be safely evolved at AI velocity?"
slug: scalability-thinking-has-a-new-dimension
description: >
  AI coding assistants let teams move faster, but velocity changes the risk profile of an existing system. Boundary clarity, narrow contracts, and continuous architectural validation are what make a system evolvable at AI speed, not just human speed.
categories:
  - "Scalability & System Design"

---

# Scalability Thinking Has a New Dimension

*The role of evolvability in modern application development.*

---

Your team adopted AI coding assistants four months ago. Output is up, and everyone is happy about it. Then last week someone shipped a change to the billing service that quietly broke an assumption three other services were making, and nobody caught it for nine days.

Nothing about that change was careless. The system simply moved faster than anyone's ability to remember what it was holding together.

For most of the last decade, when architects talked about scalability, they meant roughly one thing.

*Can this system handle more?*

More transactions per second. More concurrent users. More data. The architectural conversation that follows is well-developed and familiar. Horizontal scaling, sharding strategies, caching layers, async processing, the tradeoffs between consistency and availability, these make up the core of the scalability conversation.

Those conversations are still important. But AI tooling is introducing a new dimension of scalability that most architecture frameworks haven't caught up to yet, and it has different implications for how you design systems today.

There's a second question now. Can this system be safely *evolved* by a team working at AI-augmented velocity?

## What Changes When Teams Move Faster

AI-assisted development teams work faster. That's the point, and in many contexts the acceleration is real and substantial. You get more code per sprint and faster exploration of options. The time from idea to working prototype collapses. For the right work, this is genuinely useful.

What doesn't get discussed much is what "faster" does to the risk profile of an existing system.

When a team moves faster (commits more code, ships more changes, iterates on more features in a given period) the impact of a bad architectural decision scales with their velocity. A mistake in a service contract that a slow-moving team might catch over three sprints of gradual drift gets introduced and compounded across ten sprints before anyone notices. A technical debt item that was manageable at human speed, where you could watch it and deliberately work around it, becomes a serious problem at AI speed. There are more opportunities to step on it, and the consequences of each misstep arrive faster.

Think of it this way. If you designed a road for cars moving at 60 mph, the same design features (such as the turn radii, the sight lines, the guardrail placements) become inadequate when traffic starts moving at 120 mph. The road needs to be redesigned for the speed it's actually operating at.

Most systems were designed for teams working at human speed. The architectural properties that made them evolvable at that pace may not be sufficient for teams working at AI pace.

## The Properties That Matter at High Velocity

Some architectural properties are velocity-neutral. They matter the same whether the team ships weekly or hourly. Several others matter a lot more when teams move fast, and those are the ones that don't always get prioritized in system design. Together, they're what make an architecture *velocity-safe*.

Boundary clarity is probably the most important. When service boundaries are clear and enforced, when it's obvious what a service is responsible for and what it isn't, fast-moving teams can work inside these boundaries confidently without inadvertently violating them.

Fuzzy boundaries at low velocity mean occasional drift. At high velocity, they mean rapid, compounding drift that gets expensive fast.

Contract narrowness is related but distinct. Narrow contracts are where a service exposes only what it genuinely needs to expose and makes minimal assumptions about its callers. Narrow contracts are more resilient to fast iteration. Wide contracts accumulate coupling. Every field in an API response that a caller is implicitly depending on is a constraint on future change. At high velocity, teams add callers quickly and coupling accumulates quickly.

Continuous architectural validation is what turns the previous two properties from aspirations into enforced realities. Fitness functions, architectural linting rules, and service contract tests all run in CI on every commit and fail when architectural properties are violated. At high velocity, manual architectural review can't keep up. Automated architectural validation can.

The size of the feedback loop matters here. A violation caught in a CI check takes minutes to address. The same violation caught in production takes days or weeks. Fast teams need fast architectural feedback, which means the architectural checks have to be automated and integrated into the development flow.

## Technical Debt at AI Speed

Technical debt is not a new concept, and teams have developed workable frameworks for managing it at normal development pace. The key assumption underlying most of those frameworks is that debt accumulates more slowly than the team's capacity to address it.

AI-augmented development invalidates that assumption.

The specific concern is debt that's acceptable at human velocity because the team can deliberately route around it. At AI velocity, that ability to route around it doesn't scale at the same rate as the code output.

You can generate ten times as many changes, but you still have roughly the same bandwidth to remember that service X has a subtle coupling issue that you need to be careful around when you touch Y.

Technical debt that you could comfortably carry for another quarter at normal speed may need to be addressed in a day or two at AI speed. The impact of debt goes up as development speed increases. Debt that lived in the "important but not urgent" bucket moves suddenly to "urgent."

## Where This Shows Up in the Budget

It's tempting to file all of this under development speed. In practice it shows up as an outage at 2am, or a customer-visible regression that traces back to a coupling nobody had the bandwidth to remember.

That has a straightforward business consequence. You bought AI tooling to increase the throughput of the engineering organization. If the gains get consumed by incident response, rework, and a slow erosion of confidence in the system, the return on that investment quietly goes to zero. The worse outcome is that the team stops trusting the tooling and settles back into old speeds, and now you've paid for both the licenses and the whiplash.

Your critical service tiers are where this hurts most. A Tier 1 service with fuzzy boundaries and a wide contract is exactly the place where a fast team can do the most damage in the least time. If you're going to invest in boundary clarity and contract narrowness somewhere first, start there.

## Designing for the Team You're Building

Most architecture conversations are about the current state of the system. What it needs to handle today, how it needs to scale for the next year, what the team working in it today is capable of managing.

The more forward-looking question, and the one that's becoming more important as AI tooling adoption accelerates, is a bit different. What kind of team will be working in this system in twelve months, and what architectural properties do they need?

If your team is planning significant AI tool adoption, or if you're expecting development velocity to increase, the architectural properties that support that safely are worth identifying and investing in now. Clear boundaries. Narrow contracts. Continuous architectural validation. Explicit handling of the technical debt that becomes more dangerous at higher velocity.

None of these are novel techniques. What's new is the urgency of getting them right, and the specificity of the failure mode if you don't. A system that was evolvable at human speed isn't automatically evolvable at AI speed. Evolvability at AI velocity is something you design in. It doesn't come along for free.

Scalability has always been a multi-dimensional problem. Throughput, latency, availability, fault tolerance. Architects have been reasoning across those dimensions for years. Evolvability at high development velocity is the newest one, and it's the one nobody has a maturity model for yet.

So try this before your next planning cycle. Take an afternoon and walk your service map with a different question in mind. Where are the boundaries fuzzy enough that a fast team would blow through them without noticing? Which contracts are wide enough that a new caller could couple to something you already intended to change? Whatever comes off that walk is your list. It's worth working through before the velocity arrives, rather than after.

---

*In [The Software Conductor](https://thesoftwareconductor.com/), I write about how AI is changing the career and practice of software architecture. This article takes that same question into the technical design challenges AI-augmented teams face in the systems they build.*
