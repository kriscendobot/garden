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
title: §The-correct-three-phase-drain-loop
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

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
