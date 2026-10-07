---
title: "Nobody Gets Promoted for Turning Things Off"
slug: nobody-gets-promoted-for-turning-things-off
date: 2027-01-12
episode_number: 23
category: Beyond the Article
tags: []
description: "Finding the systems nobody owns, turning them off without getting burned, and getting the time to do it."
captivate_episode_id: "f5c55f10-5f15-450f-aa02-8af24f1a03ad"
source_articles: [nobody-gets-promoted-for-turning-things-off]
duration: "13:48"
---

A security scan flags a service called Billing Export V2. Nobody recognizes it, and nobody knows if anything still calls it. So the team patches it and leaves it running.

Lee's article laid out a process for turning systems like that off. This episode goes into the parts that are harder than they sound.

**In this episode:**

- Finding the orphans: ask your systems, not your people
- The cron jobs, flags, DNS records and alerts nobody owns
- Brownouts, a safer scream test
- The data, and archiving with an expiration date
- Retiring a public API, and the Sunset header
- The orphan sitting under a Tier 1 service
- Getting your manager to give you the time

**Links:**

- [Nobody Gets Promoted for Turning Things Off](https://softwarearchitectureinsights.com/posts/nobody-gets-promoted-for-turning-things-off/)
- [RFC 8594: The Sunset HTTP Header Field](https://www.rfc-editor.org/rfc/rfc8594)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Back in November, I wrote an article called Nobody Gets Promoted for Turning Things Off. It started with a service called Billing Export V2.

A security scan flags it, nobody on the team recognizes it, and nobody knows if anything still calls it, so they patch it, and then they leave it running. Every one of you has one of those systems, probably dozens. The article was about why they pile up, and it laid out a process for turning them off safely. Today, I want to go past that. How do you actually find these things? How do you turn one off without getting burned? What do you do about the data? And how do you get your boss to give you the time?

A quick recap first, in case you missed the original article. There's a link in the show notes if you want to read it. Organizations reward launching. A new service gets a demo and a launch post. Turning an old one off gets nothing. And if you turn off something and it breaks something, that outage has your name on it.

So for any one engineer, leaving something running is the rational choice, which means nobody turns anything off. Meanwhile, the costs keep growing. Every dead system adds complexity. It adds a security exposure because unknown code is unpatched code, and it sits on your cloud bill forever. The article gave four steps: prove it's unused, announce a date, turn it off but keep it so you can bring it back, then after a quiet period, delete it for real. That's the process. Now let's talk about the parts that are harder than they sound.

Let's start with finding them. It's hard to retire something you don't know exists. Most teams try to build this list from memory. They get a few people in a room and ask, "What do we have that nobody uses?" And you usually get some form of list. But it's the list of things people remember, and the whole problem is that these things are things that nobody remembers. So don't ask people. Ask your systems. I'd look in three places specifically. First, start with your cloud bill. If you tag resources by team or by service, look at what's untagged. Untagged resources are a great clue because the tagging usually happened when someone cared, and the untagged stuff is what nobody cares about.

And if you're not tagging things by team or service, start doing it now Then look at your deploy history. Anything that hasn't been deployed in a year or more is a candidate. Now, not being deployed for a year doesn't prove anything. Some things are stable and just don't change over time, but it's a good place to start asking questions.

Next, check your credentials. Most cloud providers can tell you when a specific credential or access key was last used. A service account that hasn't authenticated in six months is telling you something. That, of course, assumes that you have a different set of credentials for every service, which of course you do for security reasons, right? If not, you definitely wanna be doing that as well.

And look past services. Some of the worst leftovers aren't services at all. Cron jobs that run every night and write to a table that nobody ever reads. Feature flags that were supposed to be temporary three years ago DNS records pointing at things that don't exist anymore, dashboards that nobody opens, and alerts that fire so often everybody has learned to ignore them.

That last one matters more than you might think. An alert everyone ignores is training your on-call team to ignore alerts. That's a retirement candidate too. Okay, you've found something. You've looked at the traffic and the logs, and you're pretty sure nothing is using it. Pretty sure. You're never going to be completely sure. There's always the quarterly report, or the partner integration, or the one script on somebody's laptop.

Most people have heard of the scream test. You turn off something and wait to see who screams, and it works. But I've seen it done badly more often than I've seen it done right. Now, done badly, somebody turns it off on a Friday afternoon, and they go home, and the scream shows up at 2:00 AM on Saturday in the form of a page, a page is sent to someone that has no idea what just happened.

So here's how I'd do it instead. I'd use a brownout. Turn it off for an hour during business hours on a weekday when the person who did it is watching, and with a way to turn it back on in a minute or two if necessary. Announce that you're going to do this ahead of time. If nothing happens, turn it off for a day.

If that works, try a week. Then turn it off and try and leave it off. Every step is short, is reversible, and somebody is paying attention. And if someone does scream, they scream at a time when you can actually talk to them and find out what they need. A brownout turns a scream test from a gamble into an experiment Now here's something the article only touched on, and it trips up a lot of teams, and that's the data.

Turning off compute is the easy part. You stop the instances and they're gone. The data is harder. The old service probably has a database or a bucket full of files, and some of that data might matter to somebody who isn't an engineer. Finance might need transaction records for a certain number of years. Legal might have a hold on something. Your compliance team might have retention rules you've never heard of. So before you delete data, ask. Ask the people who own the obligations as well as the engineers. It's a short conversation, and it's much cheaper than finding out later.

So don't let that turn into keeping everything forever just in case Data you don't need is a liability. It's something that can leak, something that shows up in an audit, and something you're paying to store. If you keep it, move it somewhere cheap. Write down who owns it, and write down the date it gets deleted.

Archive with an expiration date. Now, everything so far assumes the users of the old system are inside your company. You can find them, you can talk to them, and you can walk down the hall. Public APIs are different. When the callers are your customers, you can't just turn something off and see who screams. The person screaming is a customer, and they might be screaming at your sales team.

So deprecating a public API version takes longer, and it takes more care. Give a lot of notice, far more than you'd give internally. Put it in writing, and measure usage customer by customer so you know exactly who is still calling the old version. There's even a standard for this. There's an HTTP header called Sunset that an API can return to say when it's going away. Clients and tools can read it and warn the developers automatically.

It's one more way to make sure nobody is surprised. And when you get down to the last few customers, pick up the phone. The last 5% of callers on an old API version usually need a real conversation Now, back to service tiers for a moment, because that's where the risk is really hiding. When teams do their first inventory of orphan services, they tend to assume those are all tier four.

Internal, low impact, nobody cares. That's why they're orphans, right? But a service's tier comes from what depends on it. And every so often, the inventory turns up an orphan that sits underneath something important. A tier one checkout flow calls an old service nobody owns. That's the most dangerous thing you'll find, and it goes to the top of the list.

You have two choices with that one. Adopt it, give it a real owner, and treat it like the tier one dependency it is, or remove the dependency so the tier one service no longer needs it. What you can't do is leave it the way it is Now, one more question. How do I get my manager to give me time to do this? The biggest mistake people make is they pitch it as cleanup.

We should tidy things up. We have a lot of cruft in the system. But that argument loses every time. Tidiness never beats a feature on a roadmap. Never. Talk about the three things your manager already cares about. Lead with cost. Here's what these ten things cost on the cloud bill every month. Now, that's a real number, and it's easy to get.

Then talk about risk. These services don't have up-to-date security patches. They have live credentials. This is what an auditor or an attacker is going to find. And then time. How many hours did the team spend last quarter patching, investigating, or getting paged for things that nobody's using? That's time taken away from the roadmap already. You're just asking it to be spent on purpose.

Then keep the ask small. Ask to retire five things this quarter. Report on what it saved, then ask for the next five. The first round is how you prove it's safe. After that, it gets a lot easier to ask in the future So here's what I do next. Pull the list from your systems, the bill, the deploy history, and the credentials. Pick one thing on that list, just one. Find somebody to own its retirement. Then run your brownout an hour on a weekday with someone watching. If nothing breaks, keep on going.

And when it's finally gone, tell people. Tell your team and tell your manager, because the whole problem with turning things off is that nobody notices when it's going well. Make sure somebody notices The original article is linked in the show notes. It has the four-step retirement process written out, so you can hand it straight to your team Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
