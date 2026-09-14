---
title: "Redundancy Assumes Independence"
slug: teardown-redundancy-assumes-independence
date: 2026-11-24
episode_number: 17
category: Teardown
tags: []
description: "A Google Cloud zone went dark for four hours. The redundancy was real, it was working, and none of it helped."
captivate_episode_id: "a2f478bf-b997-4adc-9678-c9a0047a394a"
source_articles: []
duration: "10:36"
---

A technician in an Iowa data center worked down a maintenance list, one fiber cable at a time. Thirteen minutes later, every path into the zone was gone and us-central1-b went dark for four hours and eleven minutes.

The redundancy was real. Multiple routers, separate fiber paths, independent power. None of it helped, and the reason should change how you look at your own.

**In this episode:**

- What Google actually wrote, and the one word in their report doing all the work
- Why redundancy math quietly assumes failures don't know about each other
- Four hours of outage, nineteen minutes of repair: the diagnostic gap in physical-layer failures
- Resource isolation: the zone that never looked dead from the inside, and why multi-zone failover didn't fire
- Health checks that never leave the building
- Finding your correlated maintenance — the list that isn't your single-points-of-failure list

**Links:**

- [Google Cloud incident report: us-central1-b, 1 September 2026](https://status.cloud.google.com/incidents/J5ia5t9p3g9Q5Wi7r8Ev)
- [Coinbase: a postmortem of the May 7, 2026 outage](https://www.coinbase.com/blog/a-postmortem-of-our-may-7-2026-outage)

## Transcript

Hello and welcome to Software Architecture Insights, your go-to resource for empowering software architects and aspiring professionals with the knowledge and tools they require to navigate the complex landscape of modern software design. On the 1st of September, a technician walked into a Google data center in Iowa to do a scheduled hardware upgrade, swap out some optical transceivers on the network routers. Routine work, the kind of thing that happens every week in every data center on Earth. The technician removed one fiber cable, then another, then another, then another. The entire US Central 1B availability zone went down.

Four hours and eleven minutes later, the zone finished coming back up again. More than 15 Google Cloud products went down with it, including Kubernetes Engine, Cloud SQL, BigQuery, and Spanner. If you were running in that zone, you spent the morning watching perfectly healthy machines serve zero requests from anybody. I want to walk through this incident because the headline version of the story is wrong, and the real version should change how you look at your own redundancy. So, the register ran it as, "Engineer unplugged every fiber they could see." It's a funny line, and it isn't the useful part at all.

Here's what Google actually wrote in their own final report. "A procedural error meant that the physical maintenance action sequentially unplugged one hundred percent of fiber paths across all devices within thirteen minutes." The word doing all the work in that sentence is sequentially. Nobody yanked a handful of cables in a panic. The work order handed one person the full replacement list across every router in scope. Nothing in that procedure said which cables could not come out at the same time. So they worked down the list correctly, one cable at a time, pulling each of them out for thirteen minutes until they were all pulled out and there was no path left standing.

That's a procedure defect. The human did what the paper said to do. Now, here's the part that should bother you. The zone was redundant and not in a box-ticking sort of redundant way. Multiple routing devices, physically separate fiber paths, independent power feeds. Google's own description says the design is meant to survive a single failure and most combinations of multiple failures. All of it was in place, all of it was working, none of it helped. And there's a reason for that, and it's the thing I'd like you to carry out of this episode.

Redundancy assumes independence.

When you work out availability for a redundant system, you multiply failure probabilities together. Two components at 99% each give you four nines, 99.99%, because the odds of both failing at once are the product of the two. That multiplication is only valid if the two failures don't know about each other, if they are independent. A maintenance procedure knows about all of them. It visits every redundant element in turn on purpose because that's what it was written to do. So the moment one procedure touches all your copies, those copies stop being independent, and your four nines are now one nine with nothing in your model to say so.

The spreadsheet didn't catch it. The design review didn't catch it. The redundancy was real right up to the same pair of hands that reached out and touched all of it. The timeline is interesting, too, because there's a second lesson sitting in all of this. Total outage for four hours and 11 minutes. Time to physically reseat the fibers once somebody understood what had happened was about 19 minutes. 19 minutes of the four hours. So the repair took 20 minutes, and the diagnostic of the problem took three and a half hours. That gap is the whole story of most physical layer failures.

Your telemetry is built to tell you about software, and it's good at it. Bad deploys, memory leaks, saturated queues, a database that fell over. What it cannot tell you is that a person is standing in a room holding a cable. Everything upstream reported the problem. Nothing reported the cause. The failure mode itself is the piece I'd want you to steal from this incident because it's the one that defeats the architecture that you already paid for. The VMs never went down. Machines inside US Central 1B stayed up the entire time, and traffic between VMs inside the zone kept flowing normally.

What died was the boundary. Nothing got in, nothing got out. Google called it resource isolation. Ask a VM whether it's healthy, and it says yes.

Ask another VM in the same zone, and it agrees. The only question that would have noticed this failure is one asked from outside, and a lot of times health checks never leave the building. That's why multi-zone architecture didn't save everyone who had it. Failover processes tend to fire when a zone looks dead. This isolated zone did not look dead. From the inside, everything looked great. If your health check travels the same path your users travel, you cannot detect that path failing. Your probe has to cross the boundary that your customers cross.

Different network, different region, and if the service matters enough, a different provider. The follow-up actions tell you what Google thinks the real problem was, and the order they listed them is worth noticing. Work stop alerting when fiber disconnections are detected. Automated traffic rerouting aiming to cut recovery from four hours down to five minutes. Automating the network upgrade workflow so nobody is walking a list by hand. And fourth, training. Now, three of those four take the human out of the loop, and only one tries to make the human better at doing their job.

They put that one last. Most postmortems I read do the reverse, and they're usually wrong. So what do you do with this? Go find your correlated maintenance. I don't mean your single point failures. You have a list of those already, and it's probably a decent list. This is a different list. You're looking for any one procedure that run exactly as written, reaches every copy of something you believe is redundant. Rolling deploys that sweep all zones, certificate rotations, key rollovers, firmware and agent updates, config pushes, anything whose runbook contains words such as repeat for each one.

Once you have that list, ask a plain question for each one. If this procedure does exactly what it says in order, is there anything at all that stops it before it reaches that last copy? If the answer is no, then that procedure is your single point of failure, no matter how many copies you paid for. The fix is usually small. A sequencing constraint in the work order, you know, a wait between steps, a check that refuses to continue while available capacity is under a floor. None of that is hard engineering.

It's work nobody schedules, nobody thinks about, because the redundancy already looked fine in theory. Coinbase learned a version of this lesson in May when a cooling failure took out one AWS availability zone and their matching engine had no automated way to move. Replicated everywhere, failover nowhere. While it looks different, it's really the same lesson. Your architecture diagram shows what you built. It does not show who is allowed to touch all of it at once. Google's final report on this one is in the show notes, and it's worth your time. It's short, it's specific, and frankly, it's more candid than most vendors' postmortems get.

The Coinbase write-up is in the show notes as well. Read the report, not the media coverage. The report, you'll find, is quite enlightening Thank you for joining us on Software Architecture Insights. If you found this episode interesting, please tell your friends and colleagues. You can listen to Software Architecture Insights on all of the major podcast platforms.

And if you want more from me, take a look at some of my many articles at softwarearchitectureinsights.com. And while you're there, join the 2000 people who have subscribed to my newsletter, so you always get my latest content as soon as it's available. Thank you for listening to Software Architecture Insights.
