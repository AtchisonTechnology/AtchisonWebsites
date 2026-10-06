---
title: "Your Function Call Was Free. This One Isn't."
slug: your-function-call-was-free
date: 2026-12-01
episode_number: 18
category: Beyond the Article
tags: [Series]
description: "Agents with no step limit, cost in the design review, and the latency half of inference economics."
captivate_episode_id: ""
source_articles: [your-function-call-was-free]
duration: "11:03"
---

You called that function a thousand times in a loop and never thought about it. Now the same call goes to an AI model. It takes a couple of seconds, and it sends you a bill.

In this episode, Lee goes past his article "Your Function Call Was Free. This One Isn't." into the places where inference costs bite hardest.

**In this episode:**

- Why an AI call is the next version of the network call
- Model routing, and how the prototype makes the decision when nobody else does
- Agents with no step limit, and what a stuck agent costs
- The one question to add to every design review
- Caching on meaning, and why its threshold is a correctness decision
- Latency, the other half of inference economics
- How your AI bill doubles without anyone shipping code

**Links:**

- [The AI-Native Architecture series](https://softwarearchitectureinsights.com/series/ai-native-architecture/)
- [You're at Level 2 and You Think You're at Level 4 (episode 16)](https://softwarearchitectureinsights.com/podcast/beyond-youre-at-level-2/)
- [Your Function Call Was Free. This One Isn't.](https://softwarearchitectureinsights.com/posts/your-function-call-was-free/)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Think about the last function you wrote. You called it a thousand times in a loop, and you never thought twice about it. Why would you? It ran in microseconds, and it cost nothing.

Now change one thing. That function sends a request to an AI model, and each call takes a couple seconds, and each call sends you a bill. Your loop just became a budget decision. In September, I wrote an article called "Your Function Call Was Free. This One Isn't." It's part of my series on AI-native architecture. Today, I want to go past the article into the places that bites hardest. Here's the idea, in case you missed it. The original article is linked in the show notes.

For most of our careers, calling a function has been free, fast and free. Then distributed systems came along and a call over the network wasn't free anymore. It could be slow, it could fail, and we had to design our systems around that fact. AI inference is the next version of that. Every call to a model costs real money and takes real time, so you can't treat it like a function call. It has to be part of the design.

That's the second of the four properties I use to define an AI-native system. I call it inference economics. The article used an example. I'll keep it short. Picture a support assistant that handles fifty thousand customer conversations a month. Each conversation makes six model calls, one to classify the question, one to find the right documents, a few to draft the answer, and then one to verify the results. That's three hundred thousand model calls a month.

Now, say every one of those calls goes to the biggest, most expensive model you have. Not because anyone decided that model was needed, just because that's the model the prototype used Classifying a question into one of 12 categories doesn't need your most expensive model. Writing a careful answer to an angry customer, well, that might.

Which model handles which step is a design decision. The article called that model routing, and if nobody makes that decision on purpose, the prototype makes it for you. Here's what the article didn't go into, and it's where I'm seeing the biggest surprises now: agents. The support assistant makes six calls per conversation. You can count them. You can multiply. You can predict the bill.

An agent is different. You give it a goal, and it decides how many steps to take. It calls the model, looks at the result, and decides what to do next. Sometimes that action can take three calls, sometimes it takes 40, and sometimes it gets stuck. It tries something, it fails, it tries again, and it keeps trying.

In a normal program, a loop like that burns some amount of CPU. Somebody notices eventually. With an agent, every pass through the loop costs real dollars. A stuck agent is a meter running with nobody watching it. So every agent needs limits, a maximum number of steps, a maximum spend per task, and a clear rule for what happens when it hits the limit. Does it stop? Does it hand the task to a person? Does it return its best answer so far?

Those limits belong in the design of the application from the start, the same way a timeout is part of the design of a network call. If your agent has no step limit today, that's the first thing I'd fix. The second thing I'd change is the design review. Most teams have some kind of review before a big feature gets built. Someone asks about scale. Somebody asks about security. Someone asks about what happens when a dependency is down Add one more question. What does a single use of this feature cost? Not the monthly bill, one single use. One conversation, one document, one search.

Back in November, in the level two episode, I talked about how to work out that number. The short version is you tag the calls, count what goes in and out, and divide. The point here is when you ask. Ask it before the feature is built as an estimate, then check the estimate once it's live. Something useful happens when you do that. The team starts designing for it. Somebody asks whether a step can use a smaller model. Somebody asks whether the same question gets asked a lot, and whether the answer can be reused.

That last idea is basic caching, and the article made a point about it I want to repeat here. With normal caching, you match on the exact request. With AI, two people ask the same question in different words, so you match on meaning instead of the exact text. But then you have to decide how close is close enough.

Get that decision wrong and you hand one customer the answer to someone else's question. The threshold is a correctness decision. It belongs in the design with a name next to it So far, I've talked about money. The property has a second half, and it's time. A model call can take seconds. Your user notices seconds.

Chain six calls together, one after another, and your support assistant takes ten or fifteen seconds to answer. That can be the difference between a feature people use and one they avoid. This is where the distributed systems lessons come straight back. Which calls can run at the same time? Which ones can happen before the user asks? Which ones can a smaller, faster model handle? The same routing decision that saves money often saves time too. That's a nice bonus when it happens. Just don't count on it happening. Sometimes the cheaper path is the slower one, and somebody has to choose which.

Now, one more thing from the article that surprises some people. Your AI costs can double without anyone shipping a line of code. Users start asking longer questions. Someone adds more documents to the search index, so every prompt gets bigger. A product change sends harder questions to the assistant.

Now, none of that shows up in the deploy log, but it does show up on the invoice a month later. So watch the cost per use the way you watch latency, on a dashboard with an alert owned by a team. If you only look at the monthly bill, you'll find out a month too late Here's why I keep calling this architecture.

Optimization is what you do after something works. You measure, you find the slow part, you fix it. Model routing, agent limits, caching thresholds, cost ownership. Those are hard to add later. They change how the pieces all fit together. A system that wasn't designed with them is what I call bolt-on AI. It works, it demos well, and it gets more expensive every month in ways that nobody can really explain.

A system designed around them is what I mean by AI native, and in two weeks, I'm going to spend a whole episode on exactly what I mean by that term. So this week, find every agent you run. Check that each one has a step limit and a spending limit. Pick your busiest AI feature. Write down which model each step uses and write down why.

If the answer is, "That's what the prototype used," you've found your first design decision And add one question to your next design review. What does one use of this feature cost? Your function calls used to be free. Your networking calls were a bit more expensive, but still not that expensive. This one isn't. It is expensive, both in cost and in time. Design like you know that The original article is linked in the show notes along with the rest of the AI Native Architecture series Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
