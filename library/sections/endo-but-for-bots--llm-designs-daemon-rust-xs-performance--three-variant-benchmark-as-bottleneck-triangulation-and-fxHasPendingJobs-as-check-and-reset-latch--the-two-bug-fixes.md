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
title: §The-two-bug-fixes
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

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
