---
title: §Two-different-API-shapes-for-two-different-substrates
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

The design names a §clean-distinction-between-formula-creation-and-mount-mutation:

- §`endo store` → §formula-creation (storeBlob/storeValue at daemon level): creates a new content-addressed or value formula.
- §`endo write` → §mount-mutation (writeText at daemon level): mutates a path inside an already-existing mutable mount.

§The-CLI-distinction-mirrors-the-underlying-daemon-distinction. §When-the-substrate-has-two-different-APIs-for-two-different-purposes, §the-CLI-MUST-name-them-distinctly-even-if-the-user-experience-feels-similar + §don't-collapse-two-substrate-APIs-into-one-CLI-verb. §Sibling-to-cycle-236's §three-axis-table (Method × Source × Confinement) — both designs use orthogonal-axes-to-prevent-collapse-of-distinct-substrate-APIs.
