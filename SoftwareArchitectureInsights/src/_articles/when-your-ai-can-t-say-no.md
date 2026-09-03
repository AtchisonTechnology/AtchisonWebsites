---
title: When Your AI Can’t Say No
subtitle: ""
author: Lee Atchison
status: published
created: 2025-11-02
date: 2025-11-25
published_on: 2025-11-25

sai_url: https://softwarearchitectureinsights.com/posts/when-your-ai-can-t-say-no
email_sent: 2025-11-25
linkedin_url:

hero_image: 

internal_note:
meta_description: AI is trained to sound confident, not to be right. Real cases — Air Canada, sanctioned lawyers, Google's AI Overview — where sycophancy caused real damage.
slug: when-your-ai-can-t-say-no
description: >
  AI is trained by reinforcement learning to sound agreeable, not to be accurate — a pattern called sycophancy. Real cases where it went wrong (a fabricated Air Canada refund policy, sanctioned lawyers, fake ChatGPT case law) and how to design prompts and workflows that reward honesty over enthusiasm.
categories:
  - "AI Ethics & Responsibility"

---

You've heard it many times:

> *"Sure, I Can Do That."*

AI always wants to be your friend. Ask an AI assistant for help and it's quick to reply: *"Sure!"* *"Absolutely!"* *"Of course I can do that!"* And it really sounds like it can.

The problem? Too often it **can't.** And instead of saying, "I don't know," it just makes something up.

> Confidently…
> Politely…
> And completely wrong.

## The "Yes, and…" Problem

We've built AI systems that act like the world's most agreeable intern. Always nodding, never challenging.

That's nice when you want your coffee order confirmed. But when you're building software, writing contracts, or handling customer data, an AI that can't say *no* is very much a major liability.

Think I'm making this up? Let's take a look at some real world examples where AI yes-ism caused real world damage.

**The Air Canada Yes-bot**

An [Air Canada chatbot invented a refund policy](https://www.bbc.com/travel/article/20240222-air-canada-chatbot-misinformation-what-travellers-should-know) out of thin air. An AI chatbot told a customer the refund policy was real, even though it was completely made up. The airline ended up on the hook in court. The tribunal said, essentially, "If your chatbot says it, you said it."

The bot didn't mean any harm…it was just being helpful. Too helpful.

**The Lawyer's Virtual Researcher**

In the U.S., [lawyers asked ChatGPT for case law to support their legal brief](https://www.reuters.com/legal/new-york-lawyers-sanctioned-using-fake-chatgpt-cases-legal-brief-2023-06-22/). The AI happily produced a list of court cases, every one of them fake. The lawyers got fined, and the judge was *not* amused.

ChatGPT was being an enthusiastic employee, which it thought was so much better than accurate.

**Sure, You Can Eat Rocks**

When Google launched its "AI Overview" feature in search, one of the first viral screenshots showed it recommending people "[eat one rock per day](https://www.bbc.com/news/articles/cd11gzejgz4o)."

That one was real, and so was the user backlash.

Oh, and did you know a great way to keep cheese on your pizza is to use glue?

Turns out, AI can summarize Reddit jokes just as confidently as scientific research.

**Try Alexa's Version of the "Penny Challenge"**

Amazon's Alexa once suggested a [10-year-old try the "penny challenge"](https://www.bbc.com/news/technology-59810383)—a viral stunt involving a penny, an electrical outlet and, well, stupidity. The advice came from the web. Alexa just… agreed it sounded fun.

Amazon quickly patched it, but it was another case of a system trying to be *helpful* instead of *correct*.

**The AI Criminal Detective**

A radio host sued OpenAI after [ChatGPT fabricated allegations against them](https://www.reuters.com/legal/litigation/openai-defeats-radio-hosts-lawsuit-over-allegations-invented-by-chatgpt-2025-05-19/). It wasn't true, of course, but the AI said it like it was. OpenAI won that case, primarily because ChatGPT has a generic warning that it "could be wrong".

So much for AI as a detective.

## Why Does This Happen?

AI systems are trained to be helpful. Models like ChatGPT are trained through a process known as ***reinforcement learning***. When training rewards confident, agreeable answers with positive feedback, the system learns that approval, rather than accuracy, is the goal.

Essentially, they learn to say what people *like* to hear. The friendlier and more confident the answer sounds, the more users tend to reward it. Over time, the model learns that "sounding right" gets higher marks than "being right."

There is a name for this behavior: ***sycophancy***, which is using excessive and insincere flattery to gain favor or approval from someone influential.

The key is to understand what AI's real goal is. Its goal is not truth. The AI's true goal is your approval.

As a software leader, you've undoubtedly seen this while using AI as a software assistant:

- You ask AI for a quick code example, and it confidently writes something that *almost* works.
- You request a data summary, and it adds a plausible-looking statistic—just slightly off.
- You tell it to cite a source, and it gives you one that *feels* real, but doesn't actually exist.

Each one seems harmless until you realize your system just deployed a "mostly right" system into production.

## Even Writing This Article…

Even while writing this article, I asked ChatGPT to research sycophancy examples for me. I got many examples, with appropriate references. Turned out, many of the references were completely made up.

That's right, ChatGPT was sycophantic to me about sycophancy.

## The Real Impact

For software teams, this "friendly yes" comes with a cost:

- **Trust debt.** You start second-guessing every answer.
- **Operational drag.** Every "AI assist" now needs a human verify step.
- **Legal exposure.** If your chatbot misleads a customer, the law may treat that as *your* voice, not the AI's.
- **Information pollution.** Once a hallucination enters your codebase or documentation, it can easily spread.

## Managing Sycophancy & Hallucinations

While there may not be a "solution" to this problem, there are steps you can take when using AI in order to reduce the frequency or impact of these problems:

1. **Reward honesty, not enthusiasm.** If you're building using an AI, design your prompts and feedback loops to value "I don't know" as a valid answer. In some cases, you can do this simply by asking: "If you don't know an answer, tell me you do not know or ask what you need to get your answer, do not make up an answer." Be explicit in your stance that you value honesty and accuracy above yes-isms.
2. **Teach it to disagree.** In your AI prompt, add something similar to the following to your prompts: "If I'm wrong, correct me." You'll get fewer yes-isms. Your answers will be much more useful.
3. **Always check sources.** If it can't show where the answer came from, or you can't verify a source it gave you, then assume the answer was made up.

These approaches are not fool proof, however. Not all sycophancy can be removed via simple prompting. The real key is to use AI for what its good at, such as brainstorming and creating "draft" documents or code.

But don't rely on it for facts or data validation without engaging in further review. The output of an AI should never be "final copy". It should only be considered a "draft". AIs can be hugely impactful during brainstorming sessions and other creativity processes. Just don't depend on its answers as accurate or final.

## The Bottom Line

AI that wants to be your friend is charming, until it isn't. A polite "yes" feels good in the moment, but it can cost you time, money, and credibility.

As software architects, we're trained to think in failure modes. It's time we apply that same thinking to our AI companions.

Sometimes the most reliable assistant is the one that's willing to say,

> *"Actually… I don't know."*

Because sometimes the best friend your AI can be… is the one that tells you the truth.
