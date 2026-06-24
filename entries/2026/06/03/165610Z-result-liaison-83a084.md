---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--83a084
ts: 2026-06-03T16:56:10Z
ref_id: 83a084
---

# Cycle 162: ocap-kernel docs/ken-protocol-assessment.md (second ocap-kernel ingest)

Continuation of librarian work. Cycle 162 is nominally
**comments-lane** (cycle 161 was the user-directed manual
ocap-kernel overview, treated as outside the autonomous lane-
rotation; cycle 161's papers-lane attempt is still blocked,
56+ consecutive cycles now). The natural continuation of the
ocap-kernel queue from cycle 161's §queued-for-future-cycles
plan was §queued-doc-1: `docs/ken-protocol-assessment.md`.
That doc is the highest-priority cross-comparable artifact in
the queue because it is a **§completion-claim-against-named-
protocol** document — it audits ocap-kernel's remote-
messaging system against the seven Ken properties (HPL-2010-
155 Kelly/Karp/Stiegler/Close/Cho) and asserts *All Ken
protocol properties are now implemented*.

## Source

`MetaMask/ocap-kernel docs/ken-protocol-assessment.md` from
the bare clone at `/home/kris/garden/worktrees/metamask-
ocap-kernel.git/`. Same monorepo as cycle 161 (HEAD
`a3eff0efb` 2026-05-28). The file itself was last touched in
commit `475304c46e4c9d4910f0cc50318c5346173af01b`. 203 lines.
Dual Apache-2.0 + MIT.

## Sections written (1)

`metamask-ocap-kernel--docs-ken-protocol-assessment-md--
seven-Ken-properties-self-assessment-with-crank-buffering-
and-savepoint-wrapped-receive-discipline.md` (461 lines;
commit `9d837d0e`).

**§Cohesion-honest section count**: One section. The doc is a
tight, focused completion-claim audit; splitting it would
fragment the §twelve-row self-assessment table (the single
most structurally interesting move) across multiple sections.

## Single most structurally interesting move

**§Twelve-row self-assessment table** mapping each Ken
property to a *concrete implementation pointer*:

- File paths (`remotePending.${remoteId}.${seq}`)
- Sequence number names (`seq`, `highestReceivedSeq`)
- Issue numbers (#786 crank-buffering, #808 receive-side
  savepoints)

This instantiates §each-property-points-at-a-named-
implementation-artifact discipline; §issue-numbers-anchor-
the-claims; §verifiable-provenance-not-just-assertion. Cycle
161's overview observed §named-protocol-as-acceptance-
criterion as a discipline; this document is the concrete
instance.

## Notable structural moves captured

- **§Canonical-protocol-citation**: HPL-2010-155 +
  Kelly/Karp/Stiegler/Close/Cho. §Stiegler-name observation:
  Mark Stiegler is one of five Ken authors (cycle 94's OCPL
  paper identified Stiegler 2006 HPL-2006-116 *How Emily
  tamed the Caml*; this Ken paper is Stiegler's *other* HP
  Labs collaboration).
- **§Seven-Ken-properties** enumeration with §output-validity
  as the most semantically interesting (could-have-resulted-
  from-failure-free-execution; rules out crash-induced
  phantom outputs).
- **§Ken-turn-model code block**: §atomic-checkpoint-before-
  transmit; §checkpoint-includes-output-queue invariant;
  §Done-table-tracks-processed-to-completion.
- **§Crank-buffering centerpiece (Issue #786)**: five concrete
  buffering operations (enqueueSend / enqueueNotify /
  resolvePromises with immediate=false; flushCrankBuffer on
  success; discard on rollback). §Default-safe-default-
  deferred discipline.
- **§Run-queue-as-the-commit-fence**: by the time RemoteHandle
  persists and transmits, the originating crank has already
  committed. The §key-insight.
- **§Don't-conflate-the-two-persistence-purposes**:
  remotePending serves *two* invariants — output-validity
  (Ken property 2) + at-least-once-retransmit (Ken properties
  1 + 6). §Same-table-two-invariants.
- **§Receive-side savepoint-wrapped processing (Issue #808)**:
  §savepoint-with-named-rollback-on-throw shape with explicit
  TypeScript snippet. §Revert-in-memory-state-too-not-just-
  the-database observation. §Deterministic-savepoint-name
  discipline (`receive_${remoteId}_${seq}`).
- **§Duplicate-detection-via-seq-comparison**: §guard-on-seq-
  comparison-not-Set-lookup pattern. Ken's Done table replaced
  by §high-water-mark-discipline (simpler, equivalent under
  FIFO).
- **§FIFO-via-TCP-not-receive-side-reordering**: §borrow-
  FIFO-from-the-transport choice; libp2p streams; §don't-
  reinvent-the-FIFO; §post-crash-out-of-order-handled-by-
  dedup.
- **§All-Ken-protocol-properties-are-now-implemented**
  closing assertion; §confident-completion-claim posture.

## Gap-revealing comparison with garden cycles

§Gap-revealing-comparison observations identified:

- Endo's daemon doesn't yet have a named §crank-buffering
  protocol-level invariant (cycle 119's `dp` daemon-
  persistence design touches related territory but does not
  yet name the invariant).
- Endo's streaming doesn't yet have §deferred-transmission
  (cycle 137 territory).
- Cycle 149's §error-path-cannot-depend-on-error-path is the
  per-design version of Ken's §output-validity protocol
  property.
- Cycle 100's GC-rejection-tracker gap *would not exist*
  under Ken's §exactly-once-delivery guarantee.
- Cycle 156's §gc-as-side-channel warning is *mitigated* by
  Ken's deterministic-delivery discipline.
- Cycle 141's SQLite choice (Rust supervisor side) is the
  same substrate as ocap-kernel's kernel-store.

## Synthesis target

**§Adopt-vocabulary-not-implementation**. Future Endo-side
designs could borrow the Ken-property vocabulary
(transactional-turns / output-validity / deferred-
transmission / atomic-checkpoint / consistent-frontier /
local-recovery / sender-based-logging / exactly-once-
delivery / FIFO-ordering) when discussing message-delivery
discipline. §Reference-not-substrate stance (cycle 161)
extends to §vocabulary-borrowing: pulling vocabulary from a
sibling implementation does not require importing its code.

## Files written / edited

- `library/sections/metamask-ocap-kernel--docs-ken-protocol-
  assessment-md--seven-Ken-properties-self-assessment-with-
  crank-buffering-and-savepoint-wrapped-receive-discipline.md`
  (461 lines; commit `9d837d0e`)
- `library/sources/metamask-ocap-kernel--docs-ken-protocol-
  assessment-md.md` (new source page)
- `library/sources/README.md` (cycle-162 row added above
  cycle-161 overview row under "External code repositories
  (sibling implementations)")
- `library/sections/README.md` (cycle-162 entry; totals
  bumped 666/207 → 667/208)
- `library/topics/daemon.md` (cycle-162 row)
- `library/topics/captp.md` (cycle-162 row)
- `library/topics/persistence.md` (cycle-162 row)
- `library/keywords.md` (49 new keyword rows for Ken-
  protocol terms)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually per standing inbox-drain script bug)

## Library totals

666 / 207 → **667 sections from 208 source documents**.

## Lane rotation note

Papers-lane has been blocked **56+ consecutive cycles** due
to lack of PDF-fetching infrastructure. Cycle 162 was
nominally papers-lane in the rotation; pivoted gracefully to
comments-lane and continued the ocap-kernel queue from
cycle 161's §queued-for-future-cycles plan.

## Cycle 162 — done. Schedule cycle 163.
