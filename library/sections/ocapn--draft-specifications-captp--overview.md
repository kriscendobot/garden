---
title: CapTP Specification (overview)
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: Draft spec. Largest single source in the library; 10 sections at H1 boundaries with Operations and Descriptors consolidated rather than per-H2-split. Future cycle could split if specific operations or descriptors become high-traffic lookups.
---

> Abstract: Frame for the upstream protocol's CapTP specification (draft, March 2026). 1168-line authoritative document by Jessica Tallon. Defines wire-level CapTP message exchange between OCapN peers. Section is the warning + Introduction + Additional Documents pointers.

# Warning: This is a draft specification likely to undergo significant change

This draft specification has been initially written based on Spritely Goblin's
implementation of CapTP as a base for the
[OCapN pre-standardization group](https://ocapn.org) to work from. Over
time this document will change, likely significantly as the group converges on
the design of CapTP. If you're interested in being part of that work, please
join!

Authors: Jessica Tallon, Christine Lemmer-Webber, Mark Miller & The OCapN
Pre-standardization Group.

# [Introduction](#introduction)

Capability Transport Protocol (CapTP) is a secure messaging protocol designed
for communication between objects in distributed systems across networks. By
utilizing a capability security model, CapTP ensures both security and
functionality without compromise. In this model, an object can use
another object (capability) if and only if it possesses a reference to
it. In other words, "if you don't have it, you can't use it."

CapTP offers several valuable features, including:

- Powerful promises and promise pipelining, allowing remote value usage before
  resolution.
- Error propagation across the network.
- Distributed garbage collection.
- Secure third-party handoffs, even when CapTP messages are not kept secret.

CapTP is built upon the foundation of the actor model, where each actor is
referred to as an object. An actor model is a system where objects pass messages
between one another. CapTP enables objects to have remote references to other
objects on other CapTP sessions, often on different machines across the network.
An object Alice with a reference to another object Bob can use that reference by
sending a message to Bob or by sharing the reference to Bob in a message to
another object.

With the right tooling, many programming languages implementing CapTP can
achieve the same semantics of asynchronous programming for invoking both local
and remote objects, allowing programmers to focus on code flow rather than
networking infrastructure.

# Additional Documents

This document does not stand alone, it relies upon multiple other documents
which together build up OCapN (Object Capability Network) specifications.

This specification uses the following other specifications:

-   [Syrup](https://github.com/ocapn/syrup): The serialization format used for all messages between actors
    separated by a CapTP boundary.
-   [OCapN Netlayers](./Netlayers.md): Specification to open a secure communication channel
    between two sessions, often on different networks.
-   [OCapN Locators][Locators]: Specification covers representation of object references
    for both in-band and out-of-band usage.


Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
