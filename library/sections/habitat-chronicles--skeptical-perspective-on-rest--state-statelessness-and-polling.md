---
title: What is this "state"? — state1 vs state2, statelessness, and why polling is the wrong primitive
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
ingested: 2026-07-11
ingested_by: scholar
topics: [networking, distributed-objects, eventual-send]
status: current
---

## Abstract

The essay's closing critique, and its second tie to the distributed-object lineage.
Morningstar separates two meanings hidden inside the word **"state"**: **state1** — a node
in a small finite graph of a classic state machine, with edges you can reason about
rigorously (the sense HATEOAS usually intends); and **state2** — the collection of all
values of all mutable bits defining how the system *is* at a point in time, whose space is
"perhaps effectively infinite." Mathematically the same, in practice not, "since we rarely
use state machines to formally describe entire systems." The equivocation matters: HATEOAS
is coherent under state1 but "more dubious" under state2, because there is knowledge the
server holds about its relationship with the client (session state) that alters its
responses yet is never represented in the HTTP dialog — "given that it is how nearly every
non-trivial website in the world actually works (cookies as keys into databases), this
would be like saying nothing on the web works like the web." He reframes REST as **patterned
on a simplified, idealized model of the web** — not invalidated, but to be read more
critically. The sharper point is the **client/server asymmetry**: the server controls the
state of the *data*; the client controls the state of the *conversation*; and under the
**dogma of statelessness** "the universe is born anew with each HTTP request" — "the
attention span of a goldfish." The fatal consequence for interactive systems: **the server
has no means to communicate with the client except by responding to a client-initiated
request**, so autonomous server-side processes force the client to **poll**, and "polling
is horrendously inefficient" (too frequent overloads; too infrequent adds latency). REST's
caching answer is "nonsense on stilts" — a poll asks "got any news for me?" but a cache
only answers "has the cache timed out?", and when those answers diverge the system gives
the wrong result. This is exactly the need-for-server-initiated-notification /
promise-and-eventual-send affordance the E-vat and unum behavioral-protocol lineage supply
by construction ([eventual-send](../topics/eventual-send.md),
[change-propagation](../topics/change-propagation.md)).

## Content

### Two meanings of "state"

The word "state" — especially in "hypermedia as the engine of application state" — has two
related but different meanings:

- **state1**: the kind of thing we mean in a classic state machine — a node in a graph,
  usually a reasonably small and finite graph, with edges between some nodes and not
  others that let us reason rigorously about how the system can change in response to
  events.
- **state2**: the collection of all the values of all the mutable bits that collectively
  define the way the system *is* at some point in time; here the number of possible states
  of even a fairly simple system can be very large, "perhaps effectively infinite."

In a strictly mathematical sense these are the same, but in practice they are not, "since
we rarely use state machines to formally describe entire systems (the analysis would be
awkward and perhaps intractable) but we use them all the time to model things at higher
levels of abstraction." Morningstar takes "state" in HATEOAS to generally mean state1 —
"except when people find it rhetorically convenient to mean" state2. Using the term one
way in one sentence and the other way in the next makes it "easy to be oblivious to major
conceptual confusion."

### Statelessness and the client/server asymmetry

Two important issues with HTTP-based protocols (equally applicable to conventional RPC as
to REST) arise from the **asymmetry of the client and server roles**: **while the server is
in control of the state of the data, the client is in control of the state of the
conversation.** This is justified by the **dogma of statelessness** — since the server is
"stateless," outside a given request-response cycle it has "no concept that there even is a
client." "From the server's perspective, the universe is born anew with each HTTP
request."

The standard does not literally require the server to have "the attention span of a
goldfish," but it insists that the state of long-lived non-client processes (objects whose
lifetime transcends a given HTTP request) be captured in resources conceptually **external
to the server** — identified as the key to scalability, since decoupling resources from the
server lets load be handled by parallel collections of interchangeable servers. The problem
is that in the real world we often *do* have a notion of **session state**: server-side
resources genuinely coupled to the state of the client even if the standard pretends
otherwise. Under state1, the HATEOAS conceit that the client drives the state through its
link-following is coherent (modulo the caveat that the client software needs a-priori
understanding of what the links mean). Under state2 it "looks more dubious," since the
server can hold knowledge about its relationship with the client that alters its responses
yet is never explicitly represented in the HTTP dialog — "for example, through values in
cookies being used as keys into databases to access information that is never actually
revealed to the client." Since that is how "nearly every non-trivial website in the world
actually works," calling it a violation "would be like saying nothing on the web works like
the web." The accurate statement is that **REST is patterned on a simplified and idealized
model of the web** — which does not invalidate the arguments for it, but "should cause us
to consider them a bit more critically."

### The server cannot speak first, so the client must poll

The second issue with HTTP's client/server asymmetry is that **the server has no means to
communicate with the client aside from responding to a client-initiated request**. Given
the practical reality of server-side session state, we not uncommonly find server-side
processes that *want to initiate communication with the client*, "despite the fact that the
dominant paradigm insists that this is not a meaningful concept."

The result: for autonomous server-side processes, instead of the server transmitting a
notification, **the client must poll — and "polling is horrendously inefficient."** Poll
too frequently and you put excess load on the network and servers; poll too infrequently
and you introduce latency and delay that degrades the user experience. REST proponents
counter that caching solves the load from frequent polling, "but this is nonsense on
stilts." Caching can help as a kind of denial-of-service mitigation, but to the extent the
current state of an asynchronous process is cached, poll queries are not asking "got any
news for me?" — they are asking "has the cache timed out?" If the answer to the first
question is yes but to the second is no, the system gives the wrong answer; if the first is
no but the second is yes, the client hits the server directly and the cache "has added
nothing but infrastructure cost." It makes no sense to poll more frequently than the cache
timeout (no gain), but polling slower means the cache is never hit "and might as well not
be there."

## See also

- [eventual-send](../topics/eventual-send.md) — the promise / eventual-reference model that supplies exactly the server-initiated-notification affordance whose absence forces REST clients to poll.
- [change-propagation](../topics/change-propagation.md) — the delta/notification view of keeping observers current, the complement to poll-based synchronization.
- [habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest](habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest.md) — the behavioral-protocol lineage where a presence can push a parameterized operation rather than being polled for state.

Source: [A Slightly Skeptical Perspective on REST](https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/) by Chip Morningstar, 2017-11-24 (content sha256 `b2248ed5`).
