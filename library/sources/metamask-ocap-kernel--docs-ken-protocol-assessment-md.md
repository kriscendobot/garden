---
source: docs/ken-protocol-assessment.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/ken-protocol-assessment.md
source_branch: main
source_commit: 475304c46e4c9d4910f0cc50318c5346173af01b
source_date: (last touched in commit `475304c46`)
source_authors: [MetaMask ocap-kernel team]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 162. **Second ocap-kernel ingest** after cycle 161's
  monorepo overview. §Queued-doc-1 from the overview's
  §queued-for-future-cycles plan — the highest-priority
  cross-comparable doc.

  §Completion-claim-against-named-protocol document: audits
  ocap-kernel's remote-messaging system against the seven
  properties of the Ken protocol (HPL-2010-155: *Output-Valid
  Rollback-Recovery* by Kelly/Karp/Stiegler/Close/Cho) and
  asserts *All Ken protocol properties are now implemented*.

  §Canonical-protocol-citation discipline: cites named
  protocol + source document + five authors. §Named-protocol-
  as-acceptance-criterion observation (from cycle 161
  overview) instantiated concretely.

  §Stiegler-name observation: Mark Stiegler is one of five Ken
  authors. Cycle 94's OCPL paper identified Stiegler 2006
  HPL-2006-116 *How Emily tamed the Caml*; this Ken paper is
  Stiegler's *other* HP Labs collaboration.

  §Seven-Ken-properties enumeration:
  1. exactly-once delivery FIFO
  2. output validity (could-have-resulted-from-failure-free-
     execution)
  3. transactional turns
  4. consistent frontier
  5. local recovery
  6. sender-based message logging
  7. deferred transmission

  §Output-validity is the most semantically interesting:
  §failure-free-execution-as-correctness-baseline. Rules out
  crash-induced phantom outputs.

  §Ken-turn-model code block: §atomic-checkpoint-before-
  transmit discipline. §Checkpoint-includes-output-queue
  invariant. §Done-table-tracks-processed-to-completion
  observation.

  Single most structurally interesting move: §twelve-row
  self-assessment table. Each Ken property mapped to a
  *concrete implementation pointer* (file paths, sequence
  number names, issue numbers). §Each-property-points-at-a-
  named-implementation-artifact discipline. §Issue-numbers-
  anchor-the-claims (#786 + #808). §Verifiable-provenance-
  not-just-assertion.

  §SQLite-savepoint-as-checkpoint-mechanism: ocap-kernel uses
  SQLite savepoints (kernel-store wrap) for the atomic-
  checkpoint property. Cycle 141's daemon-cas-management also
  chose SQLite (Rust supervisor side); cycle 161 noted
  ocap-kernel has both Node native + WASM implementations.

  §Crank-buffering centerpiece (Issue #786): five concrete
  buffering operations (enqueueSend / enqueueNotify /
  resolvePromises with immediate=false; flushCrankBuffer on
  success; discard on rollback). §Default-safe-default-
  deferred discipline (immediate=false by default).

  §The-key-insight: §run-queue-as-the-commit-fence
  observation. Run queue is the boundary between uncommitted-
  state and committed-state. By the time RemoteHandle persists
  and transmits, the originating crank has *already* committed.

  §Don't-conflate-the-two-persistence-purposes clarification:
  RemoteHandle's remotePending persistence serves *two*
  invariants — output-validity (Ken property 2) + at-least-
  once-retransmit (Ken properties 1 + 6). §Same-table-two-
  invariants discipline.

  §Receive-side savepoint-wrapped processing (Issue #808):
  §savepoint-with-named-rollback-on-throw shape with explicit
  TypeScript snippet. §Revert-in-memory-state-too-not-just-
  the-database observation (rollback covers database; catch
  block separately reverts in-memory highestReceivedSeq).
  §Deterministic-savepoint-name discipline (`receive_
  ${remoteId}_${seq}`).

  §Duplicate-detection-via-seq-comparison: §guard-on-seq-
  comparison-not-Set-lookup pattern. Ken's canonical Done-
  table replaced by §high-water-mark-discipline (simpler,
  equivalent under FIFO).

  §FIFO-via-TCP-not-receive-side-reordering: §borrow-FIFO-
  from-the-transport choice. libp2p streams provide in-order
  delivery; no receive-side reorder buffer needed. §don't-
  reinvent-the-FIFO discipline. §post-crash-out-of-order-
  handled-by-dedup observation.

  §Progress-summary-claim closing assertion: *All Ken
  protocol properties are now implemented*. §Confident-
  completion-claim posture backed by issue-numbered
  traceability + TypeScript snippets.

  Cross-comparison with garden cycles identified §gap-
  revealing-comparison observations: Endo's daemon doesn't
  yet have named §crank-buffering protocol-level invariant
  (cycle 119); Endo's streaming doesn't yet have §deferred-
  transmission (cycle 137); cycle 149's §error-path-cannot-
  depend-on-error-path is the per-design version of Ken's
  §output-validity protocol property; cycle 100's GC-
  rejection-tracker gap *would not exist* under Ken's
  §exactly-once-delivery; cycle 156's §gc-as-side-channel
  warning is *mitigated* by Ken's deterministic-delivery
  discipline; cycle 141's SQLite choice is the same substrate.

  §Synthesis-target identified: §adopt-vocabulary-not-
  implementation. Future Endo-side designs could use the
  Ken-property vocabulary (transactional-turns / output-
  validity / deferred-transmission / atomic-checkpoint /
  consistent-frontier / local-recovery / sender-based-logging
  / exactly-once-delivery / FIFO-ordering) when discussing
  message-delivery discipline. §Reference-not-substrate
  stance (cycle 161) extends to *vocabulary-borrowing*.

  Cycle 162 was nominally chat-lane (cycle 161 was designs).
  Papers-lane blocked 56+ consecutive cycles. Cycle 162
  pivoted to comments-lane and continued the ocap-kernel
  queue.

  Three reference links: HP Labs HPL-2010-155 / Ken project
  at U Michigan / Waterken Java implementation.
---

> Abstract: `docs/ken-protocol-assessment.md` (203 lines) is
> a **§completion-claim-against-named-protocol** document.
> Audits ocap-kernel's remote-messaging system against the
> seven Ken-protocol properties (HPL-2010-155 Kelly/Karp/
> Stiegler/Close/Cho) and asserts *All Ken protocol
> properties are now implemented*.
>
> **Second ocap-kernel ingest** after cycle 161's overview;
> §queued-doc-1 from that overview's plan.
>
> §Canonical-protocol-citation; §named-protocol-as-acceptance-
> criterion concretized.
>
> §Seven-Ken-properties enumeration; §output-validity (could-
> have-resulted-from-failure-free-execution) is the most
> semantically interesting. §Ken-turn-model code block with
> §atomic-checkpoint-before-transmit discipline.
>
> **Single most structurally interesting move**: §twelve-row
> self-assessment table — each Ken property mapped to concrete
> implementation pointer. §Each-property-points-at-a-named-
> implementation-artifact; §issue-numbers-anchor-the-claims
> (#786 + #808); §verifiable-provenance-not-just-assertion.
>
> §Crank-buffering centerpiece (Issue #786). §Run-queue-as-
> the-commit-fence observation. §Don't-conflate-the-two-
> persistence-purposes (output-validity vs at-least-once-
> retransmit).
>
> §Receive-side savepoint-wrapped processing (Issue #808)
> with TypeScript snippet. §Revert-in-memory-state-too-not-
> just-the-database. §Duplicate-detection-via-seq-comparison
> with §high-water-mark-discipline. §FIFO-via-TCP-not-
> receive-side-reordering.
>
> §All-Ken-protocol-properties-are-now-implemented closing
> assertion; §confident-completion-claim posture.
>
> §Gap-revealing-comparison with garden cycles (119/137/149/
> 100/156/141). §Synthesis-target: §adopt-vocabulary-not-
> implementation.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline](../sections/metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline.md) | daemon, captp, persistence | current |

Tight 203-line completion-claim doc. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `MetaMask/ocap-kernel@a3eff0efb`
  (last touch of file: commit `475304c46e4c9d4910f0cc50318c5346173af01b`).
- License: dual Apache-2.0 + MIT.
- **Second ocap-kernel ingest** after cycle 161's monorepo
  overview. §Queued-doc-1 from that overview's plan.
- Cycle 162 was nominally **chat-lane** (cycle 161 was
  designs). Papers-lane has been blocked for **56+ consecutive
  cycles**. Cycle 162 pivoted to comments-lane and continued
  the ocap-kernel queue (the §sibling-implementation-
  comparison genre).
- One cohesion-honest section.
