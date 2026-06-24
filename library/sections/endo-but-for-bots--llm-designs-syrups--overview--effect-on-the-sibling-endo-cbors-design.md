---
title: Effect on the sibling `@endo/cbors` design
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
parent: endo-but-for-bots--llm-designs-syrups--overview
---

[`cbors.md`](./cbors.md) (the sibling design in this PR) is unaffected. It already carries `Uint8Array` at its boundaries and is the precise peer of `@endo/syrups`.

Source: [designs/syrups.md](https://github.com/endojs/endo-but-for-bots/blob/a4978698b19bbea5fcb8049e5cb7944ac8f2485a/designs/syrups.md) at commit `a4978698` on branch `llm`.
