---
title: A Slightly Skeptical Perspective on REST — framing and the "is it REST?" trap
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [networking, distributed-objects]
status: current
---

## Abstract

Chip Morningstar's framing for a collection of skeptical-but-fair observations about
**REST** (Representational State Transfer), written out of his work in PayPal's
Central Architecture organization as teams across the company were putting RESTful
facades on services and asking how to proceed. The essay has no single unifying
thesis; it is a set of critical musings offered as an antidote to the **dogma** that
surrounds REST. Morningstar's first observation is that the dogma is ironically
rooted in the **lack of a clear, objective definition** of what REST actually is:
Roy Fielding, its originator, has been "a rather enigmatic oracle, issuing
declarations that are at once assured and obscure," leaving a wide spectrum of
interpretations for people to accuse each other of not hewing to. He therefore
declines the perennial **"is it *really* REST?"** definitional litmus test as
uninteresting — one should be concerned with *whether the thing works well for the
purpose to which it is put*, not with whether it passes a test whose terms nobody
agrees on. This is the affirmative, "steelman-then-critique" counterpart to
Morningstar's separate [unum-pattern](../sources/habitat-chronicles--unum-pattern.md)
essay's claim that behavioral distributed-object protocols are "about as anti-REST
as you can be."

## Content

A few years ago, the set of design principles traveling under the banner of **REST**
became the New Hotness in the arena of network services architecture. Morningstar
followed the development of these ideas casually until, as part of his work in the
**PayPal Central Architecture** organization, he had to do a deeper dive: parts of
the organization were increasingly standing up new services behind REST interfaces,
considering whether to put RESTful facades on existing services, or seeking guidance
on how to proceed with respect to "this whole REST fad."

For Morningstar, a key piece of absorbing a new technological idea is getting his own
head straight about how he feels about it — being "one of those people who isn't
entirely sure what he thinks until he hears what he says." What follows in the essay
is a collection of thoughts formulated in the course of that work, with no
overarching thesis unifying them beyond the hope that the musings might have some
value to others' cogitations. He warns in advance that some of it may make some
readers cranky and driven to "'splain things" to him — but he is already a little
cranky about the topic, so that will just make them even.

### Is it REST?

The first thing that strikes him is the level of **dogma** surrounding the concept of
REST. Ironically, this seems rooted in the **lack of a clear and reasonably objective
declaration of what it actually is**, leaving open a wide spectrum of interpretations
for people to accuse each other of not hewing to. Roy Fielding, the originator of
these ideas, has for his part succeeded in being "a rather enigmatic oracle, issuing
declarations that are at once assured and obscure." Morningstar once quipped that a
key requirement for whatever his group came up with should be that it *enable people
to continue arguing about whether any particular service interface was or was not
RESTful*, since the pervasiveness of such debates seems to be the signature element
of the REST movement.

Although he is generally very opinionated about technical matters, he has "zero or
less interest" in such debates. We should not be concerned with whether something
passes a definitional litmus test when people cannot agree on what the definition
even is; the concern should be **whether the thing works well for the purposes to
which it is put**. Consequently the "is it *really* REST?" question need not loom
large in one's deliberations — though it inevitably always seems to.

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
