---
title: "Your RPO Has a Price"
slug: your-rpo-has-a-price
date: 2026-11-20
episode_number: 18
category: Course Spin-off
tags: []
description: "One small system, five recovery targets, and a monthly bill that triples. Protecting your data is cheap. Getting back up fast is what costs money."
captivate_episode_id: ""
source_articles: []
duration: "9:09"
---

In a design review, someone asks the recovery question: how much data can we lose, and how long can we be down? The answer comes back fast. None, and not at all. Nobody asks what it costs.

This episode puts a price on that answer. One small system on AWS, five recovery targets, and a monthly bill that goes from about $413 to about $1,270. The system and the traffic stay the same. The only thing that changes is what someone said in a meeting.

This lesson is from my course, Architecting for Cost. Prices are AWS, September 2026.

**In this episode:**

- The two numbers behind the recovery question: RPO and RTO
- The ladder: five recovery targets, priced rung by rung
- Why protecting data is cheap and getting back up fast is expensive
- Matching the rung to the service
- When the top rung is the right answer
- This week: write down the RPO and RTO each important service has today

**Links:**

- [Architecting for Cost](https://atchisonacademy.com/courses/architecting-for-cost/launch/?utm_source=sai-web&utm_medium=referral&utm_campaign=your-rpo-has-a-price&utm_content=cta)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. In a design review, somebody asks the recovery question. If we lose this system, how much data can we actually lose, and how long can we afford to be down for?

Well, the answer comes back fast. How much can we lose? Nothing. How long can we be down for? Well, not at all. Everyone nods. It sounds responsible. Nobody asked what it costs.

Today, I want to put a price on that answer. It comes from one of the lessons in my course, Architecting for Cost, that I think shows the whole argument best.

Two numbers sit behind that question. The recovery point objective, or RPO, is how much data you can afford to lose measured in time. An RPO of five minutes means you can lose up to the last five minutes of database writes. The recovery time objective, or RTO, is how long you can afford to be down during this process.

Both are availability decisions, and the architect has to make both of those calls. But each one also picks up a backup and a replication design. The design shows up on the bill. Finance can report the number, but only the architect can choose it.

So let's price it. One small system, six containers behind a load balancer, and one Postgres database with five hundred gigabytes of data. We're gonna put this on AWS using September twenty twenty-six prices. Yours will differ a little bit, but the shape will basically be the same. We'll walk up a ladder of recovery targets and price each rung.

The bottom rung is one database in one zone with automatic backups. You can restore it to any point in time in the last few minutes, so your RPO is about five minutes. But the restore can take an hour or more. That's your RTO. The whole system architecture costs about four hundred and thirteen dollars a month.

The next rung up, add a standby database in a second zone. If the first zone fails, the standby takes over in a minute or two with no data loss at all. Well, that doubles the size of the database, making it about five hundred and ninety-three dollars a month.

Now, what if the whole region goes down? The cheapest answer is to copy your backups to a second region every night. You'd lose up to a day of data, and it would take hours to rebuild your application, but your company would survive. That adds only about $71 a month, mostly from cross-region data transfer and storage charges.

But to survive a region with only minutes of downtime, you need something already running over there in the second region. A copy of the database, data synced and kept up to date continuously, and a couple of containers and a load balancer ready to take on traffic. That adds about $280 a month, we're close to about $1,000 a month for this one service.

And now the top rung. If that's what you want, no data loss and no downtime even when a region fails, that means a full second copy of the system taking traffic continuously all the time. That's about twelve hundred, thirteen hundred dollars a month, and that's before the engineering. Writing to two regions at once needs a different type of database built for it and code that handles conflicting writes and all of that sort of work.

Four hundred and thirteen dollars to twelve hundred and seventy dollars. Same system, same traffic. The only thing that changed is what someone said in a meeting. The service is three times the price based on casual conversations that can be made in a design meeting.

Look at the pattern on the ladder. Protecting your data is cheap. Copying data and changes cost storage and transfer, and those really aren't all that expensive. But adding a nightly copy in a region, that costs a lot more. Getting back up and running quickly, that's what costs the real money. Fast recovery means capacity sitting there, running, waiting for a disaster that may never come, always up to date and always in sync with what's going on.

So RPO is cheap. Making sure you can recover your data is easy to do, relatively easy to do, and relatively inexpensive. But RTO is expensive. Being able to recover quickly, that's what RTO covers.

So RPO is cheap and RTO is expensive. Well, even a nightly copy gives you an RPO of up to a day. So the cheap end buys you a lot less. Teams tend to ask for both a good RPO and a good RTO in the same breath, as if they cost the same thing.

The fix is to match the rung to the service. A checkout service, that might be worth a warm standby and a second region. The payment path might be worth the top rung. A reporting tool that rebuilds from the warehouse every night, that probably doesn't even need a standby at all.

Now, there's a catch to all of this. The top rung is sometimes the right answer. If an hour of downtime costs your business more than the difference between the rungs, well, then it's worth doing. But that's a business decision and a business number, and it's its own piece of math. All that this ladder does is it lets you make the choice with both of the prices in front of you. How much does each level of service cost?

So this week, take your most important services and write down the RPO and RTO each one has today. If nobody can tell you the numbers, well, that's your first finding. Then find which rung each one is actually on, and price the gap between that rung and the one below it. Ask whoever set the target whether they knew the price when they set it. If the answer is no, you found a decision worth making again.

This lesson is from my new course, Architecting for Cost. The launch price is $495 instead of the normal $695, and that special runs through Tuesday, December 1st. The link is in the show notes.

Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
