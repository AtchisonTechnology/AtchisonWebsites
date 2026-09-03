---
title: What the EU AI Act Actually Requires (And What It Doesn't)
subtitle: ""
author: Lee Atchison
status: published
created: 2026-07-17
date: 2026-08-20
published_on: 2026-08-20

sai_url: https://softwarearchitectureinsights.com/posts/what-the-eu-ai-act-actually-requires-and-what-it-doesn-t
email_sent: 2026-08-20
linkedin_url:

hero_image: what-the-eu-ai-act-actually-requires-and-what-it-doesn-t.png

internal_note:
meta_description: The EU AI Act applies based on output use, not company location. A plain-language breakdown of the four risk tiers and what high-risk systems must do.
slug: what-the-eu-ai-act-actually-requires-and-what-it-doesn-t
description: >
  The EU AI Act's reach extends to any company whose AI system's output is used by people in the EU, no European office required. A plain-language breakdown of the four risk tiers, what high-risk systems (hiring, credit, biometrics) must actually do, and what the Act does not require.
categories:
  - "AI Ethics & Responsibility"

---

*A plain language breakdown of what the regulation means for software
teams building or deploying AI, even if you aren't in Europe.*

Your product manager has just heard about the EU AI Act. They send you a
message: "We use AI in our product. Do we need to comply with this?"
Maybe your legal team forwards a three page summary they don't fully
understand. Maybe a customer in Germany asks whether your system is "EU
AI Act compliant."

Here's the honest answer: it depends on what your AI system does, who
uses it, and where those users are. That's not a dodge. The EU AI Act is
deliberately proportional in its design. Most AI systems face minimal or
no new obligations. A specific and well defined set of systems face
substantial requirements. And the determining factor is the potential
harm the system could cause to real people.

Understanding which bucket you're in is the first thing any technical
leader needs to do.

## The Four Risk Tiers

The EU AI Act organizes all AI systems into four categories based on
risk profile.

**Unacceptable risk** covers systems the EU has banned outright. Real
time remote biometric surveillance in public spaces (with narrow law
enforcement exceptions), social scoring by governments, and AI that
manipulates people through subliminal techniques fall here. These
prohibitions came into force early in 2025. Most commercial AI systems
have nothing to do with any of this.

**High risk** is where the Act's real weight lives. High risk systems
face substantial compliance requirements before they can be deployed in
EU markets. They aren't banned. They just have to earn the right to
ship.

**Limited risk** systems face transparency obligations. Build a chatbot,
tell users they're talking to AI. That's the scale of the obligation.

**Minimal risk** is where most AI lives. Spam filters, video game AI,
basic recommendation engines. The Act imposes no specific requirements
beyond laws already in force, like GDPR.

The proportionality is intentional. The EU isn't trying to regulate
every AI application. It's trying to prevent specific categories of harm
where AI has already caused documented problems.

## What High Risk Actually Means

The Act defines high risk by sector and use case. The underlying
technology is irrelevant. Annex III of the Act lists the categories. The
list is more specific than most people expect. Check whether your
systems are on it.

**Employment and worker management** makes the list. This includes AI
used in hiring decisions: systems that screen resumes, rank candidates,
or serve targeted job advertisements. It includes performance evaluation
tools and systems that inform promotion or termination decisions. If you
build HR software that uses AI to score applicants, you are in high risk
territory.

**Biometric identification** systems are high risk. So are systems that
gate access to essential services: credit scoring, insurance
underwriting, decisions about unemployment benefits. **Law enforcement**
applications such as recidivism risk assessment make the list. So do
systems used in **educational settings** to evaluate students or monitor
test taking.

**Critical infrastructure** management systems affecting power grids,
water supply, or road traffic are covered. **Border management and
asylum** systems as well.

The thread connecting all of these is that they touch consequential,
often irreversible decisions about people's lives. Getting credit.
Keeping a job. Staying out of prison. Accessing education. These are the
domains where a flawed or biased AI system can cause serious harm to
real people. That's why the bar is higher.

**General purpose AI models** (the large foundation models powering many
products) have their own tier with their own requirements. These include
transparency and documentation obligations, and for the most capable
models, additional systemic risk requirements. These rules came into
force in August 2025.

## What High Risk Systems Must Actually Do

If your system lands in a high risk category, the compliance obligations
are real. They require deliberate engineering work.

You need a **risk management process** that runs throughout the system's
lifecycle, not just at initial deployment. You need **data governance
practices** that address training data quality and representativeness.
You need **logging and record keeping** sufficient to audit decisions
after the fact. You need documentation that clearly explains what the
system does, what its limitations are, and how to use it appropriately.

**Human oversight** is a genuine requirement. The system must be
designed so that humans can monitor it, understand it, and override it
when necessary. That's a design constraint. It lives in how you build
the system, not in a README.

Before a high risk system reaches the EU market, it typically needs a
**conformity assessment** and registration in a publicly accessible EU
database. Third party assessment is required for certain categories such
as remote biometric identification. Many others can use a self
assessment process. But that still means documenting the technical file,
the risk assessment, and the testing methodology in a form a regulator
could actually audit.

The major high risk requirements came into force August 2026. If you're
building or deploying systems in these categories and haven't started
the compliance work, the clock is against you.

## The Extraterritorial Question

Here's what catches many companies outside the EU off guard. The AI
Act's reach does not stop at the EU border.

GDPR famously applies to companies that target EU residents. The AI Act
goes further. Article 2 of the Act applies when the output of your AI
system is used in the EU. You don't need a European office. You don't
need to be actively targeting European customers. If your AI system
produces outputs that people in the EU rely on to make decisions, the
Act likely applies to you.

A US company building a resume screening tool that European employers
use? Probably in scope. A company building a recidivism risk tool that
any EU justice system purchases? Very much in scope. A startup with a
handful of European customers using its AI features to approve loans or
evaluate job candidates? Worth an honest look.

This isn't theoretical. The enforcement mechanisms are real, and the
penalties are substantial: up to 35 million euros or 7% of global annual
turnover for the most serious violations. That's designed to be taken
seriously by large organizations, not just startups.

The practical first step is an honest audit. Which AI systems do you
build or deploy? Which of those touch EU users or customers? And for
those that do, which category do they fall into under the Act?

## What the Act Doesn't Require

The misinformation here is just as damaging as the confusion about what
the Act actually covers. Let's name it.

The EU AI Act does **not** require all AI systems to be explainable.
Explainability considerations apply to specific high risk contexts, and
even there the requirement is for meaningful documentation and
transparency. The Act isn't asking for that.

It does **not** ban AI in hiring. It puts hiring AI in the high risk
category, which means real compliance obligations and human oversight
requirements. The Act requires accountability. Hiring AI can still ship.
It just has to earn the right.

It does **not** regulate AI used purely for internal purposes with no
impact on external individuals. It does not cover AI used for national
security or military purposes.

Registration and conformity assessment apply specifically to high risk
systems. The vast majority of AI applications face no such requirement.

Think of the Act as a market regulation. It sets standards for placing
AI systems into the EU market. Liability for what goes wrong after the
fact is handled by separate frameworks.

The Act also isn't finished evolving. It includes provisions to update
the high risk category list as AI capabilities and risk patterns change.
What's outside scope today could be added.

## A Practical Timeline

Understanding where you are on the rollout calendar matters.

The prohibited AI practices (unacceptable risk tier) became enforceable
in February 2025. Rules for general purpose AI models came into force
August 2025. The full high risk AI system requirements under Annex III
are effective August 2026. Requirements for high risk AI embedded in
safety components of regulated products (things like medical devices and
industrial machinery) follow in late 2027.

If your system is in the high risk category under Annex III, the
deadline has arrived. If you're in the product safety category, you have
more runway, but start soon.

## The Honest Takeaway

The EU AI Act is the most significant AI regulation in effect anywhere
in the world. It's also more targeted and more proportional than its
reputation suggests.

For most software teams, the immediate question is simple. Do any AI
systems you build or operate fall into the high risk categories? If the
answer is yes, the compliance work is real but manageable. And it maps
onto the kind of rigorous engineering practice a serious team should be
doing anyway. Documentation, logging, human oversight, data governance.
These aren't alien concepts. They're what good teams do when they're
building systems that make important decisions about people.

If the answer is no, your obligations are mostly transparency
disclosures and the laws already in force.

Start with the audit. That's not a bureaucratic exercise. It's the
engineering discipline of knowing what you've built and being honest
about what it does to real people.
