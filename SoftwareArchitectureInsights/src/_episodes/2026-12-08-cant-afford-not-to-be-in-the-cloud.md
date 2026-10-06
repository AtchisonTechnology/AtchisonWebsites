---
title: "You Can't Afford Not to Be in the Cloud"
slug: cant-afford-not-to-be-in-the-cloud
date: 2026-12-08
episode_number: 19
category: Then vs. Now
tags: []
description: "Almost three years after arguing the cloud costs less than it looks, Lee checks what held up and what he understated."
captivate_episode_id: ""
source_articles: [you-can-t-afford-not-to-be-in-the-cloud]
duration: "9:55"
---

In early 2024, executives kept telling Lee the cloud was too expensive. He wrote that they were comparing the wrong numbers.

Since then, some well-known companies have left the cloud and say they're saving millions. So this episode is a check on his own argument.

**In this episode:**

- The two 2024 arguments: elastic capacity, and capital expense versus cost of goods sold
- What held up, and for which workloads
- What he understated: "done properly" and the lift-and-shift bill
- Steady workloads, and why the math came out the other way for 37signals
- Cloud spend and gross margin, then and now
- Three questions to ask before you call the cloud too expensive

**Links:**

- [You Can't Afford Not to Be in the Cloud (2024)](https://softwarearchitectureinsights.com/posts/you-can-t-afford-not-to-be-in-the-cloud/)
- [DHH: Our cloud-exit savings will now top ten million over five years](https://world.hey.com/dhh/our-cloud-exit-savings-will-now-top-ten-million-over-five-years-c7d9b5bd)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. Early in 2024, I kept hearing the same thing from executives, "The cloud is too expensive." They put a cloud price for a server next to what the same server cost in their data center. The cloud number was higher, case closed.

So I wrote an article called You Can't Afford to Not Be in the Cloud. It said that comparison was missing most of the picture. That was almost three years ago. Since then, some well-known companies have publicly moved out of the cloud and said they're saving millions. So it's time to look back. What did I get right? What did I get wrong? And what would I tell that executive today?

This is Then vs. Now. If you'd like to read the original article, it's linked in the show notes. But here is what I argued. Comparing the price of a cloud server to the price of your own server is the wrong comparison. The cloud has two advantages that comparison doesn't show. The first was dynamic resource allocation.

In your own data center, you buy from your busiest day. Then that capacity sits there all year, mostly idle. In the cloud, you can add servers when traffic climbs and give them back when it falls. You pay for what you use. The second was about how the money gets counted. Building a data center is a capital expense. You spend a lot of money up front based on a guess about the future.

Cloud spending is an operating cost that tracks your actual business. It shows up as cost of goods sold, and it grows as revenue grows. The second point matters to a CFO. Money for capital projects is typically hard to get. Money that scales with revenue is much easier. And my conclusion was this, done properly, the cloud is rarely more expensive than running your own Let's start with what held up in that argument.

The money argument held up completely. Companies still don't want to write a giant check for hardware based on a three-year forecast. That hasn't changed, and I don't expect it to. The elastic argument also held up for the right kind of workload. If your traffic swings a lot, the cloud is still the best deal around.

Retail around the holidays, tax software in April, a media site when a story breaks. You'd be crazy to buy hardware for your peak and let it sit for 11 months. So the core idea was right. Price per server is the wrong way to compare. Now for what I got wrong, or at least what I understated. Look at the phrase I used, done properly. I put a lot of weight on those two words, more than they could really carry in the article.

Dynamic resource allocation only saves money if you actually give the resources back, and most companies don't. They size their servers for peak just like they did in their own data center, and then they leave them running. They move the old application to the cloud without changing its design. We call that lift and shift, and a lift and shifted application gets none of the benefits. It just gets a monthly bill instead of a capital project.

So the savings I described were real, but they only showed up for teams that designed for them. For the lift and shifters, for everyone else, the cloud was exactly as expensive as that executive feared, and sometimes more so. I should have said that part louder. The second thing I underplayed is the steady workload.

My whole argument leaned on demand that goes up and down, but some systems don't do that. They run at roughly the same load all day, every day for years. For that kind of system, elasticity buys you almost nothing. There's no valley to scale down to. This is exactly the case the companies leaving the cloud have made. The best known example is 37signals, the company behind Basecamp.

They moved their applications off AWS and onto their own hardware. They've said publicly they expect to save around ten million dollars over five years, and for their workload, I believe them. They have predictable load, a strong operations team, and the discipline to run their own hardware well. Notice what that is though. A company with a steady workload did the math carefully. That's the same comparison I asked for in 2024. For them, it just came out the other way There is one more thing that I would add to the article today.

I said moving spend into cost of goods sold was a good thing, and that's still a true statement. But cost of goods sold comes straight out of your gross margin. In 2024, a lot of companies weren't watching that closely. Today they are. When investors look at gross margin, a cloud bill that grew faster than revenue is a problem that you have to explain.

So the same line in the income statement that made the cloud easy to fund now puts the cloud bill in front of everyone. That's healthy. It also means the cloud bill is now an architectural conversation as much as a financial one. So what would I tell that executive today? I'd say the price per server comparison is wrong. That part hasn't moved.

But I changed the conclusion. In 2024, I said you can't afford to not be in the cloud. Today, I'd say you can't afford to be in the cloud without designing for it The cloud rewards systems that scale down as well as up. It rewards teams that know what each service costs to run and who is responsible for that number. And it punishes the application that was moved as is and left running at its peak size.

So before you ask whether the cloud is too expensive or not, ask three questions about the system in front of you. Does its load actually change? If it swings, the cloud is almost certainly your best option. If it's steady, have you done the full comparison? Hardware, yes, but also the people that run it, the data center, the refresh cycle, and what your engineers aren't building while they're doing that work instead.

And if you're already in the cloud, does your system give capacity back when it doesn't need it? If you're not, you're paying cloud prices for a data center design So then versus now. The argument I made was right. The math was right. What I underestimated was how many teams would move to the cloud without changing how they build.

The cloud was never cheap by default. It's cheap when your architecture takes advantage of it. That was true in 2024. It's even more true now. The original 2024 article is linked in the show notes. Read it and see whether your own system is the one it describes or the one it missed Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
