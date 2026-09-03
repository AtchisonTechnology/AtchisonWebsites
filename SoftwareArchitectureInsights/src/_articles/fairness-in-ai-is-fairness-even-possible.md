---
title: "Fairness in AI: Is Fairness Even Possible?"
subtitle: ""
author: Lee Atchison
status: published
created: 2026-07-17
date: 2026-08-06
published_on: 2026-08-06

sai_url: https://softwarearchitectureinsights.com/posts/fairness-in-ai-is-fairness-even-possible
email_sent: 2026-08-06
linkedin_url:

hero_image: 

internal_note:
meta_description: Six definitions of AI fairness exist, and several are mathematically proven incompatible. Every system that makes decisions has already chosen one.
slug: fairness-in-ai-is-fairness-even-possible
description: >
  There are at least six distinct, defensible definitions of AI fairness — demographic parity, equal opportunity, equalized odds, predictive parity, individual fairness, counterfactual fairness — and a proven mathematical result shows several are incompatible with each other. Every consequential AI system has already chosen one, whether the team meant to or not.
categories:
  - "AI Ethics & Responsibility"

---

*There are at least six distinct definitions of fairness, and most of
them conflict with each other.*

Your team spent weeks tuning the hiring recommendation model. The
product manager wants to know whether it's fair. You run the numbers.
The model recommends candidates at roughly equal rates across
demographic groups. Equal positive rates across the board. Seems fair.

A month later, an auditor reviews the system. They're looking at
something different. False positive rates. How often does the model
incorrectly recommend someone? For one group, the false positive rate is
8%. For another, it's 22%. The model produces equal recommendation rates
overall, but it achieves that by misclassifying one group at nearly
three times the rate of the other.

Is the model fair? The answer depends entirely on which definition of
fairness you're using.

*And that's the problem.*

## Multiple Definitions, Multiple Views

Fairness in AI can follow one of many different, contradictory
definitions.

**Demographic parity** requires that the model produce positive outcomes
at equal rates across groups. If 30% of Group A receives a loan
approval, 30% of Group B should too. The total number of loans approved
may be disproportionate between groups if there are more candidates in
one group than another, but the approval rates are the same independent
of group.

This model is simple to measure, widely cited in policy discussions, and
the first thing most teams reach for.

**Equal opportunity** is similar but narrower. It requires that
qualified candidates from different groups receive positive outcomes at
equal rates.

If you accept 30% of candidates from group A, shouldn't you expect to
accept 30% of candidates from group B? But what happens if group B truly
has more qualified candidates than group A?

Equal opportunity focuses on the true positive rate. If you have more
candidates in one group, you expect more matches in that one group than
in others. This gives individuals an equal opportunity regardless of
which group they belong to. Yet it does nothing to improve the overall
representation of an underrepresented group.

So researchers tightened the screws.

**Equalized odds** goes further. It requires equal rates on two
dimensions simultaneously: true positives and false positives. The model
should correctly identify actual positives at equal rates across groups,
and it should avoid misclassifying actual negatives at equal rates too.

**Predictive parity**, sometimes called calibration, flips the question.
Instead of asking whether the model's behavior is consistent across
groups, it asks whether the model's predictions mean the same thing
across groups. If the model assigns a risk score of 70% to individuals
from Group A and Group B, do those individuals actually carry the same
underlying probability? A calibrated model is one where the score is
equally trustworthy regardless of who it's applied to.

All four definitions so far have been about groups. The next two ask
about the person sitting right in front of you.

**Individual fairness** takes a different approach entirely. It requires
that similar individuals receive similar outcomes. Two people who look
similar on all relevant dimensions should get similar predictions,
regardless of which group they belong to. The goal is similar to equal
opportunity, but implemented very differently.

**Counterfactual fairness** asks yet a different question. If this
person had belonged to a different demographic group, but everything
else about them stayed the same, would the outcome have changed? If so,
the model is using that protected attribute in its prediction, even if
only indirectly through correlated features.

Six definitions. All of them defensible. All of them measuring something
real. But the goals are radically different.

## The Part Nobody Wants to Hear

Here's where it gets hard.

Several of these definitions are mathematically incompatible with each
other. This is a proven result, [formalized by researchers Jon
Kleinberg, Sendhil Mullainathan, and Manish Raghavan in
2016](https://drops.dagstuhl.de/opus/volltexte/2017/8156/). Better
models will not resolve it. More data will not resolve it. It is a
structural property of the problem itself.

The intuition is easier to grasp than the math. Demographic parity
requires equal positive outcome rates across groups. Predictive parity
requires that a given score means the same thing for an individual
regardless of their group.

But if one group has a favorable trait more often than another group,
you cannot satisfy both types of equality at the same time. You cannot
have both.

*You have to choose.*

This mathematical fact tends to be overlooked by product teams who
assumed they could just "optimize for fairness." The concept that seemed
like a single dial turns out to be multiple knobs, most of which can't
be turned up at the same time.

## The Choice Your System Has Already Made

This is the part that matters most for practitioners.

*Every AI system that makes consequential decisions has already chosen a
fairness definition.*

The choice is embedded in the training objective, the evaluation
metrics, and the decision thresholds the team selected. If the team
didn't make that choice explicitly, the training process made it
implicitly. The model optimizes for whatever the objective function
rewarded, which almost certainly was not fairness in any deliberate
sense.

A team is confident the model is fair because they measured demographic
parity and the numbers look even. Then an auditor measured equalized
odds. The numbers look nothing like what they expected. There's a
scramble to understand which measurement matters, who gets to decide,
and what the organization is actually committed to. The conversation
that should have happened at design time is now happening in a crisis.

The question your team needs to answer is which fairness definition fits
your context, and whether anyone actually made that choice on purpose.

There is no universal answer. But there is always a choice being made.

## Making the Choice Deliberately

There are many actions you can take to make the implicit fairness
choices explicit.

**Error costs.** Start with the error costs. In your specific
application, which type of error causes more harm: a false positive or a
false negative? In a medical screening context, a false negative
(missing someone who is sick) is far more harmful than a false positive
(flagging someone who is healthy). In a content moderation context, the
tradeoffs run the other way. Your fairness definition should reflect
your error cost priorities.

**Error Burden.** Next, ask who bears the costs of errors. If false
positives fall disproportionately on one group, equalized odds or equal
opportunity is likely the right frame. If you're more concerned that the
model's scores carry the same meaning across groups, calibration is the
priority.

**Legal and Compliance.** Pull in legal and compliance early. The EU AI
Act, the Equal Credit Opportunity Act, and various employment
discrimination laws each imply different fairness standards. These teams
should be part of the conversation before the engineering decisions are
made, not after.

**Document.** Write down the decision. Whatever fairness definition your
team lands on, write it down. Explain why you chose it over the
alternatives. What are you optimizing for, and what are you accepting as
a tradeoff? This documentation is the basis for accountability if the
system is ever challenged, and it forces the kind of explicit reasoning
that prevents teams from sliding into "we measured it and it looked
fine."

Fairness is a design decision you make, or one that gets made for you.

The important question is whether you're the one making it.
