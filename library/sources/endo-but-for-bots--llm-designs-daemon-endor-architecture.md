---
source: designs/daemon-endor-architecture.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endor-architecture.md
source_branch: llm
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 176. Designs-lane after cycle 175's chat-lane.
  §Endo-but-for-bots-design genre.

  806-line **§Active** design for the Rust supervisor
  architecture. §Sibling-design to cycle 141's daemon-cas-
  management (also Rust supervisor work).

  §Two-crate-decomposition: `endo` (supervisor) + `xsnap`
  (XS engine bindings). §Separation-of-routing-from-engine.

  §Binary-as-multi-tool: six subcommands (daemon / start /
  stop / ping / worker / run). §One-binary-many-roles.

  **Single most structurally interesting move**: §three-
  worker-platforms-with-byte-identical-CBOR-envelopes:
  separate (XS child process; default + preferred) /
  shared (in-process XS) / node (Node.js child process).
  §The-supervisor-is-transport-agnostic.

  §Graceful-downgrade: shared → separate when XS isn't
  linked. §Caller-should-not-rely-on-shared-semantics-for-
  correctness — §performance-hint.

  §Manager-must-be-co-resident (hard requirement). §The-
  daemon-binary-is-self-contained.

  §Pool-of-machine-runner-threads (ENDO_MACHINE_THREADS,
  default = CPU count). §Cooperative-not-preemptive
  scheduling. §Machines-yield-at-envelope-boundaries.

  §Blocking-call-authorization via parent tree: §a-parent-
  can-call-into-a-child-synchronously-but-a-child-cannot-
  block-its-parent. §Deadlock-prevention-by-structure.

  §Suspend-resume-via-CAS-streaming: §the-full-snapshot-
  never-resides-in-memory. §SHA-256-as-content-address.
  §Atomic-rename-after-write.

  §Unified-runner-four-mode-table: (Bundle/Archive) ×
  (Transport-Some/None) = 4 modes. §One-function-encodes-
  the-deployment-space.

  §Endor-implements-Ken-properties-implicitly (cycle 162):
  transactional turns + output validity + deferred
  transmission + atomic checkpoint + local recovery.
  §Synthesis-target: §adopt-Ken-vocabulary explicitly.

  §CESU-8-surrogate-pair-encoding (XS string quirk).
  §Fast-path when no 4-byte UTF-8.

  §Six-host-power-modules (fs, crypto, modules, process,
  sqlite, debug). §Capability-safe-filesystem via cap-std.

  §Five-embedded-JS-bundles via include_str! at compile
  time. §No-runtime-file-resolution-for-bootstrap.
  §Cycle-175's-@endo/harden-selector embedded in
  polyfills.js.

  §Renames-from-kind-to-platform: §kind-was-binary;
  §platform-is-three-way. §Rename-discipline (cycle 86).

  §Eleven-endo-crate-modules + §five-xsnap-crate-modules.
  §Single-responsibility-per-module.

  §Path-resolution-mirrors-@endo/where (cycle 167): same
  XDG conventions, same macOS / Linux defaults, same env-
  var overrides. §Identical-conventions-across-runtime-
  implementations.

  §Three-related-designs (daemon-capability-bus + daemon-
  xs-worker-snapshot + daemon-xs-worker-debugger). §Cycle-
  141-daemon-cas-management is the §implicit-fourth.

  §Gap-revealing-comparison with cycles 141/162/167/170/
  174/175.

  §Tier-1 vocabulary borrowing: §three-worker-platforms-
  with-byte-identical-CBOR-envelopes + §supervisor-is-
  transport-agnostic + §graceful-downgrade-shared-to-
  separate + §manager-must-be-co-resident + §pool-of-
  machine-runner-threads + §blocking-call-authorization-
  via-parent-tree + §suspend-resume-via-CAS-streaming +
  §stream-then-rename-atomicity + §unified-runner-four-
  mode-table + §five-embedded-JS-bundles-via-include_str.

  §Synthesis-target: slot machine library may need similar
  §multi-platform-worker-runtime; §three-worker-platforms
  shape is borrowable.

  §Status-Active completes the §design-lifecycle-status
  family in the corpus: Complete (cycle 168) / Active
  (cycle 176 this) / Proposed (cycle 174) / Reference
  (cycle 170) / Not Started (cycles 145+147 etc) /
  Implemented (cycle 172) / In Progress (cycle 166).
  §Seven-distinct-statuses-now-represented.

  Cycle 176 was nominally designs-lane (after cycle 175's
  chat-lane). Papers-lane blocked 70+ consecutive cycles.
---

> Abstract: `designs/daemon-endor-architecture.md` (806
> lines) is the **§Rust-supervisor-architecture-design**
> for `endor`. Status: **Active**.
>
> **Cycle 176 — designs-lane** after cycle 175's chat-lane.
> §Sibling-design to cycle 141 daemon-cas-management.
>
> **Single most structurally interesting move**: §three-
> worker-platforms-with-byte-identical-CBOR-envelopes
> (separate / shared / node). §The-supervisor-is-
> transport-agnostic.
>
> §Two-crate-decomposition (endo + xsnap). §Binary-as-
> multi-tool with six subcommands.
>
> §Graceful-downgrade (shared → separate when XS unlinked).
> §Manager-must-be-co-resident (hard requirement).
>
> §Pool-of-machine-runner-threads with §cooperative-not-
> preemptive scheduling. §Blocking-call-authorization-via-
> parent-tree (§deadlock-prevention-by-structure).
>
> §Suspend-resume-via-CAS-streaming with §atomic-rename-
> after-write. §The-full-snapshot-never-resides-in-memory.
>
> §Unified-runner-four-mode-table: (Bundle/Archive) ×
> (Transport-Some/None).
>
> §Endor-implements-Ken-properties-implicitly (cycle 162);
> §synthesis-target: §adopt-Ken-vocabulary explicitly.
>
> §Path-resolution-mirrors-@endo/where (cycle 167).
> §Cycle-175's-harden-selector-embedded-in-bootstrap.
>
> §Tier-1 borrowing: §three-worker-platforms +
> §supervisor-is-transport-agnostic + §graceful-downgrade
> + §manager-must-be-co-resident + §pool-of-machine-
> runner-threads + §blocking-call-authorization-via-
> parent-tree + §suspend-resume-via-CAS-streaming +
> §unified-runner-four-mode-table + §five-embedded-JS-
> bundles-via-include_str.
>
> §Seven-distinct-design-lifecycle-statuses now
> represented in the corpus.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes](../sections/endo-but-for-bots--llm-designs-daemon-endor-architecture--unified-Rust-binary-with-three-worker-platforms-and-byte-identical-CBOR-envelopes.md) | daemon, tooling, hardened-javascript | current |

One cohesion-honest section. §The-three-worker-platforms-
with-byte-identical-CBOR is the spine.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@llm`.
- Author: Kris Kowal (prompted).
- Cycle 176 was nominally **designs-lane**. Papers-lane
  blocked **70+ consecutive cycles**.
- One cohesion-honest section.
