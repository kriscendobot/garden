---
title: §Same-flag-for-read-and-write
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

The `-p <file>` flag is §the-same-flag-for-input-and-output-paths: `endo store -p <file> -n <name>` reads from a file; `endo cat -p <file> <name>` writes to a file. §The-direction-of-flow-is-implicit-in-the-verb + §the-flag-stays-the-same-letter. §When-a-verb-pair-takes-symmetric-file-arguments, §use-the-same-flag-not-`--from`/`--to`-duals + §the-verb-disambiguates-direction.

§Symmetry-by-verb-pair-not-by-flag-prefix. §Sibling-to-cycle-238's §cancellation-promise-as-platform-neutral-interface (both designs choose symmetry-by-verb-shape over symmetry-by-flag-rename).
