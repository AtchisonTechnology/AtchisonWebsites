---
title: Managed File Transfer in the Modern Era
subtitle: ""
author: Lee Atchison
status: published
created: 2025-11-06
date: 2025-11-11
published_on: 2025-11-11

sai_url: https://softwarearchitectureinsights.com/posts/managed-file-transfer-in-the-modern-era
email_sent: 2025-11-11
linkedin_url:

hero_image: 

internal_note:
meta_description: A GoAnywhere CVE sat unpatched for weeks on customer servers while attackers exploited it. Why patch latency makes SaaS the safer architecture for MFT.
slug: managed-file-transfer-in-the-modern-era
description: >
  A critical GoAnywhere vulnerability took a week to patch and then months for on-premises customers to install it — while ransomware groups exploited it in the wild. Why patch latency is an architectural problem, and the eight SaaS security practices (illustrated by Files.com) that eliminate it.
categories:
  - "Security & Risk"

---

It's hard not to admire confidence in marketing.

Take [Fortra](https://www.fortra.com/), for example. Fortra is the new parent company of [GoAnywhere](https://www.goanywhere.com/), a Managed File Transfer (MFT) solution that's been around for years. The Fortra website proudly declares, "We break the attack chain."

Catchy, right? Except… "break" might have been a little too on the nose. Because that's exactly what happened recently: their security response came to a screeching halt.

On September 11th, a new critical vulnerability ([CVE-2025-10035](https://www.cve.org/cverecord?id=CVE-2025-10035)) was discovered in GoAnywhere's software. By September 18th, a full week later, the patch finally rolled out.

Sounds good right? Well…

The problem? This wasn't the end of the issue. Because GoAnywhere is an installed, on-premises application, every single customer had to manually apply that patch themselves. This process can routinely take days, or even weeks, to complete across distributed enterprise environments.

Unfortunately, attackers didn't wait politely for the rollout to finish. [Bad actors, including the Medusa ransomware group](https://www.hipaajournal.com/critical-goanywhere-vulnerability-medusa-ransomware/) began actively exploiting the vulnerability in the wild. They targeted organizations that hadn't patched yet, which, of course, was most of them.

## The Great Patch Predicament

Let's be fair: this isn't just a GoAnywhere problem. No vendor is immune to vulnerabilities. But this is a problem with an entire generation of enterprise software, the kind of software that relies on customers manually installing updates on servers that live behind firewalls, in data centers, or even on virtual machines sitting forgotten in a cloud account somewhere.

For decades, we accepted this as normal.

You know the drill. Software vendors release a patch. Then customers schedule downtime. The IT teams test and validate the update. An internal change management board approves the update. The patch gets rolled out in production, often weeks later. Meanwhile, support teams are inundated with customer issues related to the patch.

That worked fine when updates were infrequent, attack surfaces were smaller, and adversaries weren't weaponizing zero-day vulnerabilities within hours of discovery.

But in today's world? That process is like trying to patch a hole in a sinking ship by mailing everyone a toolkit and hoping they get around to it before the water reaches deck level.

## Managed File Transfer: Where the Stakes Are Even Higher

Managed File Transfer systems, like GoAnywhere, occupy a particularly sensitive corner of the enterprise ecosystem. They handle the most critical asset a company owns: the company's data and the company's customer's data.

MFT solutions sit right in the middle of everything. They connect systems, automate transfers, synchronize internal and external partners, and shuttle sensitive files across the globe. They are the vascular system of an organization's data flow.

When that system is compromised in a company, attackers don't just get one file, they get the keys to the company's data kingdom.

So, when a company's MFT platform is vulnerable and unpatched, it's not just inconvenient. It's downright catastrophic.

## The Architectural Problem: Patch Latency

From an architectural standpoint, installed enterprise software introduces inherent patch latency. **_Patch latency_** is the time gap between when a vulnerability is discovered and when a fix is actually applied everywhere it needs to be applied. Even if a vendor responds quickly, it can take time for customers to install the patch, because each customer's environment is essentially a snowflake:

- Different OS versions
- Different deployment topologies
- Different internal testing policies
- Different levels of operational urgency

That means a vendor's patch is just the beginning of a potentially very long process, not the end of it. Meanwhile, ransomware groups like Medusa are continuously scanning the internet for unpatched instances faster than you can say "zero-day."

*Security shouldn't depend on how fast your IT team can find a maintenance window.*

## SaaS: Patch Once, Protect All

Now let's flip the model. Let's look at a SaaS model.

When you move to a SaaS-based Managed File Transfer platform, everything changes. Why? Because of the inherent advantages of centralized management provided by a SaaS model, companies can respond to vulnerabilities and fix them in real time. That means they can remove the vulnerability within hours or potentially minutes, rather than days and potentially weeks.

But this doesn't come for free with SaaS. Your SaaS company must be security conscious and apply best practices to give you the security your application requires.

How should SaaS architectures function to help ensure architecture security?

There are many things they can, and should, do to maintain security. If you're building or operating a SaaS platform, security isn't something you "add" on later. It's something you continuously cultivate — part architecture, part discipline, and part culture.

Here are some of the key architectural best practices every SaaS provider should adopt to keep both their application and their customers safe and sound. If you are a SaaS provider, these recommendations are strong guidance. If you are a customer of a SaaS provider, you should look for these traits in all your enterprise SaaS providers:

### 1. Automate Everything, Especially Security

Manual processes are the enemy of both consistency and speed.

Security updates, dependency upgrades, and code scans should be automated within your CI/CD pipeline. Every new commit should trigger:

- Static code analysis for common vulnerabilities
- Dependency scanning for known CVEs
- Automated container and infrastructure image validation
- Deployment only after successful security gates

If you have to rely on a developer remembering to "run the security scanner," you've already lost the battle.

> *Patching isn't a fire drill. It's just part of Tuesday…*
> *And Wednesday…and every day. Automatically.*

### 2. Embrace Zero Trust — Inside and Out

Zero Trust isn't just a buzzword: it's a design mindset. Every user, API call, and service-to-service interaction should authenticate, authorize, and encrypt. No exceptions.

That means:

- Scoped tokens and short-lived credentials
- Mutual TLS between internal components
- Role-based and attribute-based access controls
- Continuous verification, not one-time authentication

The old idea of "inside the firewall = safe" is as outdated as floppy disks. You must always assume you are under attack, and that your attacker may be inside your firewall.

> *Assume breach. Verify everything.*

### 3. Isolate by Design

Isolation is security's best friend. A modern SaaS architecture should separate concerns at every layer:

- **Data isolation**. Each component should have isolated data (no shared database schemas).
- **Microservice isolation**. Each service should be given its own limited set of access and privileges. Only those services with the need to contact another service should be allowed to do so.
- **Environment isolation**. Each of your environments, production, staging, test, etc. must be separated and isolated.

I've written extensively about the [Principle of Least Privilege](https://softwarearchitectureinsights.com/articles/less-is-more-the-principle-of-least-privilege). This principle states that each component in the system (human, service, data) should have the absolute least amount of access that is needed in order for it to perform its job, ***and absolutely no more access than that***.

By using isolation techniques, such as these, a failure in one subsystem can't cascade into a full compromise. Think of it like a battleship with multiple hulls and watertight doors that prevent water moving from one area to another. If an attack compromises one section of the ship, it can be isolated and the ship as a whole can still be saved. The same applies to application security.

### 4. Secure the Supply Chain

Modern software depends on thousands of third-party components — open-source libraries, APIs, container images, cloud SDKs. Each one is a potential weak point.

Best practices include:

- Pin dependencies and use known-good versions.
- Continuously scan your dependency graph for new vulnerabilities.
- Sign and verify your builds. SBOMs (Software Bill of Materials) are essential in modern application architectures.
- Treat external services and libraries as untrusted by default.

Your security posture is only as strong as your weakest dependency.

### 5. Design for Observability and Response

Prevention is only half the story. You also need to detect and respond fast. That means having deep observability baked into your architecture:

- Structured, centralized logging with correlation IDs
- Real-time metrics and anomaly detection
- Alerting pipelines tied to automated playbooks
- Immutable audit trails for forensic analysis

The goal is not just to detect incidents, but to understand them — quickly, clearly, and without guesswork.

Remember: you can't defend what you can't see.

### 6. Practice Secure Configuration Management

Misconfiguration is one of the top causes of breaches in cloud-based systems. Just ask [AWS about their recent DNS-driven outage](https://arstechnica.com/gadgets/2025/10/a-single-point-of-failure-triggered-the-amazon-outage-affecting-millions/), or [Microsoft about their inadvertent configuration change](https://www.the-independent.com/tech/microsoft-azure-outage-xbox-outlook-b2854987.html).

These problems do occur, and when the configuration issue results in a security issue, the results can be catastrophic.

You can mitigate security related configuration errors by using best practices:

- Enforcing infrastructure as code (IaC) for all environments.
- Using least privilege for IAM roles and API keys.
- Enabling encryption by default (both at rest and in transit).
- Rotating keys and secrets automatically, not "when convenient".

No one ever means to expose a private S3 bucket publicly, but plenty of people have done exactly that. Automation, governance, and change management processes guard against "oops" moments.

### 7. Build a Culture of Security Ownership

Technology alone can't protect a company. But a culture of security within your company can do wonders to keep you secure.

The best SaaS providers foster an environment where every engineer feels responsible for security. Specifically, this means:

- Mandatory security training and refreshers
- Blameless postmortems for incidents
- Clear disclosure and escalation procedures
- Executive buy-in that prioritizes security over short-term velocity

Security is part of every sprint, every release, and every discussion. It's not a checklist, it's a mindset.

### 8. Communicate Transparently

Customers trust SaaS providers with their most critical data. They deserve transparency when issues arise. This includes:

- A clear, public security status page or incident portal
- Proactive disclosure of vulnerabilities and mitigation steps
- Rapid customer notification during incidents
- Clear privacy and compliance documentation

Trust is hard to earn and easy to lose. The companies that communicate early and honestly, even about bad news, are the ones that build lasting credibility.

## Behind the Curtain: [files.com](http://files.com/)

Let's take a look at a SaaS company that follows these best practices. Since we started with a MFT company that wasn't SaaS (GoAnywhere), let's use a SaaS MFT company as an example of how things should be done to keep your applications safe and secure.

At the core of [Files.com](https://files.com/)'s security posture is a modern, microservices-based architecture. Each component (authentication, file storage, access control, notifications, integrations) is an independent service, deployed and managed separately. They each maintain independent control, and independent authorization.

Zero trust is central to their microservice architecture. Each service must provide authorized access to every other service in the chain. There is no "assumed internal trust". Files.com uses the battleship approach we talked about above. Even if a service is compromised, the rest of the system is still safe and secure.

If an issue occurs in one microservice, it can be isolated, patched, and redeployed without impacting the rest of the system. By using a modern CI/CD pipeline and zero downtime deployments, they automate the deployments and use deployment best practices.

When a patch to a 3rd party component appears, it is automatically included in a build, tested and deployed, automatically. No human involvement, and no management involvement. It's just fixed as quickly as possible, all automatically.

## Security by Design, Not by Slogan

Security isn't something you sprinkle on at the end of development. Rather, security must be embedded into all aspects of your development cycle, your application architecture, and your company culture. Security is one of the few key core components that must be central to all modern applications and modern companies.

With this culture, and the processes I've discussed in this article, speed will be your friend. When (not if) a vulnerability appears in your software or a component embedded in your software, you will be able to respond rapidly, and automatically, to resolve the issue.

And when used with a SaaS model, this means that the attack exposure window when a vulnerability appears will change from days or weeks to hours or even minutes.

**Hours**…rather than weeks. **Minutes**…rather than days.

Even zero-day exploits become difficult for bad actors to take advantage of when the window for exploitation is so short.

The best SaaS security doesn't depend on luck, slogans, or slow patch cycles. It depends on architecture, automation, and accountability. These are the core principles that make a system inherently trustworthy.

In the end, the companies that win on security are the ones that treat security as architecture, not afterthought.

Or, to put it more bluntly:

If your security strategy depends on hoping your customers install patches fast enough, you're not running a SaaS. You're running a software museum.
