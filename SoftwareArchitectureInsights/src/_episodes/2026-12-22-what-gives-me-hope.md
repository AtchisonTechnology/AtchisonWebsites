---
title: "What Gives Me Hope..."
slug: what-gives-me-hope
date: 2026-12-22
episode_number: 21
category: Questions I Get Asked
tags: []
description: "Lee is still worried about AI. Here are four things from 2026 that give him real hope, and one small thing to try in January for each."
captivate_episode_id: ""
source_articles: []
duration: "10:40"
---

"Are you worried about AI?" It's the question Lee gets asked more than any other right now. His answer is yes.

But it's Christmas week, and worry isn't the whole story. This episode looks at the other side: four things Lee saw in 2026 that give him real hope. Not hype. Things actually happening on real teams.

**In this episode:**

- Old code is finally getting attention
- Cost is back in the architecture conversation
- More developers are being pushed toward judgment
- Small teams can try big ideas
- One small thing to try in January for each hope

**Links:**

- [What I Got Wrong in 2026](https://softwarearchitectureinsights.com/posts/what-i-got-wrong-in-2026/)
- [The Architecting for Cost course](https://atchisonacademy.com/courses/architecting-for-cost/?utm_source=sai-web&utm_medium=referral&utm_campaign=what-gives-me-hope&utm_content=body)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. There's a question I get asked more than any other right now: Are you worried about AI? I get it from engineers, I get it from CTOs, I get it from people who don't work in tech at all. And my answer is yes. Some days I worry quite a bit. If you've been following along this year, you'll know why. I've written about code that piles up that nobody sees, about security holes we can't patch our way out of, about companies cutting the very engineers they need to keep AI-written code healthy.

That's all real. I'm not taking any of that back. But this is Christmas week, and worry isn't the whole story. So today, I wanna talk about the other side. Four things I've seen this year that give me real hope, not hype. Things that are actually happening in real teams right now.

Assuming you're listening to this the day after it launched, then you'll notice I also published a newsletter this morning. If you read that issue, I spent it looking back at what I got wrong in 2026. This episode looks forward. The first thing that gives me hope is old code. Every company has one, the system nobody wants to touch.

It's 15 years old. Maybe it's written in COBOL. Maybe it's a Java monolith or a Rails app on a version nobody supports anymore. The person who wrote it left years ago, and the documentation, if there ever was any, is wrong. Everybody agrees it should be modernized, and it's been on the roadmap for a decade.

It's been on the roadmap for a decade because there's never been a good time to spend a year of senior engineering effort on something that technically still works fine the way it is. Well, here's what changed.

AI turns out to be very good at reading old code, reading it, explaining it, and writing tests around what it does today. That's the slow, painful first step of any modernization project, and it used to take months of somebody's life. Now a team can sit down with a system nobody understands and in just a few weeks actually understand it, what it does, what it depends on, who depends on it, where the scary parts are.

That doesn't mean the AI does the migration for you. Someone still has to own the result. Someone still has to decide what the new system should look like. But the wall that stopped these projects from ever starting in the first place, it's a lot lower than it was.

I think we're going to see a lot of very old systems finally get the attention they deserved years ago. That makes me happy. That gives me hope. The second thing is cost. For a long time, cloud cost was somebody else's problem. The architects designed the system, the bill went to finance. And once a quarter or so, somebody from finance went over, talked to the architects, and asked why the bill was so big, and nobody really had a great answer.

AI changed that, and it changed it almost by accident. You see, every model call has a price, a real one per request that you can see.

Make a design choice that calls the model three times instead of once, and you've tripled the cost of that feature. You can't hide that in a big monthly number any longer. So architects started asking a question we hadn't asked enough in years: what does this request cost? And here's the part I like.

Once teams start asking that about AI calls, they start asking it about everything else, too. The database query that runs on every page load, the service that runs on three instances when it really only needs one or two, the data nobody reads but everybody stores.

Cost is an architecture decision. It always was. We just forgot it for a while. That's a big part of why I built my Architecting for Cost course this year, because the conversation is finally back where it belongs, with the people designing the system. My third hope is personal for me. More developers are being pushed toward judgment.

I've spent a lot of my career thinking about how developers become architects, and it usually takes a long time. You spend years and years writing code, and somewhere along the way, if you're lucky, you start getting asked the bigger questions. Should we build this at all? How should the pieces really fit together?

What happens to this design in three years? Well, here's what's happening now. As writing code is getting cheaper with the help of AI, the part that's left is deciding what to build and why. It's the judgment. It's the trade-offs. That's architecture. Developers are running into those questions earlier in their career than they used to, not because someone promoted them earlier, but because the AI handles more of the typing, and what's left on their desk is the thinking.

The transition is uncomfortable for a lot of people, and it's not good news for every role. But for the developers who lean into it, this is the fastest path to architecture and a promotion that we've ever had. And we're going to need a lot more architects. And now my last hope. Small teams can try big ideas.

Think about the last big idea your company decided not to try, not because it was a bad idea, but because testing it would have taken 20 people and six months, plus a year to develop, and nobody wanted to bet that much on a maybe. Now that math is changing. A small team, even one, two, three people, can now build a working prototype of almost anything that used to need a whole department.

Not production-ready code. I wanna be clear about that. Earlier this year, I spent a lot of time warning about what happens when a prototype gets shipped as if it were a production. Rather, it's a way to find out whether an idea is any good or not. It's remarkable. More ideas are getting tested. Fewer big bets get made on ideas that nobody has tried.

And the ones that work show up with real evidence, not just a slide deck. That's better for everybody, including the architects who have to build the real thing afterwards.

So, am I worried about AI? Yes, still. But I'm also more hopeful than I was a year ago, and I don't think those two things cancel out. I think they're both true. If you want to be part of the good version of all of this, here's one small thing for each hope. Pick one for January. Find the system everyone's afraid of and have AI help you explain it to your team. In your next design review, ask what each request costs. Let a developer on your team own a real design decision, not just the code.

And take the idea your company shelved because it was too expensive. Find out if it's still too expensive. None of those are big things. All of them move things in the right direction. Thank you for listening this year. I hope you have a wonderful holiday, and I'll see you in the new year.

Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
