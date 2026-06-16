---
title: §Seven-numbered-Design-Decisions
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

Seven decisions enumerated:

1. **§`@endo/platform/fs` not `@endo/tree`** — the module name reflects the broader filesystem concern.
2. **§Condition-gated `"node"` export, not assumed** — explicit about platform resolution.
3. **§`ReadableBlob` is shallow; `SnapshotBlob` adds `sha256()`** — content-addressed identity separated from readable surface.
4. **§`readOnly()` returns the readable interface, not a frozen copy** — structural attenuation.
5. **§No `help()` in this layer** — layer discipline via explicit non-inclusion.
6. **§Tree manifest format is `[name, type, sha256][]`** — sorted by name for deterministic hashing.
7. **§`TreeWriter` is a push interface** — minimal interface decouples checkout from mutable tree implementations.

§Four-cycles-with-numbered-Design-Decisions in library now (cycle 230 had 5 + cycle 236 had 9 + cycle 240 had 3 + cycle 242 has 7). §Different-counts-each-time: 3, 5, 7, 9 — §the-decision-count-IS-the-design's-shape-not-a-template. §When-a-design-has-N-named-decisions, §the-N-IS-load-bearing-don't-pad-or-trim.
