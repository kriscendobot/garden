---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
---

# Seven Ken-properties self-assessment with crank-buffering and savepoint-wrapped receive discipline

> *All Ken protocol properties are now implemented.*
>
> — `docs/ken-protocol-assessment.md` closing claim

`docs/ken-protocol-assessment.md` (203 lines) is a **§completion-
claim-against-named-protocol** document. The ocap-kernel team
audits their own remote-messaging system against the seven
properties of the Ken protocol (HP Labs Tech Report HPL-2010-155:
*Output-Valid Rollback-Recovery* by Kelly, Karp, Stiegler,
Close, and Cho) — and asserts full compliance.

**Second ocap-kernel ingest** after the cycle-161-between
overview. This is the §queued-doc-1 from that overview's
§queued-for-future-cycles plan. Continues the **§sibling-
implementation-comparison genre** with the most directly
cross-comparable doc.

## The §load-bearing-canonical-reference

The doc opens with a single sentence locating its frame:

> *This document assesses our current remote messaging system
> against the ideals of the Ken protocol, as described in HP
> Labs Tech Report HPL-2010-155: "Output-Valid Rollback-
> Recovery" by Kelly, Karp, Stiegler, Close, and Cho.*

The §canonical-protocol-citation discipline:

- **Cite the named protocol** (Ken).
- **Cite the source document** (HPL-2010-155).
- **Cite the authors** (five names).

The §named-protocol-as-acceptance-criterion observation from
cycle 161's overview is *concretely instantiated* here. The
seven Ken properties become the *acceptance test* for the
implementation. Each property either ✓ (with implementation
pointer) or not present (with explanation).

The §Stiegler-name observation: Mark Stiegler is one of the
five Ken authors. Cycle 94's OCPL paper (Swasey-Garg-Dreyer
2017) identified Stiegler 2006's *How Emily tamed the Caml*
(HPL-2006-116) as a separately-cited Stiegler work. The Ken
paper here is Stiegler's *other* HP Labs collaboration.

## The §seven-Ken-properties enumeration

The properties (verbatim, lines 9-15):

1. **Exactly-once delivery** in process-pairwise FIFO order
2. **Output validity**: Outputs could have resulted from
   failure-free execution
3. **Transactional turns**: One message delivered →
   processing → checkpoint → transmit outputs
4. **Consistent frontier**: Most-recent per-process
   checkpoints always form a recovery line
5. **Local recovery**: Crashes cause only local rollbacks,
   no domino effect
6. **Sender-based message logging**: Messages persisted in
   sender's output queue until ACKed
7. **Deferred transmission**: Outputs buffered during turn,
   transmitted only after checkpoint

The §exactly-seven-numbered-properties discipline: each
property is named, each is single-purpose, each is
independently testable. Compare with cycle 153's §three-
layer-auditable defense (Config + Allowlist + Named-step) —
both designs use a §named-N-criteria methodology.

The §output-validity property is the most semantically
interesting:

> *Outputs could have resulted from failure-free execution.*

The §failure-free-execution-as-correctness-baseline: a
message arriving at a remote is *valid* if and only if it
could have arrived in a world *without* crashes. This rules
out *crash-induced phantom outputs* (a crash producing a
message that the no-crash run would never have sent).

## The §Ken-turn-model code block

```
turn_start(deliver exactly one message to processing_function)
  → processing_function executes
  → outputs buffered in Q_out (not transmitted yet)
turn_end:
  → atomically persist(turn, app_state, Q_out, Done)
  → THEN transmit buffered messages
```

The §atomic-checkpoint-before-transmit discipline. Five key
aspects (lines 30-35):

- Only one message delivered per turn
- All outputs buffered until end of turn
- Atomic checkpoint includes application state AND output
  queue
- Transmission happens only after checkpoint completes
- `Done` table tracks which messages have been processed to
  completion

The §checkpoint-includes-output-queue invariant: the
*outputs* are durable *before* they're transmitted. If a
crash happens after checkpoint but before transmission, the
recovered process *still has the outputs to transmit*. If a
crash happens before checkpoint, no transmission occurred and
no inconsistent state exists.

The §Done-table-tracks-processed-to-completion observation:
this is the receive-side dual of the §sender-based-message-
logging property. Sender persists outputs until ACKed;
receiver persists *which-messages-are-done*. Both are
necessary for the §exactly-once invariant.

