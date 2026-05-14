---
title: Sequential Syrup Message Framing (deprecated; consolidated with @endo/syrup-frame)
source: designs/syrups.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, marshal, ocapn]
status: current
notes: Status: Deprecated. Supersedes: PR 29's @endo/syrup-frame (to be renamed @endo/syrups). The corrected reading: a chunk-stream framer carrying `Uint8Array` at both boundaries; the value codec is above, not inside. Same shape as @endo/cbors. The original design's framing as a "value-stream" layer was incorrect.
---

> Abstract: This design records a correction. The original "sequential Syrup message framing" proposal in this doc treated `@endo/syrups` as a layer above the byte-string framer that carried decoded Syrup values — wrong. The corrected reading: `@endo/syrups` and `@endo/syrup-frame` (PR 29 in `endojs/endo-but-for-bots`) are the **same package by different names**. Each adapts a stream of `Uint8Array` chunks into a stream of `Uint8Array`-delimited messages using length-prefixed Syrup byte-string framing on the wire (`<digits>:<payload>`, no separator). Only one need ship. Recommendation: rename PR 29's `@endo/syrup-frame` to `@endo/syrups` to match the sibling `@endo/cbors` naming. The sibling `@endo/cbors` design is unaffected.

# Sequential Syrup Message Framing (`@endo/syrups`)

| | |
|---|---|
| **Created** | 2026-05-04 |
| **Updated** | 2026-05-06 |
| **Author** | Kris Kowal (prompted) |
| **Status** | Deprecated |
| **Superseded by** | [`ocapn-tcp-syrups-framing.md`](./ocapn-tcp-syrups-framing.md) (PR 29) |

## Status

This design is consolidated with PR 29's `@endo/syrup-frame` ([`ocapn-tcp-syrups-framing.md`](./ocapn-tcp-syrups-framing.md)). The two packages are the same in shape: each adapts a stream of `Uint8Array` chunks into a stream of `Uint8Array`-delimited messages, using length-prefixed Syrup byte-string framing on the wire (`<digits>:<payload>`, no separator).

The earlier reading in this design (that `@endo/syrups` was a separate "message-stream" layer carrying decoded structured Syrup values, one rung above PR 29's byte-string framer) was wrong. Both `@endo/cbors` (the sibling design in this PR) and `@endo/syrup-frame` (PR 29) carry `Uint8Array` at their boundaries; the value codec sits above either of them, not inside. Under the corrected reading, `@endo/syrups` and `@endo/syrup-frame` are the same package by different names, and only one need ship.

## Recommendation

Adopt PR 29's design and rename the package and design from `@endo/syrup-frame` to `@endo/syrups`, so that the two streaming message-framing packages in this PR pair (`@endo/cbors` and `@endo/syrups`) share a naming convention. The rename has been applied to PR 29's branch across the package directory, `package.json`, exported reader and writer identifiers, design doc title, and PR title and body.

## Effect on the sibling `@endo/cbors` design

[`cbors.md`](./cbors.md) (the sibling design in this PR) is unaffected. It already carries `Uint8Array` at its boundaries and is the precise peer of `@endo/syrups`.

Source: [designs/syrups.md](https://github.com/endojs/endo-but-for-bots/blob/a4978698b19bbea5fcb8049e5cb7944ac8f2485a/designs/syrups.md) at commit `a4978698` on branch `llm`.
