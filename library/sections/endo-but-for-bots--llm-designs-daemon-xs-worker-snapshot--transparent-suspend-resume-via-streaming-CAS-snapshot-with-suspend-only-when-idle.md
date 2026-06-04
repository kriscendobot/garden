---
source: designs/daemon-xs-worker-snapshot.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md
source_path: designs/daemon-xs-worker-snapshot.md
source_branch: llm
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
  - patterns
genre: §endo-but-for-bots-design
cycle: 178
lane: designs
status: current
---

# Transparent suspend resume via streaming CAS snapshot with suspend only when idle

> §Endo-but-for-bots-design genre (designs-lane). Status:
> **In Progress** (Phase 1 complete; Phase 2 mostly done;
> Phase 3 future). §Sibling-design-pair to cycle 176
> daemon-endor-architecture (which references this as §the-
> suspend/resume-feature-design).

`designs/daemon-xs-worker-snapshot.md` (395 lines) defines
the **§worker-heap-snapshot suspend/resume** mechanism for
the Rust supervisor. The single most structurally
interesting move is the **§snapshot-as-internal-
implementation-detail-not-user-visible-formula** posture:
the manager sees a continuous CapTP session; the worker
may be Live or Suspended transparently.

## §The-problem (motivation)

§Long-running-workers consume memory and supervisor slots
even when idle. §Today-the-only-way-to-stop-a-worker-is-
to-cancel-it, §losing-all-in-heap-state.

§Restarting-requires-re-evaluating-the-formula and
§replaying-any-setup-the-guest-performed.

§The-solution: §suspend-by-snapshotting-the-heap-and-
dropping-the-machine; §resume-transparently-when-a-
message-arrives.

§Two-named-use-cases:
1. §Suspend-idle-agents (LLM agent running periodically).
2. §Checkpoint-long-computations (multi-step pipeline can
   restart from checkpoint on crash).

## §Background: §what-XS-snapshots-capture

§XS-has-`fxWriteSnapshot`/`fxReadSnapshot` for §complete-
JS-heap-image:

**§Captured**:
- All slot heaps (objects, arrays, closures, scope
  chains).
- All chunk blocks (strings, ArrayBuffers, BigInts).
- The stack (only preserved slots).
- Key/name/symbol tables.
- Promise job queue state.

**§NOT-captured**:
- Host function pointers (replaced with callback table
  indices).
- Host context pointers (`the->context`).
- Platform state (timers, I/O handles, file descriptors).
- Debug state.

§The-host-side-must-be-rebuilt-on-restore. §JS-heap-is-
fully-restored; §native-bindings-are-re-installed.

§Three-axes-of-incompatibility (snapshot bound to):
- §XS-version.
- §Architecture (32/64-bit, endianness).
- §Callback-table-layout.

§A-signature-string-identifies-the-callback-table-version.
§If-signature-doesnt-match-fxReadSnapshot-fails.

## §Snapshot-as-internal-implementation-detail (Decision 1)

> *The snapshot is an **internal implementation detail** of
> the worker lifecycle, not a user-visible formula.*

§Manager-sees-continuous-CapTP-session. §The-worker-may-be-
Live-or-Suspended-transparently. §The-transition-is-
transparent.

§No-snapshot-formulas. §No-user-visible-snapshot-objects.
§Snapshots-are-opaque-CAS-blobs.

§Cycle-170-daemon-capability-filesystem named the §single-
interface-multiple-backings pattern; this design has the
§single-CapTP-surface-multiple-worker-states pattern.

§Sibling-to-cycle-168-daemon-checkin-checkout §reference-
not-substrate-stance: §the-manager-doesn't-need-to-know-
about-implementation-mechanics.

## §Suspend-only-when-idle (Decision 2)

> *The worker must have no pending CapTP calls or
> outstanding promises. This avoids the CapTP reconnection
> problem entirely.*

§Avoidance-not-resolution: §the-CapTP-reconnection-problem
is hard; §sidestep-it-by-requiring-idle-state-at-suspend-
time.

§If-worker-is-not-idle: §suspend-fails-with-error. §No-
silent-degradation.

