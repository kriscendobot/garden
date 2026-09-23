---
title: §Reshape-blocker-for-PR as named relationship type
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

The design declares §This-design-is-a-reshape-blocker-for-PR-#128 in the introduction and §Reshape-blocker-for as a §named-section-with-impact-enumeration at the end. §Reshape-blocker-for is a §new-relationship-type-distinct-from-Supersedes-or-Dependencies: §the-design-doesn't-replace-an-old-shape (Supersedes) + §the-design-doesn't-depend-on-another-design (Dependencies); §the-design-blocks-an-in-flight-PR-until-its-shape-is-revised.

§When-a-design-must-land-before-a-PR-can-merge, §use-the-Reshape-blocker-for-section-to-name-the-PR-and-the-files-it-touches. §The-impact-enumeration names §the-specific-files-that-will-be-removed (`packages/cli/src/commands/write-text.js` and `packages/cli/src/commands/read-text.js`) and §what-replaces-them (new `endo write` / `endo read` verbs).

§Thirtieth-honest-design-evolution-record family member; §fourteenth-different-shape in 2026-06 cluster: §Reshape-blocker-for-PR as design-evolution-record-shape. §Sibling-to-cycle-238's §design-revision-after-CHANGES_REQUESTED but distinct: cycle 238 was a redesign after PR rejection; cycle 240 is a parallel design that blocks an in-flight PR's merge until the shape is reconsidered. §Two-cycles-with-PR-driven-redesign-shapes (cycles 238 + 240) — two different temporal relationships to the in-flight PR.
