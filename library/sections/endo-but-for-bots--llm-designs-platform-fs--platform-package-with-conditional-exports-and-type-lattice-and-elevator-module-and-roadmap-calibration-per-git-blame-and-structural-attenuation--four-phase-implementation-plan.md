---
title: §Four-phase implementation plan with S/M complexity tags
source-slug: endo-but-for-bots--llm-designs-platform-fs
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/platform-fs.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/platform-fs.md
total-lines: 787
ingest-cycle: 242
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation
---

Four phases:

1. **Phase 1: Package Skeleton and Types (S)** — package.json, conditional exports, types, interface guards. No behavioral code.
2. **Phase 2: Snapshot Store and Snapshot Blob/Tree (S)** — extract makeSnapshotSha256Store + makeSnapshotBlob + makeSnapshotTree.
3. **Phase 3: Checkin/Checkout Extraction (S)** — extract checkinTree + checkoutTree + makeLocalTree + makeLocalBlob + makeTreeWriter.
4. **Phase 4: Mutable Directory and File (M)** — File and Directory Exos with readOnly() attenuation.

§Three-S-and-one-M phase. §The-S/M-complexity-tag is the §size-effort-estimate per phase. §When-the-design-already-shipped, §the-Status-section's-roadmap-calibration-validates-the-phase-tags-against-actual-burst-durations. §Cycle-242's-burst-1 (initial landing) maps to Phases 1+2+3 in one day (S+S+S); §burst-2-and-burst-3 are §M-phase-and-cleanup-rolled-up.

§First-cycle-in-library-with-S/M-complexity-tag-per-phase that can be validated against §git-blame-burst-history.
