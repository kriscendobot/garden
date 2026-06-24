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
title: §Two-wrong-fixes-considered (the §illusion-of-an-option pattern)
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

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
