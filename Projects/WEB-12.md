# Ownership Workshop page: optimize for AI search

* **Linear:** [WEB-12](https://linear.app/atchison-technlology/issue/WEB-12)
* **Date Created:** 2026-10-22
* **Systems Impacted:** AtchisonAcademy

---

## Problem/Requirement

From Todoist (2026-09-14): optimize the $6K workshop page
(`atchisonacademy.com/ownership-workshop/`) for AI search, targeting
high-intent searches for the workshop. Lee's structure:

- **Top:** what is on this page / the offer, in a summary.
- **Middle:** the existing content.
- **Bottom:** FAQs, with external links.

Today the page has a good title, meta description, canonical and share
tags, but:

- The offer facts (what, who, format, price, outcome) are spread across
  the whole page. An AI answer engine has to assemble them.
- There is no FAQ, so nothing on the page answers a question in the words
  a buyer would type ("how do you decide which services are Tier 1").
- There is no structured data. The `Course` JSON-LD in `_head.erb`
  (Spec0034) only fires for the `courses` collection.
- The page links to nothing outside itself, so nothing ties it to Lee's
  existing work on the topic (the SAI article, STOSA, the book).

Related: WEB-6 (move this page onto the sales layout) is in
Hold/Deferred. This issue does not depend on it and does not do it.

---

## Solution/Fix/Change

**Decided (Lee, 2026-10-22).** Summary, FAQ copy and meta description approved as written below.

### 1. "At a glance" summary, directly under the hero

A short definition-list block. Plain facts, one line each, so it can be
quoted on its own:

| | |
|---|---|
| **What** | A private, half-day service ownership and criticality workshop, run for one engineering team on its own services. |
| **Who it's for** | Directors and VPs of engineering, and heads of platform, at organizations with roughly 100 to 1,000 engineers. |
| **What you leave with** | A tier map of your actual services, a classification method your team can keep running, and the first thing to fix. |
| **Format** | About four hours, remote, up to 25 people. You pick the date. |
| **Price** | $6,000 for the session. One fee, not per seat. |
| **How to start** | Book a 20-minute call, or ask by email. *(links to the two doors)* |

### 2. Middle — unchanged

No copy changes to the existing sections. The headline, the title
("The Ownership Gap Workshop" — final title still open, D2 in the course
planning file) and the two equal doors all stay exactly as they are.

### 3. FAQ, after the two doors and before the bio (placement: Lee, 2026-10-22)

Same `<dl>` pattern as the sales-page FAQ partial (`.sales-faq`). The
questions are phrased the way a buyer searches:

1. **What is a service tiering workshop?**
   A working session where your team decides how critical each of your
   services actually is, and writes it down. Not a lecture. You classify
   your own system, against evidence, and leave with a tier map.

2. **How do you decide which services are Tier 1?**
   From what happens when the service fails, not from who built it or how
   important it feels. A tier is a set of commitments: an availability
   target, an on-call obligation, a review burden, a spend level. If a
   service doesn't need those commitments, it isn't Tier 1.

3. **Why didn't our service catalog fix this?**
   A catalog records decisions. It doesn't make them. If nobody decided
   what matters most and who owns it, the catalog fills up with metadata
   nobody trusts. I wrote about this in
   [When Everything Is Critical, Nothing Is](https://softwarearchitectureinsights.com/posts/when-everything-is-critical-nothing-is/).

4. **How does this relate to STOSA?**
   [STOSA](https://stosa.org/) is the ownership model: every service has
   exactly one owning team. This workshop is the criticality half. Which
   services matter most, so ownership and reliability spend go where they
   count.

5. **Who should be in the room?**
   The people who can decide. Engineering leadership, the platform team,
   and the owners of your most argued-about services. The session is worth
   less with a room that has to go ask someone.

6. **How much does it cost?**
   $6,000 for the session, up to 25 people. One fee, not per seat, so
   there's no reason to leave anyone out.

7. **Is it remote? Can you come on site?**
   It runs remote by default. On-site is possible. Ask, and I'll quote it
   for your location.

8. **What do we need to prepare?**
   A list of what you run, if you have one. If you don't, that's fine.
   Building the inventory is the first part of the work, and it's where
   most teams find out what they didn't know.

9. **What does it not cover?**
   Availability targets, error budgets, ownership assignment, blast radius
   and the incident path. Those come after you have tiers. I'll tell you
   which to tackle next.

10. **Who runs it?**
    I do. Lee Atchison. Seven years at Amazon and AWS, eight at New Relic,
    and the author of
    [Architecting for Scale](https://architectingforscale.com/)
    (O'Reilly), which covers this problem in depth. More at
    [leeatchison.com](https://leeatchison.com/).

### 4. Structured data (JSON-LD)

Two blocks, generated from the page's front matter so the visible text
and the structured data cannot drift:

- **`FAQPage`** — built from the same `faq:` list that renders section 3.
- **`Service`** with an **`Offer`** — name, description, `price: 6000`,
  `priceCurrency: USD`, `areaServed`, and `provider` pointing at Lee's
  master Person record by `@id` (`https://leeatchison.com/#person`), the
  same pattern as the `Course` block (Spec0034).

Both emitted only when the page's front matter carries them, so no other
page changes.

### 5. Meta description

Current: *"A private half-day working session on service ownership and
criticality, run for your team, on your own services."*

Proposed: *"A private half-day service ownership and criticality workshop
for engineering leaders. Your team tiers its own services and leaves with a
tier map. Remote, $6,000 flat."*

Adds the words people search on ("workshop", "tier", "engineering
leaders", the price). Title tag unchanged.

---

## Testing

- `bin/bridgetown build`; check `output/ownership-workshop/index.html`.
- Validate both JSON-LD blocks with Google's Rich Results Test and the
  schema.org validator against the deploy preview.
- Confirm the visible FAQ and the `FAQPage` JSON-LD list the same
  questions in the same order.
- Confirm both doors still open, collapse, and mount SavvyCal as before.
- Mobile width: summary block and FAQ read cleanly at 375px.

---

## Summary of Steps Needed

1. Lee approves (or edits) the summary, FAQ copy and meta description.
2. Add `faq:` and `service:` front matter to `ownership-workshop.erb`.
3. Render the summary block and the FAQ in the page.
4. Add the `FAQPage` and `Service` JSON-LD to `_head.erb`, gated on front
   matter.
5. Small CSS for the summary block; reuse `.sales-faq` for the FAQ.
6. Build, check, deploy preview, validate.

---

## Open Questions

None open.

1. ~~Approve the summary, the ten FAQ answers and the new meta
   description.~~ **Approved as written (Lee, 2026-10-22).**
2. ~~On-site delivery (FAQ 7): OK to say "on-site is possible, ask"?~~
   **Yes (Lee, 2026-10-22).** It stays unpriced until someone asks (D4 in
   the course planning file).
3. ~~FAQ placement: after the two doors, or before them?~~ **After the two
   doors (Lee, 2026-10-22).**

---

## History of Updates

- 2026-10-22 — Spec created from the Todoist task. Everything above is a
  proposal awaiting Lee.
- 2026-10-22 — Lee approved the summary, FAQ copy and meta description,
  on-site wording (FAQ 7), and FAQ placement after the two doors. All open
  questions resolved. Implementation not started.
