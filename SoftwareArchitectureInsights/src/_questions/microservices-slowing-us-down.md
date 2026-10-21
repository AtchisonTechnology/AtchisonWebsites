---
title: "Why Are Our Microservices Slowing Us Down?"
order: 1
description: >-
  Microservices were supposed to let teams ship on their own. When they slow
  you down instead, the usual cause is unclear ownership.
---
Most teams move to microservices for one reason. They want teams to stop waiting on each other. Then, a year or two later, a simple feature still needs four teams, three meetings, and a coordinated release.

When that happens, look at ownership before you look at the code.

Picture a checkout change. It touches the cart service, the pricing service, and the order service. Two of those have a clear owner. The third was built by a team that has since moved on, and now three different teams make changes to it.

So every change to that service needs a conversation. Who reviews it? Who gets paged if it breaks?

Nobody is sure, so everybody gets involved.

You've built a distributed monolith, a monolith with network calls in it. It looks like success right up until a deploy to one service takes down another. You've added deployment pipelines and a network between every pair of teams, and you've kept the coordination cost you were trying to escape.

Service size causes the same slowdown. Split services too small, and one feature crosses a dozen boundaries, so developers spend their days on the connections between services. Leave them too large, and each one is a smaller monolith with all the old problems.

## One Service, One Team

The model I recommend is STOSA, the Single Team Oriented Service Architecture. Its core rule is simple. Every service has exactly one owning team, and that team builds it, changes it, deploys it, and gets paged for it.

A team can own several services. A service never has several teams.

With ownership that clear, most of the coordination goes away. A team changes its own services on its own schedule. It agrees on interfaces with its neighbors and doesn't need to agree on much else. When something breaks, everyone knows whose phone rings.

Ownership has to come with authority, too. A team that must ask permission before changing its service doesn't own it.

The same goes for architecture decisions. If every question about a service boundary waits for one architect, the teams will wait with it. Write down why each boundary sits where it does, so the owning team can decide without asking.

You can read the full model at [stosa.org](https://stosa.org/).

This advice has a limit. With one or two small teams, everyone already knows the whole system, and assigning owners won't change much. Your slowdown is more likely too many services for too few people. Merge services until each one is worth a team's attention.

For everyone else, start with a list. Write down every service and the one team that owns it. Any service with no name next to it, or with two, is where your time is going.
