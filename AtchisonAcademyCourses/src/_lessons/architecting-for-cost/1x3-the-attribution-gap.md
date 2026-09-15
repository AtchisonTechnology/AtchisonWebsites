---
layout: lesson
course: architecting-for-cost
module: 1
lesson: 3
title: "The Attribution Gap"
content_type: video_reading
vimeo_id: 1227033166
video_minutes: 8
reading_minutes: 5
reading_title: "The worksheet, and a worked example"
downloads:
  - title: Cost Attribution Worksheet (.xlsx)
    file: /files/courses/architecting-for-cost/cost-attribution-worksheet.xlsx
    note: The exercise. Four tabs, about twenty minutes, your cloud bill open beside you. Your numbers stay in the file.
  - title: Worked example — the filled worksheet (.xlsx)
    file: /files/courses/architecting-for-cost/cost-attribution-worksheet-worked-example.xlsx
    note: The same worksheet, filled in with the invented company from the reading below. Open it if you want to see a finished one before starting your own.
permalink: /architecting-for-cost/lhtsulearu/1x3/
---
The worksheet for this lesson is at the bottom of this page. There are two files there.

The first is the blank Cost Attribution Worksheet. That is the one you fill in, with your own bill
open beside you. Plan on about twenty minutes.

The second is the same worksheet already filled in, using the invented company described below.
Open it if you want to see a finished one before you start, or leave it closed until you are done
and use it to check your own.

Download the blank one now. The rest of this reading walks through the filled one.

⚠️ **The example company and its amounts are invented** for illustration, and the service names
are AWS, as they are throughout this course. Nothing here quotes a price.

The video walks through the worksheet one tab at a time. This is what a finished Attribution Table
looks like, so you have something to compare yours against.

The company is a mid-sized software business selling to other businesses. Here are its five largest
line items, with blanks left where the team did not know.

| # | Line item | Per month | What decision causes this? | When, and by whom? | To unmake it | How sure? |
|---|---|---|---|---|---|---|
| 1 | EC2 instances | $41,000 | Every service is sized for the holiday peak and runs at that size all year | 2021, each service team at launch | A quarter | Guessing |
| 2 | RDS database instances | $18,500 | Each enterprise customer gets its own database, for isolation promised in contracts | 2019, the founding engineers | A migration or re-platform | Sure |
| 3 | Data transfer, inter-AZ | $9,200 | *(blank)* | *(blank)* | Don't know | No idea |
| 4 | NAT gateway data processing | $6,800 | Services reach S3 through the public endpoint instead of a VPC endpoint | 2022, the platform team | A sprint | Sure |
| 5 | CloudWatch Logs | $5,400 | Debug-level logging stayed on in production after a 2023 incident | Unknown | A sprint | Guessing |

## What each row teaches

**Row 1.** This is the most common entry on any worksheet. The team has a theory about peak sizing, and it
is probably right. Nobody has checked utilization to confirm it, so it is marked Guessing. That is
the honest mark, and it keeps the largest line on the bill inside the gap where it belongs.

**Row 2.** This one is sure, and still expensive. The team knows exactly why it pays this. The cost bought
something real, which is isolation that customers signed for. Lesson 1x2 called that a decision
rather than a finding, and module 4 is about deciding it on purpose.

**Row 3.** This is the most useful row on the sheet. Nobody knows what is crossing zones, or why. A blank
here tells the team precisely where to look first. A plausible guess like "database replication"
would have hidden it.

**Row 4.** This is the easy win. It is sure, and it is small to fix. Most worksheets have one of these,
and it is usually the row that gets fixed first.

**Row 5.** This row names a cause and admits it cannot name the owner. "Unknown" is a fine answer in the
*When, and by whom?* column. It usually means nobody decided it on purpose.

## Column by column

**Line item.** Copy it as your bill names it, even when the name is unhelpful. Translating it comes
later, in the decision column.

**Per month.** Your real figure. It stays in your file and is never sent anywhere.

**What decision causes this?** Write the decision, not the resource. "We have a NAT gateway" is a
resource. "Services reach S3 through the public endpoint" is a decision you could change.

**When, and by whom?** A year and a team is enough. You are looking for how old the decision is and
whether the people who made it are still around to ask.

**To unmake it.** Pick the closest size from the list: a sprint, a quarter, a migration or
re-platform, cannot be unmade, or don't know. A rough size is fine. The point is knowing whether a
change is a sprint or a year.

**How sure?** Sure, Guessing, or No idea. This column is what the worksheet measures. If you are
choosing between Sure and Guessing, pick Guessing.

## Using the translation table without cheating

The ten-row translation table in lesson 1x2's reading lists common line items and their usual
causes. Use it to decide where to look. Do not copy from it.

If the table suggests a cause and you confirm it on your own system, write it in and mark it Sure.
If you cannot confirm it, write your best theory and mark it Guessing. If you have no theory at all,
leave the cell blank.

## The Drivers Check, one question worked

Take the first question, *How do customers share infrastructure?* The four descriptions run from
zero to three:

| 0 | 1 | 2 | 3 |
|---|---|---|---|
| Every customer gets their own stack, and nobody has priced the difference | Mostly per-customer, some shared, decided case by case | Mostly shared, with named exceptions | A deliberate model, and we know at what customer count it stops paying |

The example company gives enterprise customers their own database and shares everything else. That
was decided customer by customer, as deals closed. So the honest answer is **1**, even though the
team has talked about moving to a deliberate model.

Answer for what you do today. A plan you have not started scores the same as no plan.

## Reading the example's result

Here is what the Your Result tab would show for the table above.

| Measure | Result |
|---|---|
| Line items attributed with confidence | 2 of 5 |
| Unattributed spend, per month | $55,600 (rows 1, 3 and 5) |
| Line items that cannot be unmade | 0 |
| Causes left blank | 1 |

Two of five is a normal result. The number to look at is the $55,600. That is more than half of this
company's top five, spent every month on decisions nobody in the building can fully explain.

That figure is where this team should start, and your own version of it is where you should start.

## The exercise

Fill in the worksheet using your real bill. Give it the full twenty minutes, and leave blanks where
you do not know.

Keep the finished file. Your weakest driver on the Your Result tab points at the module of this
course that will matter most to you.
