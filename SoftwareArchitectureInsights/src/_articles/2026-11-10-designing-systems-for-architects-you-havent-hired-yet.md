---
title: "Designing Systems for Architects You Haven't Hired Yet"
subtitle: "Can your system be changed safely by someone who wasn't in any of the original conversations?"
author: "Lee Atchison"
status: published
created: 2026-05-07
date: 2026-11-10
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: designing-systems-for-architects-you-havent-hired-yet.png

internal_note:
meta_description: "Most systems only make sense to the people who built them. How to design one a new architect can change safely, without the history in their head."
subject: "Designing Systems for Architects You Haven't Hired Yet"
preview_text: "Everything works while the people who designed it are still on the team."
ad_slots: "Two. One directly above ## Where the Reasoning Lives. One directly above ## Who This Is For."
slug: designing-systems-for-architects-you-havent-hired-yet
description: >
  Most systems are designed by the people who understand them best. That's fine for now. But the question worth asking at design time is whether the system can be safely evolved by someone who wasn't in any of the original conversations.
categories:
  - "Scalability & System Design"
  - "The Architect's Role"

---

# Designing Systems for Architects You Haven't Hired Yet

*Can your system be changed safely by someone who wasn't in any of the original conversations?*

---

Most systems are designed by the people who understand them best. They know why the service boundaries are where they are. They know which invariants the system actually relies on, as opposed to the ones written in the docs.

They also know why the payment service retries the way it does. It was tuned for a quirk of the payment processor they left two years ago. Change it without that history, and you get a failure that only shows up under high load.

That knowledge is fine to have in someone's head while that person is on the team. The question to ask at design time is what happens when they're not.

This isn't a new question. But most teams treat it as a handoff event, something to deal with when a key person gives notice. By then the system either explains itself or it doesn't, and it's too late to change which.

Treat it as a property of the design, and you build a different system.

## The Difference Between Documentation and Design

The instinctive response to "future architects need to understand this system" is documentation. Keep the wiki updated and the ADRs current.

Documentation is something you produce after the design is done. It captures what was decided and, ideally, why.

But a future architect has to find it, read it, and decide whether it still applies to a system that has changed since. Over time, the two drift apart. A year after a major refactor, your ADRs describe a system that no longer exists.

A system designed for handoff carries its reasoning in its structure. The structure itself tells you what the constraints are.

Say service A must never call service B synchronously. You don't need to find the document that explains why. The service contract makes that rule explicit and enforces it at the boundary.

The same goes for the payment service's odd retry behavior. The retry policy lives in configuration that shows how it was calibrated, and why.

The architecture becomes the primary documentation. And architecture, unlike a wiki page, stays accurate because it's the actual system.

## Where the Reasoning Lives

The most direct form of this is a service contract that states its invariants. An interface tells you what a service accepts and what it returns. An invariant tells you what is always true: what the service guarantees its callers, and what callers must do in return.

A future architect who reads that contract sees the design intent. That's what they need to change the system safely.

Fitness functions are another. A fitness function is an automated check on the structure of the system. Three examples:

"No service in the order domain should call directly into the payment domain without going through the payment service." 

"Response times for Tier 1 services must remain below 100ms at the 95th percentile." 

"No service should have more than three direct dependencies." 

These run in CI on every change. When someone breaks a property the architecture relies on, the build fails right away. That holds even when nobody knew the rule was there.

A fitness function checks what the system is, where most tests check what it does. It states the architecture's rules to anyone who touches the code.

A new architect working in a system with good fitness functions finds the boundaries fast, because the build tells them. The system teaches them.

Decision records belong in the code or the configuration, next to the thing they explain. There they move with the code and stay accurate.

Picture a comment block in the payment service's retry configuration that tells the calibration story and what drove it. It will outlive any wiki page, and anyone who changes that configuration reads the explanation first.

## The New Architect On-Ramp Test

Here's a test for your current systems. How long does it take a strong architect, new to your system, to make architectural calls with confidence?

Experienced developers learn the code fast. The why takes longer.

That means why the system was split the way it was, which invariants it relies on, and which decisions are locked in versus still open.

In a system designed for handoff, that ramp-up takes days to weeks. The constraints are visible in the structure, and the fitness functions push back the moment you lean on a boundary.

In a system designed by and for the team that built it, the ramp-up takes months, sometimes longer. The new architect depends on whoever holds the history, and hopes those people are still around and remember it right.

That gap is real cost. It hurts most at exactly the wrong times: after a fast scaling phase stretched the original design, during a major migration, or while you build a big new capability.

## Who This Is For

The title says architects you haven't hired yet. But future architects aren't the only ones who benefit.

The current development team makes better local decisions when the architecture's intent is visible. The senior developer handling a 2 a.m. incident can make the call without waiting to escalate. The product team can see what's feasible and what would take real architectural change.

A system that describes itself gives teams autonomy. They stop escalating every hard architectural question, and they move faster, because the context is in front of them instead of in someone else's review queue.

You make this choice in the design. It shows up in how service boundaries express their constraints, what your CI pipeline checks, and how you organize and annotate configuration.

Not every system needs this. A prototype, or a service you plan to retire within a year, can live on what its builders remember. Spend the effort on the systems that will outlive their authors.

Make it a design consideration from the start, and the system will keep teaching everyone who works in it. Leave it for later, and later tends to mean never.

---

*The architect who holds all the history in their head is a bottleneck, however good they are. Getting out of that role is one of the threads in [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=designing-systems-for-architects-you-havent-hired-yet&utm_content=cta), my book for senior developers making the move to architect. It's told as a story, about a developer who learns the job from a symphony conductor.*

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=designing-systems-for-architects-you-havent-hired-yet&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=designing-systems-for-architects-you-havent-hired-yet&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=designing-systems-for-architects-you-havent-hired-yet&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=designing-systems-for-architects-you-havent-hired-yet&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=designing-systems-for-architects-you-havent-hired-yet&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
