---
layout: lesson
course: architecting-for-cost
module: 1
lesson: 2
title: "Reading a Bill as an Architecture Diagram"
content_type: video_reading
vimeo_id: 1227033117
video_minutes: 8
reading_minutes: 3
reading_title: "The translation table"
permalink: /architecting-for-cost/lhtsulearu/1x2/
---
⚠️ **Examples in this course all use AWS.** The structures are the same on any provider; the
service names are not. Nothing here quotes a price, so nothing here goes stale on a price change.

Keep this next to your cost console the first few times. The middle column is a starting hypothesis,
never a conclusion.

| Line item | Usual architectural cause | What to check first |
|---|---|---|
| **NAT gateway data processing** | Private subnets reaching outside the VPC in volume | Image pulls on deploy, backups, calls that could use a private endpoint |
| **Data transfer, inter-AZ** | Components split across zones that talk constantly | App-to-database path, cache placement, chatty service pairs |
| **Data transfer, inter-region** | A replication or DR topology | Which recovery target requires it, and when it was last reviewed |
| **Data transfer out to internet** | Customer traffic, or an unfronted origin | Whether a CDN is in front of what is being served |
| **Load balancer hours** | One balancer per service, by convention | How many services genuinely need their own entry point |
| **EBS volumes and snapshots** | Snapshot retention with no expiry | Retention policy, and whether anyone has ever restored one |
| **S3 in a hot storage class** | An assumption that data is read often | Actual access age distribution |
| **Log ingestion and retention** | Default log levels at scale, kept forever | What is emitted per request, and the retention window |
| **Idle compute at low utilization** | Capacity sized for peak, running at trough | Peak-to-average ratio, and whether it can scale |
| **Per-tenant resources** | An isolation model that gives each customer their own | The tenancy decision itself, which is module 4 |

## The three questions, expanded

**What structural choice makes this charge exist at all?** Not which team owns it. What in the shape
of the system requires it. If the answer is "nothing structural, someone left it running," it is a
FinOps item and you can hand it back.

**What would have to change in the design for it to go away?** Be specific and be honest about size.
"Merge two services" is a sprint. "Change the tenancy model" is a year. Both are valid answers, and
knowing which one you are looking at is most of the value.

**What did we get in exchange?** Every structural cost bought something: independence, availability,
latency, isolation, developer speed. Name it. A charge you cannot justify is a finding. A charge you
can justify is a decision, and it stays.

## Where the bill actively misleads

**Grouped categories.** A catch-all category can hold several unrelated charges. Break it out before
drawing conclusions about it.

**Shared services.** Platform costs often land on one account, which makes the platform team look
expensive and every consuming team look efficient.

**Growth that tracks traffic.** A line that rises with revenue may be fine. Compare against a
denominator, not against last month. That denominator is discussed in lesson 2x2.

## The exercise

Take your top five line items. For each one, write a single sentence naming the architectural
decision you believe caused it, and note how confident you are.

Keep the sheet. Lesson 1x3 is about the entries you could not fill in, and having your own version
in front of you makes that lesson land differently than watching it in the abstract.
