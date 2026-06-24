---
title: §Tree-manifest-format named explicitly
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

§Design-Decision-6: §Tree-manifest-format-is-`[name, type, sha256][]`. *This matches the existing `readable-tree` formula content in the daemon's CAS. Sorted by name for deterministic hashing.*

§Three-element-tuple-per-entry + §sorted-by-name-for-deterministic-hashing. §When-a-content-addressed-tree's-manifest-format-affects-the-hash, §the-format-MUST-be-canonical + §the-canonicalization-IS-the-sort-order-and-the-tuple-shape. §Sibling-to-cycle-240's-blobs-are-bytes (both designs name an exact wire-form shape with explicit canonicalization).
