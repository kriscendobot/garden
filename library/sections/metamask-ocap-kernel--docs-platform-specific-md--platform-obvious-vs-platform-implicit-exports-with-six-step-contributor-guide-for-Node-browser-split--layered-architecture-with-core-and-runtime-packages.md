---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §Layered-architecture-with-core-and-runtime-packages
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> *The kernel follows a layered architecture where core
> packages contain both abstract type declarations and
> their corresponding platform-specific implementations.
> The platform-specific runtime packages serve as
> orchestrators that import the appropriate
> implementations from core packages via specialized
> export paths.*

§Two-layer-package-structure:

1. **Core packages**: contain both §abstract-types-as-
   API-surface AND §platform-specific-implementations
   side-by-side.
2. **Runtime packages** (`kernel-browser-runtime`,
   `nodejs`): §orchestrators-that-import-the-right-one.

§Don't-split-platform-implementations-into-separate-packages
discipline: keeping Node-impl and browser-impl in the same
core package gives §single-source-of-truth-for-the-
abstraction. The runtime packages just choose.

§Endo-comparison: Endo's daemon package mixes Node-specific
code with abstractions; the split between abstraction and
implementation is less formalized. §Synthesis-target: a
§named-core-vs-runtime-layering convention could make
Endo's Node-vs-browser story more discoverable.
