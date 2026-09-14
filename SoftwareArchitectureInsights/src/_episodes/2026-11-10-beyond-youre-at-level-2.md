---
title: "You're at Level 2 and You Think You're at Level 4"
slug: beyond-youre-at-level-2
date: 2026-11-10
episode_number: 16
category: Beyond the Article
tags: [Series]
description: "Five levels of AI maturity, the five questions that grade a system honestly, and the one move worth planning next."
captivate_episode_id: "91143c11-5143-45a9-ba60-f2cb72dfff4a"
source_articles: [ai-native-maturity, bolting-ai-onto-your-app-is-the-new-lift-and-shift, it-passed-the-test-that-doesn-t-mean-it-works, your-function-call-was-free, the-model-isnt-wrong, you-didnt-change-anything]
duration: "17:16"
---

There's a slide on a board deck that says "AI-native platform." Three floors down, the AI call sits in the middle of a request handler with a string constant for a prompt, and nobody knows what one request costs.

Both are true, same company, same week. In this episode, Lee goes further than his article "You're at Level 2 and You Think You're at Level 4": not just how to grade a system, but who does the grading, and which single piece of work moves you up.

**In this episode:**

- Bolt-on versus AI-native, and why it's the cloud's lift-and-shift all over again
- The four things that come apart in a bolt-on system: wrongness, cost, context, and change
- The five levels of AI maturity, each with a test you can actually run
- Why self-assessments land two levels high, and the five questions to ask instead
- Grade one system, not the company
- Going from Level 2 to Level 3: fifty cases, one threshold, one cost number
- What to say when the evidence says Level 2 and the board deck says otherwise

**Links:**

