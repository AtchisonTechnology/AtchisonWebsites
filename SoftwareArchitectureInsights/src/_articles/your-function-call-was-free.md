---
title: "Your Function Call Was Free. This One Isn't."
subtitle: "AI-Native Architecture, part two of four: every inference has a price and a latency."
author: "Lee Atchison"
status: draft
created: 2026-08-20
date: 2026-09-08
series: "AI-Native Architecture"
series_position: "Act I, article 2 of 4 — property 2: inference economics"
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: your-function-call-was-free.png

internal_note: "AI-Native: Act I, Issue 2"
meta_description: "An inference call costs money and latency, and both are set in code. Model routing is an architectural decision with a per-transaction price attached."
slug: your-function-call-was-free
description: >
  Distributed systems changed architecture because the network made a function
  call expensive. AI does it again, except the cost is money as well as
  latency. Model routing is an architectural decision, not an optimization you
  do later.
categories:
  - "AI-Native Architecture"
  - "Cloud Strategy & Economics"

---

# Your Function Call Was Free. This One Isn't.

*AI-Native Architecture, part two of four: every inference has a price and a latency.*

---

The feature demoed beautifully back in March. A support assistant that reads the customer history, checks the order, and drafts a reply. Everyone in the room agreed it should ship.

It shipped in June. By August somebody in finance is asking why one line on the cloud bill is growing faster than the company is.

Nobody did anything wrong. The feature works exactly as designed.

*That's exactly the problem.*

## The Network Taught Us This Once Already

When we moved from monoliths to distributed systems, what changed architecture was a single fact. A call crossing a network became categorically different from a call that didn't.

A whole set of patterns followed. Batching, because ten round trips cost more than one. Caching, because the cheapest call is the one you skip. Circuit breakers, because a slow dependency takes you down with it. Locality, because distance is latency.

None of those were optimizations bolted on afterward. They became part of how systems got designed, because the cost of a call had moved into the range where design had to account for it.

Inference does it again. A function call costs microseconds and effectively nothing. An inference call costs money and it costs time, and both vary depending on decisions somebody made at design time.

## You Choose This Cost

Network latency was mostly something you suffered. You could shorten the path or make fewer trips, but you didn't get to pick a cheaper network.

Inference is different. Two of its biggest cost inputs are yours to set.

Model size is a choice. Context length is a choice. Both get made in the code, and both show up on an invoice thirty days later.

That's new territory for most architects. We reason comfortably about capacity, throughput, and latency budgets. We are not used to a design decision with a per-transaction price attached, visible to the CFO, that changes monthly.

Teams that leave that decision for later don't avoid it. They make it by default, and the default is almost always a bad answer. *Just use the biggest model*, because that's what the demo used. Easy at design time. Expensive forever after.

## Routing Is an Architectural Decision

Take the support assistant from the top of this article. Let's invent some numbers. Say fifty thousand conversations a month.

Each conversation fires six inference calls. One to classify what the customer wants. One to decide what history to pull. Three during drafting. One to check the draft. That's three hundred thousand model calls a month, from a feature everyone in the building calls "the chat thing."

Now look at what those six calls are doing.

Sorting a request into one of twelve categories is not the same kind of work as composing a careful reply to an angry customer. One of those is a judgment call. The other is a dropdown. Deciding which records to retrieve isn't the hard kind either. Several of those calls are going to an expensive general-purpose model for exactly one reason. It's the model that got wired in first, back in March, by someone who was solving a different problem.

I'm deliberately not putting per-token prices in this article, because they will change well before it stops being read. The ratio is the durable part. The spread between the largest models and the small ones is wide enough that moving three of those six calls down a tier changes the monthly number by a lot, and it does so without touching anything the customer can see.

That's what "which model, when" means as an architectural decision. It's routing. It belongs in the design, with a name, a place on the diagram, and consequences.

Routing to the smallest model that clears the bar requires knowing where the bar is. [Last week's article, on evaluation and acceptance thresholds](https://softwarearchitectureinsights.com/posts/it-passed-the-test-that-doesn-t-mean-it-works?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=body), was about how you get one. Without a threshold, "is the cheaper model good enough here" has no answer, and the conversation collapses back to whoever sounds most confident in the room.

The two properties are connected on purpose.

## The Cache Whose Key Is a Sentence

Exact-match caching barely helps. Two customers asking the same question in their own words produce different strings, so the cache misses almost every time. The hit rate is bad enough that most teams try it once, look at the graph, and quietly stop talking about it.

What works is matching on meaning rather than on characters. Which introduces a problem.

If a stored answer comes back for a question that's merely similar, the system has just decided that two different questions deserve the same answer. Sometimes that's correct and saves real money. Sometimes it quietly hands last month's shipping policy to somebody asking about this month's.

So semantic caching is a correctness decision wearing the costume of a performance improvement. How close is close enough is a threshold, and it needs what every threshold needs. Somebody sets it, somebody measures it, somebody owns it.

## Who Gets the Bill

One customer action fans out into six calls across three services owned by two teams. Which budget does it come out of?

That's an old problem. Cloud cost attribution took years to work out, and the answer was never purely technical. Tagging, showback, chargeback, and an agreement about what a cost center owns. All of it transfers directly.

What's different is the volatility. Traditional infrastructure cost moves when you provision something. You add capacity, the number goes up.

Inference cost moves when usage patterns change. When someone lengthens a prompt. When a retrieval step starts returning more context than it used to. When a vendor adjusts pricing. When customers start asking harder questions.

A team can double its spend without deploying a single thing. No release, no ticket, no notification.

If nobody can say what one transaction costs, nobody can say whether the feature is worth what it costs. That's an architecture problem. The instrumentation that answers it has to be designed in, which puts it on your desk long before it reaches finance's.

## The Property Two Test

Four questions, same shape as last week.

Do you know what one transaction costs in inference, as opposed to what the monthly bill is? Is model selection a decision recorded somewhere, or a default nobody has revisited since the prototype? Does anyone own the number? And when usage doubles next quarter, will you find out from a dashboard or from an email from finance?

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. For AI, that comes down to four properties: probabilistic behavior, inference economics, the context supply chain, and model lifecycle. Bolt-on AI sends everything to the biggest model and learns the economics from the invoice. AI-native treats the price of a call the way we learned to treat the latency of one.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=body).

*Next Tuesday: the context you feed the model.*

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=your-function-call-was-free&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
