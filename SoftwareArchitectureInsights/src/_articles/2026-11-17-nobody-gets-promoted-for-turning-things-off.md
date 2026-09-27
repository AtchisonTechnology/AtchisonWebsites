---
title: "Nobody Gets Promoted for Turning Things Off"
subtitle: "Every architecture collects systems nobody owns, nobody uses, and nobody dares delete. Retiring them is design work."
author: "Lee Atchison"
status: published
created: 2026-09-25
date: 2026-11-17
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: nobody-gets-promoted-for-turning-things-off.png

internal_note:
meta_description: "Every architecture piles up systems nobody owns or uses. Why they never get retired, what they cost, and a safe way to start turning them off."
subject: "Nobody Gets Promoted for Turning Things Off"
preview_text: "Leaving it running is the rational choice for every engineer. That's the problem."
ad_slots: "One ad slot directly above ## The Cost Compounds. Software Conductor house-ad snippet directly above the author bio."
slug: nobody-gets-promoted-for-turning-things-off
description: >
  Organizations reward launching and never reward retiring, so old systems
  pile up with no owner and no users. They cost complexity, security surface
  and cloud spend, and the cost compounds. How to retire a system safely, and
  how to change the incentives that keep them alive.
categories:
  - "Scalability & System Design"
  - "Cloud Strategy & Economics"

---

# Nobody Gets Promoted for Turning Things Off

*Every architecture collects systems nobody owns, nobody uses, and nobody dares delete. Retiring them is design work.*

---

Ask an engineering team what they turned off last quarter. Most can't name a single thing, even though every team has a few services like this one.

A security scan flags an old library in a service called billing-export-v2. Nobody on the team recognizes the name.

It runs on three instances and has its own database. The last commit is four years old, from an engineer who left two reorganizations ago.

Does anything still call it? Nobody knows. So the team patches the library, closes the ticket, and leaves it running.

Next year, someone will patch it again.

## Why Nothing Gets Turned Off

Every organization I've worked with rewards shipping.

Turning something off gets nothing. When it goes well, nothing happens, and nobody writes a launch post about an absence.

The risk is lopsided too. If you shut down an old service and something breaks, the outage has your name on it. If you leave it running, nothing bad happens to you at all.

The cost lands on the whole organization instead, a little at a time, for as long as the thing exists. For any one engineer, leaving it running is the rational choice.

So nobody turns anything off.

## The Cost Compounds

A service nobody uses looks free. It isn't.

Complexity is the cost architects feel first. I've argued before that [splitting a system into more services can make it easier to work on](https://softwarearchitectureinsights.com/posts/why-increasing-complexity-actually-can-decrease-complexity?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=body), as long as each piece is small and has an owner.

An abandoned service breaks that bargain. It makes the system bigger without giving anyone a smaller piece to reason about. Every engineer planning a change has to wonder whether it touches the thing nobody understands.

Security is the cost that hurts most. Each forgotten service is an endpoint, a set of credentials, and a pile of dependencies that someone is supposed to be patching. Unowned code is unpatched code, and attackers don't care whether you still use it.

Then there's the bill. Idle instances, storage nobody reads, a database replica for a report nobody opens. Each one is a rounding error. Together they're a line on the cloud bill that nobody can explain.

Teams often find out how big that line is during a cloud migration. [Moving a complex application forces you to account for every piece of it](https://softwarearchitectureinsights.com/posts/managing-complexity-in-a-cloud-migration?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=body), including the pieces nobody remembers.

None of these costs stay flat. Every dead system makes the next change slower and the next audit longer.

## Retiring a System Is Design Work

Most teams treat decommissioning as cleanup. It's something you do on a slow Friday, if you ever get one.

That's why it never happens. Turning a system off can break things in the same ways building one can, and it deserves the same care.

Start by naming one owner for the retirement. The service may have no owner, but the job of removing it needs one, or it will sit in a backlog forever. Then work through four steps.

1. Prove it's unused. Look at traffic, logs, and scheduled jobs across a full business cycle. A quarterly report only runs once a quarter.
2. Announce a date. Tell everyone who might care, in writing, with enough notice that a surprised team has time to speak up.
3. Turn it off, but keep it. Stop the service and leave the code, the data, and the deploy path intact. If someone complains, you can bring it back in minutes.
4. Delete it. After a quiet period, remove the infrastructure, the credentials, the DNS entries, and whatever data you're allowed to delete.

Step three is the one teams skip, and it's the one that makes the rest safe. What keeps old systems alive is the fear of a mistake you can't undo. A reversible shutdown takes that fear away.

Step four is the one teams never reach. A stopped service with live credentials is still attack surface, and it's still on the bill.

## Design the Ending at the Start

The cheapest time to plan a retirement is before launch.

When someone proposes a new service, ask two more questions. Who owns this in three years? And what would have to be true for us to turn it off?

That second question sounds pessimistic, but it saves a lot of pain. An experiment should say it's an experiment, with a date to decide its future. A service that replaces an older one should name the one it replaces, and the project isn't done until the old one is gone.

Two services doing one job is how most orphans start. The migration reaches ninety percent, the team moves on to the next launch, and the last few consumers keep the old system alive for years.

## Change What Gets Noticed

This is an incentive problem, so the fix is changing what gets rewarded.

Count retirements the way you count launches, and report them in the same update. Put decommissioning work on the roadmap with a name next to it, so it competes for time in the open.

And when an engineer removes a service nobody needed, say so in front of their manager. Make sure it shows up in their review.

Someone should get promoted for turning things off.

## What to Do on Monday

Pull a list of every service and cloud resource that hasn't been deployed or changed in the last year. Your cloud provider's inventory and your CI history will get you most of the way there.

For each one, write down who owns it, what calls it, and what would happen if it stopped.

Some of them will get "I don't know" for all three. Pick one of those. Name an owner for its retirement, and start step one this week.

One retirement shows your organization that turning something off is safe, normal work.

Then do it again next month.

---

*Lee Atchison is a software architect, author, and technology thought leader. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=nobody-gets-promoted-for-turning-things-off&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
