---
title: Representational (descriptive) vs. imperative (behavioral) — the resource conceit and its asymmetry
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects, networking]
status: current
---

## Abstract

The conceptual heart of the essay, and its direct tie to the object/distributed-object
lineage. REST conceptualizes every important application abstraction as a **resource**
manipulated by passing around **representations** of it; REST applications relate to
their resources in a **descriptive / representational mode**, and their world consists
mainly of data objects whose primary characteristic is their **current state**. For that
world REST is a good match — and Morningstar credits much of REST's traction to the fact
that many applications we want to build fit that mold. But traditional architectures
relate to resources in an **imperative mode**, aligned with a universe of **functional
objects whose primary characteristic is their behavior**. Since many applications can be
conceived either way, REST advocates argue for the representational stance as a better
fit to the web's affordances — yet **where the important entities genuinely exhibit a
complex behavioral repertoire, a RESTful interpretation is much more strained**. He then
names a **profound asymmetry**: framed as nouns and verbs, REST has a small *fixed* set of
verbs over an open space of nouns, whereas imperative frameworks leave *both* nouns and
verbs open. It is easy to reframe everything RESTful in imperative terms, but hard to go
the other way — which is why so many nominally-RESTful systems drift back into the
imperative camp, since "the mere adoption of design elements taken from REST (HTTP! XML!
JSON!) does not prevent the easy drift." This is the **affirmative counterpart** to the
unum pattern's "behavioral, not data — about as anti-REST as you can be" claim
([habitat-unum](../concepts/habitat-unum.md)): the same descriptive-vs-behavioral fault
line, argued from the REST side.

## Content

One of the fundamental ideas underlying REST is the conceptualization of every important
application abstraction as a **resource** that is manipulated by passing around
**representations** of it. Although the term "resource" is sufficiently vague and general
that it can be repurposed to suit almost any need, REST applications typically relate to
their resources in a **descriptive mode**. The worlds that REST applications deal with
tend to consist mainly of **data objects whose primary characteristic is their current
state**; for this, REST is a good match. Morningstar thinks a key reason REST has gotten
as much traction as it has is that many of the applications we want to develop fit this
mold.

In contrast, more traditional architectures — the ones REST self-consciously sets itself
apart from — typically relate to their resources in an **imperative mode**. This aligns
well with an application universe consisting mainly of **functional objects whose primary
characteristic is their behavior**. Since many kinds of applications can be conceived of
either way (representational or behavioral), the advocates of REST would argue that you
are better off adopting the representational, descriptive stance, as it is a better fit
to the natural affordances of the web ecosystem. **However, in cases where the important
entities you are dealing with really do exhibit a complex behavioral repertoire at a
fundamental level, a RESTful interpretation is much more strained.**

Note also that there is a **profound asymmetry** between these two ways of
conceptualizing things. If you think of a distributed application protocol abstractly in
terms of nouns and verbs, **REST deals in a small, fixed set of verbs while the space of
nouns remains wide open**. In contrast, traditional, imperative frameworks also support a
completely open space of nouns but then go on to allow the space of verbs to be similarly
unconstrained. It is very easy to frame everything that RESTful systems do in imperative
terms, but it can be quite difficult to go in the other direction. This may account for
why so many systems supposedly designed on RESTful principles fall short when examined
with a critical eye by those who take their REST seriously: **the mere adoption of design
elements taken from REST (HTTP! XML! JSON!) does not prevent the easy drift back into the
imperative camp.**

## See also

- [habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest](habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest.md) — the counterpart argument from the distributed-object side: unum message interfaces are about *behavior, not data*, and behavioral protocols out-compress data-replication ones, so "the unum pattern is about as anti-REST as you can be."

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
