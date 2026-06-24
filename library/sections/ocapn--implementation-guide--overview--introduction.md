---
title: Introduction
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

The upstream-protocol specifications provide a generalized distributed object communication system. The specifications correspond to an underlying abstract model of computation where each peer on the network contains objects exported to other specific peers on the network which import them. While many peers on the network connect to many other peers, the set of exported objects which may be operated upon are dependent on the interactions between the objects on those two peers — i.e. different peer pairs will have different exports; not all peers get access to all objects. The idea is that a distributed network is like a society of inter-cooperating objects/actors with different sets of relationships and cooperation between the objects/actors contained on different peers.

This perspective is pervasive throughout the design and even its narrative and visual imagery. In server-to-server interactions, the protocol can protect against objects being exposed across a network boundary which were not consensually shared with that peer. On a more fine-grained level, implementations which partition their internal behavior in terms of objects will have a smooth and intuitive model for partitioning and coordinating access granting between system subcomponents resembling ordinary programming. (Here "objects" refers to encapsulated state and behavior accessible only through a reference, not to any idea of "object oriented" in terms of class hierarchies, which many implementations do not use.)

Of course, there is no way to enforce at a network level that other peers correspond to the operational semantics described in this document. However, implementations which do follow these ideas will reap the benefit of being able to write applications which look equivalent for asynchronous programming on a single computer as for asynchronous programming across a fully distributed network. Programmers can focus on the underlying core ideas and behaviors of their programs rather than on network programming details. Safety and security become intuitive outcomes of ordinary argument passing in programming following the simple object capability paradigm of "if you don't have it, you can't use it".

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
