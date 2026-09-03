---
title: Don’t stop your migration!
subtitle: ""
author: Lee Atchison
status: published
created: 2023-12-22
date: 2023-12-26
published_on: 2023-12-26

sai_url: https://softwarearchitectureinsights.com/posts/don-t-stop-your-migration
email_sent: 2023-12-26
linkedin_url:

hero_image: 

internal_note:
meta_description: Migrations get worse before they get better. Why giving up in the "Valley of Pain" costs more than pushing through to the benefits on the other side.
slug: don-t-stop-your-migration
description: >
  Application migrations rarely deliver benefits in a straight line — there's a painful low point where effort has gone up but nothing feels better yet. A real story of a company that quit at the bottom of that valley, and why sticking it out pays off.
categories:
  - "Cloud Strategy & Economics"

---

Are you planning an application migration? Perhaps you are moving your on-premise application to the cloud, or perhaps you are modernizing an older application to a more appropriate application architecture.

Migrations such as these are commitments. Commitments of time. Commitments of resources. Commitments of mindset and corporate energy. They can involve long and evolved transitions. They involve lots of effort—an effort that does not directly, immediately correspond to a realized benefit. Instead, the benefit often comes much later than the initial investment. Often, the situation can become worse before the benefits begin to kick in.

*It's tempting to want to give up and quit the migration early.*

I've seen it all too often. A company moving from a monolith to a service architecture stops the project not long after the migration has begun because the costs are higher than expected, and the benefits just haven't begun to materialize yet. The pain comes quickly, while the benefits don't come until much later.

Completing a migration such as this involves managing expectations and understanding the true return on investment.

## The Valley of Pain

When we look at starting a major migration, we have certain expectations about the benefits we will see from the migration. We expect the benefits to be a function of the effort and time we put into that migration. We calculate that the ROI (return on Investment) will make the migration effort worthwhile.

But this is a simplistic view of determining the value and benefit of the migration. A simple ROI calculation doesn't sufficiently capture our understanding of how our efforts turn into benefits. Typically, we imagine the benefits and investment will play out relatively uniformly over time, similar to that shown in Figure 1.

![Figure 1. Expected effort vs investment appears straightforward.](https://thecreatorcentral-us-east-1.s3.amazonaws.com/5l05q8o7aub9r8o7k3wqrkmpdpna)

As time goes on and we continue our investment in migration, we expect that the benefits we receive, either real or perceived, will continue to increase. The more effort and time we put in, the more benefit we receive.

But, in reality, this idealistic chart isn't representative for how the migration normally works out. The relationship between investment and benefit will often be a lot more complex and will look like that shown in Figure 2.

![Figure 2. Actual effort vs investment isn't as simple.](https://thecreatorcentral-us-east-1.s3.amazonaws.com/rpgyaxw2q0udq4ak9unfmopesjz4)

Here, the initial investment appears not to have much benefit. In fact, we may actually see regression in benefits as things get worse initially. Only as time goes on will the real benefits appear to take off.

To illustrate, let's consider a simple example. Imagine you are moving a monolith to a service-oriented architecture. Initially, as you start changing parts of the monolith over to services, you might actually witness a decrease in performance. The application complexity actually increases because your application contains many more moving parts. You continue to add more individual services to your application, yet still, the remains of the monolith are there and are heavily involved in the function of the application. This complexity may cause reliability problems, scaling problems, and other unforeseen problems. In short, your application may be worse off than it was before you began the migration. Things are a mess.

But as time passes, you work your way out of this low point, and the actual benefits of the migration effort begin to kick in. Your benefits multiply on each other. You will start seeing a return on your benefit as service creation becomes easier and takes over more functionality from the monolith. The growth of benefits over time will accelerate. Finally, you are seeing the real value of the migration.

But to see these benefits, you had to make it through the low points of the early days of the migration. You have to make it through what I call the *Valley of Pain*.

There is a strong tendency to want to give up on the migration in this valley. After all, you've invested in the migration and haven't seen any benefits. In fact, things have gotten worse than they were before.

But don't give up here. If you stick with the migration a little longer, you'll see the benefits come through. You'll make it to the point where the benefits are growing faster than the effort you put in.

![Figure 3. The pull to stop early is strong.](https://thecreatorcentral-us-east-1.s3.amazonaws.com/yiduq0fhw6yoru6k0qnee8954fjd)

## Falling for this trap

I've been through many a migration. Virtually all of them have this valley the migration goes through. Companies do fall into the trap of giving up at this low point and suffer the consequences.

One major company I worked with abandoned their monolith migration at the worst possible time—at the very bottom of the valley. In doing so, they stopped the project and quite literally "declared victory." But there was no victory for them.

They informed everyone working hard on the project that they all had "learned enough" from the painful migration effort: "We now know what's actually involved in implementing this migration, so we can stop here and maybe pick the migration back up again later on." They wanted to return to doing "real work" and stop investing in the migration. They concluded by telling everyone, "This exercise was a valuable experience, don't you think?"

True, it was valuable experience, ***but at what cost?***

What they actually had created was an untenable code base. They had built several services that were sort of *bolted* onto the side of the remaining monolith. Yet the monolith was still there and still just as difficult to work on. Their code was really a mess, and they suffered from the problems caused by this mess for years.

As a result of this decision, they severely reduced their ability to produce new features for some time to come. Morale among the engineering team hit an all-time low, and they lost many good engineers. They even created some severe availability issues that impacted customer satisfaction. This was not a pleasant environment to work in at the time.

The lesson from this story is this: ***The relationship between benefits and effort is not linear.*** There will be times during the migration when things seem to be getting worse rather than better. But don't give up; there will be a light at the end of the tunnel, and the benefits will begin to appear. The benefits will be more than worthwhile in the long term.

Before you start any migration, understand the costs and understand the benefits. But more importantly, understand when you have to pay the costs and when you will see the benefits. Don't stop when the costs start to build; wait for the benefits that will ultimately come.

*This article, written by me, first appeared in [InfoWorld](https://www.infoworld.com/article/3630388/dont-stop-your-migration.html).*
