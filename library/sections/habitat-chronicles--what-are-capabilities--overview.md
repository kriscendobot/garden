---
title: What Are Capabilities? — preliminary remarks and the term itself
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-theory]
status: current
---

## Abstract

The framing section of Chip Morningstar's canonical plain-language object-capability
explainer, written (at Alan Karp's prompting) as the "here, read this" introduction
the ocap literature lacked — everything else being *too long* (Mark Miller's PhD
thesis), *too old* (Dennis and Van Horn's seminal 1966 paper, the root of the family
tree), or *embedded* in a specific language (Stiegler's *E In A Walnut*, the Pony
tutorial), OS (KeyKOS, seL4), or application (smart contracts, distributed storage).
Morningstar first disarms the word **"capabilities"** itself — its everyday
software-engineering meaning ("what a system can do") collides with the technical
meaning ("what permissions it has been given") — and motivates the contraction
**"object capabilities" / "ocaps"**, which leans on the natural alignment between
capabilities and object-oriented programming to escape the lexical confusion. It also
warns the reader that the ideas carry *controversy* (part immune-response to
criticism, part academic tribalism, part healthy engineering wariness of novelty)
whose historical context colors the literature but not the ideas' merits.

## Content

At a gathering of coconspirators a couple of months before writing, **Alan Karp**
lamented the lack of a good, basic introduction to capabilities for people not
already familiar with the paradigm. There is plenty written, but it is all either
really long (Morningstar recommends Mark Miller's PhD thesis as "a great nerdy
read"), or really old (the root of the family tree is probably **Dennis and Van
Horn's seminal 1966 paper**), or embedded in explanations of specific programming
languages (Marc Stiegler's *E In A Walnut*, the capabilities section of the Pony
tutorial), operating systems (KeyKOS, seL4), things that *use* capabilities (smart
contracts, distributed file storage), or discussions of particular aspects (Norm
Hardy's many useful fragments). Nothing that is just a good "here, read this" to toss
at curious, technically-able people. So Karp gave Morningstar "a meaningful stare,"
and this essay is the result.

**The term itself is the first thing to confront.** "Capabilities" is confusing
because the word has a perfectly good everyday meaning even in software engineering:
at PayPal, people would talk about the system's *capabilities*, meaning what it can
do. The everyday meaning is actually close to the technical one — both are about what
a system "can" do — but the everyday sense means the *functionality* realized rather
than the *permissions* granted. One path out of the confusion takes its cue from the
natural alignment between capabilities and object-oriented programming (it is easy to
express capability concepts with OO abstractions). This has led, without much loss of
meaning, to the term **"object capabilities"**, abbreviated **"ocaps"**, sloughing
off some of the lexical confusion. The downside: some historically important
capability systems are not really object-oriented. "But sometimes oversimplification
is the price of clarity. The main thing is, just don't let the word 'capabilities'
lead you down the garden path; instead, focus on the underlying ideas."

**There is also controversy.** Part is a natural immune response to criticism (nobody
likes being told they are doing things all wrong), part is academic tribalism, and
part is the engineer's instinctive — and often healthy — wariness of novelty.
Morningstar almost hesitates to mention it, but it matters for reading the
literature: "some of the pushback these ideas have received doesn't really have as
much to do with their actual merits or lack thereof as one might hope; some of it is
profoundly incorrect nonsense and should be called out as such."

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
