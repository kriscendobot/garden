---
title: The four messaging patterns — Reply, Neighbor, Broadcast, Point
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

Once a server presence can talk to all of a unum's client presences, experience
showed that a **small fixed set of four messaging patterns** captures essentially
everything wanted, and these were codified into the messaging libraries. Framed in
the context of the server processing a message received from one client, the four
are: **Reply** (back to the client that sent the message being processed),
**Point** (to a specific client the server explicitly chooses — like Reply but the
recipient is explicit, and used rarely; needing a Point usually signals something
odd), **Broadcast** (to all client presences), and **Neighbor** (to all client
presences *except* the sender — the one newcomers find weird). Crucially, these are
not built on Point as a primitive: the underlying messaging primitive is a
lower-level fanout/routing construct that handles one-or-many recipients with a
single mechanism so a multi-target message is not multiply buffered. Two idioms
recur: a **client-initiated action** produces a Reply (status/privileged detail to
the requestor) plus a Neighbor (the event, de novo, to everyone else); a
**server-initiated action** produces a Broadcast (nobody knew, so all need the
same information). Presences exist in the first place precisely because they share
a common context in which one client's actions affect the others — unlike the web's
independent one-on-one client/server dialogs.

## Content

In the client-server unum model, the server can communicate with all of a unum's
client presences. Although a message could be sent to any one, to all, or to any
subset, in practice a small number of messaging patterns suffice — four that are
repeatedly useful, to the point of being codified in the messaging libraries. All
four are framed in the context of processing some message received by the server
presence from one of the clients; that context identifies which client sent it.

- **Reply** — directed back to the client presence that sent the message the server
  is processing.
- **Point** — directed to a specific client presence chosen by the server; like
  Reply, except the recipient is explicit rather than implied and could be any
  client regardless of context.
- **Broadcast** — sent to all the client presences.
- **Neighbor** — directed to all the client presences **except** the sender of the
  message being processed. This is the pattern newcomers find weird.

These four are **not** generalizations of Point. Some people assume Point is a good
primitive to implement the other three, but the messaging primitive is a
lower-level construct that handles fanout and routing for one or many recipients
with a single common mechanism, so a message with more than one target is not
multiply buffered. Point messages are used rather rarely; using one usually
indicates you are doing something odd.

The reason there are multiple client presences at all is that they **share a common
context** in which one client's actions can affect the others — in contrast to the
classic web model, where each client has its own one-on-one dialog with the server,
unrelated to the server's simultaneous dialogs with other clients. The
multiple-clients-in-a-shared-context model is a very good match for online games and
virtual worlds (you *can* build those on the web model, but it cuts against the
grain).

Two idioms recur. **Client-initiated actions** typically take the form of a request
from a client to the unum's server presence; the server's handler takes the
appropriate actions, then sends a **Reply** informing the requestor of the results
(often just a status, since the requestor already knows what it asked; and, if the
requestor is in a privileged role such as the unum's owner or holder, possibly extra
information not shared with others), plus a **Neighbor** informing the other clients
of what just happened (a different payload, since they need to learn of the action
de novo). **Server-initiated actions** are typically communicated to all clients via
**Broadcast**, since none of them start out knowing what is going on and all require
the same information. The server's ability to autonomously initiate actions is
itself a difference from traditional web applications (server-initiated actions are
now supported by HTTP/2, "in a strange, inside out kind of way," but have yet to
become part of the typical web developer's toolkit).

Source: [The Unum Pattern](https://habitat-chronicles.com/2019/08/the-unum-pattern/) by Chip Morningstar, 2019-08-28 (content sha256 `7d099818`).
