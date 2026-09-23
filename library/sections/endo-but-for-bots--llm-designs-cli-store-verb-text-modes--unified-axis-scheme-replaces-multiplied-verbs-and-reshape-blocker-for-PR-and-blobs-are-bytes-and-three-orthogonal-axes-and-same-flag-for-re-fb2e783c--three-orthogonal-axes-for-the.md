---
title: §Three-orthogonal-axes for the CLI surface
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write
---

The design's §load-bearing-observation is that the existing verbs mix §three-axes:

1. **§Source / sink:** stdin, stdout, file path, argv string literal.
2. **§Representation:** opaque blob (bytes), text (UTF-8 string), JSON (structured passable value), bigint (passable scalar), tree (`readable-tree` of nested entries).
3. **§Where-it-lives-in-the-formula-graph:** content-addressed immutable formula (`readable-blob`, `readable-tree`) vs. primitive value (passable string, bigint), vs. path inside a mutable mount.

§The-third-axis-was-introduced-without-naming. §PR-#128's-`writeText` introduced the mutable-mount axis without naming it; both `endo store --text` (write a string-value formula) and `endo write-text` (write UTF-8 bytes through a mount) look like "save some text" but operate against different addressing schemes. §When-an-axis-is-introduced-without-naming, §the-design-debt-IS-the-axis-name + §the-fix-is-to-name-the-axis-not-to-add-more-verbs.

§The-CLI-already-presents-a-confusing-surface-around-stored-content + §adding-two-more-top-level-verbs-without-a-presentation-strategy-multiplies-the-confusion. §Verb-count-as-named-cost — §each-new-verb-multiplies-the-surface-area + §the-presentation-strategy-IS-the-design.
