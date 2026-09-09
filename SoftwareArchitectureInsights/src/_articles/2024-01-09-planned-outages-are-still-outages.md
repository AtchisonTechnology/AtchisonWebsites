---
title: Planned Outages are Still Outages
subtitle: ""
author: Lee Atchison
status: published
created: 2023-12-26
date: 2024-01-09
published_on: 2024-01-09

sai_url: https://softwarearchitectureinsights.com/posts/planned-outages-are-still-outages
email_sent: 2024-01-09
linkedin_url:

hero_image: 

internal_note:
meta_description: A weekly two-hour maintenance window caps your availability at 98.8% — no matter how reliable the app is otherwise. Planned downtime is still downtime.
slug: planned-outages-are-still-outages
description: >
  Customers don't care whether an outage was planned. Why routine maintenance windows quietly cap your real availability far below the 99.9%+ your team thinks it's hitting, and why the fix is zero-downtime deployment, not a bigger excuse.
categories:
  - "Availability & Resilience"

---

Don't be fooled into thinking your site is highly available when it isn't.

Planned and regular maintenance involving unavailable applications still counts against availability for those applications. After all, from your customer's viewpoint, your application is still unavailable. The fact that you planned that it would be unavailable is not important to your customers.

I often hear companies using routine maintenance windows as an excuse. Usually, the argument goes like this:

> "We have fantastic availability — our application never fails. That's because we regularly perform system maintenance. What we do is this: we schedule routine, weekly, two hour maintenance windows and bring down our application during that time. We keep our availability high by doing maintenance during these windows. As a result, our application rarely goes down at an unexpected time."

The problem is the customer who wants to use your application during the maintenance window is still unsatisfied. Your customer's application use is not governed by your arbitrary maintenance windows. Just because you've scheduled regular maintenance doesn't mean the customer is okay with your application being down at that time.

As a result, if you routinely bring your application down for a weekly, two-hour maintenance window, your availability is not 100%. Instead, you have two hours of downtime every week, even if everything goes well. Two hours of downtime a week means your availability is, at most, only 98.8%. Your application is down, by design, over 1% of the time.

98.8% availability is horrible for a modern digital application. A modern digital application should have at least 99%, or 99.9% availability…that's only two 9's or three 9's availability. Even these numbers are modest requirements. Depending on your customer needs and industry expectations, your planned availability may need to be 99.99% or higher. But 98.8%? By almost any measure, that is just plain horrible.

Yet, without having a single failure of your application, the best your organization can achieve by scheduling routine maintenance like this is 98.8% availability. Planned maintenance hurts nearly as much as unplanned outages. If your customer needs your application to be available and it isn't, your customer has a negative experience. It doesn't matter whether or not you planned for the outage.

You might be thinking: "But we have our maintenance window in the middle of the night when nobody is using our application." Again, depending on your application and the customer's usage patterns, this isn't a good solution either. Modern digital applications are more and more global entities, needing to be operational in multiple time zones with different peak usage periods. Additionally, most applications don't have a time when they aren't needed at all. Even low usage means there are dissatisfied customers during a planned outage. Now, some applications might be able to get away with being down during true zero-usage times, but this situation is becoming rarer and rarer. Modern applications, by definition, are almost universally expected to be operational 24x7.

Additionally, you may not always know how your planned downtime can be interpreted by your customers. Case in point: I once owned a smart thermostat in my home that was provided by a major heating and cooling provider. One day, I received an email from them giving me a planned maintenance availability schedule for a major upgrade they were performing. The message warned me that they were going to be updating their backend systems over the next several months. During that time, they would be routinely bringing down their backend application *at random (non-deterministic) times* during each day to perform changes. They wanted to warn me so that I could "adjust my expectations accordingly."

They, of course, apologized in advance for any inconvenience the scheduled downtime would cause. Of course, while this plan felt good to the company since they were keeping customers informed of what was going on, in fact, the plan they outlined was completely unacceptable from a customer standpoint. Consider this: what they were essentially telling me is that they would bring down their application, by design, at random times every day for several months. This is the definition of a planned poor customer experience.

That weekend, I replaced the thermostat with a different one from a different company. I will never deal with that original company again. Their "plan" cost them a customer and probably many more customers.

Poor availability — planned or unplanned — costs you business.

What's the alternative? It's actually quite clear: strive to perform zero-downtime upgrades and system maintenance. Build your application with high availability built in, and you never need to have planned downtime. While this may not be easy or even possible for some existing legacy applications, it is definitely doable for all new modern applications, and it is something you can strive for during all your application modernization upgrades.
