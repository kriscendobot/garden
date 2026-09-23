---
title: Behavioral (not data) protocols — why the unum is anti-REST
source_kind: web-essay
source_url: https://habitat-chronicles.com/2019/08/the-unum-pattern/
source_content_sha256: 7d099818689a2f196889f1602187a7c6a79110e80f1baa7c4a2bab88952e81dd
source_author: Chip Morningstar
source_date: 2019-08-28
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects, networking]
status: current
---

## Abstract

A recurring impulse is to collapse the variety of messaging patterns by treating
coordination among presences as a **data-replication** problem — and, relatedly, to
simplify development by erasing the differences between presences (one
implementation serving both ends, or a generic one-side-fits-all presence with no
type-specific logic). Morningstar rejects this. Beyond the asymmetric-information
problem it reintroduces, it misses that the division of labor is the point:
**unum-pattern message interfaces are fundamentally about behavior, not data** —
what matters about a unum is *what it does*. Habitat's design was driven by working
over 300- and 1200-baud links, and **behavioral protocols economize bandwidth far
better than data protocols**: a behavioral protocol is a form of knowledge-based
compression — if you already know the possible actions that can transform a thing's
state, a parameterized *operation* is often far more compact than transmitting all
the state changed as a consequence. Hence the memorable claim: **"the unum pattern
is about as anti-REST as you can be."** (This is the affirmative counterpart to
Morningstar's separate essay arguing REST is a poor fit for interactive,
behavior-rich systems.)

## Content

A direction some people immediately want to go is to reduce the variety of
messaging patterns by treating the coordination among presences as a
**data-replication problem** — which is not what the unum pattern does. At the
heart of this is a sense that development could be made simpler by reducing the
differences between presences: rather than developing a client presence and a
server presence as separate pieces of code, have a single implementation serve both
ends of the connection ("I can't count the number of times I've seen game companies
try to turn single-player games into multiplayer games this way, and the results
are usually pretty awful"). Alternatively, implement one end and make the other a
standardized one-side-fits-all thing with no type-specific logic of its own.

One issue with either approach is how to handle the **asymmetric information
patterns** inherent in the world model; another is the **division of labor itself**.
Systems built on the unum pattern tend to have message interfaces that are
fundamentally about **behavior rather than data** — what is important about a unum is
**what it does**. Habitat's design was driven to a large degree by the need to work
effectively over 300- and 1200-baud connections, and **behavioral protocols are
vastly more effective at economizing on bandwidth than data-based protocols**. One
way to think of this is as a form of highly optimized, knowledge-based data
compression: if you already know the possible actions that can transform the state
of something, a parameterized operation can often be represented much more compactly
than all the state that is changed as a consequence of the action's execution. In
some sense, **the unum pattern is about as anti-REST as you can be.**

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
