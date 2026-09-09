---
title: Why increasing complexity actually can decrease complexity
subtitle: ""
author: Lee Atchison
status: published
created: 2024-01-25
date: 2024-01-30
published_on: 2024-01-30

sai_url: https://softwarearchitectureinsights.com/posts/why-increasing-complexity-actually-can-decrease-complexity
email_sent: 2024-01-30
linkedin_url:

hero_image: 

internal_note:
meta_description: A system made of hundreds of microservices looks more complex than a monolith. For the developers working in it, the opposite is often true. Here's why.
slug: why-increasing-complexity-actually-can-decrease-complexity
description: >
  Splitting a monolith into microservices makes the system as a whole look more complex — but it shrinks the complexity any one developer has to hold in their head, if you get service sizing and team ownership right.
categories:
  - "Scalability & System Design"

---

In the dynamic world of software development, complexity is often viewed as the arch-nemesis of productivity and efficiency. Yet, here lies the paradox: embracing complexity can actually pave the way to simplicity.

How can this be the case?

Let's focus a bit on complexity in software development. We can often think of complexity as a big, tangled ball of yarn. The more you pull on one thread, the messier it gets.

Now imagine breaking up that big ball of yarn into smaller, neat little bundles. Each one is its own thing, easier to handle, and way less intimidating.

That's what microservices do to software development. They take a giant, confusing codebase and chop it up into bite-sized pieces.

So, while an entire application made up of hundreds of microservices may seem at first glance to be more complex than a simple monolith, the reality is a lot more…well, complex.

While the entire application appears more complex, in reality, the individual services are easier to understand—and hence easier to work on—by a software development team.

## Microservice architecture complexity

Many companies have built large monolithic applications only to find that they get weighed down in complexity. Too many developers working in a single code base makes it difficult to work independently to add new features and fix existing defects. This limits the number of simultaneous projects that developers can work on in a single application. Additionally, individual projects make changes that may have a broad impact on the code base. Understanding the impact of this broader impact is more difficult when the application becomes larger and more complex. Together, these issues lead to more defects, lower quality, and increased technical debt as the complexity continues to rise.

When you split an application into separate modules of some type, you are attempting to modularize that complexity in order to reduce the number of developers that need to work in a single code base. Additionally, you reduce the breadth of the impact your changes do make. This tends to create more stable code, more supportable code, less technical debt, and higher overall application quality and developer productivity.

Improving application quality and stability and improving developer productivity also leads to an improved overall developer experience, which reduces fatigue, burnout, and, ultimately, turnover.

There are many ways to modularize an application, some of these ways are more effective at accomplishing these goals than other ways. In my opinion, the best model for application modularization is to use a microservice-based application architecture.

Combining a microservice-based application architecture with a solid model for organizing your development teams and their ownership and responsibility, you end up with an organization where individual developers can focus more and maintain responsibility for less complexity overall. These developers end up being more productive and more efficient and create higher-quality code with less technical debt. These developers have higher job satisfaction and burn out less often.

The application as a whole may be more complex, but the individual piece that individual developers have to focus on is substantially less complex.

The microservice model improves the developer's experience.

## Not all microservices are created the same

However, simply moving to a service or microservice-based architecture doesn't give you this advantage automatically. Rather, you have to both architect your application rationally and organize your teams appropriately. There are two things you need to watch out for, in particular: service sizing and team organization.

### Service Sizing

The size of your services has a big impact on the complexity exposed to your developers. If you size your services too small, your application ends up with a very large number of interconnected services. This interservice connectivity increases visible complexity significantly. Your application as a whole becomes more complex. Your developers see this complexity and have to deal with this complexity, defeating the purpose of moving to services in the first place.

If you size your services too large, then you lose the advantages that microservice architectures offer. Your services are simply mini-monoliths, and they have all the complexity disadvantages of larger monoliths. Once again, individual developers have to deal with increased complexity, and you've simply moved to multiple complex applications rather than a single complex application. These mini-monoliths may assist your developer's complexity load in the short term but not in the long term.

Only when you size your services appropriately do you achieve the correct balance that effectively decreases your individual developer's complexity and cognitive load.

### Team Organization

Team size, structure, ownership responsibilities, and lines of influence are just as critical in building your application as the code itself. In order to handle a service architecture efficiently, you must organize your development teams around your application architect appropriately. Additionally, your teams must be given the responsibility, authority, ownership, and support needed to provide complete management of their owned services.

Failure to provide this organization and related support structures will add a different type of complexity that is just as destructive to your organization. Team organization, along with appropriate team assignments and setting responsibilities and ownership, is critical in reducing the cognitive load of the application to the individual developers.

I recommend the [**STOSA**](https://stosa.org/) organizational model. This model describes a way your organization can create and assign team-level responsibilities in a service-based application architecture. I talk about the STOSA model extensively in my O'Reilly Media book, [**Architecting for Scale**](https://leeatchison.com/books/).

*This article is partially based on an article I wrote that first appeared in [InfoWorld](https://www.infoworld.com/article/3642835/a-cure-for-complexity-in-software-development.html).*
