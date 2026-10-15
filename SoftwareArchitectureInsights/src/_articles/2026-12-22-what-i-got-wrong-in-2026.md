---
title: "What I Got Wrong in 2026"
subtitle: "Four calls from this year. Two I'd take back, and two I'd make again."
author: "Lee Atchison"
status: published
created: 2026-10-05
date: 2026-12-22
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: what-i-got-wrong-in-2026.png

meta_description: "Four calls from 2026 on AI and architecture. Two aged badly, two held up. What the misses and the hits taught me going into 2027."
slug: what-i-got-wrong-in-2026
description: >
  A look back at four calls from 2026. Two aged badly: keeping AI on a
  short leash, and treating AI as only a tool. Two held up: the bill for
  AI-written code, and prompt injection as a property rather than a bug.
categories:
  - "AI Strategy & Adoption"
  - "The Architect's Role"

---

# What I Got Wrong in 2026

*Four calls from this year. Two I'd take back, and two I'd make again.*

---

I make a lot of calls in this newsletter.

Most weeks I tell you what I think is coming and what to do about it. That's the job. It also means some of what I wrote in January has had a full year to prove me wrong.

So I went back and reread everything I published in 2026. Here are four calls worth a second look. Two of the calls aged badly. Two held up better than I expected.

## Keep AI on a short leash

In February I wrote two pieces about AI-written code. In [The Hidden Costs of Vibe Programming](https://softwarearchitectureinsights.com/posts/the-hidden-costs-of-vibe-programming-why-ai-generated-code-isn-t-the-shortcut-you-think-it-is?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body), I told you to give vibe coding a hard pass.

Two weeks later, in [AI Promised 10x Developers](https://softwarearchitectureinsights.com/posts/ai-promised-10x-developers-the-reality-is-far-more-complicated?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body), I went further. "AI coding on its own: never. AI assisting human developers: always."

That aged badly.

Coding agents went from a curiosity to normal practice this year. Teams hand an agent a whole task and review what comes back, and plenty of them are shipping good software that way.

What I got wrong was the leash. I assumed safety came from a human watching every line as it was written. It comes from a clear design, a real review, and someone who owns what ships.

"Hard pass" was too absolute, too. A throwaway prototype or a one-off internal tool is a fine place to let the AI drive.

If I could talk to February me, I'd say this. ***Worry less about who types the code, and more about who owns it.***

## AI is a tool, not a strategy

My first article of the year was [We Need an AI Strategy!](https://softwarearchitectureinsights.com/posts/we-need-an-ai-strategy-what-your-boss-really-means?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body) Its core line was "AI is a tool, not a product strategy." Start from the business problem, I said, and use AI only where it helps.

That advice still holds. What I undersold was what happens after you say yes.

By August I was arguing that [bolting AI onto your app is the new lift-and-shift](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body). Once AI is in a system, it changes how the whole system behaves.

Results become probabilistic. Every call has a price. Your context becomes a supply chain, and your model changes on someone else's schedule.

You can pick up a tool and put it down again. AI in production doesn't work that way.

What I'd tell myself now is to start with the business problem, then expect the architecture to change around the answer.

## The bill still came due

Here's a twist on that first call. I was wrong about how AI would write code. I was right about what that code would cost.

In the same February pieces, I warned that AI-written code piles up debt nobody sees. I also said it would take more senior engineers to keep it healthy, at the same moment companies were cutting them.

In March, Amazon had a run of high-severity outages, at least one of them tied to AI-assisted changes. I wrote about it in [When the Bill Comes Due](https://softwarearchitectureinsights.com/posts/when-the-bill-comes-due-amazon-s-ai-bet-and-the-engineers-it-let-go?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body). Amazon's fix was to require senior engineers to sign off on AI-assisted changes.

In July, GitClear's Maintainability Gap report put numbers on the rest. Since 2023, duplicated code blocks are up 81% and refactoring is down 70%.

I covered it in [AI Closes the Ticket. But Who Builds the System?](https://softwarearchitectureinsights.com/posts/ai-closes-the-ticket-but-who-builds-the-system?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body) Codebases are growing outward much faster than anyone is cleaning them up.

So the leash got longer, and the bill got bigger. Both are true.

## Prompt injection is a property, not a bug

In April I wrote that [prompt injection isn't a bug, it's a property](https://softwarearchitectureinsights.com/posts/prompt-injection-isn-t-a-bug-it-s-a-property?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body). SQL injection eventually got fixed by frameworks that made the safe path the default. I said prompt injection wouldn't follow that path. "We are not going to get that lucky this time."

That one held up.

OpenAI has since said publicly that prompt injection may never be fully solved. In June, an OWASP researcher said it still drives most AI agent security failures in production.

The advice from April still stands. Assume an injection will eventually succeed, and design so it can’t do much damage when it does. Give each agent the narrowest permissions it needs, and keep a human in the loop for anything with real consequences.

I called that [limiting the AI blast radius](https://softwarearchitectureinsights.com/posts/prompt-injection-isn-t-a-bug-it-s-a-property?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body), an idea I’d first written about for ordinary services in [Less is More: The Principle of Least Privilege](https://softwarearchitectureinsights.com/posts/less-is-more-the-principle-of-least-privilege?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=body). It matters more now than it did in April.

## What the misses taught me

Both of my misses were about speed. I underestimated how fast AI would move from assistant to actor, and how far into the system it would reach once it got there.

Both of my good calls were about cost. The debt, the oversight, and the attack surface didn't move nearly as fast, because they belong to the system, and systems change slowly.

That's the lesson I'm taking into 2027. Be humble about how fast the tools change. Be stubborn about what they cost.

Happy new year. I'll see you in January.

---

*Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=what-i-got-wrong-in-2026&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
