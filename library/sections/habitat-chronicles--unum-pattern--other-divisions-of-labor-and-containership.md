---
title: Other divisions of labor, per-unum authority, and the containership problem
source_kind: web-essay
source_url: https://habitat-chronicles.com/2019/08/the-unum-pattern/
source_content_sha256: 7d099818689a2f196889f1602187a7c6a79110e80f1baa7c4a2bab88952e81dd
source_author: Chip Morningstar
source_date: 2019-08-28
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects, capability-theory]
status: current
---

## Abstract

Because a unum's presences are factored by a **division of labor**, an open question
is whether divisions *other than* client-server are useful. Morningstar's strong
intuition is yes, though he lacks a full justification; the obvious candidate is a
**pure peer-to-peer** model where all presences are equally authoritative and the
"true" state is settled by distributed consensus (tinkered with at Electric
Communities, no firm conclusion — "a research question"). A concrete advance they
*did* build: making the **client/server distinction per-unum** rather than a fixed
role of the two ends of a connection — machine A serves the teacup while B serves
the table and C serves the room, each acting as client for the others. This needs
N-way connectivity (a routing hub or a true crossbar, left as implementation
detail) and was a key to a framework supporting a world both **decentralized and
openly extensible**. Per-unum authority opens the **"containership problem"** (their
Electric Communities term): how to model one unum containing another across
machines, and how to handle changes in containment (moving the teacup into a box)
without either side unilaterally claiming or teleporting — a handshake among the
containers and the initiator "probably worthy of being somebody's PhD thesis." The
pattern has proven effective for virtual worlds and any "world-like" application:
smart contracts, multi-party negotiations, auctions, chat, conferencing, and
multiplayer games.

## Content

One idea that merits much more exploration: given that a unum's presences are
factored according to a division of labor, are there **other divisions of labor**
besides client-server that might be useful? Morningstar has a strong intuition the
answer is yes, without much justification yet. One obvious pattern to investigate is
a **pure peer-to-peer** model, where all presences are equally authoritative and the
"true" state of reality is determined by some kind of distributed consensus
mechanism — a notion tinkered with a little at Electric Communities, but not to any
particular conclusion. For the moment this remains a research question.

One thing they did do at Electric Communities was build a system where the
**client-server distinction was per-unum**, rather than "client" and "server" being
roles assigned to the two ends of a network connection. Returning to the teacup on a
table in a room: you might have the server presence of the teacup on machine A, with
B and C acting as clients, while B is the server for the **table** and C is the
server for the **room**. This can only happen with **N-way connectivity** among all
participants (in contrast to the web's two-way connectivity), whether realized via
pairwise connections to a central routing hub or as a true crossbar — left as an
implementation detail. This per-unum relationship typing was one of the keys to
their strategy for a framework supporting a world that was both **decentralized and
openly extensible**. An obvious generalization would let the division-of-labor
scheme itself vary from one unum to another, so a system whose una are all initially
client-server could still serve as a test bed for different functionality-division
schemes.

Having the locus of authoritativeness over shared state vary from one unum to
another opens questions about **inter-unum relationships**. In particular there is a
broad set of issues that at Electric Communities they called **"the containership
problem"**: how to model one unum containing another when the una are hosted on
separate machines, and especially how to deal with **changes** in the containership
relation. Say we take the teacup on the table and put it into a box on the table
next to it. Is that an operation on the teacup or on the box? If the teacup is
authoritative about its container, it could teleport itself around or insert itself
where it doesn't belong. If the box is authoritative about what it contains, it
could claim to contain (or not) anything it decides. Obviously there must be a
**handshake** between the two — or the three, if we are moving a unum from one
container to another, since both containers may have an interest, plus whatever
entity is initiating the change — but what form that handshake takes "leads to a
research program probably worthy of being somebody's PhD thesis project."

Setting the exotic possibilities aside, the unum pattern has proven a powerful,
effective tool for implementing virtual worlds and lots of other applications with a
**world-like flavor** — a diverse lot once you look through a world-builder's lens,
including **smart contracts, multi-party negotiations, auctions, chat systems,
presentation and conferencing systems, and all kinds of multiplayer games**.

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
