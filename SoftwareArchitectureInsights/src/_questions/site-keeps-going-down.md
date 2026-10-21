---
title: "Why Does Our Site Keep Going Down?"
order: 2
description: >-
  Repeat outages usually come from risks nobody counted. Planned downtime,
  services everyone calls critical, and single points of failure in people.
---
The status page is green. Last month's postmortem is filed, and every action item is closed. Then a customer writes in to ask why the site was down again on Sunday night.

Sunday night was the maintenance window. Nobody on the team counted it as an outage.

Most sites that keep going down aren't failing in a new way each time. They go down because of risks nobody ever wrote down as risks. A few of them show up again and again.

The first is the downtime you scheduled yourself. A planned maintenance window is still downtime. Your customer doesn't know it was planned, and doesn't care.

A weekly two-hour window caps you at about 98.8% availability before anything breaks by accident. Moving it to the middle of the night helps less than it used to, because someone in another time zone is always trying to log in. I've written more about this in [Planned Outages Are Still Outages](/posts/planned-outages-are-still-outages/).

The fix is zero-downtime deploys and maintenance. It's hard to retrofit into an old system. It's doable in anything you build new or are already modernizing.

The second risk is treating everything as critical. Ask a team to rank its services and watch what comes back. Checkout is Tier 1. Auth is Tier 1. The internal reporting tool is Tier 1 because an executive uses it.

When nearly everything claims the top tier, the reliability budget gets spread flat. The reporting tool gets the same attention as checkout, and checkout never gets the second region it needed.

Ownership fails the same way. A service owned by three teams is owned by none of them. When it breaks, the first half hour goes to finding someone with the context and the authority to change it.

Service tiers and single-team ownership fix this together. The tier says how much reliability a service needs. One named owning team is on the hook to deliver it. More in [When Everything Is Critical, Nothing Is](/posts/when-everything-is-critical-nothing-is/).

One caution here. Some services don't need any of this. An internal tool used by five people during business hours can live with a maintenance window and a Tier 3 label. Spending Tier 1 money on it is how your real Tier 1 services go short.

The third risk is the single point of failure nobody counted. Most teams can find the database with no replica. Fewer look for the other kinds.

One is a person. When a single architect holds the reasoning behind the system, teams make changes that seem reasonable and slowly break what the design was meant to prevent. Ask what would stop if that person were unreachable for six weeks.

Another is a login. When every vendor console signs in through one Google account, losing that account locks you out of all of them at once.

Neither shows up on an architecture diagram.

So start with a short exercise. Pick your ten busiest services. For each one, write down its tier and its one owning team. Then add up last quarter's planned downtime and count it against your availability.

Every blank you can't fill in is a candidate for your next outage.
