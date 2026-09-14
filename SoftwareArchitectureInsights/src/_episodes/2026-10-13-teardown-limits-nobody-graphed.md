---
title: "The Limits Nobody Graphed"
slug: teardown-limits-nobody-graphed
date: 2026-10-13
episode_number: 14
category: Teardown
tags: []
description: "GitHub had three outages in three weeks with the same root cause: capacity ran out in places nobody was watching."
captivate_episode_id: "fb6a12bc-f78e-4026-94cb-4b866416afe0"
source_articles: []
duration: "9:30"
---

GitHub published five incidents for August 2026. Three of them are the same failure: capacity ran out somewhere nobody was graphing, and production traffic found the limit before any monitoring did.

Your autoscaler scales the thing you are observing. Saturation happens in the thing you don't.

**In this episode:**

- The August 17th outage: seven and a half hours, 29,000 organizations, 4.8 million failed or slow requests
- Three incidents, one blind spot: sidecar concurrency, network flow tables, database primary headroom
- Why these limits are dangerous: someone else's layer, hard rather than soft, and no dashboard
- Retry amplification, and how a capacity problem in one data center became an authentication outage everywhere
- Protective throttles set so high they engaged after the damage was done
- Two lists to build this week: your real hard limits, and your retry code

**Links:**

- [GitHub Availability Report: August 2026](https://github.blog/news-insights/company-news/github-availability-report-august-2026/)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. On the 17th of August, GitHub had the kind of day that nobody wants. Issues, pull requests, The REST and GraphQL APIs, actions, Copilot, authentication, webhooks, all of it degraded or failing for seven and a half hours. At the peak, 56% of requests through the front door failed or crawled. About 29,000 organizations felt it. Roughly 4.8 million requests either failed outright or took long enough that the person waiting gave up.

Now that's a bad day, and talking about it and digesting what happened is a fairly ordinary teardown postmortem review. But what makes this one worth your time is what happened in the three weeks around it GitHub published five incidents for August. Three of them are the same failure. On the sixth, a routine display reduced pod capacity in one data center. The sites still running went past their concurrency limits, and the service mesh sidecar started CPU throttling and restarting out of memory. The incident went on for 10 hours and 42 minutes On the 17th, a new traffic peak pushed one data center's load balancers past their limits.

The service mesh sidecar hit its concurrency limit and didn't scale up correctly. Network flow limits ran out across multiple load balancer nodes. On the 26th, actions growth month over month outran the infrastructure, and a traffic burst saturated the shared database primary. One in five run starts failing at the peak Three times in three weeks, capacity ran out somewhere nobody was watching. Production traffic found the limit before any monitoring ever did. Three separate incidents, one underlying blind spot. And a blind spot at a company with GitHub's engineering depth is worth more of your attention than a single bad afternoon.

Here is the idea. Your autoscaler scales the thing you are observing. Saturation happens in the thing that you don't observe. Think about what you actually have scaling policy set on. Pods probably, CPU, and memory. Maybe request rate or queue depth if you've done the work on those. Now think about what actually ran out at GitHub. Service mesh sidecar concurrency, network flow table entries on the load balancer node, headroom on a database primary once a fallback path turned on. Nobody writes a scaling policy against sidecar concurrency. I've never seen a dashboard with flow table entries on it, and I bet you haven't either.

These limits have three things in common, and the combination is what makes them dangerous. They live deep in the infrastructure plumbing rather than up in your application, so they belong to a layer that somebody else chose. They're hard limits rather than soft ones, which means the behavior past the limit is a cliff instead of a slope, and they have no dashboard, hence no visibility. GitHub's own follow-up list gives the game away. Correct the autoscaling policies to account for sidecar concurrency. Audit request, concurrency, and scaling limits across the whole service mesh.

They went looking for the limits they didn't know that they had. That's the work that was needed There's a second thread in the August 17th incident that deserves its own attention. A latent bug in client's retry logic amplified traffic into the shared gateway authentication path. So a capacity problem in one data center's load balancers became an authentication failure across the entire product. Sign-in is upstream of everything, which is why the blast radius covered everything, issues, pull requests, the APIs and actions, everything all at once. Part of GitHub's remediation was blocking the retry triggering requests to that endpoint.

In other words, to recover from the outage, they first had to stop their own clients from hammering them. Retry logic tends to get written once early in a product life cycle by whoever was creating the client. Then nobody touches it for years, and it sits there quietly working the same way, whether it's effective or not. GitHub's follow-up is to review and fix retry and backoff limits in its clients to prevent amplification cascades. It's worth stealing that sentence for your own backlog One more interesting thing from the 26th incident. This one is short.

They had protective throttles, but the throttles were set too high, so they engaged after the damage was already done. Engineers tuned them by hand during the incident, then raised them back gradually while watching telemetry. The circuit breaker was there. It was configured to trip after the fire was already burning. Their fix is to make it automatic rather than manual. A throttle a human has to set during an incident is not a safety mechanism. It's a second job for somebody who already has one. So two things for you to do. First, go find as many of your real hard limits as you can.

I don't mean your capacity plan, which covers the resources you decided to buy. I mean the limits sitting inside the layers that you didn't choose Sidecar concurrency, connection tables, flow tables, file descriptors, thread pools, database connections, queue depths. For each one of those, ask yourself two questions. Do you know what the limit is? And does anything tell you before the limit is reached? Most teams can't answer the first question for most of the list, and that by itself is a finding worth taking to your next architecture review. Second, go read your retry code.

When a dependency starts failing, does the client back off? And is there any cap on total retry volume across all of your clients at once? If a retry storm is possible, then every hard limit on that first list stops being a slowdown and turns into an outage. That's the connection between the two lists, and it's why GitHub's bad day was seven and a half hours instead of 40 minutes.

A link to GitHub's August availability report is in the show notes. It covers all five of these incidents, and it's more specific than most companies are willing to talk about their own capacity limits. Hats off to them. By publishing the information, they are holding themselves accountable, and they're helping the rest of the industry. Take a look at it. Read the whole month rather than just the 17th incident. The pattern is the point Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
