---
title: "Why Does Our Cloud Bill Keep Growing?"
order: 3
description: >-
  Most cloud bills grow because nobody designed them. The three defaults
  behind the growth, and how to make cost a real requirement.
---
Finance asks the same question every quarter. Traffic is flat and revenue is flat, so why did the cloud bill go up again?

Most engineering teams can't answer, because nobody on the team decided to spend more. The bill grew anyway.

It grew because nobody designed it.

Every line on a cloud invoice traces back to an architecture choice somebody made, or never got around to making. Make those choices on purpose and cost is something you can steer. Leave them to defaults and it piles up.

Three defaults cause most of it, and static capacity is the oldest of them.

Plenty of applications reached the cloud through lift-and-shift, moved over exactly as they were onto servers sized for the busiest hour of the busiest day of the year. That's renting a whole office building when most days you need a few rooms.

The cloud is cheap when capacity follows demand. An application that can't scale down pays peak prices every hour of the month. I called this [the big cloud migration misstep](/posts/the-big-cloud-migration-misstep/), and teams still make it.

Then there's everything nobody turned off. Think of the old service a migration never finished replacing, the replica behind a report nobody reads, or last spring's test environment.

Each one is a rounding error, but together they become a line on the bill that nobody can explain. Organizations reward shipping new things and give nobody credit for retiring old ones, so the old ones stay.

AI inference is the newest default, and it grows fastest. AI features charge per call, and model size and context length are design decisions that show up on the invoice thirty days later. A team that wires in the biggest model because the demo used it pays that price on every request.

Inference cost can also climb with no deploy at all. A longer prompt does it, and so does a retrieval step that starts returning more context than it used to. I walked through this in [Your Function Call Was Free. This One Isn't.](/posts/your-function-call-was-free/)

## Make Cost a Requirement

The fix is to treat cost the way you already treat latency and availability. It gets a target and an owner.

Know what one transaction costs, as opposed to what the monthly total is. A monthly number tells you something went up. A per-transaction number tells you which feature did it.

Give every resource a team. Tagging and showback are old, unglamorous tools, and they still work. Nobody cuts a cost they don't own.

Talk about cost while the design is still on the whiteboard. Changing an instance type or a model choice is cheap before launch. After launch it competes with every other item on the roadmap, and it usually loses.

There's one place I'd hold off. A prototype that might not survive the quarter doesn't need cost engineering yet. Give it a review date instead, and make cost part of deciding whether it graduates.

None of this argues against the cloud. For most companies, run properly, it still costs less than owning a data center. The trouble is the gap between how the cloud is priced and how the system was built.

Pull the five largest lines from last month's bill. Next to each one, write down the design decision that created it and who owns that decision. The lines where you can't fill in either column are where to start.

If you want to work through those decisions in depth, that's what my course [Architecting for Cost](https://atchisonacademy.com/courses/architecting-for-cost/) covers.
