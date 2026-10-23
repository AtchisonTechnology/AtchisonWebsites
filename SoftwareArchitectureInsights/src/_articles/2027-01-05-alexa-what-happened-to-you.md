---
title: "Alexa, What Happened to You?"
subtitle: "She still says yes. She just doesn't do it."
author: "Lee Atchison"
status: published
created: 2026-10-13
drafted: 2026-10-23
date: 2027-01-05
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: alexa-what-happened-to-you.png

meta_description: "Alexa+ put a language model in front of every command, and the basics got worse. Why Alexa is coming out of my home, and what I want next."
slug: alexa-what-happened-to-you
description: >
  Alexa+ routes even "turn on the lights" through a language model, and the
  basics got worse. Lee's story of why Alexa is coming out of his home: the
  architecture change, the shopping-first incentives that let it happen, and
  why reliable basics are where home assistants have to go next.
categories:
  - "Availability & Resilience"
  - "AI Strategy & Adoption"

---

# Alexa, What Happened to You?

*She still says yes. She just doesn't do it.*

---

"Alexa, turn on the family room lights."

She answers with her cheerful little "ba-deep." That's the sound that means she heard me and took care of it.

Nothing happens.

So I say it again, "Alexa, turn on the family room lights." Ba-deep. Nothing.

I say it a third time. Ba-deep. The lights come on. That happens in my house almost every day now.

And once in a while, with nobody talking and nothing on that sounds anything like "Alexa," she speaks up on her own. From across an empty room, out of nowhere, she says "Goodbye."

## Alexa used to be good at this

When Alexa showed up, nothing else came close. She was the first voice assistant at scale that did real things in your home. She played music, set timers, and turned on the lights.

She was dumb, but dependable. You said the same words, and the same thing happened every time.

She was great for the grocery list. "Alexa, add butter to the shopping list," and butter showed up in AnyList, the shopping app I use.

## Then came Alexa+

Amazon rolled out Alexa+ to every US user in February 2026. It's the generative AI version, built on large language models.

I use it. It should have been a big step up. Instead, the things I use every day got worse.

"Alexa, play cool jazz" gets me music that is neither cool nor jazz. So I say "Alexa, stop."

Ba-deep. Polka.

It takes two or three tries to get silence.

The shopping list is worse. Amazon cut off the third-party list connection back in 2024, so "add butter to the shopping list" now lands on Alexa's own list.

That list is buried deep in the Alexa phone app, which has almost no features. Alexa won't even show it to me when I ask.

To reach AnyList, I have to say "Alexa, add butter to my AnyList shopping list." Sometimes that works. Other times she misses the word "AnyList," and the butter goes to the hidden list. Ba-deep either way.

So now I check every item by hand. If I have to check it by hand, I might as well add it by hand. Siri, for the record, gets this right every time.

Then there's the mishearing. It happens constantly now, and it never seems to improve. It just gets a little worse, one...step...at...a...time.

## What actually changed

Old Alexa matched your words to a fixed action. "Turn on the family room lights" meant one thing, and it fired one thing.

Alexa+ puts a large language model in front of every request. The model reads what you said, decides what you meant, and picks an action, which is a great fit for "help me plan dinner for six."

It's a terrible fit for a light switch. Language models are probabilistic. Ask the same thing twice and you can get two different decisions.

A light switch should never be probabilistic.

The ba-deep makes it worse. It used to mean "I heard you, and I did it." Now Alexa confirms success without knowing whether it succeeded. Once that happens, you can't trust her "yes" anymore.

Amazon says Alexa+ runs on models from its own Nova family and from Anthropic. I write about Claude a lot, and I don't blame Anthropic for any of this.

The problem is how Amazon chose to use the models. It put one in front of commands that never needed it.

I've called this kind of thing [the new lift-and-shift](https://softwarearchitectureinsights.com/posts/bolting-ai-onto-your-app-is-the-new-lift-and-shift?utm_source=sai-email&utm_medium=email&utm_campaign=alexa-what-happened-to-you&utm_content=body). Bolt AI onto an existing product, and the whole product starts behaving differently, including the parts that used to work.

## Why Amazon let it happen

Amazon has always run Alexa as a store with a speaker attached.

Echo devices sold for about what they cost to make. The plan was to make money later, when people used them, mostly by shopping.

People used them for timers, music, and lights instead. In 2022, Business Insider reported that Alexa and the devices group were on pace to lose $10 billion that year.

Now look at what Amazon brags about with Alexa+. Customers make three times as many purchases with it as they did with the old Alexa. Andy Jassy told investors that everywhere Alexa goes, it drives momentum for the business.

Nobody brags about how often the lights come on.

That shopping list change fits the same pattern. My list moved out of a third-party app and onto an Amazon list, one step from checkout.

I can't say that's *why* Amazon did it. I can't help noticing, though.

## Where home assistants need to go

The assistant that wins the home will keep the basics rock-solid and put the AI on top. Lights, timers, lists, and music should work the same way every time. The smart stuff can sit above that and handle everything else.

Right now, Siri looks closer to that. It's getting better, slowly, and it rarely gets the basics wrong.

Siri is where I'm leaning. I haven't decided yet.

If you only use your Echo for timers and the weather, you may be fine. The trouble starts when you depend on it.

## Where that leaves me

I've decided. Alexa is coming out of my home.

I don't have a replacement plan yet. Siri is the likely answer, but switching costs money, and Siri hasn't proven herself either. I don't want to go out of the frying pan into the fire.

So I gave Alexa one last request.

"Alexa, add 'replace Alexa' to my shopping list."

Ba-deep.

And all my lights turned off.

---

*Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=alexa-what-happened-to-you&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=alexa-what-happened-to-you&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=alexa-what-happened-to-you&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=alexa-what-happened-to-you&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=alexa-what-happened-to-you&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
