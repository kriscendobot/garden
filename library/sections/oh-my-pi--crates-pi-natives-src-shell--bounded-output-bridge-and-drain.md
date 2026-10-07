---
title: Bounded output bridge and drain semantics
source: crates/pi-natives/src/shell.rs
source_repo: can1357/oh-my-pi
source_commit: 04fcdf69ad085059a3d143eb907f4ec13f77db5f
source_date: 2026-10-06
source_authors: [can1357, roboomp, David]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, streams]
status: current
---

> Abstract: Shell output crosses from Rust readers to the JavaScript `onChunk` callback through a 64-slot bounded queue and a pump that coalesces chunks into batches of at most 64 KiB and awaits each callback, so a slow consumer backpressures the child process instead of growing memory. Bounded stall and drain timeouts keep a wedged consumer or an orphaned pipe reader from stranding a run, while successful runs still deliver every accepted chunk.

## Backpressure, not buffering

`BRIDGE_QUEUE_CHUNKS = 64`. One queued chunk is at most one read (64 KiB or less), so the Rust side holds about 4 MiB in the worst case before reader sends park. A parked reader in turn parks the child on its stdout/stderr pipe or PTY, which is ordinary backpressure, instead of buffering the surplus in process memory. The source cites issue #4078: the earlier bridge used an unbounded channel and fire-and-forget calls, and a regression test records that a 32 MiB stream queued all 33,554,432 bytes while the consumer stalled.

The pump forwards through `call_async`, which resolves only after the JavaScript callback runs. At most one batch therefore sits in the N-API queue, and the event loop's real consumption rate throttles the pipeline.

## Coalescing

`pump_chunks` greedily drains everything already queued into one batch of up to 64 KiB (`MAX_BATCH_BYTES`) before forwarding. Children that write a byte at a time (printf-style progress, token streams) otherwise produce one callback per `write(2)`; the source records about 200% CPU on the JavaScript main thread from that pattern. The 64 KiB cap also keeps any single callback from handing the main thread a multi-megabyte string. An explicit end-of-output item ends the pump even while a sender clone is still alive (the PTY keeps one to inspect queue depth), and a `busy` flag lets the PTY tell an empty queue from output in transit.

## Bounded failure modes

- **Wedged consumer.** `FORWARD_STALL_TIMEOUT` is 30 seconds per forward. The deadline resets for every forward, so a slow consumer that is still making progress drains losslessly. Only a callback that never returns trips it. The pump then returns and drops its receiver, so parked readers fail fast and keep draining the child instead of leaving it blocked in `write(2)` with the run stuck as running (#12657). The pump also stops as soon as a forward reports that the JavaScript side is gone (environment teardown).
- **Orphaned reader after interruption.** When a run is cancelled or times out, a grandchild that inherited stdout can keep a pipe-reader sender alive indefinitely. `await_drain` waits at most `INTERRUPTED_DRAIN_SHUTDOWN_TIMEOUT` (2 seconds), then aborts the pump, so the promise settles near its requested timeout (#10308).
- **Normal completion and errors** drain with no deadline. The source's test notes that bounding this path would report success while silently dropping queued output.

The asymmetry is deliberate: lossless delivery when the run finished, bounded latency when it was interrupted.

Source: [crates/pi-natives/src/shell.rs](https://github.com/can1357/oh-my-pi/blob/04fcdf69ad085059a3d143eb907f4ec13f77db5f/crates/pi-natives/src/shell.rs) at commit `04fcdf69`.
