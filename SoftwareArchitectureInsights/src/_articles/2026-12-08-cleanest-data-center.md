---
title: "The Cleanest Data Center Is Off the Planet"
subtitle: "Unlimited sun in, waste heat radiated out. No water, no grid, no neighbors."
author: "Lee Atchison"
status: published
created: 2026-09-22
date: 2026-12-08
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: cleanest-data-center.png

meta_description: "SpaceX wants data centers in orbit. Sunlight for power, radiation for cooling, no water or grid. What that means for where your compute runs."
slug: cleanest-data-center
description: >
  Power and cooling are the two hardest problems in running a data center,
  and on the ground they have become political problems too. SpaceX's plan
  for orbital data centers solves both at the source: constant sunlight for
  power, radiation into deep space for cooling, no water and no grid. The
  politics move rather than disappear, and for architects the lesson is
  inference economics: when power sets the price of compute, where the
  power comes from becomes an architecture decision.
categories:
  - "Cloud Strategy & Economics"
  - "AI Strategy & Adoption"

---

# The Cleanest Data Center Is Off the Planet

*Unlimited sun in, waste heat radiated out. No water, no grid, no neighbors.*

---

Building a data center has turned into a political fight. The utility says the substation upgrade will take four years, the county wants a water study, and three hundred residents show up to the planning meeting.

Some version of that meeting is happening all over the country.

On September 21, Texas Governor Greg Abbott ordered the state's environmental regulator to stop issuing permits for new data centers. His reasons were water and the power grid. At least a dozen states filed data center moratorium bills this year.

Power and cooling have always been the two hardest problems in running a data center. Now they are political problems too.

## Two Problems, One Neighborhood

Every watt a server draws turns into heat. You pay for that watt twice, once when it comes in as power and again when you pull it back out as heat.

On Earth, both halves land on someone. The power comes off a shared grid, and residents feel it in their electric bills. The heat usually leaves through evaporative cooling, which means water drawn from the same rivers and aquifers the town depends on.

That is why data centers are so hard to site. They compete with their neighbors for the two things those neighbors can least afford to share.

AI is forcing the issue, because AI racks draw far more power than the racks that came before them. Every workload you run sits on the same electricity and the same cooling, AI or not.

## What Orbit Changes

SpaceX, which acquired xAI earlier this year, wants to move the whole thing off the planet. In January it filed with the FCC for up to a million satellites built as orbital data centers. The first dedicated compute satellites, called AI1, are planned for late 2027, each designed for about 120 kilowatts of compute.

Start with power. Above the atmosphere, in the right orbit, there is no night.

Google's Project Suncatcher team says a solar panel in a dawn-dusk sun-synchronous orbit can be up to eight times more productive than one on Earth, and produces power nearly continuously. Nobody's electric bill goes up.

Cooling changes even more. There is no air in space to blow across a heat sink and no water to evaporate. Heat leaves one way, by radiating out into deep space.

Radiation is the ultimate cooling strategy.

It uses no water. It dumps no heat into anyone's river or neighborhood. Deep space is a heat sink that never fills up.

The engineering is big. Radiators have to be large, and so do the solar arrays feeding the racks. SpaceX's first-generation satellite has a 70-meter wingspan.

That size isn't an accident. Space is cold, but it's also a vacuum, and a vacuum is an insulator. The only way heat leaves is by radiating, so radiator area grows with every kilowatt you add. Critics say that's where the economics break.

Those are problems of size and launch cost, and launch cost is the number SpaceX has built its entire business on driving down.

These are all solvable engineering problems. The water and grid fights on the ground are not engineering problems at all, which is why engineering can't solve them.

## The Politics Move With It

A data center in orbit has no county board, no neighbors, and no water permit. That is a big part of the appeal.

The politics *do* come along for the ride, however.

Orbit is a shared resource. Spectrum and orbital slots are licensed by the FCC and coordinated internationally, and a million-satellite filing from one company is a large claim on that commons. Brookings has already argued that oversight is split across too many agencies to govern it well.

Then there is jurisdiction. Under the Outer Space Treaty, the country that authorizes a spacecraft is responsible for what it does.

A satellite licensed in the United States carries U.S. law with it. For any company with data residency rules, "which region is this running in?" gets a strange new answer.

And there is concentration. Thousands of companies can build a data center on the ground. In orbit, capacity belongs to whoever can launch it, and today that is a short list.

So the local fight becomes a national and international one. But I do think that is a better fight to have. That fight is about how we share a resource that sits in nobody's backyard, and nobody has to give up their water to settle it.

## What This Means for Architects

Most of us will never deploy a workload to orbit. The reason orbit is on the table still matters to every architect.

Earlier in the AI-Native series, I called inference economics one of the four properties that make AI systems different. [Every model call has a real, variable cost](https://softwarearchitectureinsights.com/posts/your-function-call-was-free?utm_source=sai-email&utm_medium=email&utm_campaign=cleanest-data-center&utm_content=body). Underneath that price sits power and cooling.

When power sets the price of compute, where the power comes from becomes an architecture decision.

We already pick regions for latency, for data residency, and for price. Power is joining that list whether the satellites fly or not.

Grid-constrained regions will get more expensive and slower to grow, and new capacity will land where clean power is available. Orbit is the far end of that same curve.

The practical move is to keep your workloads movable. Decide placement per workload, and don't let your first cloud contract decide it for you.

Batch inference, training, and large offline jobs are the easiest to move toward cheap power, on the ground today and possibly in orbit later. Interactive work that sits next to its data will move last.

## Where I Land

I think orbital data centers are the right direction. The engineering is hard, but it's the kind of hard that gives way to iteration and launch volume.

What matters most to me is the environment. Every data center we build on the ground takes water and grid capacity from someone or something. A data center that runs on sunlight and radiates its heat into space takes neither.

No data center on the ground can be that clean.

---

*Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=cleanest-data-center&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=cleanest-data-center&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=cleanest-data-center&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=cleanest-data-center&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=cleanest-data-center&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
