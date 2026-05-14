---
title: Promise Kit (overview)
source: packages/promise-kit/README.md
source_repo: endojs/endo
source_commit: 2fc917e9
source_date: 2024-06-20
source_authors: [Mudassir Shabbir]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: @endo/promise-kit provides makePromiseKit() — a more ergonomic alternative to new Promise((resolve, reject) => ...). Returns a {promise, resolve, reject} triple, useful for resolver/reject objects passed to remote APIs or stored for later resolution.

# Promise Kit

The promise-kit package provides a simple abstraction for creating and managing a promise. It exports, `makePromiseKit` which is a utility function used to create a Promise and its associated resolver and rejector functions. This is particularly useful in asynchronous programming, where you might need to create a promise and resolve or reject it at a later point in time.
Note that this serves as a "ponyfill" for `Promise.withResolvers`, making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`.


Source: [packages/promise-kit/README.md](https://github.com/endojs/endo/blob/2fc917e9/packages/promise-kit/README.md) at commit `2fc917e9`.