§What-counts-as-idle:
- No pending CapTP calls.
- No outstanding promises from remote objects.
- Machine quiescent (no running JS, no pending host
  entries).

§The-prompt's-original-concern (from §revised-scope-
discussion-2026-04-15) was §obligating-the-worker-to-
sense-and-recover-from-loss-of-ephemeral-connectivity.
§The-revised-scope-narrowed-this: §don't-try-to-recover;
§refuse-to-suspend-when-state-would-need-recovery.

§Honest-narrowing-of-scope during design. §The-§revised-
scope-section records the conversation.

## §Transparent-resume-on-message (Decision 3)

> *The supervisor adapter detects messages to suspended
> handles and restores the worker before delivery. The
> manager doesn't need to know about suspension.*

§The-supervisor-is-the-resume-trigger. §Manager-just-sends-
a-message; §latency-spikes-during-restore; §nothing-else-
changes.

§Six-step-resume-flow:
1. Message arrives for suspended handle.
2. Supervisor detects (parent-of-cycle-176's `on_resume`
   callback).
3. Spawn worker thread with `"restore"` init envelope.
4. Worker streams snapshot from CAS file.
5. Buffered message delivered.
6. Supervisor releases ephemeral GC root.

§First-message-after-suspend-pays-the-restore-latency;
§subsequent-messages-are-Live-speed.

## §Streaming-snapshot-to-CAS (Decision 5)

> *The full snapshot is never buffered in memory.*

§Stream-don't-buffer. §Cycle-141-daemon-cas-management
provides the CAS; §cycle-176-daemon-endor-architecture
also names this discipline.

§Suspend-streaming:
1. Worker streams XS snapshot chunks via `fxWriteSnapshot`
   callback to a temp file in CAS directory.
2. §SHA-256-computed-on-the-fly.
3. Atomic rename to `{cas_dir}/{sha256_hex}`.
4. Worker sends `"suspended"` with hex digest only —
   §only-the-hash-transits-the-envelope-bus.

§Resume-streaming:
1. Supervisor sends `"restore"` init with CAS file path.
2. Worker calls `Machine::from_snapshot_file()`, §streaming-
   from-disk.
3. Full snapshot never resides in memory.

§Memory-bounded-suspend-and-resume regardless of worker
heap size.

§Atomic-rename-after-write is the §write-then-publish
discipline (cycle 141 sibling at content-store layer).

## §CAS-storage-with-ephemeral-GC-roots (Decision 4)

> *Snapshot blobs are stored in the content-addressable
> store by SHA-256. An ephemeral GC root prevents
> collection while the worker is suspended.*

§Two-references-to-the-blob:
- §The-CAS-itself (content-addressed durable storage).
- §Ephemeral-GC-root-from-supervisor (prevents collection
  during suspended lifetime).

§Released-on-resume-or-cancel. §If-supervisor-crashes-
before-resume: §the-ephemeral-root-is-lost; §the-blob-may-
be-GC'd; §the-worker-cannot-be-resumed. §Acceptable-on-
crash because §suspend-resume-is-an-optimization-not-a-
correctness-feature.

§CAS-GC-not-yet-implemented (named in Phase 3 future
work). §The-bookkeeping-is-set-up-correctly-for-when-it-
arrives.

## §Append-only-callback-table (Decision 6)

> *New host functions are always appended. The signature
> changes when the table changes.*

§Stable-indices-across-suspend-resume: §the-snapshot's-
embedded-callback-indices-must-point-to-the-same-functions-
on-restore.

§Append-only-discipline: §new-functions-go-at-the-end;
§existing-indices-never-change.

§Within-a-single-binary: §same-binary-same-registration-
order = §identical-table = §signature-match.

§Cross-version: §signature-mismatch = §fxReadSnapshot-
fails-loudly. §No-silent-corruption.

§Sibling-to-cycle-175's-pin-on-first-install: §once-an-
index-is-assigned-it-cannot-change.

## §Two-init-paths (the bootstrap branch)

```ts
type InitVerb = "init" | "restore"
```

