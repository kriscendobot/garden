---
title: Recommendation
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

Adopt PR 29's design and rename the package and design from `@endo/syrup-frame` to `@endo/syrups`, so that the two streaming message-framing packages in this PR pair (`@endo/cbors` and `@endo/syrups`) share a naming convention. The rename has been applied to PR 29's branch across the package directory, `package.json`, exported reader and writer identifiers, design doc title, and PR title and body.

Source: [designs/syrups.md](https://github.com/endojs/endo-but-for-bots/blob/a4978698b19bbea5fcb8049e5cb7944ac8f2485a/designs/syrups.md) at commit `a4978698` on branch `llm`.
