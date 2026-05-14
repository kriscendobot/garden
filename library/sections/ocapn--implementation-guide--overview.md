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
---

> Abstract: Frames the upstream protocol (OCapN, the Object Capability Network) as a distributed peer-to-peer messaging system built on the actor model. Three sub-specifications: CapTP (inter-object messaging with capability security, distributed cooperative GC, first-class promises, three-party handoffs), OCapN Netlayers (the lower-level standard for network-specific channel implementations), and OCapN Locators (in-band and out-of-band descriptors of peers and objects). The frame asserts that following the protocol's abstract semantics yields the property that asynchronous programming across a network looks equivalent to asynchronous programming on a single computer — "safety and security become intuitive outcomes of ordinary argument passing".

# OCapN Implementation Guide

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

## Introduction

The upstream-protocol specifications provide a generalized distributed object communication system. The specifications correspond to an underlying abstract model of computation where each peer on the network contains objects exported to other specific peers on the network which import them. While many peers on the network connect to many other peers, the set of exported objects which may be operated upon are dependent on the interactions between the objects on those two peers — i.e. different peer pairs will have different exports; not all peers get access to all objects. The idea is that a distributed network is like a society of inter-cooperating objects/actors with different sets of relationships and cooperation between the objects/actors contained on different peers.

This perspective is pervasive throughout the design and even its narrative and visual imagery. In server-to-server interactions, the protocol can protect against objects being exposed across a network boundary which were not consensually shared with that peer. On a more fine-grained level, implementations which partition their internal behavior in terms of objects will have a smooth and intuitive model for partitioning and coordinating access granting between system subcomponents resembling ordinary programming. (Here "objects" refers to encapsulated state and behavior accessible only through a reference, not to any idea of "object oriented" in terms of class hierarchies, which many implementations do not use.)

Of course, there is no way to enforce at a network level that other peers correspond to the operational semantics described in this document. However, implementations which do follow these ideas will reap the benefit of being able to write applications which look equivalent for asynchronous programming on a single computer as for asynchronous programming across a fully distributed network. Programmers can focus on the underlying core ideas and behaviors of their programs rather than on network programming details. Safety and security become intuitive outcomes of ordinary argument passing in programming following the simple object capability paradigm of "if you don't have it, you can't use it".

## Implementing OCapN

This is an opinionated guide on how a prospective implementer could go about implementing a fully compliant CapTP implementation. It is highly recommended to read through the specifications before using this guide as it is useful to get a sense of what is *required* by the specification, as opposed to what is merely *suggested* by this guide.

To help implementation the guide is broken into distinct stages which can be tested on their own against the conformance test suite.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
