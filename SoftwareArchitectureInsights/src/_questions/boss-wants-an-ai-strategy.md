---
title: "My Boss Wants an AI Strategy. Where Do I Start?"
order: 5
description: >-
  When leadership asks for an AI strategy, start with the business goal behind
  the request. Four questions to ask before anyone writes a line of code.
---
Your manager forwards a link to a competitor's launch announcement. The message under it is one line. "We need an AI strategy. Can you put something together by Friday?"

You are now the AI strategy person, and nobody asked whether you wanted the job.

Start with the request itself, because it is rarely about AI.

When leadership says "we need AI," they usually mean something else. We need to look innovative. We can't fall behind that competitor. Our support costs are too high. Customers keep asking for something we can't deliver.

Those are four different projects. Only some of them need a model.

So the first move is a conversation. The prototype can wait.

Ask your manager to describe the outcome without using the word "AI." If they can name a business number they want to move, such as support cost, conversion rate, or hours spent on a manual process, you have a real project. If they can't, you have a press release looking for a feature.

Once you have a goal, ask four questions about it.

What problem are we solving, measured in business terms?

Do we have the data to support it? A model is only as good as what you feed it, and most teams find their data is messier than they assumed.

Would something simpler work? A rules engine or a plain statistical model often gets most of the value for a fraction of the cost and risk.

Who owns it after launch? Models drift. Vendors ship updates. Inference shows up on the bill every month, and someone has to own the evaluation, the cost, and the fallback for when the model is wrong.

If nobody can answer that last question, the project isn't ready.

Next, be honest about where you stand. Most organizations [rate themselves two levels higher](/posts/ai-native-maturity/) than their architecture supports. A working demo looks the same whether the system behind it is well designed or held together by a prompt string in one handler.

Two quick checks tell you the truth. Can anyone say what a single AI transaction costs? Does anyone own an evaluation set built from what real users do? If both answers are no, your strategy starts there, before any new feature.

A good strategy is also a list of what you won't change. [Most of your systems should stay as they are](/posts/you-dont-have-to-rewrite-everything/), with at most a simple model call added. Only the few where the business depends on the model being right, cheap, current, and stable justify a redesign.

Saying that out loud is part of the job. It keeps the budget on the two systems that matter and off the hundred that don't.

One exception. If your product's core value already comes from a model, skip the "do we need AI" step, because you are past it. Spend that time on evaluation and cost instead.

Here is the first move. Before Friday, write one page. Name the business goal in plain language. List the two or three places where AI might move that number, the simpler alternative for each, and who would own each one after launch.

Bring that page to your manager. It turns "we need AI" into a decision they can make.
