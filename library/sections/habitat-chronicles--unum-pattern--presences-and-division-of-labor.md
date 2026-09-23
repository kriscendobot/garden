---
title: Presences and division of labor (not master/replica)
source_kind: web-essay
source_url: https://habitat-chronicles.com/2019/08/the-unum-pattern/
source_content_sha256: 7d099818689a2f196889f1602187a7c6a79110e80f1baa7c4a2bab88952e81dd
source_author: Chip Morningstar
source_date: 2019-08-28
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects, change-propagation]
status: current
---

## Abstract

The portion of a unum residing on a particular machine is a **presence**; the
teacup unum has a presence on the server and a presence on each client. The most
common misreading — and the one Morningstar most wants to head off — is to treat
the server presence as the "real" unum and the client presences as cached
shadow-copies or proxies kept coherent by a data-replication framework. That
*is* buildable (many commercially successful MMOs work that way) but it is **not**
the unum model. The fundamental concept presences embody is **not master vs.
replica but division of labor**: each presence has distinct responsibilities in
the joint work of being the unum, each is authoritative about different aspects of
the unum's existence, and each typically holds **private state it does not share**.
The client presence owns display-side concerns (3D rendering, animation, user
controls); the server presence owns shared-world concerns (the physical model, the
teacup–table interaction) and may hold secrets (a hidden flaw, an inscribed
message revealed only to a client holding a magic amulet). This asymmetric-
information structure is exactly what pure data-replication schemes accommodate
awkwardly — the reason the unum model does not reduce to replication.

## Content

The objects that realize a unum do live at particular memory addresses in
particular computers. The unum, in contrast, has a **distributed existence**. The
portion of the unum that resides in a particular machine is a **presence**. The
teacup unum thus has a presence on the server and presences on each client
machine. The client presences are concerned with **presenting** the unum to their
local users; the server presence is concerned with keeping track of the portion of
the unum's state that all users share.

Many people find the presence abstraction natural, but it can lead them to jump to
conclusions. Because implementers of distributed systems often build on frameworks
providing **data replication**, it is easy to fall into thinking of the server
presence as the "real" version and the client presences as shadow copies that
cache a (perhaps slightly stale) representation of the true state — or as proxies.
This is not exactly wrong (you can build systems that work this way, and many
distributed applications, possibly including most commercially successful MMOs,
do), but it is not the model being described here.

One problem with data-replication schemes is that they do not gracefully
accommodate use cases that require some information be **withheld** from some
participants — not that you can't, but it cuts against the grain. It is not just
that the server is authoritative about shared state; the server is also allowed to
take into account **private state the clients don't have** in order to determine
how shared state changes over time and in response to events.

A server presence and a client presence are not doing the same job. The underlying
concept is **division of labor**. Each has distinct responsibilities in the joint
work of being the unum; each is authoritative about different aspects; each
typically maintains private state of its own. In the client-server example, the
client presence manages client-side concerns — 3D rendering, animation sequencing,
presenting controls for the user to manipulate the teacup. The server keeps track
of the physical model within the world — the interactions between the teacup and
the table. Each presence knows things that are none of the other's business,
either because the information is outside the other's scope (the current animation
frame; the force on the table) or because the other is **not supposed to know** it
(the server knowing this teacup has a hidden flaw that will break it into pieces —
revealing a secret message on the broken edges — if hot water is poured in).
Different client presences may also withhold information from each other for
function or privacy: one client renders 3D in a GUI while another shows only a
textual description with a command line; the server may reveal the secret message
to my client and to none of the others because I possess a magic amulet that lets
me see such things.

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