## The §single most structurally interesting move — §twelve-row self-assessment table

The §Assessment-of-Our-Current-System section presents a
**twelve-row table** (lines 41-55), each row mapping a Ken
property to a *concrete implementation pointer*:

| Property | Implementation pointer |
|----------|----------------------|
| Sender-based logging | `remotePending.${remoteId}.${seq}` keys |
| Sequence numbers | `seq` outgoing + `highestReceivedSeq` incoming |
| Cumulative ACK | piggyback ACKs |
| Retransmission | timeout-based |
| Crash-safe persistence | write-message-then-update-nextSendSeq ordering |
| Local recovery | restore seq state + restart ACK timeout |
| Transactional turns | crank-buffering defers outputs |
| Deferred transmission | outputs reach RemoteHandle only after crank commits |
| Output validity | crank-buffering ensures outputs escape only after commit |
| Atomic checkpoint | database savepoints |
| Exactly-once receive | transactional receive with dedup (Issue #808) |
| FIFO ordering | TCP in-order + dedup |

The §each-property-points-at-a-named-implementation-artifact
discipline. Not "we do X"; rather "we do X *here*, via *this
specific code path*." A future reader (or auditor) can
*verify the claim* by reading the named file or running the
named test.

The §issue-numbers-anchor-the-claims observation: §#786
(crank-buffering) and §#808 (exactly-once receive) are
*verifiable artifacts* — GitHub PRs / issues that record
*when* and *how* the property was implemented. The §verifiable-
provenance-not-just-assertion discipline.

The §database-savepoints-for-atomic-checkpoint specific
implementation choice: rather than a custom transaction
manager, ocap-kernel uses *SQLite savepoints* (which the
kernel-store package wraps). Cycle 141's daemon-cas-management
also chose SQLite (via Rust supervisor); cycle 161's overview
noted ocap-kernel's kernel-store has both Node.js native and
WASM SQLite implementations. The §SQLite-savepoint-as-
checkpoint-mechanism choice is consistent across the
substrate.

## The §crank-buffering centerpiece

§Crank-buffering (Issue #786) is the implementation of the
§transactional-turns + §deferred-transmission + §output-
validity triad. The model:

```
crank_start(deliver one item from run queue)
  → create database savepoint
  → vat processes message
  → vat syscalls buffer outputs (sends, notifications) in CrankBuffer
crank_end:
  → if success: atomically flush buffer to run queue + commit state
  → if failure: rollback to savepoint, discard buffer
```

The §savepoint-create-then-buffer-then-commit-or-rollback
shape. Five concrete operations listed (lines 75-79):

- `enqueueSend(target, message, immediate=false)` buffers
  sends
- `enqueueNotify(endpoint, kpid, immediate=false)` buffers
  notifications
- `resolvePromises(endpoint, resolutions, immediate=false)`
  buffers all resolution effects
- On successful crank: `#flushCrankBuffer()` moves items to
  persistent run queue
- On rollback: buffer is discarded along with database
  changes

The §immediate-equals-false-by-default observation: all the
enqueue methods take an `immediate=false` parameter. The
*default* is buffering. The §default-safe-default-deferred
discipline.

The §the-key-insight paragraph (lines 81-83) makes the most
important §output-validity argument:

> *When a message destined for a remote reaches `RemoteHandle`,
> it arrives via the run queue. Items only reach the run queue
> after the originating crank commits. Therefore, by the time
> `RemoteHandle` persists and transmits a message, the crank
> that produced it has already committed. The transmitted
> message corresponds to committed local state.*

The §run-queue-as-the-commit-fence discipline: the *run queue*
is the *boundary* between *uncommitted state* and *committed
state*. Anything past the run queue *has been committed*.
Anything before the run queue *is still in a buffer that may
roll back*.

## The §two-different-persistence-purposes clarification

> *`RemoteHandle` persists messages to `remotePending` before
> transmitting for a different reason: to enable
> retransmission on recovery if the transmission or ACK is
> lost. This is part of the at-least-once delivery mechanism,
> not the output validity mechanism.*

The §don't-conflate-the-two-persistence-purposes observation.
Two *distinct* reasons to persist:

1. **Output validity** (Ken property 2): outputs persist
   *before* externalization so they're durable across
   crashes.
2. **At-least-once retransmit** (Ken properties 1 + 6): the
   *transmitted-but-unacknowledged* messages persist so they
   can be retransmitted if the transmission or ACK was lost.

The same persistence machinery (`remotePending` table) serves
both purposes, but the *invariants are different*:

- **Output validity** says: *if this output exists, it
  reflects committed local state*.
- **At-least-once retransmit** says: *if this output was sent
  but not ACKed, we can resend it*.

The §same-table-two-invariants discipline. A future reader
who *only sees the table* might mistake one invariant for
the other; the doc names both *explicitly*.

## The §receive-side savepoint-wrapped processing

The §receive-side-implementation section (Issue #808) shows
the *implementation in TypeScript*:

```typescript
const savepointName = `receive_${this.remoteId}_${seq}`;
this.#kernelStore.createSavepoint(savepointName);
try {
  // Process message (translate refs, add to run queue, etc.)
  switch (method) {
    case 'deliver': ...
    case 'redeemURL': ...
    case 'redeemURLReply': ...
  }
  this.#kernelStore.setRemoteHighestReceivedSeq(this.remoteId, seq);
  this.#kernelStore.releaseSavepoint(savepointName);
} catch (error) {
  this.#highestReceivedSeq = previousHighestReceivedSeq;
  this.#kernelStore.rollbackSavepoint(savepointName);
  throw error;
}
```

The §savepoint-with-named-rollback-on-throw shape. Four
concrete moves:

1. **Create savepoint** with a *deterministic name* (`receive_
   ${remoteId}_${seq}`).
2. **Process the message** inside the savepoint.
3. **Update `highestReceivedSeq` at the end** (within the
   savepoint).
4. **On error**: rollback the savepoint *and* revert the
   in-memory `highestReceivedSeq` to its previous value.

The §revert-in-memory-state-too-not-just-the-database
observation. The savepoint rolls back *database* state; the
catch block separately reverts *in-memory* state
(`this.#highestReceivedSeq = previousHighestReceivedSeq`).
Without that line, the in-memory state would diverge from the
database after rollback — a subtle bug source.

The §deterministic-savepoint-name discipline: `receive_
${remoteId}_${seq}` encodes the *coordinate* of the savepoint
(*which* message). If multiple savepoints are nested or
debugger-inspected, the name pinpoints which one is which.

## The §duplicate-detection-via-seq-comparison

```typescript
if (seq <= this.#highestReceivedSeq) {
  this.#logger.log(`ignoring duplicate message seq=${seq}`);
  return null;
}
```

The §guard-on-seq-comparison-not-Set-lookup pattern. Ken's
canonical implementation uses a *Done table* (which tracks
each message individually); ocap-kernel uses a *monotonic
high-water-mark* (which is simpler and works *given* FIFO
delivery from the transport).

The §high-water-mark-discipline observation: under FIFO,
*all* messages with `seq <= highestReceived` are by definition
already processed. Storing just the high-water-mark is
*equivalent* to storing the Done table — under the FIFO
assumption.

The §FIFO-via-TCP-not-receive-side-reordering observation
(line 137):

> *We use TCP-based transports (libp2p streams) which
> guarantee in-order delivery during normal operation. Out-
> of-order arrival only occurs after a crash when the sender
> retransmits. With duplicate detection, retransmitted
> messages for already-processed sequence numbers are dropped,
> maintaining FIFO semantics.*

The §borrow-FIFO-from-the-transport choice. ocap-kernel
chooses libp2p streams (TCP-based) as the transport; TCP's
in-order delivery is *inherited* rather than re-implemented.
The §don't-reinvent-the-FIFO discipline.

The §post-crash-out-of-order-handled-by-dedup observation: the
only way out-of-order arrival happens is the *post-crash
retransmit* edge case; dedup handles it. No receive-side
reorder buffer needed.

## The §progress-summary-claim

The closing table (lines 187-195) claims **all seven Ken
properties are now implemented**:

| Area | Status |
|------|--------|
| Kernel-internal output buffering | Achieved (#786) |
| Rollback discards uncommitted outputs | Achieved (#786) |
| Atomic kernel state + output queue | Achieved (#786) |
| Output validity (send side) | Achieved (#786) |
| Deferred transmission (send side) | Achieved (#786) |
| FIFO ordering | Achieved (TCP transport) |
| Exactly-once receive (dedup + atomicity) | Achieved (#808) |

The §all-Ken-protocol-properties-are-now-implemented closing
assertion (line 197) is the §confident-completion-claim
posture — backed by the issue-numbered traceability + the
TypeScript snippets. The doc *commits* to the claim.

The §issue-numbered traceability anchors the claim. A future
auditor can read PR #786 and PR #808 to *verify* the
implementation actually does what the doc says.

## How this maps to garden cycles

The most structurally direct comparisons:

- **Cycle 119** (`daemon-capability-bus`) — Endo's
  envelope-protocol-and-handle-rewriting. **Gap**: Endo's
  daemon doesn't (yet) have the §crank-buffering atomic-
  output-or-rollback discipline as a *named protocol-level
  invariant*. The §run-queue-as-the-commit-fence pattern
  could be adopted.
- **Cycle 137** (`daemon-message-streaming`) — the §cross-
  peer-streams-ride-CapTP observation. **Gap**: Endo's
  streaming doesn't yet have Ken's §deferred-transmission
  property (stream chunks could escape before the producer's
  turn commits).
- **Cycle 149** (`unhandled-rejection-display`) — the §error-
  path-cannot-depend-on-error-path insight. Ken's §output-
  validity is *the formal framework* for that insight: if all
  outputs escape only after commit, the diagnostic-substrate-
  cannot-fail invariant becomes a protocol property *for
  free*.
- **Cycle 100** (`unhandled-rejection.js`) — SES's GC-driven
  rejection-tracker. **Gap**: Ken's §exactly-once-delivery
  invariant *would prevent* the rejection-tracking gap (no
  duplicate deliveries means no spurious-rejection cases).
- **Cycle 156** (`finalize.js`) — the §gc-as-side-channel
  warning + the §blockchain-replay hazard. Ken's deterministic-
  delivery + Done-table approach is *exactly the discipline*
  that mitigates the gc-as-side-channel concern: outputs are
  deterministic functions of inputs *across crashes*, not of
  *gc timings*.
- **Cycle 141** (`daemon-cas-management`) — Rust supervisor +
  SQLite. The §SQLite-savepoint-as-checkpoint-mechanism is
  the *same* technology choice ocap-kernel makes for crank-
  buffering.

The §gap-revealing-comparison observation: ocap-kernel has
*named* properties that Endo's daemon implements *informally*
or *partially*. Future Endo-side designs could *adopt the
Ken-property vocabulary* without reimplementing the
substrate.

## The §synthesis-target — adopt Ken vocabulary in Endo designs?

This doc names a *vocabulary*:

- §transactional-turns
- §output-validity
- §deferred-transmission
- §atomic-checkpoint
- §consistent-frontier
- §local-recovery
- §sender-based-logging
- §exactly-once-delivery
- §FIFO-ordering

Future Endo-side designs could *use these names* when
discussing the daemon's message-delivery discipline. The
§adopt-vocabulary-not-implementation move: we don't need to
*reimplement* ocap-kernel's crank-buffering to *talk about*
output validity. Using the Ken vocabulary in Endo design
discussions makes the *gap* visible at design-review time —
"this design doesn't yet have output validity in the Ken
sense; future design could add it" is a more *actionable*
critique than ad-hoc descriptions.

The §reference-not-substrate stance (cycle 161): we don't
import ocap-kernel's code; but we *can* import their
*vocabulary* and *discipline*.

## Related sections

- cycle 161
  [[metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate]]
  — overview ingest that flagged this doc as the §queued-doc-1
  for highest-priority follow-up.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — Endo's envelope-protocol substrate; the §gap-revealing-
  comparison shows what Ken-properties Endo's daemon could
  adopt.
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — daemon-side streaming; could adopt §deferred-transmission.
- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — §error-path-cannot-depend-on-error-path; Ken's output-
  validity is the protocol-level formalization.
- cycle 156
  [[endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability]]
  — the §gc-as-side-channel + §blockchain-replay-hazard
  warnings. Ken's deterministic-delivery mitigates both.
- cycle 141
  [[endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc]]
  — same SQLite-substrate choice; ocap-kernel uses savepoints
  for kernel state; daemon-cas-management uses SQLite for
  content store.
- cycle 153
  [[endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint]]
  — sister §named-N-criteria methodology (CI: three layers /
  Ken: seven properties; both audit explicitly against the
  named criteria).
