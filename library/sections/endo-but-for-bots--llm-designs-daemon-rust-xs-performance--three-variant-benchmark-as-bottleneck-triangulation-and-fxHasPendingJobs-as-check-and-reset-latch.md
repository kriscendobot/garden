---
source: designs/daemon-rust-xs-performance.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-rust-xs-performance.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
status_at_ingest: Active
genre: §endo-but-for-bots-design §performance-investigation
cycle: 188
lane: designs
status: current
---

# Three-variant benchmark as bottleneck triangulation, fxHasPendingJobs as check-and-reset latch, and two-wrong-fixes considered before three-phase drain loop

> §Designs-lane after cycle 187's chat-lane. §The-twenty-
> second-consecutive designs/chat alternation cycle (166-188).
> §Status: **Active** — a §living-design that captures the
> diagnosis + fix + benchmark + remaining-optimization map.
> §Cycle-184-daemon-xs-worker-metering's §three-Dependencies
> table named this design as the "reactive pump loop
> integration" sibling.

`daemon-rust-xs-performance.md` (592 lines, Created 2026-04-16,
Updated 2026-04-17) records the §performance-investigation
that produced two bug fixes (XS host argument off-by-one + 1ms
sleep in pump loop) and a three-variant benchmark harness that
triangulates the bottleneck.

§The-single-most-structurally-interesting-move is §three-
variant-benchmark-as-bottleneck-triangulation: Node.js vs
Rust+XS vs Rust+Node. §The-comparison-decomposes-costs because
Rust+XS and Rust+Node differ §only-in-worker-platform; Rust+
Node and Node.js differ §only-in-supervisor. §If-Rust+XS ≈
Rust+Node, the bottleneck lives in the supervisor (not the
worker). §This-is-the-§controlled-experiment discipline.

## §The-three-variant-benchmark (the spine)

| Variant | Supervisor | Worker | What it isolates |
|---------|------------|--------|------------------|
| Node.js | Node.js process | Node.js subprocess workers | Baseline (in-process CapTP) |
| Rust+XS | Rust supervisor | XS workers | Both Rust supervisor + XS engine |
| Rust+Node | Rust supervisor | Node.js subprocess workers | Just Rust supervisor (worker = Node.js as baseline) |

§A-third-variant (Rust+Node) was added to §isolate-supervisor-
overhead-from-worker-overhead. §Without-it, a slow Rust+XS
result could be either the Rust supervisor's fault or the XS
worker's fault. §With-Rust+Node, the comparison is decisive:

> The Rust+XS and Rust+Node columns being nearly identical
> confirmed the bottleneck was in the manager's message bus,
> not in the worker platform.

§The-§nearly-identical observation is the §triangulation
result. §If-both-Rust-variants-are-slow-equally, the slowness
is upstream of the worker.

§Compare-to-cycle-182-debugger's §three-option-architectural-
decision-table and cycle 178-snapshot's §three-axes-of-
snapshot-incompatibility. §This-design's §three-variant-
benchmark is a §three-way-experimental-decomposition (rather
than a three-option-design-decision).

## §The-two-bug-fixes

### §Fix-1: §off-by-one in `frame.sub(2 + i)` → `frame.sub(1 + i)`

§The-XS-stack-frame-layout puts arguments at decreasing offsets
from `the->frame`:

```
mxArgv(i) = the->frame - 1 - i
  First arg (i=0): frame.sub(1)
  Second arg (i=1): frame.sub(2)
```

§Every-Rust-host-callback used `frame.sub(2 + index)` — §an-
extra-+1 from misreading the XS macros (confusing `mxArgv`
with `mxThis`).

§Files-fixed: `worker_io.rs` + `powers/fs.rs` + `powers/
crypto.rs` + `powers/sqlite.rs` (8 occurrences) + `powers/
process.rs` + `lib.rs` (test host functions). §Six-files-and-
~20+-call-sites.

§Compare-to-cycle-185-check-bundle's §gap-between-design-and-
implementation. §This-bug-was-§a-systematic-misreading rather
than a §design-vs-implementation-drift, but both are §wide-
ranging-once-found.

### §Fix-2: §1ms-sleep-in-pump-loop → §three-phase-drain-loop

§The-original-pump-loop called `fxRunPromiseJobs` once, checked
`fxHasPendingJobs`, and if the flag was set, slept 1ms before
retrying. §The-fix: replace sleep with a §three-phase-drain
that loops `fxRunPromiseJobs` until the flag returns 0.

§Why-the-sleep-was-wrong (named explicitly):

