---
title: "platform-fs — @endo/platform package with conditional exports and a six-type filesystem lattice"
source-slug: endo-but-for-bots--llm-designs-platform-fs
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/platform-fs.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/platform-fs.md
total-lines: 787
status: Complete (initial 2026-03-20; refactor through 2026-05-11)
ingest-cycle: 242
ingest-date: 2026-06-08
lane: designs
---

# platform-fs.md

A 787-line **Complete** design for the `@endo/platform` package. The package landed 2026-03-20 (commit `e0dda06fb` on the `llm` branch) and was refactored through 2026-05-11.

## Key design moves

- **§Roadmap-calibration-per-git-blame** as named retrospective design-doc structure (thirty-first honest-design-evolution-record family member; fifteenth-different-shape in 2026-06 cluster).
- **§Calendar-vs-active-development-distinction** explicit when most of the calendar span is light-touch.
- **§Conditional-exports** with three paths (default condition-gated `./fs` + lite always-available `./fs/lite` + explicit-platform bypass `./fs/node`).
- **§Type-lattice as 2×3 axis table** (three roles × two kinds; six named types).
- **§Snapshot-extends-Readable** as structural subtyping.
- **§Structural-attenuation-not-behavioral-attenuation** — readOnly returns the readable interface, not a frozen copy with throwing write methods.
- **§The-"elevator"-module** as named architectural pattern — platform-specific module does the platform import so platform-agnostic code never has to.
- **§No-help()-in-this-layer** as explicit non-inclusion with higher-layer named.
- **§Push-interface vs pull-interface** decoupling (TreeWriter is push; ReadableTree is pull).
- **§Tree-manifest-format** named with explicit canonicalization (`[name, type, sha256][]` sorted by name).
- **§Three-roles-an-object-can-play** (Readable / Snapshot / Mutable) with named substrates per role.
- **§Stops-at-the-filesystem-boundary** as named design discipline.
- **§Seven-numbered-Design-Decisions** — different count from prior 230/236/240; §the-N-IS-load-bearing-not-a-template.
- **§The-Prompt-IS-the-naming-spec** — when the prompt fixes the vocabulary, the design fills it in.
- **§Four-phase implementation plan with S/M complexity tags** that can be validated against git-blame-burst-history.

## Section files

- [§platform-package-with-conditional-exports + §type-lattice + §elevator-module + §roadmap-calibration-per-git-blame + §structural-attenuation](../sections/endo-but-for-bots--llm-designs-platform-fs--platform-package-with-conditional-exports-and-type-lattice-and-elevator-module-and-roadmap-calibration-per-git-blame-and-structural-attenuation.md) — full 787-line design ingest.

## Ingest scope

Cycle 242 (designs-lane): full 787-line ingest. §First-explicit-observation of four patterns: §Roadmap-calibration-per-git-blame as retrospective design-doc structure + §the-"elevator"-module as named architectural pattern + §structural-attenuation-not-behavioral-attenuation as named design discipline + §push-interface-vs-pull-interface-decoupling as orthogonal axis.
