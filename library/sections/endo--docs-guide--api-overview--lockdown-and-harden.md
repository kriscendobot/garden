---
title: "`lockdown()` and `harden()`"
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Canonical for the four main API verbs (lockdown, repairIntrinsics, hardenIntrinsics, harden). As of cycle 30 supersedes endo--docs-reference--lockdown-api, endo--docs-reference--repair-intrinsics-api, endo--docs-reference--harden-intrinsics-api, endo--docs-reference--lockdown-and-harden. For exhaustive per-option detail on lockdown() see endo--docs-lockdown--*.
parent: endo--docs-guide--api-overview
---

`lockdown()` and `harden()` essentially do the same thing; freeze objects so their
properties cannot be changed. The only way to interact with frozen objects is through
their methods. Their differences are what objects you use them on, and when you use them.

`lockdown()` **must** be called first. It hardens JavaScript's built-in *primordials*
(implicitly shared global objects) and enables `harden()`. If you call `harden()`
before `lockdown()` executes, it throws an error.

`lockdown()` works on objects created by the JavaScript language itself as part of
its definition. Use `harden()` to freeze objects created after `lockdown()`was called;
i.e. objects created by programs written in JavaScript.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