1. **§Performance**: every CapTP round-trip paid ≥1ms of dead
   time. §Multi-step-operations accumulated many milliseconds.
2. **§Correctness**: the sleep was a §workaround-for-the-
   wrong-problem. The right fix is to drain the queue rather
   than wait for "something else" to drain it.

§The-benchmark-improvement: 7-18x on every warm operation
(eval_warm 17.9x; storeValue_lookup 26.6x; cancel_worker
11.4x; ping 9.7x; provideWorker 8.3x; list 7.8x).

§Compare-to-cycle-184-metering's §key-simplification (admission
control eliminates embargo). §Both-are-§replace-a-workaround-
with-a-correct-mechanism patterns. §The-workaround-was-paying-
a-performance-cost-to-mask-a-correctness-bug.

## §fxHasPendingJobs-is-check-and-reset (the critical insight)

```c
// xsnap-platform.c
static int gHasPendingJobs = 0;

void fxQueuePromiseJobs(txMachine* the) {
    the->promiseJobs = 1;
    gHasPendingJobs = 1;  // Set when ANY promise resolves
}

int fxHasPendingJobs(void) {
    int result = gHasPendingJobs;
    gHasPendingJobs = 0;  // RESET on read
    return result;
}
```

§The-§latch-not-counter discipline: `fxHasPendingJobs` returns
1 if any promise was queued since the last call, then **clears
the flag**.

§The-design-names-this-explicitly: "It is not a count; it is a
one-shot latch."

§Why-this-matters: a single `fxRunPromiseJobs` call only
drains the jobs that were pending at call time — newly queued
jobs require another call. §And-the-latch-reset-on-read means
you can't peek at the flag without consuming it.

§The-§read-once-consume-once semantics make this a §primitive-
synchronization-channel. §Compare-to-cycle-156-finalize.js'
§weak-value-map and cycle-173-promise-executor-kit's §release-
on-settle. §All-three-are-§one-shot-mechanisms with §specific-
lifecycle-semantics.

## §Two-wrong-fixes-considered (the §illusion-of-an-option pattern)

§The-design-records-§two-wrong-paths considered before the
correct fix:

### §Wrong-path-1: sleep(1ms)

§Already-discussed. §Pays-performance-for-no-correctness-
benefit.

### §Wrong-path-2: blocking recv after fxRunPromiseJobs

```
Replacing sleep with a blocking recv_raw_envelope() caused a
deadlock.  After fxRunPromiseJobs, fxHasPendingJobs returns 1
because jobs were queued during execution.  Those jobs don't
need external input — they just need another fxRunPromiseJobs
turn.  But the code blocked on recv, waiting for an envelope
that would never come because the JS hadn't progressed far
enough to send the outbound message...
```

§The-§deadlock named explicitly: the blocking-recv waits for
input that the worker can only produce after running more
promise jobs.

§Compare-to-cycle-186-break-dev-dependency-cycles' §"illusion
of an option" — a candidate fix that looks correct but isn't.
§Cycle-188-blocking-recv looks like "wait for next envelope"
but it's a §self-imposed-deadlock when the work is internal.

§Two-wrong-fixes-named-explicitly = §honest-design-evolution-
record (cycles 178/180/183/184/186 family).

## §The-correct-three-phase-drain-loop

```rust
loop {
    // Drain promise jobs until no new jobs are queued.
    loop {
        fxRunPromiseJobs(machine.raw);
        if fxHasPendingJobs() == 0 { break; }
    }

    // Drain inbound envelopes (non-blocking).
    let mut got_envelope = false;
    loop {
        match try_recv_raw_envelope() {
            Ok(Some(data)) => {
                got_envelope = true;
                handle_envelope(&machine, &data);
            }
            Ok(None) => break,
            Err(_) => break 'outer,
        }
    }

    // Envelopes may have triggered new promise jobs.
    if got_envelope { continue; }

    // sendRawFrame (called during promise execution) may have
    // queued new jobs without producing inbound envelopes yet.
    if fxHasPendingJobs() != 0 { continue; }

    // Truly idle.
    break;
}
```

§Three-phases per iteration:

1. **§Phase-1: drain promise jobs** until fxHasPendingJobs == 0.
2. **§Phase-2: drain inbound envelopes** (non-blocking).
3. **§Phase-3: decide-to-loop-or-break** based on whether
   envelopes arrived OR new jobs got queued.

§Zero-sleep + §zero-polling = §correct-and-fast.

