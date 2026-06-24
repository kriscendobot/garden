---
title: "`lockdown()`"
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

`lockdown()` freezes all JavaScript defined objects accessible to any
program in the execution environment. Calling `lockdown()` turns a JavaScript
system into a hardened system, with enforced OCap (object-capability) security. It
alters the surrounding execution environment (realm) such that no two
programs running in the same realm can observe or interfere with each other
until they have been introduced.

To do this, `lockdown()` tamper-proofs all of the JavaScript intrinsics to prevent
prototype pollution. After that, no program can subvert the methods of these objects
(preventing some man in the middle attacks). Also, no program can use these mutable
objects to pass notes to parties that haven't been expressly introduced (preventing
some covert communication channels).

For a full explanation of `lockdown()` and its options, please click
[here](./lockdown.md).

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
