---
title: "designs/cli-store-verb-text-modes.md — Unified axis scheme replaces multiplied verbs + reshape-blocker-for-PR + blobs-are-bytes + three-orthogonal-axes + same-flag-for-read-and-write"
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
kind: index
section_count: 19
---

Sections:

- [Unified axis scheme replaces multiplied verbs + reshape-blocker-for-PR + blobs-are-bytes + three-orthogonal-axes + same-flag-for-read-and-write](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--unified-axis-scheme-replaces-m.md)
- [§Reshape-blocker-for-PR as named relationship type](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--reshape-blocker-for-pr-as-name.md)
- [§Three-orthogonal-axes for the CLI surface](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-re-fb2e783c--three-orthogonal-axes-for-the.md)
- [§Survey-table-of-existing-verbs](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--survey-table-of-existing-verbs.md)
- [§Unified-axis-scheme as the recommendation](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--unified-axis-scheme-as-the-rec.md)
- [§Same-flag-for-read-and-write](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-rea-fb2e783c--same-flag-for-read-and-write.md)
- [§No-encoding-flag-the-daemon-does-not-negotiate-codecs](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--no-encoding-flag-the-daemon-do.md)
- [§Blobs-are-bytes as load-bearing maxim](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--blobs-are-bytes-as-load-bearin.md)
- [§Two-viable-name-choices with Pro/Con per choice](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--two-viable-name-choices-with-p.md)
- [§Three-decisions section with quoted maintainer reviews](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--three-decisions-section-with-q.md)
- [§Three-alternatives-with-three-fates (all rejected)](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-re-fb2e783c--three-alternatives-with-three.md)
- [§Edit-and-patch reserved as future siblings](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--edit-and-patch-reserved-as-fut.md)
- [§Two-different-API-shapes-for-two-different-substrates](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--two-different-api-shapes-for-t.md)
- [§PR-stacking-discipline in Sibling-design section](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--pr-stacking-discipline-in-sibl.md)
- [§Deferred section with named future-cost](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--deferred-section-with-named-fu.md)
- [§Test-plan section with six named scenarios](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-r-fb2e783c--test-plan-section-with-six-nam.md)
- [§Borrowable patterns](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write--borrowable-patterns.md)
- [§Synthesis target — slot machine library](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-re-fb2e783c--synthesis-target-slot-machine.md)
- [§Library meta-counters](endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write--library-meta-counters.md)
