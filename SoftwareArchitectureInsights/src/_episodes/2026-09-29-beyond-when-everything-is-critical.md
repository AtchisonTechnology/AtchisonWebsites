---
title: "When Everything Is Critical, Nothing Is"
slug: beyond-when-everything-is-critical
date: 2026-09-29
episode_number: 13
category: Beyond the Article
tags: []
description: "How to decide which services matter most, and which one team owns each of them."
captivate_episode_id: "8b8212c2-42c0-4030-ae9b-1232d80f8dd7"
source_articles: [when-everything-is-critical-nothing-is]
duration: "16:00"
---

It's 3am and a payment service is failing. The engineer who answers has never touched it, and the next hour goes to finding someone who can fix it.

In this episode, Lee goes further than his article "When Everything Is Critical, Nothing Is." The article named the two missing decisions. This episode is about how to make them: which services matter most, and which one team owns each of them.

**In this episode:**

- The four service tiers, in plain terms
- Three questions that keep everything from landing in Tier 1
- Why every tier is a budget decision, and why you should cap Tier 1
- The dependency trap: a Tier 1 service is only as reliable as the lower-tier service it can't live without
- What "owner" means: paged, planned, permitted
- Inherited services, and an exercise to run this week

**Links:**

- [The ownership-gap diagnostic](https://softwarearchitectureinsights.com/service-ownership-diagnostic)
- [STOSA: Single Team Oriented Service Architecture](https://stosa.org/?utm_source=sai-web&utm_medium=referral&utm_campaign=when-everything-is-critical-nothing-is&utm_content=body)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Last month, I wrote about a 3:00 AM page. A payment service was failing, and the engineer who answered the page never touched it. The next hour was spent finding someone who actually knew how to fix it.

That article was called "When Everything is Critical, Nothing Is." Today, I want to go further than the article had room to discuss. The article told you what's missing: two decisions, which services matter and who owns them. What it didn't tell you is how to make those decisions, and that's where most teams tend to get stuck. So that's this episode, how you add a service tier to your services, and how you make ownership stick.

Let's start with a quick recap in case you missed the article. By the way, if you'd like to read the original article, there's a link to it in the show notes. When an outage runs long, we usually blame the technology or we blame communication. But look at where the time actually goes. In a story from the article, the actual problem took 11 minutes to find, and the other 62 minutes went to finding a person responsible.

No technical fix would have saved those 62 minutes. What was missing were two key decisions. The first is criticality. Which of your services matter the most? The second decision is ownership. For each service, which one team, one single team, is accountable for keeping that service up and running? Now, most organizations have made neither decision, or even worse, they think they've made the decision, and the answer on paper doesn't really match what really happens at 3:00 in the morning.

So let's start with service tiers. I've used a four-tier model for a long time now. I wrote about it in my book, "Architecting for Scale." Here's the short version of that. A Tier 1 service is a service where if it goes down, the business is hurt right away. Customers can't buy, they can't log in, and money stops flowing into the business. A Tier 1 service outage means the building is on fire.

A Tier 2 service is a service where failure hurts, but the business can keep going. Customers will notice something is wrong. You know, maybe search is slow or not working, or recommendations are missing from products, or something like that, but things generally still work. And most importantly, the business can keep moving forward. Money is still being made. Commitments are still being kept. A Tier 3 service is a service whose failure most customers wouldn't even notice right away.

Maybe eventually, but not right away. Something in the background, like an email digest or a report that runs overnight, or something like that. Those are examples of Tier 3 services. A Tier 4 service is internal and doesn't touch customers at all. If a Tier 4 service goes down, somebody on your team might get annoyed, but that's really the full extent of the impact. Now, the definitions are the easy part.

Most teams can agree on those definitions in about 10 minutes. The hard part, though, is applying them to your application. In this article, I described an exercise where 53 services got sorted, and 48 of them came back as Tier 1. I've seen versions of that sort of problem occurring more than once. And I want to be fair to the people that are doing it because nobody's being dishonest here.

Each team gets asked, "Is your service important?" And every team says, "Yes, of course," because it is important, at least it is to them. The problem is the question. Is it important? We'll always get a yes answer. After all, if a service isn't important, well, why does it exist at all? So change the question. Here are three questions that I recommend asking instead of the is it important question.

Start with this one: What happens to a customer in the first hour this service goes down? Not the first day, the first hour. If the answer is they can't complete a purchase, then this service is a Tier 1 service. But if the answer is something more like a nightly report is late, then this most definitely is not a Tier 1 service. Then ask this question. If this service and the checkout service both fail at the exact same time, which one do you fix first?

Everyone knows the answer. The checkout service. The checkout service is probably one of your most critical services, period, if you're a e-commerce application at least. Because without the checkout service, the business itself is dead. But the moment you ask the question out loud, the moment you ask how does your service compare to the checkout service, you've ranked the two services against each other. And the last question: would you pay for a second cloud region for this service in order to improve availability, or would you put an engineer on call for it overnight?

Making a service Tier 1 comes with a price tag. It costs money to duplicate a service for availability, and on-call engineers are expensive to your other projects as well. If nobody's willing to pay for those things, well, then the service just plain can't be a Tier 1 service. That last question changes the conversation completely because every tier assignment is now a budget decision. One more thing that helps is putting a limit on the number of Tier 1 services you're allowed to have in your application.

Pick a number. Maybe it's five, maybe it's eight, maybe it's fifteen. The right number absolutely depends on your application. But pick one and write it down. Then, if a team wants to add a new service to the Tier 1 list and it, the list is already full, something else has to come off the list. Or they have to make the case in front of everyone why the limit needs to be increased.

Now, this may sound bureaucratic, but in practice, it moves the ranking conversation into a meeting on a Tuesday afternoon, which is a whole lot better than a bridge call at three o'clock in the morning during a crisis. You're going to rank your services either way. You can do it calmly ahead of time, or you can let whoever answers the page do it in the middle of the night.

It's your choice. Now, something this article didn't get into, and it trips up almost every team that tiers for the first time, and that is dependencies. Say the checkout service is a Tier 1 service. Now, checkout calls a tax calculation service. Somebody ranked the tax calculation service as a Tier 3 service because it's small and nobody really thinks that much about it. It was a poor ranking, but that's what they came up with.

But what happens when the tax service goes down? Well, in most cases, checkout goes down with it. Your Tier 1 service is only as reliable as the least reliable thing that it can't live without. So here's the rule I use. When a Tier 1 service, such as the checkout service, depends on a lower tier service, you have two choices. You raise the dependent service to be a Tier 1 status service on its own right, with everything that comes with that and all the costs that are associated with that, or you make the Tier 1 service, like the checkout service, able to survive without the dependency.

Maybe checkout can use a cached tax rate for a few minutes. Maybe it lets the order through and calculates the tax later. Maybe it turns off one feature instead of failing the whole page. Either raise the tier of the dependency or make the dependency itself optional. Either choice works. The one that fails is a Tier 1 service quietly depending on a Tier 3 service as a necessity with nobody noticing until the night it really matters.

When you do your first tiering pass, walk the dependencies of every Tier 1 service. That's usually where some of the surprises are going to show up. Okay, let's talk about ownership, the second question. Every service has exactly one owning team. The team is named, and the team is current. That's part of a principle that I call STOSA, Single Team Oriented Service Architecture. One service, one owning team.

The rule is simple, but living it is actually quite a bit harder. Owner is one of those words people use and nobody really defines. So let's try coming up with a definition of ownership. An owning team is the team that gets paged when a service breaks. It's the team that has the service on its roadmap, so upgrades and fixes get scheduled. And it's the team that can change the service and deploy it without asking anybody's permission.

Paged, planned, permitted. If a team has all three of those attributes, it owns the service. If it's missing any one of them, it doesn't. So here's a test you can run. Pick a service, any service. Ask the team that's listed as the owner three questions. First, when this breaks at 3:00 AM, does your phone ring? Is there work for this service in your plan for this quarter?

Could you deploy a change to it today without asking another team? If the answer to all three of those questions is yes, great, you have ownership. But what you'll often find is two yeses and a no. The team gets paged, but they can't deploy without also calling in the platform team. Or they can deploy it, but it's never on their roadmap, so nothing gets upgraded until it breaks.

That no is where your next long outage is coming from. The hardest ownership cases are inherited services. Something written by a team that no longer exists, or by one person who left. Nobody wants those, and I understand why. Taking ownership means taking the 3:00 AM pages for code that you didn't write and don't fully understand. So don't hand it over and walk away. If you're asking a team to own an inherited service, give them time to learn it.

Put that time on the roadmap. Let them fix the worst of the problems that occur in a service before they're on the hook overnight. And if a service isn't worth that level of investment, well, that tells you something as well. Maybe it belongs in Tier 4 instead of Tier 3 or two. Maybe the service should be retired. And that's where the two decisions start working together. The article made this point, but I'll make it again because it's the heart of the whole matter.

A tier without an owner is a promise nobody made. You can call checkout a Tier 1 service, and if no single team is accountable for that, nobody is going to defend it when a deadline shows up. An owner without a tier is a team defending everything at equal priority, which means really defending nothing in particular. They'll spend their effort on whatever broke most recently, not what is most critical.

Put those two decisions together and each one makes the other one work harder. The tier tells the team how much reliability you can buy, and ownership gives them the authority and the obligation to buy it. So here's what I'd do this week. Take your 10 busiest services. For each one, write down the tier and the owning team from memory, not from the service catalog. Then check the catalog.

Then ask the owning teams the three questions: paged, planned, permitted. For your Tier 1 services, walk their dependencies. Find the lower tier service your Tier 1 service just can't live without. You don't have to fix everything you find, but you'll know where your next 3:00 AM page is probably going to come from, and you'll know who's going to answer it. The original article is linked in the show notes.

So is the ownership gap diagnostic that I mentioned there. It's a spreadsheet, a simple spreadsheet that you can download that walks you through all of this for your own services. Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms. And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com.

And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
