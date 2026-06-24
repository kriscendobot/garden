---
title: OCapN Implementation Guide (overview + introduction)
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: Frames the upstream protocol as three sub-specifications (CapTP / Netlayers / Locators). Soft-flag overlap with ocapn--draft-specifications-model--* (the abstract model) and with the per-spec source files.
kind: index
section_count: 3
---

> Abstract: Frames the upstream protocol (OCapN, the Object Capability Network) as a distributed peer-to-peer messaging system built on the actor model. Three sub-specifications: CapTP (inter-object messaging with capability security, distributed cooperative GC, first-class promises, three-party handoffs), OCapN Netlayers (the lower-level standard for network-specific channel implementations), and OCapN Locators (in-band and out-of-band descriptors of peers and objects). The frame asserts that following the protocol's abstract semantics yields the property that asynchronous programming across a network looks equivalent to asynchronous programming on a single computer — "safety and security become intuitive outcomes of ordinary argument passing".

Sections:

- [OCapN Implementation Guide](ocapn--implementation-guide--overview--ocapn-implementation-guide.md)
- [Introduction](ocapn--implementation-guide--overview--introduction.md)
- [Implementing OCapN](ocapn--implementation-guide--overview--implementing-ocapn.md)

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
