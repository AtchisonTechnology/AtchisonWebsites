---
title: "Is AI Making Our Code Worse?"
order: 4
description: >-
  AI makes teams faster at what they already do. GitClear's data shows
  duplication up and refactoring down. Here's how to keep your codebase healthy.
---
For most teams, yes. The tool isn't the cause, though.

AI makes your team faster at whatever it already does, good habits and bad ones alike.

The data on this is consistent. GitClear's 2026 report, "The Maintainability Gap," looked at 623 million code changes from 2023 to 2026. Refactoring has fallen 70%. Block duplication has climbed 81%. Work on code more than a year old has dropped 74%.

The year before, GitClear's 2025 report found something that had never happened. Copy/pasted lines outnumbered moved lines. Moved code is usually refactored code. Copied code is duplication.

Those trends don't hit every engineer the same way.

In GitClear's data, the heaviest AI users produced 4-10x more durable code than non-users, and wrote more tests. They're experienced engineers with strong structural instincts. A faster tool gives them more time to clean up the module they're working in.

Across the broader population, the picture changes. A separate [GitClear study](/posts/ai-promised-10x-developers-the-reality-is-far-more-complicated/) put the average productivity gain at about 25%, far from the promised 10x. AI power users also generated nearly 10 times more code churn than they did before AI. Churn is code rewritten or thrown away soon after it's written, and it's an early sign of technical debt.

An assistant sees a handful of files, rarely the whole system. It can't see the function three folders over that already does the job, so it writes a new one. It's built to produce something that works right now, and a closed ticket looks like success.

The work it skips is the work that keeps a codebase healthy. Refactoring. Reusing what exists. Keeping module boundaries clear and contracts narrow. Knowing how the whole system fits together.

That work is still yours.

## What to do about it

Measure structure alongside volume. Lines of code and commit counts reward the wrong behavior, so track duplication, refactoring, and churn next to throughput. GitClear's [maintainability research](/posts/ai-closes-the-ticket-but-who-builds-the-system/) is a good model for what to watch.

Budget refactoring time into every sprint. If cleanup is always scheduled for later, AI makes later arrive faster.

Review for structure, too. Ask whether new code calls into existing modules or copies them. When a change duplicates something that already exists, send it back.

There's one place to relax. A prototype you'll delete next month, or a one-off script, doesn't need clean structure. Let AI write it fast and skip the structural review. The rules apply the moment that code ships to customers and someone has to maintain it.
