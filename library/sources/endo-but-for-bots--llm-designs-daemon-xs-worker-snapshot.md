---
source: designs/daemon-xs-worker-snapshot.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md
source_branch: llm
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-04
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 178. Designs-lane after cycle 177's chat-lane.
  §Endo-but-for-bots-design genre.

  395-line **§In-Progress** design. §Sibling-design-pair
  to cycle 176 daemon-endor-architecture (which names this
  as §the-suspend/resume-feature-design).

  **Single most structurally interesting move**: §snapshot-
  as-internal-implementation-detail-not-user-visible-formula.
  Manager sees continuous CapTP session; worker may be Live
  or Suspended transparently.

  §The-problem: long-running idle workers consume memory
  and supervisor slots. §The-solution: suspend by
  snapshotting + dropping machine; resume transparently on
  message.

  §Two-named-use-cases: §suspend-idle-agents + §checkpoint-
  long-computations.

  §XS-snapshot-captures heaps + chunks + stack (preserved
  slots only) + key/name/symbol tables + promise job queue.
  §Does-NOT-capture host function pointers (replaced with
  callback table indices), host context, platform state,
  debug state.

  §Three-axes-of-snapshot-incompatibility: XS version +
  architecture + callback table layout. §Signature-string-
  identifies-callback-table-version.

  §Six-Design-Decisions:
  1. §Snapshot-as-internal-implementation-detail (no user-
     visible formulas).
  2. §Suspend-only-when-idle (avoids CapTP reconnection
     problem entirely).
  3. §Transparent-resume-on-message (supervisor restores
     before delivery).
  4. §CAS-storage-with-ephemeral-GC-roots.
  5. §Streaming-snapshot-to-CAS-not-in-memory.
  6. §Callback-table-is-append-only.

  §Two-state-machine: Live ↔ Suspended. §Two-transitions
  (suspend → CAS; message → restore).

  §Four-control-verbs: suspend / suspended / suspend-error
  / restore. §All-payloads-UTF-8-text (paths or hashes).
  §Big-data-through-filesystem; §small-coordination-
  through-envelopes.

  §Two-init-paths (init vs restore) §one-entry-point.
  §Sibling-to-cycle-159-debug-flag pattern. §Restored-
  machines-skip-bootstrap-steps-4-and-6-through-9.

  §Streaming-discipline: §SHA-256-computed-on-the-fly +
  §atomic-rename-after-write + §only-the-hash-transits-
  the-envelope-bus.

  §Append-only-callback-table: §stable-indices-across-
  suspend-resume; §sibling-to-cycle-175-pin-on-first-
  install.

  §Phased-implementation: Phase 1 (Rust FFI + Machine API)
  Complete with 6 round-trip tests; Phase 2 (Supervisor
  suspend/resume) In Progress with 3 unit tests; Phase 3
  (auto-suspend, CAS GC, filesystem layout, cross-version
  compat) Future.

  §Phase-1-resolved-an-unknown-callback-table-issue (built
  XS from source vs prebuilt libxs.a from different version).

  §Revised-scope-discussion-2026-04-15 records §honest-
  design-evolution: snapshots are not formulas; forking
  out of scope; time-travel out of scope; auto-suspend
  future work. §Cycle-170-Reference-status pattern at
  smaller scale.

  §Sibling-design-pair with cycle 176: this is the
  §feature-spec; cycle 176 is the §substrate. §Different-
  grain-different-scope.

  §Cycle-162-Ken-protocol's §atomic-checkpoint property
  implemented at worker layer here.

  §Gap-revealing-comparison with cycles 176/141/162/170/
  175/159/168.

  §Tier-1 vocabulary borrowing: §snapshot-as-internal-
  implementation-detail + §suspend-only-when-idle +
  §streaming-snapshot-to-CAS-not-in-memory + §CAS-storage-
  with-ephemeral-GC-roots + §append-only-callback-table +
  §two-init-paths-one-entry-point + §big-data-through-
  filesystem-small-coordination-through-envelopes +
  §revised-scope-as-honest-design-evolution-record.

  §Synthesis-target: slot machine library's long-running
  game sessions could benefit from §suspend-only-when-idle
  semantics. §Snapshot-as-internal-implementation-detail
  posture generalizes.

  Cycle 178 was nominally designs-lane (after cycle 177's
  chat-lane). Papers-lane blocked 72+ consecutive cycles.
---

> Abstract: `designs/daemon-xs-worker-snapshot.md` (395
> lines) is the **§worker-heap-snapshot suspend/resume**
> design. Status: **In Progress**.
>
> **Cycle 178 — designs-lane**. §Sibling-design-pair to
> cycle 176 daemon-endor-architecture.
>
> **Single most structurally interesting move**: §snapshot-
> as-internal-implementation-detail-not-user-visible-
> formula. §The-manager-sees-continuous-CapTP-session.
>
> §Suspend-only-when-idle (§avoids-CapTP-reconnection-
> problem-entirely). §Transparent-resume-on-message.
> §Streaming-snapshot-to-CAS-not-in-memory. §CAS-storage-
> with-ephemeral-GC-roots. §Append-only-callback-table.
>
> §Two-init-paths-one-entry-point (init vs restore).
> §Big-data-through-filesystem-small-coordination-through-
> envelopes.
>
> §Revised-scope-discussion-2026-04-15 records §honest-
> design-evolution.
>
> §Cycle-162-Ken-protocol's-§atomic-checkpoint property
> implemented at the worker layer here.
>
> §Tier-1 borrowing: §snapshot-as-internal-implementation-
> detail + §suspend-only-when-idle + §streaming-snapshot-
> to-CAS-not-in-memory + §CAS-storage-with-ephemeral-GC-
> roots + §append-only-callback-table + §two-init-paths-
> one-entry-point + §big-data-through-filesystem-small-
> coordination-through-envelopes + §revised-scope-as-
> honest-design-evolution-record.
>
> §Synthesis-target: slot machine library's long-running
> sessions could §suspend-only-when-idle.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle](../sections/endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle.md) | daemon, persistence, patterns | current |

One cohesion-honest section. §The-snapshot-as-internal-
implementation-detail posture is the spine.

## Provenance

- Fetched 2026-06-04 from `endojs/endo-but-for-bots@llm`.
- Author: Kris Kowal (prompted).
- §Sibling-design-pair with cycle 176 daemon-endor-
  architecture.
- Cycle 178 was nominally **designs-lane** (after cycle
  177's chat-lane). Papers-lane blocked **72+ consecutive
  cycles**.
- One cohesion-honest section.
