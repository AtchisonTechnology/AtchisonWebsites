---
title: The Single-Architect Availability Problem
subtitle: ""
author: Lee Atchison
status: published
created: 2026-05-07
date: 2026-07-28
published_on: 2026-07-28

sai_url: https://softwarearchitectureinsights.com/posts/the-single-architect-availability-problem
email_sent: 2026-07-28
linkedin_url:

hero_image: 

internal_note:
meta_description: Apply the single-point-of-failure test to your architecture practice, not just your systems. Concentrated architectural knowledge is a reliability risk.
slug: the-single-architect-availability-problem
description: >
  Reliability engineering asks what happens when a component becomes unavailable. Most organizations never ask that about the person who holds all the architectural context — and the six-week test to find out if you have that single point of failure.
categories:
  - "Availability & Resilience"
  - "The Architect's Role"

---

Imagine you're doing a reliability review of a critical system. You're walking through the architecture, applying the standard single-point-of-failure test: what happens to this system if component X becomes unavailable?

You find one. A database that three services depend on, with no replica. A message queue that sits in the path of every customer transaction. A third-party API call with no circuit breaker and no fallback. You document these items, prioritize them, and your team adds redundancy, failover, or a graceful degradation path.

That's how reliability engineering works. You identify the single points of failure and you address them systematically.

Now, when's the last time you applied that same test to your architecture practice?

Most organizations have a single point of failure sitting in plain sight in their architecture work. They've classified it as a people issue, or a knowledge management issue, or a bus factor conversation they keep meaning to have. It isn't any of those things.

It's a system reliability problem. And it deserves the same systematic treatment.

## What the Single Point of Failure Looks Like in Practice

When architectural knowledge concentrates in one person, systems develop an invisible dependency on that person's availability. I don't just mean availability for new decisions, although that's real. I mean availability for the *reasoning behind existing decisions*.

What does that look like in practice? A team wants to change how two services communicate. They look at the service contracts, system documents, and the comments in the code. They can't find a clear answer about why the current design was chosen or what constraints it was trying to satisfy. So they make a change that seems reasonable from where they're standing. Three months later, that change has introduced a subtle ordering dependency that breaks under load. It's exactly the kind of problem the original design was meant to prevent.

Who knew? Nobody. The reasoning wasn't there to find.

Or consider this. A team escalates a design decision to the architect, even though they're capable of making it themselves, because they've learned that they don't have enough context to make it confidently. The architect answers. The team moves forward. But the team's judgment hasn't improved. They'll be back next time. The architect isn't a bottleneck because they're slow to answer. They're a bottleneck because the knowledge required to answer well never left them.

Both of these are failure modes from the same root cause. Architectural knowledge concentrated in a way that makes the system brittle when that knowledge becomes unavailable.

## The Cost Model

What are the real costs here?

The direct costs are familiar. The architect as bottleneck, decisions queued and delayed, team velocity constrained by a single person's available time. Those are real costs. But they are also the *visible costs*.

The *hidden costs* are where the real damage accumulates. Teams making decisions without sufficient context add accidental complexity to their system. Every workaround for a constraint they don't understand is a form of complexity that makes the system harder to change later.

Every escalation that should have been a local decision is now a context-switch cost for the architect.

And every time a team works around a service boundary they don't fully understand rather than questioning whether the boundary is still right, the system drifts a little further from its intended design.

Compound this over a year or two in a fast-moving codebase, and you end up with a system that looks coherent in the architecture docs but has accumulated a substantial layer of complexity that nobody can fully explain. The architectural single point of failure (SPOF) didn't cause a dramatic outage. It caused a slow degradation in the system's evolvability that was invisible.

Invisible, that is, until it became very visible.

## How to Find Your SPOF

The "what happens when X is unavailable" test is straightforward to apply to people, even if we don't usually frame it that way.

Pick your most experienced architect. Now ask what would stop if they were completely unreachable for the next six weeks. No email, no Slack, no calls.

Call it the six-week test.

Some things that stop are fine. New major initiatives should probably wait for key input. That isn't a SPOF. That's an appropriate dependency on expertise.

What you're looking for is things that *would* stop that *shouldn't* have to. This includes decisions that teams should be capable of making but wouldn't make confidently without that specific person's involvement. Design questions that would get answered wrong, or not at all, because the reasoning behind existing constraints isn't available anywhere the team can reach. Services that would drift in a problematic direction because nobody else knows what direction they're supposed to be drifting in.

If your list is long, you have an architectural SPOF. The question is what to do about it.

## Distributing Judgment Beyond the Documents

The instinctive response to this diagnosis is documentation. Write things down. Capture the decisions. Make sure the reasoning is somewhere. That instinct isn't wrong. It's only a small part of the solution.

Documentation captures what was decided at a point in time. It doesn't build the judgment required to make *similar decisions* in the future, when the situation has evolved and the documented decision no longer applies cleanly. Knowledge that lives in documents requires someone to interpret it. Knowledge that lives in people's judgment requires much less translation.

The goal isn't documentation. The goal is *distributed judgment*.

*Distributed judgment* means building the capability to make good architectural decisions across a broader set of people.

In practice, this means a few things that are distinct from just writing better specs. It means running architecture reviews that teach rather than approve. In those reviews, the architect surfaces the reasoning behind a recommendation, along with the recommendation itself. It means creating design standards that explain *why* standards exist, so that teams can understand when an exception is warranted and when it isn't. It means treating the "how do you know when this rule applies" question as the important one, not just the rule itself.

It also means the architect spending time in conversations that build other people's context, rather than only conversations where the architect provides answers. The latter feels more productive in the short run. It compounds in the wrong direction.

## The Reliability Test

Here's a clean way to think about where you stand. Ask yourself what would happen if your most experienced architect left the company tomorrow, with reasonable notice and full cooperation on transition. How long would it take for your team's architectural decision quality to return to where it is today?

If the answer is months to a year or more, you have a significant SPOF. If the answer is weeks, you've done meaningful work to distribute the judgment.

The answer isn't always comfortable. But it's the right question to be asking before the transition happens under less cooperative circumstances. Think about a sudden departure, an extended leave, a promotion into a role where the day-to-day architectural work is no longer in scope.

Single points of failure are problems you can address systematically. The same principles apply whether the component you are evaluating is a *database* or an *architect*.

---

*In [The Software Conductor](https://thesoftwareconductor.com), I explore how architects can scale their judgment across teams, and why that's the most important thing they can do for their organizations and their own careers.*
