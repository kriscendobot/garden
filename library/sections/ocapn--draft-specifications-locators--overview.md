---
title: OCapN Locators (overview)
source: draft-specifications/Locators.md
source_repo: kriscendobot/ocapn
source_commit: f7005c122a7b8050d927c6358d4856d9b5475136
source_date: 2025-12-03
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: Draft spec; significant change expected. Overlaps with marshal's convertValToSlot/convertSlotToVal callbacks at the application boundary.
---

> Abstract: Two locator types in the upstream protocol: peer locators (for finding a peer's session-handler) and sturdyref locators (for resuming a capability across sessions). Section is the front matter and warning that the spec is draft and likely to change.

# Warning: This is a draft specification likely to undergo significant change

This draft specification has been initially written based on Spritely Goblin's
implementation of as a base for the [OCapN pre-standardization
group](https://ocapn.org) to work from. Over time this document will change,
likely significantly as the group  converges on the design of OCapN. If you're
interested in being part of that  work, please join!

Authors: Jessica Tallon, Christine Lemmer-Webber & The OCapN Pre-standardization
Group.

# [Introduction](#introduction)

OCapN Locators used to identify OCapN capable peers or objects available on a
specific peer. They can be used in band as Syrup encoded data or out of band
when bootstrapping a connection as URIs.

These locators are agnostic to the netlayer that the peer or object is located
on, it encodes the transport  protocol name, key and other additional data which
would be used by any given  netlayer to reach the peer.


Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
