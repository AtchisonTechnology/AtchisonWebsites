---
title: Working as Intended
subtitle: ""
author: Lee Atchison
status: published
created: 2026-07-17
date: 2026-05-18
published_on: 2026-05-18

sai_url: https://softwarearchitectureinsights.com/posts/working-as-intended
email_sent: 2026-05-18
linkedin_url:

hero_image: working-as-intended.png

internal_note:
meta_description: "Five AI systems that caused real harm without a single bug: Amazon's biased hiring tool, a healthcare algorithm, COMPAS, facial recognition, and Apple Card."
slug: working-as-intended
description: >
  Five real AI deployments — Amazon's biased hiring tool, a healthcare triage algorithm, COMPAS recidivism scoring, a wrongful facial-recognition arrest, and the Apple Card — caused serious harm without a single line of buggy code. The harm was upstream, in proxy-variable and fairness-definition choices engineers made without recognizing them as ethical decisions.
categories:
  - "AI Ethics & Responsibility"

---

There's a phrase you've probably typed into a ticket at some point in
your career. Maybe someone filed a bug. Maybe a customer complained. You
looked at the system, traced the behavior, and confirmed that the output
was exactly what the logic should produce. So you closed it:

**Working as intended.**

It's the cleanest possible resolution. It means the system did what the
system was supposed to do. It means the problem, if there is one,
belongs to someone else: product, policy, legal, whoever wrote the
requirements. Your code is correct.

*Your job is done.*

That phrase is doing a lot of quiet harm right now. And I don't think
most of the engineers who write it realize it.

Over the last decade, some of the most damaging AI deployments in the
world were closed with exactly that ticket resolution. The systems
performed. The models converged. The metrics looked great. And then real
people, people trying to get jobs, access healthcare or simply stay out
of prison, experienced outcomes that were unjust, discriminatory, or
outright dangerous.

The cause wasn't bugs. It was decisions made at the whiteboard and in
requirements meetings. It was decisions made in the quiet moments when
the definition of "success" got locked in and nobody asked whose success
we were actually optimizing for.

*And the result was real damage to real people.*

Here are five of those systems.

## 1. Amazon's Hiring AI: The Resume That Penalized Women

In 2014, Amazon began building an AI tool to automate resume screening.
The goal was reasonable. They received enormous volumes of applications,
and they wanted a system that could surface the best candidates faster.
The engineering team trained it on a decade of resumes that Amazon had
previously reviewed, feeding the model a historical record of what good
candidates looked like.

The system learned. And what it learned was that Amazon had historically
hired mostly men.

By 2015 the team had discovered that the model was systematically
downgrading resumes that contained the word "women's," as in women's
college, women's chess club, women's professional network.

It was penalizing graduates of *women's colleges*.

It had taught itself that language patterns coded as male were
predictive of success because those patterns were what success had
looked like for the previous ten years.

