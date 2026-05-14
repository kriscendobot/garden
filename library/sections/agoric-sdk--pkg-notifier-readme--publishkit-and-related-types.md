---
title: PublishKit and Related Types (frame)
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: eaef5bfd888e01d641e3e450df4809a165c68633
source_date: 2024-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, capability-security]
status: current
---

> Abstract: Frame for the package. Provides production/consumption of asynchronous value sequences via three kits: the recommended PublishKit, plus the deprecated NotifierKit and SubscriptionKit. All three let a service notify clients of state changes. The README assumes familiarity with JavaScript async iteration (AsyncGenerators / AsyncIterables / AsyncIterators) and elaborates on the user-doc semantics at docs.agoric.com/guides/js-programming/notifiers.html.

# PublishKit and Related Types

This package provides an abstraction for production and consumption of asynchronous value sequences, the *PublishKit*, along with similar but deprecated types *NotifierKit* and *SubscriptionKit*. All three let a service notify clients of state changes.

In JavaScript, *async iterations* are interacted with by means of AsyncGenerators, AsyncIterables, and AsyncIterators. For an introduction to these concepts and implementations, see [here](https://javascript.info/async-iterators-generators).

This content elaborates on [user documentation](https://docs.agoric.com/guides/js-programming/notifiers.html) to more precisely describe the semantics and distributed system properties of the types.

Source: [packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
