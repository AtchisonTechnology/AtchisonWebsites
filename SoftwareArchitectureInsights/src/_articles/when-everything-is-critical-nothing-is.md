---
title: When Everything Is Critical, Nothing Is
subtitle: Criticality is one decision. Ownership is the other. Most organizations have made neither.
author: Lee Atchison
status: published
created: 2026-08-17
date: 2026-08-25
published_on: 2026-08-25

sai_url: https://softwarearchitectureinsights.com/posts/when-everything-is-critical-nothing-is
email_sent: 2026-08-25
linkedin_url:

hero_image: when-everything-is-critical-nothing-is.png

internal_note:
meta_description: Most reliability failures are ownership failures. Two decisions sit underneath every reliable system. Which services matter, and who is accountable.
slug: when-everything-is-critical-nothing-is
description: >
  Reliability isn't only a technical property, it's an ownership property. Two decisions sit underneath every reliable system, what actually matters and who is accountable for keeping it up, and most organizations have made neither.
categories:
  - "Availability & Resilience"
  - "The Architect's Role"

---

# When Everything Is Critical, Nothing Is

*Criticality is one decision. Ownership is the other. Most organizations have made neither.*

---

It's 3:07 in the morning and a phone is going off. The alert says a payment-related service is throwing errors for about a third of its requests. The engineer who acknowledges the page has never touched that service. They open the runbook, which was last edited by someone who left the company in March. They page the team they believe owns it. That team replies that it owns the client library, not the service itself, and suggests trying the platform group.

Forty minutes in, nobody has changed a single line of configuration. The fix isn't hard. Nobody on the call has the context or the authority to make it.

The service recovers at 4:20. Two days later, the incident write-up is finished and names the root cause as connection pool exhaustion. That's technically accurate. It's also the least interesting fact in the document. The pool exhaustion took eleven minutes to diagnose. The other sixty-two minutes were spent looking for a person who knew what was going on.

## The diagnosis everyone reaches for first

Incidents like that get filed under communication. The review recommends better cross-team visibility. Somebody proposes a service catalog. Catalogs are good, and a catalog will faithfully record the fact that nobody ever decided.

Somebody else proposes consolidating the on-call rotations.

None of that is wrong. Some of it helps. But organizations do all of it and then have the same incident again eight weeks later, which tells you the diagnosis missed.

What happened at 3am wasn't a communication failure. Two decisions were missing, and the incident found them at the worst possible hour.

The first: which services actually matter?

The second: who is accountable for keeping them operational?

We treat reliability as a technical property. Retries, redundancy, failover, error budgets, multi-region. All of that matters, and I've written plenty about it. But underneath all of it sit two decisions that aren't technical at all. Most organizations have never made either one, and no tool is going to make them for you.

## Everything is Tier 1, which means there are no tiers

Ask an engineering organization to sort its services by criticality and watch what comes back. Checkout is Tier 1, obviously. Auth is Tier 1, because nothing works without it. The recommendation service is Tier 1, because revenue. The internal reporting tool is Tier 1, because the CFO uses it. By the end of the exercise there are fifty-three services and forty-eight of them are Tier 1.

At that point the tiers have stopped classifying anything. When everything is critical, nothing is critical.

The cost of that shows up in the budget. Reliability money is finite, and treating a service as Tier 1 critical costs real dollars. Multi-region deployment costs dollars. A dedicated on-call rotation costs headcount and sleep. Failure injection testing eats engineering weeks. When forty-eight services all claim the top tier of criticality, that spend gets spread flat across them. The internal reporting tool gets the same architectural attention as checkout. And checkout doesn't get its second region, because after the flat spread there wasn't enough left to pay for one.

Paging has the same problem. If everything can fire a severity-1 alert, severity 1 stops meaning anything. The engineer at 3:07 has been trained by six months of low-stakes pages to assume this one is probably also nothing. That assumption is correct most nights. It costs you the night it isn't.

Tiering is uncomfortable, and the paperwork is the easy part. Assigning a tier means agreeing, ahead of time and in writing, that some things are allowed to break while you fix something else first. Try having that conversation with the team that owns the thing you just ranked third. It's much easier to call everything important and let the ranking happen at 3am, by whoever answers the page.

## Ownership means one team, named, and current

The second decision sounds easy. Every service has exactly one owning team. That team is named. The name is right today, not left over from 2023.

Shared ownership sounds collaborative, but it's really a *lack* of accountability. When two teams own a service, each has a good reason to think the other is handling it. When four teams own it, nobody owns it, and every one of them would sincerely tell you otherwise.

This is the principle I've called [STOSA](https://stosa.org/), single team oriented service architecture. One service, one owning team, period.

During an incident, the thing you actually control is the number of hops between the page firing and the person who can change something. Every hop is a handoff. Every handoff is minutes. Single ownership makes that number one. Ambiguous ownership makes it three, or four, or a Slack thread that goes quiet at 3:40 because the one person who knew the answer is asleep in another time zone.

That's an availability argument. The page reaches someone who can fix it, and the outage is twelve minutes instead of ninety.

The bigger cost comes earlier, though. Unowned services don't get the boring work that keeps them running. Certificates get renewed by whoever remembers. Dependency upgrades slip, because no team's roadmap has a line for a service that isn't theirs. Capacity headroom drifts for a year, because watching that graph is a job and jobs belong to teams. The 3am page is the failure you see. The eighteen quiet months that built it are the real one.

Ownership is uncomfortable for the same reason tiering is. Putting a team's name on a service means that team takes the pages, including the 3am ones, for something they inherited and didn't write. That's a real cost to real people. It's why the owner field so often gets a plausible name instead of an agreed one.

## Neither decision works without the other

Tiers without ownership are useless. You can classify checkout as Tier 1 and commit to four nines, and if no single team is accountable for that number, nobody is going to defend it when a deadline shows up. The tier is a promise nobody made.

Ownership without tiers is a team defending everything equally, which is the same as defending nothing in particular. Give a team twelve services and no criticality ranking, and it will spend its reliability budget on whichever one broke most recently. Without better information, that's a reasonable way to work. It's also how the service that hasn't broken yet becomes the one that takes you down.

Put them together and each makes the other work more effectively. The tier tells a team how much reliability to buy. Ownership gives that team the authority, and the obligation, to buy it. A Tier 1 service with a named owner is a commitment. Either half alone is a preference.

## Check your top ten

Take your ten highest-traffic services. For each one, write down the owning team and the criticality tier. Don't simply write down what the service catalog says. Write down what you believe, from memory, *right now*.

Then go check. The gap between those two lists is something worth measuring. In most organizations I've worked with, the gap is wider than anyone in the room expects.

If you want a more structured version of that exercise, I've put together an ownership-gap diagnostic that walks through five dimensions: service inventory, ownership, criticality, alignment between the two, and enforcement. It's a spreadsheet you fill in for your own environment, and it will tell you which of the two decisions your organization is actually missing.

[Get the ownership-gap diagnostic](https://softwarearchitectureinsights.com/service-ownership-diagnostic)
