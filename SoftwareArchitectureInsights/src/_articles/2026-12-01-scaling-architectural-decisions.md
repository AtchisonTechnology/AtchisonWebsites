---
title: "When Your Architects Give Different Answers"
subtitle: "You fixed the bottleneck. Now three architects need to give one answer."
author: "Lee Atchison"
status: published
created: 2026-09-25
date: 2026-12-01
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: scaling-architectural-decisions.png

meta_description: "More architects fix the bottleneck and create a consistency problem. Domain owners and decision rights keep several architects giving one answer."
slug: scaling-architectural-decisions
description: >
  The sequel to The Single-Architect Availability Problem. Once architectural
  judgment is spread across several architects, the bottleneck turns into a
  consistency problem. Domain ownership, decision rights sorted by reach, and
  shared principles keep the architects giving the system one answer.
categories:
  - "The Architect's Role"

---

# When Your Architects Give Different Answers

*You fixed the bottleneck. Now three architects need to give one answer.*

---

Add a second architect and you get a second answer to every question.

Two teams ask two architects the same question in the same week. Should the new order service publish events, or should the billing service call it directly?

One architect says events. The other says a synchronous call. Both give good reasons, and both are right about the part of the system they were looking at.

Six months later, your system does it both ways. Nobody chose that.

## You Fixed the Bottleneck

Earlier this year I wrote about [the single-architect availability problem](https://softwarearchitectureinsights.com/posts/the-single-architect-availability-problem?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=body). When all the architectural judgment lives in one person, that person is a single point of failure. The fix was to distribute the judgment.

Say you did it. You now have three or four people who can make good architectural calls, and decisions no longer queue behind one calendar.

You also lost something you didn't know you had.

One architect, however overloaded, was consistent. Every answer came from the same head, with the same principles and the same memory of past decisions. The system had one point of view, even when that point of view was slow to arrive.

Anyone who has scaled a database knows this trade. Replace one server with a cluster, and your availability problem becomes a consistency problem. You have to decide which node owns which data, and how the nodes agree when a write touches more than one of them.

An architecture practice with several architects needs the same two answers. Partitioning and consensus. In practice, that means domain ownership and decision rights.

## Give Every Question One Owner

Start with the domains. Each architect owns one area of the system, such as payments and billing, the customer-facing platform, or data and integration.

Draw the lines along the service boundaries you already have, so each domain maps to a known set of services and the teams that own them.

This is the same idea behind [STOSA](https://stosa.org/?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=body), the Single Team Oriented Service Architecture model, where every service has exactly one owning team. Here, every architectural question has exactly one owning architect.

That stops teams from shopping. When any architect can answer any question, teams learn which one tends to say yes, and they ask that one.

Nobody does this out of bad intent. It's simply the fastest path to an answer.

The result is a system whose direction is set by whoever happened to get asked.

## Sort Decisions by How Far They Reach

Domains tell you who owns a question. Decision rights tell you how far up it goes.

A decision contained inside one service belongs to the team that owns the service. The architect advises and teaches, then gets out of the way. Most decisions live here, and keeping them with the teams is why you distributed judgment.

A decision that affects several services inside one domain belongs to that domain's architect. They decide, write down why, and tell the teams involved.

A decision that crosses a domain boundary is where the order-service mess came from. Neither architect owns it alone. It goes to the architects as a group, and the group names one person to make the call.

That last step matters more than it looks. "The architects will discuss it" is how a cross-domain decision stalls for a month. Every one of them needs a named decider and a date.

## Keep the Architects Consistent

Ownership and decision rights settle who decides. They don't make three architects reason alike. For that, the architects need the same principles and a clear view of what the others decided.

Write principles with their reasons attached. "Prefer asynchronous events between domains" is a rule. "Prefer asynchronous events between domains, because a failure in one domain shouldn't take down another" is a principle. The reason lets an architect handle a case the rule never anticipated, and handle it the way the others would.

Keep one decision log for all the architects, where each entry says what was decided, by whom, and why. Any format works, as long as it lives in one place. If each architect keeps notes in their own place, you are back to judgment that lives in individual heads.

Review each other's decisions on a regular schedule. The domain architect has already made the call. The review lets the others see the reasoning, and catch two architects drifting apart before the system does.

When the architects disagree, they argue it out in that room. Once the call is made, every architect defends it, including the ones who argued against it.

Teams should never hear two answers to one question.

---

*Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=scaling-architectural-decisions&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
