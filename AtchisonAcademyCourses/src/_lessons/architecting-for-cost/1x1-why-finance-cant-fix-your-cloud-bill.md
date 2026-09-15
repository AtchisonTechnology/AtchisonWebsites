---
layout: lesson
course: architecting-for-cost
module: 1
lesson: 1
title: "Why Finance Can't Fix Your Cloud Bill"
content_type: video_reading
vimeo_id: 1227029244
video_minutes: 9
reading_minutes: 3
reading_title: "Where each tool stops"
permalink: /architecting-for-cost/lhtsulearu/1x1/
---
The video makes the argument. This is the reference version, so you can check a specific technique
against a specific line on your own bill.

| Technique | What it reaches | Where it stops |
|---|---|---|
| **Tagging and allocation** | Which team or product owns a charge | Says nothing about what caused the charge |
| **Rightsizing** | Instances larger than their workload | Cannot make an instance unnecessary |
| **Idle and orphan cleanup** | Things nobody uses | Finds waste once, then the same waste regrows |
| **Reserved capacity and savings plans** | The rate you pay | You still committed to the capacity |
| **Anomaly detection** | Sudden changes | Steady, structural growth looks normal to it |
| **Storage lifecycle rules** | Data past a fixed age | Cannot change what access pattern the design assumes |

Read the right column as a list of the things only a design change can do.

## Why the second year is different from the first

The first year of cost work is the easiest money most companies will ever find, because it is
cleanup. Somebody left things running. Somebody never bought a commitment. Somebody tagged nothing.

That work has an end. Once the obvious waste is gone, the remaining spend is doing something, and
the only way to spend less is to want less of it or to get it a different way.

Both of those are design questions.

## Two ways companies misread the plateau

**They add process.** A monthly cost review, an approval step for new resources, a dashboard on a
wall. Process makes existing spend more visible. It does not change what the system does.

**They push targets down.** Each team gets a percentage. Teams meet it by shrinking instances until
something breaks, then quietly reverting after the reporting period. The number comes back.

Neither is a discipline failure. Both are what happens when the only tools available are pointed at
effects.

## What to take from a plateau

A cost programme that has flattened out is telling you something specific. Every remaining dollar is
attached to a structural choice somebody made deliberately.

That is not bad news. Those choices are visible, they are documented in your own systems, and most
of them can be revisited. What they cannot be is delegated to somebody who is not allowed to change
the architecture.

## For your own system

Before the next lesson, answer these three from memory, without opening a console.

1. What was your cloud spend last quarter, roughly, and is it going up or down?
2. Which three architectural decisions do you believe drive most of it?
3. When was the last time either of those numbers changed because of a design decision rather than
   a purchase or a cleanup?

The third question is the one that matters. For most teams the honest answer is "never," and that is
the position this course is written for.
