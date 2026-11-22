---
title: "The Decision Record Nobody Reads"
subtitle: "Writing decisions down is the easy part. Finding them again is where teams fail."
author: "Lee Atchison"
status: published
created: 2026-11-20
date: 2026-12-08
published_on:

sai_url:
email_sent:
linkedin_url:

hero_image: decision-records-nobody-reads.png

meta_description: "Most teams write architecture decisions down, then can't find them. Tie records to services, mark what replaced what, and link them to risks and tiers."
slug: decision-records-nobody-reads
description: >
  Most teams keep some kind of architecture decision record. Few can find the
  right one when it matters. Records fail because of where they live and how
  they're organized. Tie each record to the
  services it touches, mark what replaced what, and link decisions to the
  risks they accept and the tiers they serve.
categories:
  - "The Architect's Role"

---

# The Decision Record Nobody Reads

*Writing decisions down is the easy part. Finding them again is where teams fail.*

---

A new engineer joins the payments team. In their second week, they propose moving the ledger to a document database. It's a reasonable idea, and they've thought it through.

In the meeting, someone senior sighs. "We looked at that two years ago. There were reasons."

Nobody remembers the reasons. One person thinks the notes are in Confluence. Another remembers a Slack thread that's long gone. The team spends forty minutes rebuilding an argument it already had.

The painful part is that the team did write the decision down.

## Written Down Isn't the Same as Kept

Most teams I talk with have some kind of decision record. A folder of architecture decision records in a repo. A wiki page called "Decisions." A template somebody introduced after a bad quarter.

The records exist. They just don't get used.

Try a simple test. Ask someone to find the decision behind the part of the system they're about to change, and time it. If finding the record takes longer than asking a colleague, the records have failed, no matter how well each one is written.

A decision record has one job. It answers "why is it like this?" for the person who wasn't in the room, and that person is usually someone you haven't hired yet.

## Why Good Records Go Unread

A record in a repo the team rarely opens, or on a wiki nobody searches, is a record nobody reads. People look for answers where they already work.

Numbering doesn't help either. A list that runs from ADR-001 to ADR-147 tells you the order things were decided. It doesn't tell you which ones touch the service you're changing today.

Old decisions also never get closed out. A decision gets replaced, and the old record stays, still marked "accepted." Now the reader finds two answers and has to guess which one is current.

Then there's everything the record doesn't connect to. Take the choice to run the ledger in one region. It's tied to that service's tier, and to a risk somebody chose to accept. When the decision, the tier and the risk live in three different places, nobody sees the whole picture.

## Make Records Easy to Find

Earlier this month I said your architects need [one shared decision log](https://softwarearchitectureinsights.com/posts/scaling-architectural-decisions?utm_source=sai-email&utm_medium=email&utm_campaign=decision-records-nobody-reads&utm_content=body). Starting one is easy. Organizing it so people can find what's in it is harder.

Tie every record to the services it touches. When someone opens the payments service, its decisions should be right there, and a search for the service name should turn them up first.

Mark what replaced what. When a decision changes, the old record says so and points to the new one, so there is always one current answer.

Link each decision to the risks it accepts. A record that says "single region, regional outage risk accepted" belongs next to that row in your risk matrix. When the risk changes, you know which decision to revisit.

Show the service tier on the record. A decision on a Tier 1 service carries more weight than one on a Tier 4 internal tool, and readers should see that at a glance.

None of this needs a special tool. One shared repo with a markdown file per service, linked from each service's README, gets you most of the way.

## When This Is Overkill

A team of five engineers who sit together and built the whole system doesn't need much of this. Ask the person next to you. Write down the few decisions that would surprise a new hire, and stop there.

The structure starts to matter once the team grows past the point where everyone was there for every decision. That tends to happen around the second or third team on the same system, which is also about when the original architects start moving on.

## Start With One Service

Pick the service that confuses new people the most. Find every decision that shaped it. Put them in one place, tied to that service, with the replaced ones marked.

Then hand it to your next new hire and see whether they can answer "why is it like this?" without asking anyone.

If they can, do the next service.

---

*One more thing. A markdown file per service gets you most of the way. For teams that want more, I'm building Cascadras. It will keep a team's decision records, risk matrices and service tiers in one place, linked to each other. If it sounds useful, [take a look and reserve a founding seat](https://softwarearchitectureinsights.com/free/cascadras/?utm_source=sai-web&utm_medium=referral&utm_campaign=cascadras&utm_content=decision-records-nobody-reads). I'd also like to hear how your team keeps its decisions today. The signup form asks.*

---

*Lee Atchison is a software architect and author who helps companies architect and operate AI-powered SaaS at scale. He is the author of [The Software Conductor](https://thesoftwareconductor.com/?utm_source=sai-email&utm_medium=email&utm_campaign=decision-records-nobody-reads&utm_content=bio) and the O'Reilly book [Architecting for Scale](https://architectingforscale.com/?utm_source=sai-email&utm_medium=email&utm_campaign=decision-records-nobody-reads&utm_content=bio), and was the founder and CTO of Product Genius, an AI startup. He teaches [software architecture and cloud courses](https://leeatchison.com/courses?utm_source=sai-email&utm_medium=email&utm_campaign=decision-records-nobody-reads&utm_content=bio) through Coursera, LinkedIn Learning, and O'Reilly. He writes about software architecture, cloud systems, and AI at [Software Architecture Insights](https://softwarearchitectureinsights.com/?utm_source=sai-email&utm_medium=email&utm_campaign=decision-records-nobody-reads&utm_content=bio), and [works with organizations](https://leeatchison.com/contact?utm_source=sai-email&utm_medium=email&utm_campaign=decision-records-nobody-reads&utm_content=bio) on cloud modernization, AI enablement, and architecture strategy.*
