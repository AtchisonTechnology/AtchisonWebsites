---
title: "Less is More: The Principle of Least Privilege"
subtitle: ""
author: Lee Atchison
status: published
created: 2025-06-03
date: 2025-06-03
published_on: 2025-06-03

sai_url: https://softwarearchitectureinsights.com/posts/less-is-more-the-principle-of-least-privilege
email_sent: 2025-06-03
linkedin_url:

hero_image: 

internal_note:
meta_description: "The Principle of Least Privilege: grant each service only the permissions it needs, nothing more, to keep its blast radius as small as possible."
slug: less-is-more-the-principle-of-least-privilege
description: >
  A two-service message queue example shows why granting only the minimum necessary permissions — write-only for the sender, read-only for the receiver — keeps a compromised service's blast radius as small as possible.
categories:
  - "Security & Risk"

---

Another critical principle in maintaining a safe and secure application running in the cloud is understanding the Principle of Least Privilege. The Principle of Least Privilege is an industry-standard security principle widely known to reduce the impact of bad actor attacks.

The idea behind the principle of least privilege is to:

1. Grant an entity the minimum permission it absolutely needs to perform its operations.
2. Grant no more permissions than that.

This principle applies to cloud infrastructures and on-premises infrastructures alike. It is a critical best practice for building a safe and secure cloud infrastructure.

Let's take a look at an example. Figure 1 shows two services communicating via a message queue. *Service A* inserts messages into the queue, and those messages are read off the queue by *Service B*.

![Figure 1. Two services with two permissions.](https://file-assets.thecreatorcentral.site/7xbngn2s8pnqg8oci28klvz6r4uk)

We see that Service A has a set of permissions assigned to it to access the queue, and Service B has a set of permissions assigned to it to access the queue.

What should those permissions be for these two services?

For Service A, the permissions granted should be:

- Access to this single queue. No other queue should be accessible from this service.
- This service should be able to write messages into the queue, but it should not be able to read or remove messages from the queue.

For Service B, the permissions granted should be:

- Access to this single queue. No other queue should be accessible from this service.
- This service should be able to read and remove messages from the queue, but it should not be able to write messages into the queue.

No other permissions should be granted to either service.

Why don't we just grant both services full access to the queue? We don't because if the service has an error or failure, or if it gets compromised by a bad actor, we don't want it to be able to damage any more of our system than possible. Suppose we, for instance, give Service A the ability to delete messages from the queue, and Service A becomes compromised. In that case, Service A could remove messages from the queue destined to be sent to Service B. But since Service A doesn't need the ability to remove messages from the queue, if we don't give it those permissions, it can't remove messages from the queue, reducing the amount of damage it can execute.

The amount of damage a compromised service can potentially cause if it gets compromised is sometimes called its *blast radius*. For example, if we give Service A full access to the queue, we give the service a larger blast radius than if we only give Service A the ability to insert messages into the queue. Keeping our blast radius as low as possible should be a goal of every component in our application.

The principle of least privilege is designed to give your application—and each component within your application—the smallest blast radius possible while still able to perform the job it was designed to perform.