§The-comment-§"sendRawFrame (called during promise execution)
may have queued new jobs without producing inbound envelopes
yet" names a §subtle-corner-case: a JS promise resolution can
queue more JS work *without* producing a Rust envelope. §The-
§fxHasPendingJobs-final-check catches this.

§Compare-to-cycle-178-snapshot's §two-init-paths-one-entry-
point and cycle-184-metering's §three-mode-meter. §All-three-
are-§state-machine-with-named-phases patterns.

## §The-XS-block-scoping-bug-with-eval+try/catch

§A-second-XS-engine-quirk surfaced during the fix work:

```
When bundle code is wrapped in try { <code> } catch(e) {},
const declarations become block-scoped to the try block.
XS does not retain these bindings for async continuations
after await, causing ReferenceError for any const declared
inside the try block that is referenced after an await.
```

§The-bug: §block-scoped-const-not-retained-across-await in XS.
§Workaround: use `eval(jsonString)` or inline values at the
usage site.

§This-affected-daemon_bootstrap.js — the CBOR helper functions
had to be §inlined-at-the-call-site because `main()` awaits
before using them.

§Compare-to-cycle-178-snapshot's §callback-table-is-append-
only (§stable-indices-across-suspend-resume) and cycle-176-
endor-architecture's §CESU-8-surrogate-pair-encoding (XS
string quirk). §All-three-are-§XS-engine-quirks-with-named-
workarounds. §The-quirks-form-a-§taxonomy of "things that
work in V8 but require care in XS."

## §The-benchmark-comparison-table

§Before-fixes (with 1ms sleep):

| Operation | Node.js | Rust+XS | Rust+Node |
|-----------|---------|---------|-----------|
| ping | 0.3ms | 5.8ms | 5.4ms |
| eval_warm | 2.0ms | 44.7ms | 43.7ms |
| storeValue_lookup | 0.8ms | 47.9ms | 49.0ms |

§After-fixes:

| Operation | Node.js | Rust+XS | Rust+Node | Speedup |
|-----------|---------|---------|-----------|---------|
| ping | 0.3ms | 0.6ms | 0.6ms | 9.7x |
| eval_warm | 1.7ms | 2.5ms | 3.0ms | 17.9x |
| storeValue_lookup | 1.0ms | 1.8ms | 2.2ms | 26.6x |

§The-§speedup-column compares Rust+XS-before vs Rust+XS-after.
§Numbers-cited in three places (summary + before-table + after-
table + speedup-column) for §triangulation-from-multiple-angles.

§Compare-to-cycle-184-metering's §all-seven-phases-Complete
status section with file-paths-and-test-counts. §Both-record-
empirical-evidence-of-design-claims.

## §Four-remaining-optimization-opportunities (the §next-cycle of perf work)

```
1. JSON encode/decode in CapTP payload
2. Channel bridge scheduling latency
3. Worker spawn latency
4. String info cache
```

§Each-opportunity-is-named-with-an-attribution to a specific
mechanism. §`JSON encode/decode` lives in `connection.js`;
§`channel bridge` lives in the supervisor↔manager interface;
§`worker spawn latency` lives in `provideWorker`; §`string info
cache` lives in `build.rs:147`.

§Compare-to-cycle-180-hex-package's §five-known-gaps and cycle
178-snapshot's §revised-scope-discussion. §This-design-names-
known-future-work-with-attribution rather than open-ended
TODOs.

## §The-working-copy-inventory (the §uncommitted-change-map)

§The-design-includes-an-uncommitted-change-map section that
maps eight discrete change clusters to design documents:

| # | Cluster | Files | Design doc |
|---|---------|-------|------------|
| 1 | XS host function argument fix | 6 files | This design |
| 2 | Reactive pump loop fix | lib.rs lines 1296-1358 | This design |
| 3 | Worker platform refactoring | 8 files | daemon-endor-architecture (cycle 176) |
| 4 | XS heap snapshots + suspend/resume | 9 files | daemon-xs-worker-snapshot (cycle 178) |
| 5 | Benchmark harness | 1 new file | This design |
| 6 | CESU-8 encoding fix | worker_io.rs | This design + cycle 176 |
| 7 | XS block-scoping workaround | daemon_bootstrap.js | This design |
| 8 | Misc (Cargo.lock + Cargo.toml + designs/README) | several | All three |

§The-§working-copy-inventory section serves as §a-map-so-the-
next-agent-can-orient-quickly. §This-is-§designs-as-living-
documents discipline: the design is not just specification but
also §navigation-aid for the in-progress work.