§Worker-startup-branches-on-init-verb:
- `"init"`: §normal-bootstrap (XS shared cluster, register
  worker I/O host functions, eval host aliases, bootstrap
  SES, install base64, eval program).
- `"restore"`: §stream-restore-from-CAS-file; §skip-the-
  bootstrap-steps; §only-re-establish-the-context-pointer.

§The-snapshot-already-contains-all-globals after step 9 of
the cycle 176 bootstrap sequence. §Restored-machines-skip-
steps-4-and-6-through-9.

§Same-entry-point-two-code-paths. §Sibling-to-cycle-159's
§debug-flag-as-one-new-verb pattern: §encode-the-mode-in-
the-init-envelope.

## §The-state-diagram (Live ↔ Suspended)

```
                    ┌─────────┐
     suspend()      │         │  message arrives
  ┌────────────────►│Suspended├──────────────────┐
  │  snapshot→CAS   │         │  CAS→restore      ▼
┌─┴──┐               └─────────┘               ┌─────┐
│Live│◄─────────────────────────────────────────│Live │
└────┘         resumed, message delivered       └─────┘
```

§Two-states; §two-transitions. §The-state-machine-is-
simple-because-the-discipline-was-strict.

§Cycle-173-promise-executor-kit's §three-state-internal-
reference-lifecycle had three states; this has two.
§Different-purpose, §different-state-count.

## §Envelope-protocol (four verbs)

| Verb | Direction | Payload | Purpose |
|------|-----------|---------|---------|
| `"suspend"` | supervisor → worker | CAS dir path (UTF-8) | Tell worker to quiesce + snapshot |
| `"suspended"` | worker → supervisor | SHA-256 hex (UTF-8) | Worker confirms snapshot written |
| `"suspend-error"` | worker → supervisor | error message (UTF-8) | Worker cannot suspend |
| `"restore"` | supervisor → new worker | CAS file path (UTF-8) | Init verb for resume |

§Four-control-verbs-cover-the-protocol. §All-payloads-are-
UTF-8-text-paths-or-hashes — §no-binary-bytes-on-the-
envelope-bus (snapshot bytes flow through filesystem, not
envelopes).

§The-byte-stream-bypasses-the-envelope-bus. §Big-data-
through-filesystem; §small-coordination-through-envelopes.

## §Six-Design-Decisions enumerated

1. Snapshot-as-internal-implementation-detail.
2. Suspend-only-when-idle.
3. Transparent-resume-on-message.
4. CAS-storage-with-ephemeral-GC-roots.
5. Streaming-snapshot-to-CAS-not-in-memory.
6. Callback-table-is-append-only.

§Each-decision-named. §Cycle-170's-seven-Open-Questions /
cycle-176's-no-explicit-Open-Questions / this design's
§revised-scope-section show three §design-honesty patterns.

## §Phased-implementation with named state

| Phase | Content | State |
|-------|---------|-------|
| 1 | Rust snapshot FFI + Machine API | Complete (6 round-trip tests passing) |
| 2 | Supervisor suspend/resume | In Progress (most items done; 3 unit tests passing) |
| 3 | Auto-suspend, CAS GC, filesystem layout, cross-version compat | Future |

§Phase-1-resolved-an-unknown-callback-table-issue by
compiling XS from source (the prebuilt libxs.a came from a
different XS version).

§Cycle-141-daemon-cas-management's-§implementation-phases
have a sibling shape: phased-with-honest-state-reporting.

§Phase-2-remaining: integration test (full supervisor
round-trip), ephemeral GC root bookkeeping.

§Phase-3 names §four-future-enhancements without
committing to a timeline.

## §The §revised-scope discussion (honest design evolution)

> *The design was revised based on discussion (2026-04-15):
> Snapshots are not formulas... Forking workers... out of
> scope. Time-travel debugging... out of scope. Auto-
> suspend on idle/memory pressure... future work.*

§Honest-design-evolution-recorded. §The-original-prompt
asked for §formula-producing-snapshots; §the-discussion-
narrowed-the-scope.

