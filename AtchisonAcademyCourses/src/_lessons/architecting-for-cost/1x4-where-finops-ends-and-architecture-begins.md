---
layout: lesson
course: architecting-for-cost
module: 1
lesson: 4
title: "Where FinOps Ends and Architecture Begins"
content_type: video_reading
vimeo_id: 1227033207
video_minutes: 7
reading_minutes: 4
reading_title: "The sorting test"
permalink: /architecting-for-cost/lhtsulearu/1x4/
---
⭐ Carries the reference version of the capital-versus-operating-expense point. The full treatment,
including how to use it in a funding argument, is lesson 08-01, *The Color of Money*.

One question sorts most cost work: **can this be fixed without changing the system?**

| Work | Owner | Why |
|---|---|---|
| Rate and commitment purchasing | FinOps | Changes price, not usage |
| Tagging, allocation, showback plumbing | FinOps | Reporting, though the model behind it is yours (lesson 07-01) |
| Anomaly detection and budget alerts | FinOps | Watches effects |
| Forecasting | FinOps | Needs your input, not your ownership |
| Idle and orphan cleanup | FinOps | Nothing structural changes |
| Service decomposition and granularity | Architecture | Sets the fixed cost of existing |
| Tenancy and isolation model | Architecture | Sets the cost curve per customer |
| Data placement, boundaries, egress paths | Architecture | Determines what crosses a metered line |
| Storage class and lifecycle by access pattern | Architecture | An assumption about how data is used |
| Recovery point and recovery time targets | Architecture | An availability choice with a price |
| Capacity headroom and elasticity | Architecture | A peak assumption with a monthly invoice |
| Model choice and routing for inference | Architecture | Module 6 |

When something appears in both columns, it is usually a reporting problem on the surface and a
design problem underneath. Tagging is the standard example.

## The colour of money, short version

Cloud did not only change how much infrastructure costs. It changed what kind of cost it is.

Buying servers was **capital expenditure**. A company spent once, put the asset on the balance
sheet, and spread the cost over the years it expected to use it. Cloud is **operating expenditure**.
It is paid monthly, forever, and it scales with usage.

Why a CFO cares:

- Operating expense lands on reported earnings in the period it is incurred. Capital expense is
  depreciated over time.
- Capital spending is usually approved once, as a project. Operating spending is reviewed every
  period, which is why cloud spend gets attention that a server purchase never did.
- Growth in operating expense compounds into every future forecast.

**And it is not the same everywhere.** How welcome that shift is depends on the business:

- A capital-heavy or regulated business may be comfortable owning assets and may prefer to. Hybrid,
  colocation and long commitments are easier arguments there.
- A software business usually prefers operating expense and predictability, and a proposal to buy
  hardware will meet resistance no matter how good the arithmetic is.
- A company under earnings pressure treats every recurring dollar differently from one that is not.

The practical consequence for you is narrow but real. The same cost proposal, with the same numbers,
wins at one company and dies at another, and the difference has nothing to do with the technical
argument. Knowing which kind of company you work for tells you which argument to make.

## The working agreement

Write this down somewhere both sides can see it.

**FinOps brings:** the number, the trend, which team it lands on, and the forecast.
**Architecture brings:** the decision that causes it, the cost of changing it, and what the company
gives up if it does.

A cause with no number never gets funded. A number with no cause never gets fixed.

## The failure mode, stated plainly

If a cost initiative owned by an architect has produced dashboards, tag audits and spend reviews,
and has not produced a single design change, it has become a slower copy of the FinOps function.

Check yours against that. It is the most common way a year disappears here.

## Module 1 in four sentences

Finance cannot reach the cause of your bill. A bill can be read backwards to the decisions that
caused it. Most teams cannot make that connection, and the gap is where the money is. The work that
is yours is separable from the work that belongs to finance.

Module 2 turns that into a method.
