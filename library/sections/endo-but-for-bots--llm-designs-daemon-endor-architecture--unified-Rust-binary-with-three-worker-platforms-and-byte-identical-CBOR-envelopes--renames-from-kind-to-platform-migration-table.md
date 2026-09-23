---
source: designs/daemon-endor-architecture.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endor-architecture.md
source_path: designs/daemon-endor-architecture.md
source_branch: llm
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - hardened-javascript
genre: §endo-but-for-bots-design
cycle: 176
lane: designs
status: current
title: §Renames-from-kind-to-platform (migration table)
parent: endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes
---

| Old | New |
|-----|-----|
| `kind: 'locked'` | `platform: 'separate'` (default) |
| `kind: 'locked'` | `platform: 'shared'` (explicit) |
| `kind: 'node'` | `platform: 'node'` |
| `defaultWorkerKind` | `defaultPlatform` |
| `workerKind` | `workerPlatform` |

§Vocabulary-update: §kind-was-binary-locked-vs-node;
§platform-is-three-way-separate-shared-node.

§The-old-name-conflated-two-axes: confinement (locked vs
not) and engine (XS vs Node). §The-new-name-names-the-
actual-engine-choice.

§Migration-summary-table is the §rename-discipline pattern
(cycle 86's rename-discipline-skill is the canonical
form).
