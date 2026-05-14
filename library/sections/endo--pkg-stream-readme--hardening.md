---
title: Hardening
source: packages/stream/README.md
source_repo: endojs/endo
source_commit: 1aafa86e
source_date: 2022-01-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, hardened-javascript]
status: current
---

> Abstract: How @endo/stream interacts with SES: streams are themselves harden()'d, and the combinators preserve hardening across transforms. Notes on what cannot be hardened (transient closure state) and the patterns to work around it.

## Hardening

This library depends on Hardened JavaScript.
The environment must be locked down before initializing this library.
All of the exported functions and the streams they produce are hardened.

This implementation of streams ensures that iteration results are shallowly
frozen.
The user is responsible for hardening the transported values if that is their
intent.
Some values like array buffers cannot be frozen.

Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
