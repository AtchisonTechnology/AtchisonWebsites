---
title: "AI Closes the Ticket. But Who Builds the System?"
slug: ai-closes-the-ticket-but-who-builds-the-system
date: 2026-12-15
episode_number: 20
category: Beyond the Article
tags: []
description: "What a team lead actually does when AI closes the tickets and nobody builds the system."
captivate_episode_id: ""
source_articles: [ai-closes-the-ticket-but-who-builds-the-system]
duration: "11:09"
---

The sprint board is green. Twenty-two tickets closed. Six months later, the same team has four versions of one address validator, and a one-day change takes a week.

Lee's article "AI Closes the Ticket. But Who Builds the System?" named that gap. This episode is about what a team lead does about it on a Monday morning.

**In this episode:**

- Visible work, invisible work, and why AI tools only do the first kind
- Why every signal a manager watches says things are great
- One owning team per service (STOSA)
- Measuring the invisible work, starting with one duplication number
- Making room for cleanup in the plan
- Asking the AI for the right thing
- The one question to add to code review

**Links:**

- [AI Closes the Ticket. But Who Builds the System?](https://softwarearchitectureinsights.com/posts/ai-closes-the-ticket-but-who-builds-the-system/)
- [Is AI Code Automation Contributing to Code Complexity? (episode 15, on GitClear's research)](https://softwarearchitectureinsights.com/podcast/then-now-ai-code-complexity/)
- [STOSA: Single Team Oriented Service Architecture](https://stosa.org/?utm_source=sai-web&utm_medium=referral&utm_campaign=ai-closes-the-ticket-but-who-builds-the-system&utm_content=stosa)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Picture a sprint review. The board is green. 22 tickets closed, the most the team has ever done in a two-week sprint. Everyone's happy. The AI tools are really paying off.

Now, picture the same code base six months later. There are four slightly different versions of that function that validates an address. Nobody knows which one is the real one, and a change that used to take a day now takes a week because every fix has to be re-made in four places. Both of those teams are the same team.

Back in July, I wrote an article called "AI Closes the Ticket, But Who Builds the System?" It was about that gap. AI is very good at closing tickets and closing them very quickly at scale. It's much worse at the work that keeps a system running healthy. The article described the problem. Today I wanna take a look at what you actually do about it on a Monday morning If you missed it, here is the short version of the article, and if you'd like to read the original article, there's a link in the show notes.

A code base needs two kinds of work. There's the visible work, new features, bug fix tickets. Somebody asked for it, somebody can see it, and it closes. Then there's the invisible work, pulling duplicated code together, moving logic to the place it really belongs, deleting things that nobody uses. Nobody files a ticket for those things. It happens because an engineer notices something is wrong and fixes it while they're in there.

AI tools are built for the first kind. You give them a task, they finish the task, and all the tests pass. The second kind needs judgment about the whole system, and the tool isn't asked for that judgment, so it doesn't provide it. Back in October on this show, I walked through GitClear's research on this in detail. I'm not gonna repeat all of it here, but two numbers tell the story.

Duplicated code is up eighty-one percent since twenty twenty-three. Refactoring is down seventy percent. More code is being added, much less of it is being cleaned up. Here's the part I want to spend the time on here. Why doesn't anyone catch this? Because every signal a manager looks at says things are great. Velocity is up. Tickets are closing. Pull requests are merging. The demo works great.

And code review doesn't catch it either. A reviewer looks at one change. The change is fine. It works. It's tested. It's readable. What the reviewer can't see is that the same logic already exists in three other places in the code base. The trouble is in how the change relates to everything else. So every individual decision looks right. The damage only shows up in the total. That's why better tools won't fix this. It's a leadership problem.

So the question in the title: who builds the system? In a healthy team, the answer used to be everybody a little bit every day. Senior engineers cleaned up as they went. It wasn't anyone's job, it just happened. AI broke that. When writing new code costs almost nothing, adding a fifth copy of something is faster than finding and fixing the four that exist. So the cleanup that used to happen as a side effect stops happening.

If that work used to happen by accident, it now has to happen on purpose, and on purpose means somebody owns it. This is where I go back to the idea I've used for years. I call it STOSA, single team-oriented service architecture. Every service has exactly one owning team. Ownership covers more than who gets paged. The owning team also answers for the shape of the code.

If the service has one owning team, that team is the one that has to answer for four copies of the address validator. If a service is owned by everybody, then nobody is watching its structure, and AI makes that gap grow faster than it ever did before. So step one is boring. Make sure every service has one team whose name is on it Step two is to change what you measure. If your dashboard shows tickets closed and lines of code, AI will make that dashboard look amazing. It's measuring exactly the thing AI is best at.

Add a few numbers that show the invisible work. How much duplicated code is in this service, and is it going up or is it going down? How much of this month's change was moving and consolidating existing code versus adding new code? When did anyone last touch the oldest, most important module in your system? You don't need a fancy tool to start. Several code analyst tools report duplication today.

Pick one, run it on your most important service, and write down the number. Then look at the same number again in a month. You're not trying to hit a target. You're trying to see the direction. If duplication climbs every month while velocity climbs too, you know where the velocity is coming from. Step three is money and time. Invisible work doesn't get done if there's no room for it. And, quote, "We'll clean it up later," has never worked. Not once. You know that and I know that.

So put it on the plan. Some teams reserve a fixed share of every sprint. Some run a cleanup week every quarter. The exact method matters less than having a method, writing it down, and making sure it survives the next deadline And here's the part that leaders miss. Some of the time AI saved you should go right back into structure. If AI made the team faster at features, great. Spend part of that gain keeping the system healthy enough to stay fast. Otherwise, you're borrowing the speed from next year.

Step four is the one engineers can do today without asking anyone. The tools do what they're asked, so ask them for the right thing. Before you ask an assistant to add a feature, ask it to find anything in the code base that already does something similar. Make that a habit. Make it part of your team's instructions for the tool so it happens every single time.

When the assistant writes new code, ask it whether this should reuse something that existed before. And once in a while, give it a ticket that is pure cleanup. Find the duplicated validation logic in this service and consolidate it. AI can do that work as well. It just never volunteers to do it. The article made a point I want to repeat. AI amplifies the habits your team already has.

A senior engineer who always looked for existing code before writing new code will keep doing that, and a tool makes them faster. An engineer who never had that habit now produces more code faster without it. So the habit is the thing to teach. The tool just multiplies it. One last change, and it's not that big. Add one question to your code review. Does this already exist somewhere? That's it. Just one question. It moves the reviewer from, "Is this change correct?" to, "Does this change belong?" And that's the question AI isn't asking.

So here's what I'd do this week. Pick your most important service, confirm it has one owning team, run a duplication report on it, and write the number down. Add the does this already exist question to your review checklist, and put one cleanup ticket on the board. Just one. Give it to the AI if you'd like.

AI will keep closing your tickets. That part is solved. Somebody still has to build the system. Make sure you know who that is. The original article is linked in the show notes. If you missed the earlier episode on GitClear's research, that's linked there, too Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
