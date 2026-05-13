---
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
section_count: 7
status: current
notes: Single commit in git log; content references issues from ~2020 and reads as older than its commit date. Two sections (distributed, async) describe future plans, not implementation.
---

> Abstract: The Endo "Logging Errors" reference. Covers the three-piece system (tamed `Error`, `assert` global, causal `console`) and the side-table mechanism by which hidden diagnostic info (stacks, detailed messages, annotations) flows from in-band code into out-of-band console output. Distinguishes the local pattern (implemented) from distributed-diagnostic and asynchronous-deep-stacks plans (not implemented, tracked via specific agoric-sdk issues). Closes with a speculative "unreal logging" model where logging only happens under deterministic replay.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--docs-errors--overview.md) | errors, hardened-javascript, agent-conventions | current |
| [goals-non-goals](../sections/endo--docs-errors--goals-non-goals.md) | errors, hardened-javascript | current |
| [configuration-variations](../sections/endo--docs-errors--configuration-variations.md) | errors, hardened-javascript, compartments | current |
| [hiding-revealing-local-diagnostic](../sections/endo--docs-errors--hiding-revealing-local-diagnostic.md) | errors, hardened-javascript, capability-security, compartments | current |
| [hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | errors, captp, marshal | current (plans only) |
| [hiding-revealing-async-diagnostic](../sections/endo--docs-errors--hiding-revealing-async-diagnostic.md) | errors, eventual-send | current (plans only) |
| [unreal-logging](../sections/endo--docs-errors--unreal-logging.md) | errors, hardened-javascript | current (speculative) |

## Provenance

- File last modified 2025-09-25 by Kris Kowal. Single commit in `git log`; content reads older than its date.
- Captured at endo `fe81477b`.

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md).
