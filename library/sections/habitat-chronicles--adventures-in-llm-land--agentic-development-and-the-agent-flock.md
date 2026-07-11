---
title: Agentic development and the agent flock — multiple independent entities working on your behalf, managed like brilliant-but-naive junior developers
source_kind: web-essay
source_url: https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/
source_content_sha256: a4ddab90a5eb77fac616b8e9177dc7555f9086c787dad0ff39b4010f94094cc9
source_author: Chip Morningstar
source_date: 2026-02-18
ingested: 2026-07-11
ingested_by: scholar
topics: [agent-fleet-orchestration, llm-agent-frameworks]
status: current
---

## Abstract

Morningstar's account of what "agentic" development actually feels like, and why the
right mental model for it is **engineering management, not solo programming**. The
shift to "agents" terminology, he suspects, tracks a real structural fact: the tools
make it easy to have "multiple independent entities ('agents!') doing work on your
behalf at the same time." The recurring analogy — one he says several people he knows
have independently reached — is that each tool behaves like **a junior programmer
hired straight out of school**: super-smart, current on all the latest techniques,
energetic, but "prone to leaping before they look and completely lacking in the kinds
of common sense and taste that come with having spent a few years in the trenches."
The productive posture is therefore the one an engineering manager already knows:
*software-development-at-a-higher-level-of-abstraction*, directing a flock of capable
but naive actors — now "without HR procedures or organizational politics." This is
the human-facing intuition behind the garden's own fleet: many bounded-authority
gardeners, each brilliant-but-naive in a role, supervised rather than hand-coded.

## Content

Morningstar suspects the drift from "vibe coding" to **"agentic" development** is not
purely marketing. Part of it, he thinks, is structural:

> Possibly this terminology shift has to do with the fact that these tools make it
> easy to have multiple balls in the air at once, leading you to have multiple
> independent entities ("agents"!) doing work on your behalf at the same time.

The dominant metaphor his peers reach for is a **new junior hire**:

> A few people I know have likened these tools to a junior programmer who your team
> hired straight out of school: someone who is super smart, very knowledgeable about
> All The Latest Things The Cool Kids Are Using, and energetic in the way that only
> naive young people can be, but also prone to leaping before they look and
> completely lacking in the kinds of common sense and taste that come with having
> spent a few years in the trenches.

He endorses the metaphor from experience:

> This is pretty much consistent with my experience. It really *is* like managing a
> flock of recent MIT grads with masters degrees in computer science but no real
> world work experience. Fortunately for me, managing energetic, scary smart, but
> absurdly naive developers is something I've done previously in my career with
> reasonably good success, so I'm pretty comfortable with this as a process. In a
> lot of ways this is better; I've always found the
> engineering-management-as-software-development-at-a-higher-level-of-abstraction
> mindset very enjoyable and satisfying, but now you can do it without HR procedures
> or organizational politics.

The concrete texture of that management is the two months he spent "coaxing and
prodding the fool thing" on his first project — issuing the kinds of corrections you
would give a naive but capable subordinate: *"when you update one field of a record,
don't change any of the other fields," "when you have several different related pages
on a site all displaying textual data, they should all use the same font," "when you
make a change to the code to add or fix a feature, all the other stuff that
previously worked should continue to work, and in the same way as before."* On net it
took considerably less of his time than doing it all himself would have — "it's just
I would have made completely different mistakes and gone down completely different
blind alleys."

The load-bearing takeaway for a fleet designer: the unit you supervise is a *flock of
independent, capable-but-tasteless actors*, and the skill that scales it is
engineering management (setting direction, catching naive mistakes, keeping already-working
things working), not line-by-line authorship.

Source: [Adventures In LLM Land, With Thoughts On The AI Revolution](https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/) by Chip Morningstar, 2026-02-18 (content sha256 `a4ddab90`).
