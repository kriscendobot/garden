---
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
section_count: 9
status: current
notes: A how-to-build-it companion to the draft-specifications. Walks an implementer through six stages plus appendix, organized around Alisha (Peer A), Ben (Peer B), and Carol (Peer C) so the reader can track the gifter/receiver/exporter terminology in the third-party-handoff section. Many sections cross-cut with the draft-specifications and with Endo realizations; soft-flag per-section.
---

> Abstract: An opinionated implementation guide for the upstream protocol, organized as six stages (0–5) plus stage 6 for third-party handoffs, against which the OCapN test suite is split. Each stage corresponds to a testable milestone. Stages 0–2 cover the connection-establishment + deliver-only + promises feature plateau; stages 3 and 5 cover the two GC flavors; stage 4 covers promise pipelining; stage 6 (the longest) covers third-party handoffs and the gifter/receiver/exporter certificate exchange. The guide uses the running Alisha/Ben/Carol narrative throughout, so the same characters that appear in the draft-specifications anchor the implementation walk-through. Authored by Jessica Tallon (2026-03-12), file-commit `8704f69e`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/ocapn--implementation-guide--overview.md) | ocapn, captp | current |
| [stage-0-foundation](../sections/ocapn--implementation-guide--stage-0-foundation.md) | ocapn, captp | current |
| [stage-1-deliver-only](../sections/ocapn--implementation-guide--stage-1-deliver-only.md) | ocapn, captp, marshal | current |
| [stage-2-promises](../sections/ocapn--implementation-guide--stage-2-promises.md) | ocapn, captp, eventual-send | current |
| [stage-3-import-export-gc](../sections/ocapn--implementation-guide--stage-3-import-export-gc.md) | ocapn, captp | current |
| [stage-4-promise-pipelining](../sections/ocapn--implementation-guide--stage-4-promise-pipelining.md) | ocapn, captp, eventual-send | current |
| [stage-5-question-answer-gc](../sections/ocapn--implementation-guide--stage-5-question-answer-gc.md) | ocapn, captp | current |
| [stage-6-handoffs](../sections/ocapn--implementation-guide--stage-6-handoffs.md) | ocapn, captp, capability-security | current |
| [appendix-vats](../sections/ocapn--implementation-guide--appendix-vats.md) | ocapn, captp | current |

## Cross-references

- The guide's stages are also test-suite milestones; the OCapN test suite (`endojs/ocapn-test-suite`) implements the same stage structure for conformance testing.
- Stage 0 covers the same `op:start-session` / `op:abort` material as `ocapn--draft-specifications-captp--*` (which has the formal spec); soft-flag.
- Stage 1's import/export descriptor mechanics correspond to `endo--pkg-captp-readme--*` (Endo's realization) and `ocapn--draft-specifications-captp--operations-and-descriptors`.
- Stage 6's handoff certificate flow expands on the spec's terse description of `desc:handoff-give` / `desc:handoff-receive`. The Endo realization is in `endo--pkg-ocapn-readme--*` and `endo--pkg-captp-readme--*`.
- Appendix A on vats is referenced from `ocapn--draft-specifications-model--*` and overlaps `endo--pkg-daemon-readme--*` (vats are the daemon's worker abstraction).

## Source

[implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
