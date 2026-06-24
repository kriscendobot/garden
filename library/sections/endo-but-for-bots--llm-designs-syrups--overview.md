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
kind: index
section_count: 4
---

> Abstract: This design records a correction. The original "sequential Syrup message framing" proposal in this doc treated `@endo/syrups` as a layer above the byte-string framer that carried decoded Syrup values — wrong. The corrected reading: `@endo/syrups` and `@endo/syrup-frame` (PR 29 in `endojs/endo-but-for-bots`) are the **same package by different names**. Each adapts a stream of `Uint8Array` chunks into a stream of `Uint8Array`-delimited messages using length-prefixed Syrup byte-string framing on the wire (`<digits>:<payload>`, no separator). Only one need ship. Recommendation: rename PR 29's `@endo/syrup-frame` to `@endo/syrups` to match the sibling `@endo/cbors` naming. The sibling `@endo/cbors` design is unaffected.

Sections:

- [Sequential Syrup Message Framing (`@endo/syrups`)](endo-but-for-bots--llm-designs-syrups--overview--sequential-syrup-message-framing-endo-syrups.md)
- [Status](endo-but-for-bots--llm-designs-syrups--overview--status.md)
- [Recommendation](endo-but-for-bots--llm-designs-syrups--overview--recommendation.md)
- [Effect on the sibling `@endo/cbors` design](endo-but-for-bots--llm-designs-syrups--overview--effect-on-the-sibling-endo-cbors-design.md)

Source: [designs/syrups.md](https://github.com/endojs/endo-but-for-bots/blob/a4978698b19bbea5fcb8049e5cb7944ac8f2485a/designs/syrups.md) at commit `a4978698` on branch `llm`.
