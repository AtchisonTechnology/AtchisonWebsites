---
title: Why you should use a microservice architecture
subtitle: ""
author: Lee Atchison
status: published
created: 2023-11-30
date: 2023-12-05
published_on: 2023-12-05

sai_url: https://softwarearchitectureinsights.com/posts/why-you-should-use-a-microservice-architecture
email_sent: 2023-12-05
linkedin_url:

hero_image: 

internal_note:
meta_description: Why monolithic apps turn into an unmanageable 'muck' as they grow, and how a microservice architecture with clear, single-team service ownership fixes it.
slug: why-you-should-use-a-microservice-architecture
description: >
  How a growing monolith turns into unmanageable "muck" — slow releases, tangled ownership, cascading bugs — and how splitting it into microservices with a STOSA-style single-owner model lets development teams and the business scale together.
categories:
  - "Scalability & System Design"

---

Your application is large. You have many customers, and they make good use of your many features and capabilities. You have a large catalog of products, and your store is big and feature-rich. You are doing well.

Except, you are having problems.

Your application crashes too often. Your developers are always on it when it fails, and they are very fast at fixing your site, but it takes time and energy. You are down at least once a month or so—and you can be down for hours at a time. Imagine the lost business.

Your developers would like to fix the problem—they'd like to do a lot of things. They keep talking about these great new features they'd like to implement, but they simply can't get it done. They're too focused on bug fixing and firefighting.

You've talked about hiring more people, but your budget doesn't support it. Besides, you are hiring constantly to replace the people who are leaving. Judy left for a bigger tech company. Joe left because he got burned out handling too many late-night emergencies.

The tech problems are weighing on you, and they are weighing on your team. You don't see any way out of it. You and your company are trapped.

You have fallen into the trap that many software companies—and many IT departments of non-software companies—have fallen into. They've created large, monolithic applications that seem to handle everything. But these applications have become so large and so complicated that they are unwieldy. No one person can understand everything that's going on in the application.

Things break, and they take forever to fix. You try to add new or improved capabilities, but the changes are so intertwined that you can't get them done quickly—and when they are complete, they are full of bugs. Your development pace is slow and getting slower. You try to add more developers, and they don't seem to make things go any faster. And the learning curve for the new developers is insanely steep.

You are stuck in the muck.

The muck is not inevitable. You can re-architect your application to scale *with* your company, not against it.

## The growing application

You started out OK with a simple application, written and managed by a single person or a small development team or two. Your application looks like Figure 1, nice and simple.

![Figure 1. A simple but growing application.](https://thecreatorcentral-us-east-1.s3.amazonaws.com/ocg4ilo9vg0wwrp1gg0cl9ui2p5a)

But time goes on, the application grows. Your application is a success, and traffic increases dramatically. You add new features and capabilities, and you hire more developers to work on the application. Soon, it looks like Figure 2.

![Figure 2. A complex, stagnant application.](https://thecreatorcentral-us-east-1.s3.amazonaws.com/oqi1wnre2bzjviwerkxcjidofrwt)

Now, you've got problems. Nobody knows which parts of the application they own. Team 1 makes a change and it impacts Team 3. Tensions are high, productivity is low. Bugs creep into the application, and your site begins to fail, seemingly randomly. And when there's a failure, your teams struggle to figure out what's wrong, because no single person can understand everything that's going on in the application. This is a prime example of muck.

Your independent development teams aren't truly independent, because the changes that one team makes has a big impact on what the other teams are working on. You can't work on independent projects, because all projects are intertwined. Innovation is stifled, and so is your business.

## The value of microservices

Now take a look at Figure 3.

![Figure 3. A microservice application.](https://thecreatorcentral-us-east-1.s3.amazonaws.com/rxg8iuwu7lm5zrz2ebj20zonktyi)

Here, each service is independent and isolated from every other service. Each service is smaller, but there are more of them. Each has a well-defined interface between them, and each represents a piece of well-defined business logic.

More importantly, each service has a single owner. One development team is responsible for all aspects of each individual service.

The application is cleaner, making the ownership and responsibilities clearer.

In short, your application has scaled. Not scaled in the sense of the number of customers it can support, but scaled in the sense of the number of independent developers, projects, and initiatives it maintains to support your growing business.

Your development teams aren't stepping on each other's toes, and they are more productive because there is less muck involved. They are happier, and they are more likely to stay with the company longer.

Further, you can grow the number of development teams, hence the number of developers, by simply rebalancing ownership responsibilities. More developers become more productive, and you can make better progress on those all-important business projects that are critical to your growing business.

And if a problem occurs, by analyzing the interaction between services you can much more easily determine where the problem originates, and which team should fix it. Additionally, each team has a much smaller set of responsibilities, hence greater knowledge about how the services they are responsible for function, so they can fix problems much faster and much more effectively. And because they have a better understanding of the areas they are responsible for, they are less likely to introduce errors into the system.

## Microservices help you scale

Microservice architectures help you scale in many dimensions:

- *Traffic and customers.* Microservices enable you to support more customers with more traffic and more data.
- *Number of developers and development teams.* Microservices enable you to add more development teams, hence more developers to your application. Developers are more productive, because they aren't stepping on one another's toes as much as they are in a monolithic development process.
- *Complexity and capabilities*. Teams have less application "surface area" to think about, allowing them to work on more complex problems within their domain. With more teams working on more problem domains, more complex projects are possible.

## Single Team Oriented Service Architecture (STOSA)

Simply moving your application to a microservice-based architecture is not sufficient. It is still possible to have a microservice-based architecture, but have your development teams work on projects that span services and create complex interactions between your teams. Bottom line: You can still be in the development muck, even if you move to a microservice-based architecture.

To avoid these problems, you must have a clean service ownership and responsibility model. Each and every service needs a single, clear, well-defined owner who is wholly responsible for the service, and work needs to be managed and delegated at a service level. I suggest a model such as the [Single Team Oriented Service Architecture](https://stosa.org/) ([STOSA](https://stosa.org/)). This model, which I talk about in my book [*Architecting for Scale*](https://architectingforscale.com/), provides the clarity that allows your application—and your development teams—to scale to match your business needs.

## The cost of microservices

Microservice architectures do come at a cost. While individual services are easier to understand and manage, a microservices application as a whole has significantly more moving parts and becomes a more complex beast of its own. This can lead to application complexity and the problems complexity brings to other aspects of your application, and these issues should not be ignored.

Additionally, many companies stuck in the muck (as shown in Figure 2) will begin a project to migrate to a microservice architecture (as shown in Figure 3). However, they will often find the transition more difficult and more expensive than they hoped or anticipated. And so, partway through the migration, they abandon the effort. [They are partially migrated and often in worse shape than when they started.](https://www.infoworld.com/article/3630388/dont-stop-your-migration.html)

Before you undertake a migration to a microservice architecture, make sure that you understand the costs, the benefits, and the challenges ahead. You must have proper expectations set in order to make the transition—and your future-state application—a success.

*A version of this article, written by me, first appeared in 2021 on [InfoWorld](https://www.infoworld.com/article/3637016/why-you-should-use-a-microservice-architecture.html).*
