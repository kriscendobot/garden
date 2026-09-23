---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §Roadmap-calibration-per-git-blame with named bursts and commit hashes (thirty-first honest-design-evolution-record family member).
- §Calendar-vs-active-development-distinction explicit when most of the calendar span is light-touch.
- §Conditional-exports with three paths (default condition-gated + lite always-available + explicit-platform bypass).
- §Type-lattice as 2×3 axis table (three roles × two kinds).
- §Structural-subtyping (Snapshot extends Readable) for content-addressed types.
- §Structural-attenuation-not-behavioral-attenuation — readOnly returns the readable interface, not a frozen copy.
- §The-"elevator"-module as named architectural pattern — platform-specific module does the import so the platform-agnostic module never has to.
- §No-help()-in-this-layer as explicit non-inclusion with the higher-layer named.
- §Push-interface (TreeWriter) vs pull-interface (ReadableTree) decoupling.
- §Tree-manifest-format named with explicit canonicalization (`[name, type, sha256][]` sorted by name).

**Tier-2 (design discipline):**

- §Three-roles-an-object-can-play with named substrates per role.
- §Relationship-to-existing-interfaces enumerates each overlap and names mapping or deliberate omission.
- §Stops-at-the-filesystem-boundary as named design discipline.
- §Four-phase implementation plan with S/M complexity tags.
- §Two-named-methods-on-TreeWriter (minimal interface by construction).
- §subDir-deferred-to-future-VFS-layer with reason and future-layer named.

**Tier-3 (named comparisons):**

- §The-Prompt-IS-the-naming-spec — when the prompt fixes the vocabulary, the design fills it in.
- §Superset-by-construction — `@endo/platform/fs/node` re-exports everything from `/lite` plus Node specifics.
