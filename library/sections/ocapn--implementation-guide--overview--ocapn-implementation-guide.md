---
title: OCapN Implementation Guide
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
parent: ocapn--implementation-guide--overview
---

OCapN, the **O**bject **Cap**ability **N**etwork, is a set of specifications which describe a protocol for writing distributed peer-to-peer applications. These specifications provide everything from creating a communication channel, to sending messages between objects across a network, and handing off to an object on a third peer on the network. The messaging paradigm is built on the idea of the actor model which has different objects (actors) which exist on multiple computers and can send messages to actors either locally or remotely.

The three specifications that make up OCapN are:

- **CapTP**: The object/actor-level distributed messaging system which builds upon a network agnostic communication channel, abstracted over the OCapN Netlayers. CapTP provides:
  - A general inter-object networked messaging protocol.
  - A powerful capability security model which is intuitive to ordinary programming interactions.
  - Distributed, cooperative garbage collection.
  - First-class promises and promise pipelining, allowing for efficient communication with to-be-created objects before they even exist and propagating information about message failure to relevant interested parties.
  - A peer introduction mechanism known as "handoffs" which allows users to continue to program with the intuition of ordinary programming even when communicating with multiple peers that do not yet know about each other.
- **OCapN Netlayers**: The lower level standard for defining different network specific implementations of the communication channels, on top of which CapTP sends messages. Netlayers provide a unified abstraction upon which CapTP can operate without having to decide a particular underlying networking protocol.
- **OCapN Locators**: In-band and out-of-band descriptors of OCapN capable peers and objects.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