- [The AI-Native Architecture series](https://softwarearchitectureinsights.com/series/ai-native-architecture/)
- [You're at Level 2 and You Think You're at Level 4](https://softwarearchitectureinsights.com/posts/ai-native-maturity/)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Somewhere right now, there's a slide that says AI-native platform. It's been on the board deck for two quarters. The CTO presented it, the demo went well, and nobody in the room had any reason to doubt it. Three floors down, an engineer is looking at the code behind that demo. There's a call to an AI vendor sitting in the middle of a request handler.

The prompt is just a constant string. Nobody has ever measured whether the answers are any good or not, and nobody knows what a single request actually costs. Both of those things are true. Same company, same system, same week. Last month, I published an article about that gap called "You're at Level Two and You Think You're at Level Four." The article was part of an ongoing series on AI-native architectures. That article gave you a way to grade a system for how effective it is at utilizing AI. It doesn't say who does the grading, what to do when the grading comes back bad, or which piece of work moves you up a level.

That's today. Everything today rests on one distinction.

There are two ways to put AI into a product. The first is what I call bolt-on. You have an application, you find a spot where a model would help, you call the model right there, and you ship it. The architecture doesn't change at all. You've just added a feature The second is AI native. The entire system is designed around the fact that there is an AI model inside of it. We've been here before at this kind of a distinction before. It happened during cloud migration. Every enterprise said they had moved to the cloud.

Most had moved the same old application onto rented servers in the cloud. Same design, same failure modes, new invoice. We called it lift and shift. Bolt-on AI is to AI what lift and shift is to the cloud. The problem is that a bolt-on feature and an AI-native feature look identical in a demo. Same screen, same answer, same happy customer. They come apart in four places. The first part of my AI Native article series was about those four, So let me name them now. One, the model can be wrong, not broken, just wrong, and confidently wrong.

So what does your system do when it gets a wrong answer?

Two, every call costs money. Normal code you write once and running it is close to free. AI code you pay for per request forever Three, the answer depends on what you feed the model, your documents, your customer records, your search results. That's a supply chain, and it can go stale or leak private data. Four, the model changes underneath you. Your vendor ships an update you didn't ask for, and your product behaves differently on a Tuesday when the model went live. Wrongness, cost, context, and change. A bolt-on system usually has no answer for any of those four issues Which brings us to the maturity model in this article.

There are five levels of AI maturity, and each one comes with a test that you can run, not just an adjective you can claim. Level one is called attached. The AI call sits right in the middle of the code that needs it, prompt it all, just like in the demo.

The test is a search. Count the number of places in your code base that call a vendor's AI library directly. At level one, there are several of those, each added by whoever needed it on, in this particular week. Nothing wrong with being there. It's where everybody starts.

Level two is shipped. Real customers are using the AI-enabled feature. There's a monthly bill now, an AI bill. The code mostly works. Most enterprises are sitting right here today, and this is the level that gets called AI native on a slide, but it's not. There's two tests here. What does one transaction cost you in AI charges? And who owns the test set? At level two, your answers to both those questions are murky at best Level three is measured, and I need to define a term here, a term that's important for the rest of this episode.

An eval set, short for evaluation set. It's a pile of real AI requests with a valid, correct answer written down beside each one. You can run the set against an AI model and score the results deterministically. How well did the AI do at answering these specific requests?

At level three, that eval set exists. Somebody outside engineering has agreed what score is considered good enough, and AI cost per transaction is a real number that somebody is tracking and somebody is responsible for. The test is a question about the past. What did the last model update do to your accuracy, and what are the numbers that support that? A team at level three can answer that question. Nothing has been redesigned yet. They just can observe exactly what they have. Level four is designed. All four of the properties I spoke of earlier have a real answer in the architecture of your system.

A layer checks the model's output with a written rule for what happens when the model isn't confident. Somebody chose the model on purpose and wrote down why. Every data source feeding it has a shelf life. That's level four. Level five is default. Level four is about one system, having one system at a high-quality AI native level. Level five is about the entire organization. The second AI-heavy system you build takes less architecture work than the first one because the pieces already exist systemically within your company and somebody already owns them. Put your newest AI system beside your oldest.

If the new one started where the old one finished, that's a good indication of a level five thinking Now the claim of this episode. What level is your organization at? You'll probably guess about two levels too high. Self-assessments land high, and they do it almost every time. The reason is simple. Level two looks exactly like level four from the outside. Every signal an executive can see is the same at both level two and level four. The demo, the usage numbers, the customer quotes. Everything that actually separates them is invisible at least until something actually breaks.

So who does the grading? This is where most maturity assessments fall apart. You hand the model to each team and ask them to grade themselves. I watched this for years with service tiers, which rate each service by how badly the business suffers when it's down. Ask 53 teams whether their service is important, and 48 say yes. The teams aren't lying to you. The question is just the wrong question. So don't ask a team what level they're at. Ask them the five questions and write down what they say. How many places in your code call an AI vendor directly?

What does one transaction cost in AI charges? Who owns the evaluation set? What did the last model update do to your accuracy in real numbers? And would a brand-new AI system here start from what this one already built or would it start from scratch? One more rule before you start. Grade one system. Don't grade the entire company. Companies want a company-wide answer because that's what fits on a slide. A company-wide answer is an average, and the average hides the things you need to know. So pick the system where AI matters most to the business.

If that one is at level two, you are at level two. Whatever the pilot project down the hall is working on, you are at level two. Now, assume the grade comes back level two. it usually does at this stage for most companies, and this is where teams go wrong. They read the level four description, see checking layers and model routing and data shelf lives, and start building all of that at once. Don't do that. Going from two to three is the only move worth planning. Level three is three things: an eval set, an agreed threshold, a known cost per transaction.

That's the whole level. There's no architecture changes there, no redesign. You're installing instrumentation, not rebuilding the entire engine. And everything above that leans on those instruments. You can't tell whether a checking layer helped with no way to measure accuracy.

You can't move to a cheaper model without knowing what this one costs. Level four without level three is a stack of design decisions that nobody can evaluate, and nobody can tell whether they're correct or not So let's build that evaluation set because this is where teams stall. The blocker is usually imagination. People picture a research benchmark with thousands of labeled examples, decide there's no time to build all of that, and they go back to shipping features. Your first eval set should be about 50 cases, 50, not 50,000. Pull them out of your logs, real requests that real users sent, including the ugly ones and the ones you already know the model got wrong.

Don't use developer-invented examples. Then somebody writes down the right answer for each one. That's an afternoon's worth of work. It's tedious, but it is not hard. Then the threshold, and this part cannot happen inside of the engineering organization. Somebody who owns the business outcome has to say what good enough means. Forty-two out of 50 correct? Forty-eight? The number matters less than whose name is on it. Because the day a vendor update drops your score, that person has already agreed what unacceptable looks like. You don't want to negotiate that during an incident.

Fifty cases, one afternoon of labeling, one conversation with a business owner. That is most of the distance from level two to level three The cost number is the other half, and it's more annoying than it sounds. Now, you know what your AI bill was last month. That's not the number. The number is what one single transaction costs, and your provider will not hand you that number. You tag requests, count the tokens going in and out, and divide by transactions. Call it a day's worth of work. Teams skip it because the bill is small right now.

That's the reason to do it now. When the bill is four hundred dollars, nobody minds that you can't break it down. When it's forty thousand dollars and somebody asks which feature is responsible for the change, you'll wish you had spent that day.

And that one number changes design decisions by itself. The moment a team sees that one feature costs thirty times another feature, somebody asks whether it needs the expensive model or if a cheaper model might be good enough. One line in the article is the part that should worry you. An organization at level two that believes it's at level four has stopped working on it, not out of laziness. The work looks finished. It's the same thing as the lift and shifted cloud application that's no longer working under cloud readiness. They look like they're already done.

You can see it in a roadmap. The feature shipped two quarters ago. Nothing has changed since, and nothing new is proposed because the thing on the slide is done. An organization that knows it's at level two is still moving. Same architecture, same features, completely different direction. So a bad self-assessment isn't a vanity problem. It's what stops the next piece of work from getting scheduled Which brings up the awkward part. What do you do when the evidence says level two and the board deck says AI native platform? Don't walk into that meeting with a maturity model.

Nobody enjoys being told their slide is wrong, and you'll spend the hour defending the model instead of the finding. Bring one question instead. Ask what happens to the product if the vendor ships a model update next month. If the answer is that nobody knows, you've made the point without grading anybody. Then offer the fix, and the fix is small. Fifty cases and a threshold, one sprint's worth of work. Executives will say yes to that. They say no to a maturity program One more, because somebody always asks whether they can skip level three and go straight to the designing.

Well, you can try. You build the verification layer, ship it, and then can't tell anybody whether it worked. Six months later, someone proposes ripping it out to save latency, and the argument gets settled by whoever is the most senior person in the room, even without data. The eval set is what makes those arguments useful with data. That's its real job So what can you do this week? Well, pick the one system where AI matters most to your business, answer the five questions, and write the answers where other people can see them.

Then pull 50 real requests out of your logs and start labeling them. You'll know your level by Friday, and you'll have started the one piece of work that gets you past it. If you haven't read my original article, I recommend reading it. It's linked in the show notes, Along with the earlier pieces in the series on AI Native, where those four properties come from. They are both part of an ongoing article series on AI Native architecture I'm writing for my Software Architecture Insights newsletter right now Thank you for joining us on Software Architecture Insights.

If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
