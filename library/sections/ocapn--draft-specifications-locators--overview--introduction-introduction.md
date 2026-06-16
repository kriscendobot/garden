---
title: "[Introduction](#introduction)"
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
parent: ocapn--draft-specifications-locators--overview
---

OCapN Locators used to identify OCapN capable peers or objects available on a
specific peer. They can be used in band as Syrup encoded data or out of band
when bootstrapping a connection as URIs.

These locators are agnostic to the netlayer that the peer or object is located
on, it encodes the transport  protocol name, key and other additional data which
would be used by any given  netlayer to reach the peer.

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