§The-pattern-named: §record-the-scope-pruning-where-it-
happened. §Cycle-170-daemon-capability-filesystem's
§reference-status-after-narrower-subset-shipped is a
parallel form (full reference → narrower subset shipped
as daemon-mount).

§Sibling-to-cycle-149's-three-Open-Questions and cycle-
172's-Open-Questions-resolved-during-implementation:
§design-evolution-shapes are §recoverable-from-the-
document.

## §The §sibling-design-pair with cycle 176

§Cycle-176-daemon-endor-architecture is the §supervisor-
architecture-that-this-suspend/resume-feature-fits-into.
§This-design-is-the-feature-spec; §cycle-176-is-the-
substrate.

§Both-designs-share:
- §The §CAS-streaming-discipline (also cycle 141).
- §The §atomic-rename-after-write pattern.
- §The §envelope-protocol-for-control-verbs.
- §The §parent-tree-blocking-call-authorization.

§Two-designs-one-implementation: cycle 176 names the
overall architecture; this names the specific feature.
§Different-grain-different-scope.

## §Why-this-design-matters (the bigger picture)

§Memory-pressure-on-the-Endo-daemon is the load-bearing
problem: §long-running-agents-consume-supervisor-slots-
even-when-idle.

§The-solution-isn't-cleverer-allocators; §it's-let-idle-
workers-be-actually-zero-cost via snapshot+drop.

§Cycle-162-ken-protocol's §atomic-checkpoint property is
implemented here for the worker layer: §the-snapshot-is-
the-atomic-checkpoint of the JS heap.

§Future-extension: §auto-suspend-heuristics could make
this transparent to operators too. §The-mechanism-is-here;
§the-policy-is-future-work.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 176 (daemon-endor-architecture) | §Sibling-design-pair; this is the §suspend/resume-feature-spec |
| 141 (daemon-cas-management) | §CAS-substrate this writes snapshots into |
| 162 (ken-protocol-assessment) | §Atomic-checkpoint property implemented at worker layer |
| 170 (daemon-capability-filesystem) | §Single-interface-multiple-backings sibling shape |
| 175 (@endo/harden make-selector) | §Once-an-index-is-assigned-it-cannot-change sibling discipline |
| 159 (daemon-debug-worker-restart) | §Same-entry-point-two-code-paths sibling (debug vs restore as init flag) |
| 168 (daemon-checkin-checkout) | §Stream-don't-buffer sibling at content-store layer |

## §Tier-1 vocabulary borrowing candidates

§Snapshot-as-internal-implementation-detail (transparency
of state to the manager).

§Suspend-only-when-idle (avoid the hard reconnection
problem by requiring quiescence).

§Streaming-snapshot-to-CAS-not-in-memory (memory-bounded
regardless of heap size).

§CAS-storage-with-ephemeral-GC-roots (durable storage +
transient pinning).

§Append-only-callback-table (stable indices across
suspend/resume).

§Two-init-paths-one-entry-point (init vs restore as a
mode flag).

§Big-data-through-filesystem-small-coordination-through-
envelopes.

§Revised-scope-as-honest-design-evolution-record.

§Tier-2: §atomic-rename-after-write, §SHA-256-on-the-fly
computation.

## §Synthesis-target

§Slot-machine-library's-long-running-game-sessions could
benefit from §suspend-only-when-idle semantics — if a
player walks away, the session can snapshot and free
memory until they return.

§The-§snapshot-as-internal-implementation-detail posture
generalizes: §any-system-with-expensive-idle-state benefits
from §transparent-suspend-resume.

## §A-mid-flight-design (Status: In Progress)

§Status-In-Progress is the most common §design-lifecycle-
status in the corpus (cycle 166 daemon-mount, cycle 161
filesystem-watchers, cycle 162 ken-protocol-assessment
references, others). §Active-work-in-the-design-archive.

§Phase-2-resolution-of-the-unknown-callback-table is the
kind of §debugging-artifact that the Status section
captures.

§The-design-is-not-static: §it-tracks-the-implementation.
§Revised-scope + §phased-implementation + §completed-
tests-listed make this a §living-document.
