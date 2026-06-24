---
title: §Synthesis target — slot machine library
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

For a slot machine library:

- §Roadmap-calibration-per-git-blame for §game-engine-shipped-history-with-named-bursts.
- §Conditional-exports for §game-engine-on-different-platforms (default browser + lite always-available + explicit-platform paths).
- §Type-lattice for §game-state-roles (Player-view + Snapshot + Mutable) × (Single-game + Tournament).
- §Structural-subtyping for §game-state-snapshot-extends-game-state-readable.
- §Structural-attenuation-not-behavioral-attenuation for §player-view-of-game-state-simply-lacks-admin-methods.
- §The-"elevator"-module for §game-platform-bridge that does the platform-specific import so the platform-agnostic game engine never has to.
- §No-help()-in-this-layer for §game-rule-engine-doesn't-include-discoverability (layered separately).
- §Push-interface vs pull-interface for §game-state-rendering-target (TreeWriter analog).
- §Game-rule-manifest-format named with explicit canonicalization.
- §Stops-at-the-game-rule-engine-boundary as named design discipline.
