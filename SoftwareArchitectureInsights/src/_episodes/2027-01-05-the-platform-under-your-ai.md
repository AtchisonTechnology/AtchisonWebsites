---
title: "The Platform Under Your AI"
slug: the-platform-under-your-ai
date: 2027-01-05
episode_number: 22
category: Beyond the Article
tags: [Series]
description: "How to turn one team's AI gateway into a shared platform: start from the copy with the scars, keep only what's general, and hand over cost first."
captivate_episode_id: ""
source_articles: [the-platform-under-your-ai]
duration: "15:21"
---

In November, Lee wrote about the platform under your AI: which pieces of an AI feature belong in a shared platform, and which belong to the team. The rule was to build the platform from the second copy.

This episode is the part the article skipped. How do you take something one team already built and turn it into something every team can use?

**In this episode:**

- Why platforms designed on a whiteboard usually miss
- Step one: start from the copy with the scars, not the cleanest one
- Step two: one question that separates what's general from what's the team's
- Step three: hand over cost attribution first
- Step four: the original team moves first, and nobody is forced
- Where the cloud comparison strains: keep the platform thin, make the gateway strong
- This week: count the copies

**Links:**

- [The Platform Under Your AI](https://softwarearchitectureinsights.com/posts/the-platform-under-your-ai/)
- [From Cloud-Native to AI-Native: The Next Evolution of Enterprise Architecture](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift/)
- [The AI-Native Architecture series](https://softwarearchitectureinsights.com/series/ai-native-architecture/)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Back in November, I wrote about something every company building AI features is going to run into. Three teams build three AI features, and each team builds its own gateway to the model vendor, its own evaluation scripts, its own place to keep prompts, three of everything, and three separate bills nobody can add up.

That article was called "The Platform Under Your AI." It was about which of those pieces belong in a shared platform and which don't. Today, I want to talk about the part the article skipped because the article told you when to build the platform.

It said build it from the second copy. What it didn't tell you is how. How do you take something one team already built and turn it into something every team can use? That turns out to be where most platform efforts go wrong. A quick recap first, in case you haven't read the article.

There's a link in the show notes if you'd like to take a look at it. This article is part of a series I've been writing on AI-native architecture. The series starts from a comparison with the cloud. When companies first moved to the cloud, a lot of them just picked up the old system and put it on rented servers.

We called that lift and shift. Same design, new invoice. The AI version of that is what I call bolt-on AI. You take an existing system, attach a model to it, and ship the feature. Nothing underneath gets redesigned. And one of the things that happens with bolt-on AI is duplication.

Every team that bolts on a model builds the same handful of things to support it. A gateway that handles authentication, retries, and logging. Something that tests whether the answers are any good or not. A place for prompts to be stored.

Plumbing to pull in the documents that the model needs, and some logic about which model gets which request. Every team builds all of those. The question is whether they're built once or once per team. The rule the article landed on comes straight from the cloud era.

The platform owns the mechanism. The team owns the decision. The gateway is shared. Which model a feature calls is up to the team. The test harness is shared. What counts as a good answer for your product is up to you. Okay, that's the what.

Now the how. I'll start with the failure because it's so common. Somebody notices the duplication, three teams, three gateways, and they propose a platform. A new team gets formed, and it sits down in front of a whiteboard, and it designs the AI platform the company is going to need. It's thoughtful work, and it's usually wrong.

The people doing it are usually good at this. The trouble is they're designing for teams that haven't asked for anything yet, so they're guessing, and platform teams guess wrong about as often as everyone else does. We saw this in the cloud era. Many large companies have an internal platform somewhere that took a year to build and that nobody adopted.

The application teams kept using their own scripts because their scripts worked. The platform that did work came from somewhere else. They were pulled out of something a team had already built that a second team wanted to use.

So the article said, "Build from the second copy." The first copy proves you need the thing. The second copy shows you what shape it actually has. Here's how I'd go about actually doing that. Step one is choosing which copy to start from, and the instinct is to pick the cleanest one, the one with the nicest code, the best tests, the design that everybody admires.

I'd pick the one that's been in production the longest, the most time carrying real traffic. Here's why. The production copy has all the scars. It knows what happens when the vendor times out. Someone added retry logic after the first bad night, and it handles the rate limit that nobody knew about until the first time traffic hit it. The elegant copy may not have been hit yet at all.

It hasn't learned any of that. A platform built from the copy with scars starts out knowing things. A platform built from the elegant one has to learn them all again and again and again on every team's traffic at once. Step two, you've got the copy. Now you have to decide which parts of it are general and which parts belong to the team that wrote it.

The article said, "Generalize the parts that are actually general." Well, that's easy to say, but here's a test that makes it easier to do. For each piece of the copy, ask one question: Would the second team have to change this to use it? If yes, it's a decision, and it stays with the team. So take the authentication.

Every team would use it the same way, so it's general. The retries and their timeouts, those are general too. The logging mechanism, that's probably general as well. What gets logged might not be, so you make that part configurable.

Now take the model name hard-coded in the gateway. The second team would change that on day one, so that part's not general. The prompt sitting in a config file, well, that, of course, isn't general either. And the threshold for what counts as a passing eval score, well, that belongs with the product as well, not in the platform. You'll find copy is mostly general underneath and specific on top. Strip off the top, keep the bottom. There's a trap here, though. Once you start generalizing, it's tempting to keep going, to add the features a second team might want, or the third team, or a team that doesn't exist yet.

Don't do that. That's the whiteboard coming back in through the side door. Generalize what the second team actually needs. When the third team shows up, generalize again. Step three is deciding what to hand over first, and my answer is always the same: cost. Specifically, cost attribution. Every call that goes through the shared gateway gets tagged with which feature made it and which team owns that feature.

Cost goes first for a reason. With three separate gateways, you get three separate bills. They don't add up to anything. Finance asks what AI is costing the company, and nobody can answer that. Or worse, three people answer with three different numbers. A shared gateway with cost tagging gives you one number, one number finance trusts, and one number the architects trust, and it's the same number.

That's the first thing a platform team can deliver that no single feature team can. No feature team working alone can tell you what the company spends on AI. And there's a second reason. It gives the platform team credibility. The first thing it ships answers a question the business has been asking.

That buys a lot of patience for everything that comes afterwards. Step four, and this one is easy to skip. The team whose copy you extracted has to move onto the platform version first before anyone else. Think about it from the second team's point of view.

You're being asked to adopt a shared gateway, and you notice the team that wrote the original is still running its own copy. What does that tell you? It tells you the platform version isn't good enough for the people who know it best, and you'd be right to stay away. So the original team goes first, and if they won't, listen to them.

They're telling you the extraction broke something. Fix that before you ask anyone else to move. And for everyone else, don't make it mandatory. Make it cheaper. Make it better. The platform version should be less work than maintaining their own copy. When that's true, teams move on their own.

When it isn't true, a mandate just gets you teams that comply on paper and route around it in practice. One more thing about moving teams over. Don't try to move their prompts on their eval cases. The platform provides the registry, a place where prompts get stored and versioned with a history.

That's mechanism. But the prompts themselves stay with the teams. So do the test cases for those prompts. A test case describes what a good answer looks like for one product's users. The platform team doesn't know those users.

Teams will move their prompts into the registry on their own. The first time a prompt change breaks something and nobody can tell what the old version did, that's a much better migration plan than any mandate. Now, I want to add something the article didn't say, and it's about the cloud comparison itself.

All of this, the second copy, mechanism versus decision, it all comes from the cloud era, and I think it transfers, but there's one place where it strains. Cloud primitives settled down. A deployment pipeline looked more or less the same for years at a time. Once a platform team built it, most of the work was keeping it running.

AI primitives sit on top of something that moves much faster. Vendors are shipping new models all the time. APIs are changing. What's the best model for a given job can change between one quarter and the next. So an AI platform is going to change more than a cloud platform did, and that has two consequences.

The first is keep it thin. Every layer the platform adds is a layer somebody has to rewrite when the vendor changes something underneath it. A thin platform can bend when that happens. The second one is more interesting. It makes the gateway worth more. When the vendor changes an API or retires a model, the shared gateway is the one place that change lands.

You fix it once. With three private gateways, you fix it three times, and one of them gets missed. So the fast change argues for less platform overall and a stronger gateway at the center of it. There are other places where the cloud comparison strains. For platforms, this is the one that matters most.

The series is going to come back to that question, where the cloud playbook carries over and where it doesn't. Because an idea that's useful needs its edges drawn as well. So here are the things I would do this week. Make a list of every AI feature your company runs in production. For each one, write down where its gateway lives, where its prompts live, and how it gets tested.

Then count the copies. If you find one, you're early. Leave it alone and let it prove itself. If you find two, now's the time. Pick the one with the scars, strip it down to what the second team actually needs, and start with cost tagging. And if you find three or more, you're a little late. Start with the cost anyway.

It's the fastest way to turn these bills into one number, and it gives the platform a reason to exist that nobody will argue with. The original article is linked in the show notes. So is the article that started the AI-native series if you want the whole bolt-on versus AI argument from the beginning. Both come from my Software Architecture Insights newsletter.

Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
