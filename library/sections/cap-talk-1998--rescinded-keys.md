---
title: "Rescinded keys and select-like service (revocation must be indistinguishable; the fixed thread table)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Charles Landau, Jonathan S. Shapiro]
source_date: 1998-03-31
thread_subject: "rescinded keys / Select-like service"
ingested: 2026-09-16
ingested_by: scholar
topics: [revocation, capability-security]
status: current
---

Abstract: Charles Landau (drawing on KeyKOS/EROS practice) on the representation of *rescinded keys*, and Shapiro on EROS's fixed-size thread table. Landau's revocation point is a design principle of independent interest: **a rescinded key must return a message just like any other key** — revocation must be *indistinguishable* from a live-but-unhelpful object, so that a server implementing many logical objects behind one key can emulate "this object has been rescinded," and so a process losing a race can act like a rescinded resume key before committing suicide. He therefore sees little value in giving rescinded keys a distinguishable representation (EROS overloads `DK(0)` for zero, node-slot initialization, and rescinded keys alike). The paired `Select-like service` thread shows EROS wrestling with "thread pressure" from support threads that only wait-then-kickstart, and a proposed `select`-style primitive — early evidence of the fixed-resource-table constraint that shapes EROS's whole design.

## Rescinded keys must be indistinguishable

> But it is necessary for a rescinded key to return a message just like any other key. Consider the model in which a single server process implements several "objects" distinguished by the data byte of start keys. To make it look like some, but not all, "objects" have been rescinded, the server has to emulate a rescinded key.

> Another example: Process A invokes a start key to process B. B gets the resume key. B is part of a complex of processes that, in a race with A, decide to shut down. To resolve the race, B has to act like a rescinded key to the resume key before committing suicide.

Landau's conclusion: "Given this, I don't see a lot of value in distinguishing rescinded keys." `DK(0)` (data key zero) is overloaded for three functions — holding the number zero, initializing new node slots, and representing rescinded keys — and while nothing architecturally forbids distinguishable keys for these, Landau sees no value in it. This *indistinguishability of revocation* is a subtle contrast with later Endo/E revocation designs, where a broken reference is a distinguishable terminal state a client can react to (`_whenBroken`); see [Concurrency Among Strangers §9](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch.md).

## The fixed thread table and select

Shapiro (forwarded from the eros-arch list) worried about "thread pressure": domains needing many support threads whose whole job is "wait for something interesting to happen on a capability, turn around and kickstart some process," a structure forced on any domain accepting input from multiple sources (his example: an X-server multiplexing mouse, keyboard, and connections). "The problem is exacerbated by the fact that EROS has a fixed-size thread table." He floated a `select bit-vector -> bit-vector` primitive of "equal stature to that of the CALL/RETURN/SEND primitives." Landau's reply argued `select` "doesn't solve the problem" (out-of-order server replies still block support threads) and that thinking about what useful computation the support threads could do "often improves the structure ... you end up with a better object-oriented design." The fixed-size kernel table constraint is the same one that made challenge-2's dynamic kernel allocation "intractable" in the [challenge problems](cap-talk-1998--acl-vs-capability-challenge-problems.md).

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), messages from Charles Landau and Jonathan S. Shapiro, 1998-03-31.
