---
title: 'endo-but-for-bots designs/daemon-rust-xs-performance.md — Rust+XS Daemon Performance'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-rust-xs-performance.md
source_paths:
  - designs/daemon-rust-xs-performance.md
authors:
  - Kris Kowal (prompted)
created: 2026-04-16
updated: 2026-04-17
status_at_ingest: Active
ingested: 2026-06-03
ingested_by: scholar
topics:
  - daemon
  - tooling
sections:
  - endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch.md
genre: §endo-but-for-bots-design §performance-investigation
cycle: 188
lane: designs
---

# Rust+XS Daemon Performance (design — Active)

## §Abstract

592-line Active design that records the §performance-
investigation producing two bug fixes (XS host argument off-
by-one + 1ms sleep in pump loop) and a §three-variant-
benchmark harness (Node.js / Rust+XS / Rust+Node) that
triangulates the bottleneck.

§The-key-finding: the bottleneck was the 1ms `thread::sleep`
in the XS event loop, not the worker engine. §The-three-
variant-benchmark proved it: Rust+XS and Rust+Node showed
nearly identical numbers before the fix, isolating the cost
to the supervisor.

§The-fix: replace sleep with a §three-phase-drain-loop:

1. Drain promise jobs until `fxHasPendingJobs() == 0` (the
   §check-and-reset-latch).
2. Drain inbound envelopes (non-blocking try_recv).
3. If envelopes triggered new jobs OR new jobs were queued
   without envelopes (sendRawFrame case), loop; else break.

§The-result: 7-18x speedup on every warm operation.

§Additional-XS-engine-quirks-discovered during the work:

- §off-by-one in `frame.sub(2 + i)` should be `frame.sub(1 +
  i)` — every Rust host callback was reading the wrong stack
  slot.
- §XS-block-scoping-with-eval+try/catch — const declarations
  don't survive await across try-block boundaries; workaround
  is to inline at usage site.
- §CESU-8-encoding for XS string round-trip (same as cycle 176
  endor-architecture's named quirk).

§Active-status (not Complete): the design captures §the-
investigation rather than a §design-then-ship artifact. §The-
§working-copy-inventory section maps eight uncommitted change
clusters to three design documents.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/daemon-rust-xs-performance.md` | 592 | The design being ingested |
| `rust/endo/xsnap/src/lib.rs` | — | XS machine, reactive pump loop (the fix) |
| `rust/endo/xsnap/src/worker_io.rs` | — | Host function helpers + CESU-8 |
| `rust/endo/xsnap/src/powers/{fs,crypto,sqlite,process,modules}.rs` | — | Host function impls (offset fixes) |
| `rust/endo/xsnap/xsnap-platform.c` | — | fxHasPendingJobs + fxQueuePromiseJobs |
| `rust/endo/xsnap/src/daemon_bootstrap.js` | — | Bundled JS daemon manager (block-scoping fix) |
| `packages/daemon/test/bench-daemon.js` | — | Three-variant benchmark harness |

## §Dependencies and lineage

- §Cycle-184-metering's §Dependencies-table cites this design
  as "reactive pump loop integration" sibling.
- §Cycle-176-endor-architecture is the §parent-architecture-
  design (this design's #3 / #4 working-copy items reference
  cycle 176 + cycle 178).
- §Cycle-178-snapshot's §two-init-paths-one-entry-point relies
  on the pump loop's correct quiescence semantics; the §sleep-
  fix lands before snapshot integration.
- §Sibling-to cycle 182-debugger's §thread-local-buffers-with-
  mutex (same engine-level concurrency discipline).
- §XS-engine-quirk-taxonomy now spans cycle 176 (CESU-8),
  cycle 178 (callback-table), cycle 184 (custom-fxAbort), and
  cycle 188 (block-scoping + frame-offsets).

## §Related sources in the library

- §Cycle 184 (`endo-but-for-bots--llm-designs-daemon-xs-worker-
  metering.md`) — §sibling-Dependencies-entry. Cycle 184's
  Dependencies table names cycle 188 as "reactive pump loop
  integration."
- §Cycle 176 (`endo-but-for-bots--llm-designs-daemon-endor-
  architecture.md`) — §parent-architecture. The Worker
  platform refactoring (working-copy item 3) is cycle 176's
  scope.
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-snapshot.md`) — §sibling-feature. The XS heap
  snapshot work (working-copy item 4) is cycle 178's scope.
- §Cycle 182 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-debugger.md`) — §sibling-XS-feature. Different
  problem; same engine.
- §Cycle 177 (`endo--packages-netstring-reader-js.md`) — the
  netstring framing used by the Unix-socket transport between
  Node.js client and Rust supervisor.
- §Cycle 186 (`endo-but-for-bots--llm-designs-break-dev-
  dependency-cycles.md`) — §"illusion of an option" rejection-
  language sibling. Cycle 188's two-wrong-fixes are the same
  shape: candidates that look correct but aren't.

## §Comment fragments worth preserving

```
It is not a count; it is a one-shot latch.
```

§The-§latch-not-counter discipline. §Five-word-§critical-
insight that explains why the §sleep-was-both-wrong-and-
necessary.

```
The right fix is to loop fxRunPromiseJobs until
fxHasPendingJobs returns 0.
```

§The-correct-discipline named in one sentence. §Loop-until-
quiescent.

```
The Rust+XS and Rust+Node columns being nearly identical
confirmed the bottleneck was in the manager's message bus,
not in the worker platform.
```

§The-§triangulation-result. §The-§nearly-identical observation
is what isolates the bottleneck.

```
Those jobs don't need external input — they just need another
fxRunPromiseJobs turn.  But the code blocked on recv, waiting
for an envelope that would never come because the JS hadn't
progressed far enough to send the outbound message...
```

§The-§deadlock-mechanism named explicitly. §Sibling to cycle
186's §"illusion of an option" — a fix that looks correct
but isn't.

```
sendRawFrame (called during promise execution) may have
queued new jobs without producing inbound envelopes yet.
```

§The-§subtle-corner-case named. §A-JS-promise-resolution can
queue more work without producing a Rust envelope; the
§final-fxHasPendingJobs-check catches this.
