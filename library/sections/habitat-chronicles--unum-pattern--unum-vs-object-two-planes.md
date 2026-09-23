---
title: Unum vs. object — two planes of existence
source_kind: web-essay
source_url: https://habitat-chronicles.com/2019/08/the-unum-pattern/
source_content_sha256: 7d099818689a2f196889f1602187a7c6a79110e80f1baa7c4a2bab88952e81dd
source_author: Chip Morningstar
source_date: 2019-08-28
ingested: 2026-07-11
ingested_by: scholar
topics: [distributed-objects]
status: current
---

## Abstract

The core ontological move of the unum pattern: a world entity (the canonical
example is a **teacup** on a table in a room in a virtual city) occupies a
**different plane of existence** from the software objects that realize it. Ask
"where is the teacup, really?" — there is a representation in your client, in my
client, and in the server. The tempting answer "it's really in the server" (the
server as source of truth) is *wrong* for this model; the correct answer is that
the teacup is on a table in a room, and its identity is entirely distinct from the
identities of any of the software objects implementing it. Because the clients and
server still need to *name* the teacup in their protocol, the world entity has its
own **objective identity** — an actual identifier distinct from any object's
memory address. To stop the word "object" from meaning two different things
(world-object vs. OOP-object), Morningstar reserves **object** for the OOP object
in an implementation and coins **unum** (Latin, "a single thing"; plural "una" or
"unums") for the world entity.

## Content

Consider a distributed, multi-participant virtual world such as Habitat or one of
its descendants. This world is by its nature very object oriented, but not in the
same way we mean in object-oriented *programming* — which is confusing, because the
implementation is itself very object oriented in exactly the OOP sense.

Imagine you are in a room in a building in downtown Populopolis. There is a table,
and on it a teacup. You are not really in the world — your **avatar** is; you
interact through client software that talks over a network to a server. So where is
the teacup, really? There is a representation inside your computer, a representation
inside the server, and (if my avatar is in the room too) a representation inside my
computer. Is it in your computer, my computer, or the server? One reasonable answer
is "all of the above," but many technical people will say it is "really" in the
server, since they regard the server as the source of truth. **The correct answer
is that the teacup is on a table in a room inside a building in Populopolis.** The
teacup occupies a different plane of existence from the software objects used to
realize it. It has an objective identity of its own — if you and I each refer to
it, we are talking about the same teacup — and this identity is entirely distinct
from the identities of any of those software objects. It must have such an
identity, because there still needs to be some actual identifier usable in the
communications protocols the clients and server use to refer to the teacup when
they describe manipulations of it.

You might distinguish the two senses of "object" with modifiers — "world object"
versus "OOP object" — and that is what they did for several years. But this made it
easy to fall back on the shorthand "object" when context seemed clear, and context
often was not clear to somebody in the conversation, producing confusion and
misunderstanding. So after some false starts they settled on using **object** to
always mean an OOP object in an implementation, and **unum**, from the Latin for a
single thing, to mean a world object. (The plural sparks "endless debates about
whether it is properly *una* or *unums*"; Morningstar's opinion is take your pick,
people will know what you mean.)

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
