---
title: The convention this design enables
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments, tooling]
status: current
parent: endo-but-for-bots--llm-designs-htcs--phases-tests-and-design-decisions
---

Phase 3's grep target — `Buffer.from(` and `.toString('utf` —
implicitly names the codebase convention this design supports:
**prefer `Uint8Array` + `TextEncoder` / `TextDecoder` over Node's
`Buffer`** for code that runs under SES. Once the codecs are
permitted, SES code can portably do UTF-8 byte work without falling
back to the Node-specific `Buffer` global; the audit step in phase 3
is the migration sweep that follows.
