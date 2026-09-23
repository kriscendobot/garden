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
title: §fxHasPendingJobs-is-check-and-reset (the critical insight)
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

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
