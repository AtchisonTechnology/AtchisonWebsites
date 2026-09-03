---
title: You can’t afford not to be in the cloud
subtitle: ""
author: Lee Atchison
status: published
created: 2024-02-15
date: 2024-02-20
published_on: 2024-02-20

sai_url: https://softwarearchitectureinsights.com/posts/you-can-t-afford-not-to-be-in-the-cloud
email_sent: 2024-02-20
linkedin_url:

hero_image: 

internal_note:
meta_description: "Comparing cloud server cost to on-prem server cost misses the real savings: dynamic resource allocation and swapping capital expense for cost of goods sold."
slug: you-can-t-afford-not-to-be-in-the-cloud
description: >
  A CEO who compares cloud server pricing directly to on-prem server pricing is only looking at half the ledger. The real financial case for the cloud is dynamic resource allocation and a shift from capital expense to cost of goods sold.
categories:
  - "Cloud Strategy & Economics"

---

Consider the following story:

> "I went into my CEO's office. Our CEO is a very driven, technical, hands-on CEO. All technical decisions have to go through him before the company goes forward with a plan. Today, the discussion was the cloud. The problem? The CEO said we couldn't move our application to the cloud because it was too expensive. His evidence? 'If you compare the cost per hour of a cloud-based server instance, to the monthly costs we pay for our servers, the cloud-based servers are just too expensive.' Our CEO just doesn't get the cloud."

Yes, this is a disturbingly common story. This story defines many companies' mindset behind cloud migration. If you take an application and move it as is to the cloud (*"lift-n-shift"* in cloud terminology), then naturally, it will take as many server resources to run it in the cloud as it takes to run it in an on-premise data center. Using this analysis, the CEO was right…at least at the highest levels.

## The real cloud finance story

However, this story does not consider the chief advantages of the cloud from a financial perspective: the cloud enables the use of *dynamic resource allocation*.

When you use the cloud, the real benefit of the cloud is you can dynamically adjust the amount of resources you need constantly, reducing your resource utilization in down times. You don't need to have unused resources simply lying around. Additionally, given that you can increase the number of resources as easily as you can decrease the number of resources, you don't need to have excess resources available to handle unexpected or planned usage spikes. You simply add the required resources when you need them. This dynamic resource variability means an application—even one not optimized for the cloud—typically requires fewer resources when running in the cloud than it requires on-premise. Now, this isn't always the case. The more you optimize the application for the cloud (such as moving to a cloud-native, dynamic, microservice-based architecture), the greater the resource savings in the cloud and the lower the cost.

So, while it's true that at the highest level, a cloud-based server typically costs more than an equivalent on-premise server. By the time you consider the fully loaded costs and understand that you are allocating cloud resources by the minute, not leasing by the month or year, the savings in cloud utilization can be dramatic.

This isn't a new phenomenon. It's one of the core advantages that has driven the success of the cloud over the years.

Yet, there is a second, largely forgotten, financial advantage to using the cloud.

## The color of money

When you build out an on-premise data center, you typically build it by purchasing (or leasing) the equipment and real estate necessary to build the data center. It's a large, mostly upfront expenditure. You build the data center to meet not your current demands, but your expected future demands. In short, you need to *invest capital* in building your infrastructure. A *capital expenditure* is one of the most expensive uses of money a company can make because you are investing in a prediction of future needs rather than an immediate current need.

But when you put your application in the cloud, you *rent* only the resources you need *at that moment*, rather than for future needs. In theory, your application needs resources that are roughly in proportion to the number and size of your active customer base, which is (at least loosely) tied to your revenue. This means you rarely need to use a capital expenditure to fund your application infrastructure; rather, you can use *COGS*—*Cost of Goods Sold*. This is money that is typically easier and less expensive to come by. For most companies, it's substantially easier to raise money to cover COGS expenses than it is to raise money to cover a capital expense. This is because, typically, COGS expenses are tied directly to revenue, while capital expenses are more of a speculative investment.

So, not only do you need *less* money for *fewer* resources, but the money you spend is *easier and less expensive* for your company to use. Hence, the true cost savings of the cloud.

Of course, whether this is an advantage for you and your company depends on the financial situation of your company, and the financial laws of your particular country. You should discuss this with your CFO for details relevant to your company and circumstances.

## Yes, the cloud *is* less expensive

In my years of experience, I've found it rare that the cloud *actually* was more expensive than an on-premise solution. Most of the time, there are real savings when properly using a public cloud for your application infrastructure.

Yes, there can be extra costs if the cloud resources are not managed properly. Many companies find excess cloud costs caused by unused capacity created by development organizations because creating a new resource is more convenient than using existing resources properly. So, managing your cloud expenditures is a critical aspect of a proper cloud strategy.

But, when an actual comparison is made, and the benefits of the cloud are properly calculated, rarely is the cloud more expensive than on-premise.