Amazon scrapped the tool in 2017 and [Reuters published the story in
2018](https://www.reuters.com/article/us-amazon-com-jobs-automation-insight/amazon-scraps-secret-ai-recruiting-tool-that-showed-bias-against-women-idUSKCN1MK08G).

Here's the engineering decision worth sitting with. The team chose to
train the model on historical hiring outcomes as a proxy for candidate
quality. That is a choice that sounded entirely reasonable. Outcomes are
measurable. The data existed. The alternative, defining candidate
quality in some other way, is harder, more contested, and requires
judgment calls that a purely data driven approach seems to avoid.

But historical outcomes don't measure quality. They measure who got
hired.

Those are not the same thing, especially in a workforce with documented
gender disparities. The moment you optimize for historical decisions,
you optimize for historical biases. The system was working as intended.
The intent was the problem.

## 2. The Healthcare Algorithm That Decided Black Patients Were Less Sick

In 2019, a study [published in
*Science*](https://www.science.org/doi/10.1126/science.aax2342) revealed
that an algorithm used by major U.S. health systems to identify patients
who needed intensive care management was systematically directing that
care away from Black patients, even when those patients were equally
sick.

The researchers estimated that the bias was reducing the share of Black
patients referred to care management programs by more than half.

The algorithm hadn't been designed to consider race. What it did do was
it used healthcare cost as a proxy for healthcare need. The logic made
intuitive sense at the time. Patients who require more care cost more,
so patients with higher predicted costs probably need more care.

The problem is that this assumes healthcare costs accurately reflect
healthcare needs. They don't. Black patients have historically received
less care than white patients with equivalent conditions, a disparity
rooted in structural factors throughout the healthcare system. So their
historical costs were lower.

As a result, the algorithm predicted they would cost less. Costing less
meant they were less sick. So they received less care.

The model worked correctly. It predicted costs accurately. What it could
not do, and what nobody asked it to do, was account for the fact that
the data it was trained on was itself the output of a biased system.

This is the proxy variable trap, and it shows up everywhere in AI
development. When a team can't directly measure what they care about,
they substitute something they can measure. Cost for need. Click through
rate for user satisfaction. Arrest history for criminality. The
substitute is almost always easier to quantify. It's almost always a
worse choice. And it's almost never explicitly flagged as an ethical
decision, because it feels like a technical one.

## 3. COMPAS: The Recidivism Score That Wasn't Neutral

COMPAS (Correctional Offender Management Profiling for Alternative
Sanctions) is a risk assessment tool used by courts across the United
States to inform decisions about bail, sentencing, and parole. It
produces a score between one and ten indicating the likelihood that a
defendant will reoffend.

In 2016, [ProPublica published an investigation called *Machine
Bias*](https://www.propublica.org/article/machine-bias-risk-assessments-in-criminal-sentencing).
Their finding was stark. COMPAS was nearly twice as likely to
incorrectly flag Black defendants as high risk compared to white
defendants, and nearly twice as likely to incorrectly rate white
defendants as low risk when they would go on to reoffend.

The company that built COMPAS, Northpointe, pushed back. Their argument
was technically accurate. The algorithm was calibrated. Among defendants
who scored, say, a seven, the proportion who reoffended was roughly the
same regardless of race. By one definition of fairness, the tool was
working correctly.

*Working as intended.*

But there are multiple definitions of fairness, and they are
mathematically incompatible with each other. A system can be calibrated
for one thing while still producing unfair results in another area. You
can't, unfortunately, have it both ways. This is a reality of
statistics, not a policy preference.

The engineers who built COMPAS chose a definition of fairness. They may
not have meant to make a decision like that, but they did. They probably
thought they were just building an accurate model. But the choice of
what "accurate" means, which errors are acceptable, which kind of
fairness to optimize for, is an ethical decision. This ethical decision
was embedded inside what looks like a purely technical one. It shapes
who goes to prison and for how long.

Working as intended. Intended by people who never had to sleep on what
"intended" would mean for the person sitting across from a judge.

## 4. Robert Williams and the Arrest That Shouldn't Have Happened

On January 9, 2020, [Robert Williams was
arrested](https://www.washingtonpost.com/opinions/2020/06/24/i-was-wrongfully-arrested-because-facial-recognition-why-are-police-allowed-use-this-technology/)
in his driveway in front of his wife and daughters. Detroit police
suspected him of shoplifting watches from a Shinola store. He spent
thirty hours in detention before being released.

He hadn't done it. The real shoplifter had been caught on surveillance
video inside the store. Detroit police had run that image through a
facial recognition system, and the system had returned a match. Robert
Williams.

Williams is Black. The surveillance footage was grainy. The match was
wrong.

The facial recognition algorithm had produced a match. That's what it
was designed to do. Surface potential matches from a database. It
worked. It matched. The problem was in everything that surrounded the
algorithmic output. The threshold at which a "match" was considered
actionable. The absence of any meaningful human verification protocol
before an arrest warrant was issued. The deployment decision to use a
system with documented higher error rates for darker-skinned faces in a
law enforcement context.

The algorithm didn't arrest Robert Williams. The system around it did.
But the engineers who designed the algorithm, who knew or should have
known about the differential accuracy rates across skin tones, and the
product team that decided this was ready for law enforcement deployment,
were all part of that system.

Williams is one of the documented cases. He was not alone. Researchers
and civil liberties organizations have documented multiple wrongful
arrests tied to facial recognition matches across the United States in
the years since. In nearly every documented case, the person arrested
was Black.

The engineering question isn't whether to build facial recognition. It's
whether, given what you know about the error characteristics of your
model, you should deploy it in a context where a false positive gets
someone arrested. That is a decision engineers make. It is not a
conversation that happens after launch.

## 5. The Apple Card and the Gender-Neutral Algorithm

In November 2019, David Heinemeier Hansson, the creator of Ruby on
Rails, [posted a thread on Twitter that went
viral](https://x.com/dhh/status/1192540900393705474). He had received an
Apple Card with a credit limit twenty times higher than the one offered
to his wife. This was despite the fact that they filed joint tax
returns, owned assets jointly, and by his account, his wife had a higher
credit score than he did.

Others reported similar experiences. The New York Department of
Financial Services launched an investigation. Goldman Sachs, which
issued the Apple Card, said the algorithm did not use gender as a
variable.

That statement was almost certainly true. It was also almost certainly
irrelevant.

Credit scoring models use dozens of variables: income, credit history,
types of accounts held, credit utilization, length of credit history.
Many of these variables correlate with gender.

No one programmed that in. It emerged from the financial behaviors the
model was measuring, which have historically differed between men and
women because of decades of structural inequality in wages, employment,
and financial access.

When you train a model on historical financial data, you bake in the
financial history that data reflects. The model learns that a certain
cluster of financial behaviors is associated with creditworthiness. That
cluster can look an awful lot like "has always had uninterrupted income"
or "has never taken time off to raise children" without ever touching a
gender field.

Goldman didn't need to include gender. The signal was already there,
encoded in the features they did include.

The investigation ultimately found no violation of fair lending laws,
which tells you something about the laws and not necessarily about the
outcomes. The engineering team built a model that was legally compliant
and technically sophisticated. Whether they asked themselves what
patterns in this feature set correlate with gender, and what they wanted
to do about that, is not a matter of public record.

## The Through-Line

Five different domains. Five different companies. Five teams of
engineers who, by any reasonable standard, were doing their jobs well.

None of these systems had bugs in the traditional sense. None of them
were hacked or corrupted. They converged on their training objectives,
passed their evaluations, and shipped. They produced the outputs they
were designed to produce.

The harm was upstream. It was in the training data nobody questioned
closely enough. In the proxy variable that seemed reasonable until it
wasn't. In the fairness definition chosen without acknowledging it was a
choice. In the deployment context where someone decided the model was
good enough even knowing its error characteristics. In the feature set
nobody pressure-tested for historical bias.

Those are engineering decisions. They happen in the part of the process
where engineers are actually working, not in some compliance review that
happens later, not in a policy meeting that engineers aren't invited to.
They happen in Jupyter notebooks and data pipelines and architecture
discussions and sprint planning.

The engineers who made those decisions weren't malicious. Most of them
probably never thought of themselves as making an ethical choice at all.
The issue isn't that AI engineers are bad people. We've built a
profession where the ethical dimensions of technical decisions are
systematically invisible, right up until they end up in a congressional
hearing or a federal lawsuit or a wrongful arrest.

The question isn't whether AI systems will cause harm. Some already
have. More will. The question is whether the engineers building them
will have the frameworks, the vocabulary, and the professional
expectation to catch the next one before it ships.

That starts with treating proxy variable selection as a design decision,
not a data shortcut. It starts with asking whose outcomes your training
data actually reflects. And it starts before the model ships, not after
the lawsuit.
