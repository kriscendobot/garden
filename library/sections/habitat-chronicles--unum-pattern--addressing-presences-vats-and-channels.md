---
title: Addressing a unum — presences, vats, and message channels
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

Because a unum is not an object, "sending a message to a unum" really means
sending a message to some **presence** of that unum (a presence *is* an object). A
message address therefore needs **two components**: (1) the identity of the unum,
and (2) an indicator of which presence(s) you want to reach. In the systems
Morningstar built (Habitat and its descendant Elko), the objects on a machine run
inside a common execution environment now called a **vat**, and cross-machine
messages travel over channels between vats; from a vat's perspective the external
presences of a unum are in **one-to-one correspondence with the message channels**
to the vats hosting them, so you designate a presence by naming its channel. The
model does not require every presence to reach every other (in a Habitat/Elko
system clients talk only to the server, never to each other). This yields a
consequential **client/server asymmetry**: a client has only one channel (to the
server), so the unum identity alone suffices to route — the client programmer never
has to distinguish "message the unum" from "message the server presence." The
server, by contrast, is simultaneously in communication with **multiple clients**,
which is where the pattern's power and its unfamiliarity both come from.

## Content

We can loosely talk about "sending a message to a unum," but message-sending is an
OOP concept, not a world-model concept. Sending a message to a unum (which is not
an object) is really sending a message to some **presence** of that unum (since a
presence is an object). To designate the target, the address needs two components:
(1) the identity of the unum and (2) an indicator of **which presences** of that
unum you want to talk to.

In these systems, the objects on a machine within an application all run inside a
common execution environment — what we now call a **vat**. Cross-machine messages
are transported over communications channels established between vats. From a vat's
perspective, the external presences of a given unum (presences other than the local
one) are in **one-to-one correspondence** with the message channels to the other
vats that host those presences, so you can designate a presence by indicating the
channel that leads to its vat — for those presences you can talk to, anyway. The
unum model does **not** require that a presence be able to directly communicate
with all other presences: in a Habitat- or Elko-style system, clients don't talk to
other clients, only to the server.

Here we meet an asymmetry between client and server that is another frequent source
of confusion. From the client's perspective there is only one open message channel
— the one to the server — so the only other presence a client knows about is the
server presence. The identifier of the unum is then sufficient to determine where a
message should go, since there is only one possibility. Client-side developers need
not distinguish "send a message to the unum" from "send a message to the server
presence of the unum"; they can program to the conventional model of "send messages
to objects on the other end of the connection" and everything works the way they
are used to. On the **server side**, things get more interesting: server code is
**simultaneously in communication with multiple clients** — something web-world
developers have usually never experienced. This is where working with the unum
pattern becomes very different, and where it acquires much of its power and
usefulness.

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
