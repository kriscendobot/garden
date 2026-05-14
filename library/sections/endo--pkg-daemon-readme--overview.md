---
title: Endo Daemon (overview)
source: packages/daemon/README.md
source_repo: endojs/endo
source_commit: 6d06a67b58e46523ea44c6a27cc2334d7c8e7a18
source_date: 2022-12-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security, captp]
status: current
notes: Tiny README; entire file is one section. Date is from 2022 (oldest README in the active library so far); content is foundational and stable.
---

> Abstract: The Endo daemon is a persistent host for hardened-JavaScript worker processes, owned per-user and reached over a Unix domain socket or named pipe. Communicates in CapTP framed over netstring envelopes; the bootstrap object provides the user-agent API, from which agents derive facets for other agents. The controller manages daemon lifecycle. This is the package's entire README; per-topic detail (process model, capability bank, mount handles) will accumulate in topic files as the corpus grows.

# Endo Daemon

This package provides the Endo daemon and controller. The controller manages the Endo daemon lifecycle.

The Endo daemon is a persistent host for managing guest programs in hardened JavaScript worker processes. The daemon communicates through a Unix domain socket or named pipe associated with the user, and manages per-user storage and compute access.

Over that channel, the daemon communicates in CapTP over netstring message envelopes. The bootstrap provides the user agent API from which one can derive facets for other agents.

Source: [packages/daemon/README.md](https://github.com/endojs/endo/blob/6d06a67b58e46523ea44c6a27cc2334d7c8e7a18/packages/daemon/README.md) at commit `6d06a67b`.