§Compare-to-cycle-184-metering's §Status-section-as-shipped-
artifact-archive. §Both-are-§designs-as-archives but at
different lifecycle points: cycle 184 archives completed work;
cycle 188 archives in-progress work.

## §Status: Active (not Complete)

§Active-not-Complete: the design is a §living-document that
captures the §investigation-and-discoveries rather than a
§one-shot-design-then-ship artifact.

§The-Active-status pairs with cycle 176-endor-architecture (the
parent design with status Active). §Cycle-178/184-snapshot/
metering have status In Progress / Complete (each describes
one feature-line). §Cycle-176/188-are-Active because they
describe ongoing investigations.

§Five-design-lifecycle-statuses-observed-so-far across the
endo-but-for-bots designs:

| Status | Examples |
|--------|----------|
| **Complete** | cycle 180 hex-package, cycle 184 metering, cycle 186 break-dev-deps |
| **In Progress** | cycle 178 snapshot, cycle 182 debugger, cycle 186 (Cuts 2-5 in this state) |
| **Proposed** | cycle 174 gateway-package |
| **Active** | cycle 176 endor-architecture, cycle 188 rust-xs-performance |
| **Reference** | cycle 170 daemon-capability-filesystem |
| **Implemented** | cycle 133 daemon-guest-eval-simplification |
| **Not Started** | cycle 135 daemon-locator-reference (originally) |

§Seven-distinct-statuses now observed across the corpus (one
more than cycle 178's §seven-distinct-design-lifecycle-statuses
count — cycle 188 confirms the same set).

## §Cohesion notes

- §Three-variant-benchmark-as-bottleneck-triangulation: Node.js
  vs Rust+XS vs Rust+Node. §The-third-variant isolates
  supervisor from worker.
- §fxHasPendingJobs-is-check-and-reset (latch not counter)
  with §read-once-consume-once semantics.
- §Two-wrong-fixes-considered-and-rejected (sleep + blocking
  recv) before three-phase drain loop. §Sibling to cycle 186's
  §"illusion of an option" pattern.
- §The-blocking-recv-deadlock named explicitly with §reason
  ("waits for input that the worker can only produce after
  running more promise jobs").
- §Three-phase-drain-loop with §subtle-final-fxHasPendingJobs-
  check for §sendRawFrame-queued-jobs-without-producing-
  envelopes.
- §The-XS-block-scoping-bug + §CESU-8-encoding-bug + §off-by-
  one-frame-offset = §three-XS-engine-quirks-with-named-
  workarounds discovered during the work.
- §Benchmark-numbers-cited-from-three-angles (summary +
  before-table + after-table + speedup-column).
- §Four-remaining-optimizations named with §attribution-to-
  specific-mechanisms.
- §Working-copy-inventory section as §navigation-aid for
  in-progress work that spans three design documents.
- §Active-status as §living-investigation rather than §design-
  then-ship artifact.

## §Tier-1 borrowing

- §three-variant-benchmark-as-bottleneck-triangulation (A vs
  B vs C lets you isolate which boundary causes the cost)
- §check-and-reset-latch-not-counter (read-once-consume-once
  flag semantics)
- §two-wrong-fixes-considered-and-rejected (the §illusion-of-
  an-option pattern applied to performance fixes; name the
  deadlock + the dead-time)
- §three-phase-drain-loop (drain-jobs → drain-envelopes →
  check-for-new-work → loop or break)
- §subtle-final-check-for-implicit-state (the second
  fxHasPendingJobs check catches jobs queued without envelopes)
- §benchmark-numbers-cited-from-three-angles
- §working-copy-inventory section as §navigation-aid
- §Active-status as §living-investigation
- §the-§XS-engine-quirks-taxonomy (block-scoping + CESU-8 +
  frame offsets join cycle 176's CESU-8 + cycle 178's callback
  table)
- §designs-as-archives-of-in-progress-work (not just shipped)

## §Synthesis-target

The §slot-machine-library's worker-platform-performance work
(if applicable) can §borrow-the-three-variant-benchmark-as-
bottleneck-triangulation. §A-third-variant-that-shares-one-
boundary-with-each-other-variant lets you decompose costs.

§The-§check-and-reset-latch-not-counter pattern is borrowable
for any §work-pending-signal where the consumer needs to drain
to quiescence; the §read-once-consume-once-semantics make a
naive while-loop terminate naturally.

§The-§working-copy-inventory pattern is borrowable for any
§multi-design-investigation where uncommitted work spans
multiple specification documents; the inventory is a §map for
future contributors.
