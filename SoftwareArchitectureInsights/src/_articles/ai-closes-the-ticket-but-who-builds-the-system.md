---
title: AI Closes the Ticket. But Who Builds the System?
subtitle: ""
author: Lee Atchison
status: published
created: 2026-07-02
date: 2026-07-07
published_on: 2026-07-07

sai_url: https://softwarearchitectureinsights.com/posts/ai-closes-the-ticket-but-who-builds-the-system
email_sent: 2026-07-07
linkedin_url:

hero_image: 

internal_note:
meta_description: GitClear's 623-million-change study finds AI-assisted teams ship faster while refactoring falls 70% and duplicated code climbs 81%. What that costs you.
slug: ai-closes-the-ticket-but-who-builds-the-system
description: >
  AI coding tools close tickets fast, but GitClear's 2026 research across 623 million code changes shows refactoring down 70% and duplicated code up 81% since 2023. AI doesn't make developers better — it amplifies the habits they already have.
categories:
  - "Scalability & System Design"
  - "The Architect's Role"

---

Your team is shipping faster than ever. The sprint board is clearing. AI coding tools have turned hours of boilerplate into minutes. Leadership is happy.

And quietly, your codebase is accumulating a bill it hasn't paid yet, and perhaps can never afford to pay.

GitClear's 2026 research report, "The Maintainability Gap," tracks seven code quality signals across 623 million analyzed code changes from 2023 to 2026. The report does *not* argue that AI writes bad code. What it finds instead is both more nuanced and more important. AI-assisted development optimizes for the visible and the immediate, while quietly neglecting the invisible work that keeps a codebase maintainable over time.

## The Ticket Closes. The Architecture Doesn't Know It.

AI coding tools are genuinely good at taking a clear, bounded task and producing working code that satisfies it.

Fix this bug.

Implement this endpoint.

Add this validation.

When the inputs and outputs are well-defined, AI tools deliver.

The problem is that most of the structural work that keeps a large system maintainable doesn't look like a ticket. It looks like a judgment call.

Should this new function call an existing one, or create a new one? Should this block be extracted into a shared module? Should this old code path be cleaned up now that the new approach is in place?

These questions don't show up in a task description. They require understanding the system, where it came from, where it's going, what already exists. AI tools, optimized to deliver a simple but satisfying code diff, tend to answer these questions with whatever's cheapest. They add new code, copy/paste a code pattern, and ultimately skip the cleanup.

Think of it like a contractor who's paid per room added to a house. He'll frame up a new room in a weekend. What he won't do, unless someone makes him, is go back and check whether the foundation under the existing rooms can hold the weight, or whether the wiring from three additions ago is still up to code. Nobody asked him to. The house looks bigger. Whether it's sound construction is a different question entirely.

GitClear's data shows exactly this at scale.

Refactoring, the 'move' operations that consolidate and reuse code instead of duplicating it, has fallen 70% since 2023. Cross-file function connectivity, how often new code reaches back into existing modules, is down 35%. And long-term maintenance, the work of touching code that's more than a year old, has dropped 74%.

Meanwhile, block duplication has climbed 81%. Even more concerning, error-masking constructs are also on the rise, up 47%. These are things like broad catch blocks and safe-navigation operators that swallow and ignore errors whole, rather than surface and process them.

The codebase is growing outward. But it's not deepening. New code increasingly stands alone and disconnected from the architectural reality.

## Why AI Thinks Short-Term

This isn't a flaw in the technology so much as a consequence of how it's incentivized. AI assistants produce output that passes the immediate tests. The code compiles, the tests pass, the ticket closes. They have no stake in what the codebase looks like six months from now, when a developer who wasn't in this sprint has to find the three near-identical functions and figure out which one to update.

GitClear calls this optimizing for "atomic code." AI delivers a happy path. A passing test. A closed ticket.

The invisible and deferred work (reuse, consolidation, error surfacing) gets left behind. These activities require context, judgment, and familiarity with a system that the tool doesn't have and isn't asked to acquire.

There's also a compounding dynamic. As AI lowers the cost of producing brand new code to near zero, the relative cost of understanding existing code stays high. So the rational path bends further toward "add new" rather than "improve existing." It's simply easier to do.

Each pass makes the codebase slightly bigger, slightly harder to navigate, and slightly harder to refactor.

This is how technical debt grows.

## AI Amplifies What You Already Do

It turns out that AI doesn't turn every developer into a 10x engineer. Instead, it simply amplifies the habits a developer already has.

The heaviest AI users in GitClear's data produced 4-10x more durable code than non-users. They wrote significantly more test code. They generated less review burden per unit of output. These are experienced developers with strong structural instincts, and AI gave them enormous leverage.

But across the broader population, the same force increases bad habits. Some developers weren't in the habit of refactoring. Others didn't look for existing functions before writing new ones. Others still defaulted to a broad catch block when an exception needed real thought. AI made all of those habits faster, and more consequential.

I've seen this play out inside teams I've run. Give a senior engineer with strong instincts a faster tool, and they use the extra time to write tests and clean up the module they're touching. Give that same tool to someone who's never been in the habit of checking for an existing function first, and they just produce more code, not necessarily good code. The tool didn't change either engineer's judgment. It just removed the friction that used to slow bad judgment down.

For engineering leaders, this is the critical insight. The question isn't whether to use AI tools. It's whether your team has the structural instincts and explicit expectations in place to ensure that AI amplifies good habits, not just fast ones.

## This Is an Architecture Problem

The patterns GitClear is measuring aren't just code hygiene concerns. They are basic software architecture concerns.

A codebase where new code doesn't call existing modules is a codebase with growing duplication at the service level. A codebase with significant error-masking constructs is a codebase that increasingly lies to its own operators about its health.

A codebase where legacy code goes untended is a codebase where technical debt isn't just accumulating, it's compounding in the parts nobody has visited in forever.

More code and more defects aren't a contradiction. They're the predictable outcome of optimizing the wrong things. Speed of code production increases with AI, but that doesn't mean speed of quality output increases.

## What to Measure, What to Protect

So, what now?

Start with what you measure. Lines of code and commit count are meaningless proxies that AI inflates without effort.

Meanwhile, structural health tells a different story: refactoring operations as a share of changed lines, function connectivity across files, duplication rate, legacy code maintenance activity. These metrics all reveal whether the code being produced is deepening the system or just growing without bound.

As long as productivity is proxied by volume, AI will reliably game that proxy.

## The Question Worth Asking

AI makes your team faster. That's real. The danger is measuring only the speed and assuming the rest is fine.

The teams that own maintainable codebases in 2028 aren't going to be the ones that shipped the most commits. They're going to be the ones that actively architected the systems that were being created. They measured structure alongside volume. They budgeted for the invisible work. And they coached their teams to see what the tools consistently miss.

The tools are staying. The question is whether you're steering them in the right direction or not.
