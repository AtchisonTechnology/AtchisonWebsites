---
title: "You Don't Have to Rewrite Everything"
subtitle: "AI-Native Architecture: which systems deserve the work, and which stay bolted on for good."
author: "Lee Atchison"
status: draft
created: 2026-09-02
date: 2026-10-20
series: "AI-Native Architecture"
series_position: "Act II, article 3 of 4 — the migration path"
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: you-dont-have-to-rewrite-everything.png

internal_note: "AI-Native: Act II, Issue 3"
meta_description: "Bolt-on AI is the right permanent answer for most of your systems. Four criteria for finding the few where it isn't, and three answers instead of one."
slug: you-dont-have-to-rewrite-everything
description: >
  The cloud era had the six R's, and they mattered because they gave teams
  permission to leave most of the estate alone. AI-native needs the same
  thing more, because the pressure to declare everything AI-native comes from
  outside engineering. Four criteria that sort the estate, and three answers
  instead of one.
categories:
  - "AI-Native Architecture"
  - "Cloud Strategy & Economics"

---

# You Don't Have to Rewrite Everything

*AI-Native Architecture: which systems deserve the work, and which stay bolted on for good.*

---

The roadmap slide says "AI-native by Q2." It was written by someone who has never opened the service catalog.

The architect who has opened it counts one hundred and forty systems. Eleven of them call a model. Two of those matter.

The meeting to explain that distinction has not been scheduled, because nobody wants to be the person who says "most of this should stay exactly as it is."

That person is right.

## The Six R's Gave People Permission

The cloud migration frameworks had a list. Rehost, replatform, refactor, and a few more R's depending on whose deck you read. The list was useful for a reason that had little to do with the categories.

It gave people permission to leave things alone. Rehost was a legitimate answer, and so was retire. A team could look at a payroll system that ran fine and say "this one moves as-is and we never touch it again," and the framework backed them up.

Without that permission, every system became a candidate for the expensive option, and the migration stalled under its own ambition.

AI-native needs the same list, and needs it more. The pressure to go cloud-native mostly came from inside engineering. The pressure to be AI-native is coming from the board, from the roadmap, and from a competitor's press release.

Engineering is the group that has to say where the line is.

## Bolt-On Is the Right Permanent Answer for Most Systems

This is the part that will get quoted out of context. For most of the systems in your estate, bolt-on AI is correct, and it is correct forever.

A summarize button on an internal admin tool does not need a verification layer, a routing policy, and a context supply chain with freshness bounds. It needs a model call and a fallback if the call fails. Building more than that is spending architecture on a feature the business would not miss.

The first four articles in this series described what it costs to design around the four properties. That cost is worth paying on a small number of systems. On the rest it is waste, and calling the waste "AI-native" does not change what it is.

The work is finding the small number of exceptions.

## Four Criteria

AI is load-bearing in a system when the business depends on the model being right, cheap, current, and stable. Each of those is a property. Each one has a question.

If the model were wrong, would a customer notice before you did? That is probabilistic behavior, and it has money attached to it. A wrong summary on an internal dashboard gets a shrug, and a wrong answer in a customer-facing support flow gets a refund or a regulator.

Is inference a visible line in this product's economics? If doubling usage would change the margin, inference economics is a design constraint here. If the whole feature costs less than the meeting to discuss it, it is not.

Do the answers depend on context that changes daily? A model reasoning over last year's policy document is a bolt-on. A model reasoning over this morning's inventory, this customer's account, and the ticket that was just filed has a context supply chain, whether anyone designed it or not.

Would a model change be a product change? If a vendor update could change what your customers experience in a way they would describe to a colleague, the model lifecycle belongs to you, whatever the contract says.

Two or more yes's and the system deserves the work. One yes deserves a conversation. Zero yes's is a bolt-on, permanently, with a clear conscience.

## Three Answers Instead of One

The migration frameworks had more than two options, and so does this. The first answer is to leave it. Bolt-on stays bolt-on. Write down that it was a decision, so the next architect does not mistake it for neglect, and stop thinking about it.

The second answer is to contain it. Put the model behind a boundary, build the evaluation set, and change nothing else. This is the AI equivalent of replatforming.

The system is still designed the way it was, but the volatile component is now measurable and replaceable. Most one-yes systems belong here. It costs a fraction of a redesign and buys most of the safety.

The third answer is to redesign. All four properties treated as design constraints from the start, the way the first four articles in this series described. It is reserved for the two systems out of one hundred and forty where the business is riding on the model.

Most systems sort roughly the same way. A long tail of leave-it, a handful of contain-it, one or two redesigns. If your sort comes out with twenty redesigns, try again.

## The Conversation You Are Avoiding

The hard part of this is organizational, which is a polite way of saying it is a meeting.

Somebody has to tell the owner of the roadmap slide that "AI-native by Q2" means two systems. Nine more get a boundary and an eval set. The remaining one hundred and twenty-nine do not change at all, which is a smaller story than the slide promised.

It is also the story the cloud era eventually told, after several years of pretending every application would be refactored. The organizations that got there faster were the ones with an architect willing to say "rehost" out loud.

The four criteria are that architect's script. They turn "we're not doing that" into "here is the test, here is how each system scored, and here is where the money goes."

## The Sorting Test

Take your service catalog, or the closest thing you have to one. For every system that calls a model, ask the four questions.

Customer notices first? Margin depends on it? Context changes daily? Model change is a product change?

Count the yes's. Sort into leave, contain, and redesign.

Then compare the redesign column to the roadmap slide. The distance between them is the conversation.

## Bolt-On or AI-Native

Every enterprise said they were in the cloud. Most had moved the same monolith onto rented servers. Same architecture, same failure modes, new invoice. We called it lift-and-shift, and it took most of a decade to explain why that was a starting point and not a destination.

Bolt-on AI is that same move. Wire a model into a workflow, ship the feature, update the deck.

AI-native is the same answer cloud-native was. Stop hosting the old design on the new platform and design for what the platform actually is. Bolt-on AI is the right answer for most systems and the wrong answer for the ones that matter. AI-native is knowing which is which, and spending the four properties where they count: probabilistic behavior, inference economics, the context supply chain, and model lifecycle.

The full four-properties test is in [the article that started this series](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=you-dont-have-to-rewrite-everything&utm_content=body).

Next Tuesday: someone has to own all of this, and it is probably not a new title on the org chart.

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=you-dont-have-to-rewrite-everything&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=you-dont-have-to-rewrite-everything&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=you-dont-have-to-rewrite-everything&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=you-dont-have-to-rewrite-everything&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=you-dont-have-to-rewrite-everything&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
