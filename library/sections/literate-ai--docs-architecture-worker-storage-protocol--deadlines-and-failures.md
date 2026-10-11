---
title: "Worker storage observation protocol: deadlines and failures"
source: docs/architecture/worker-storage-protocol.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, process-monitoring]
status: current
---

> Abstract: The receiver runs its own watchdog from process start and emits a request-bound `timed-out` response if measurement stalls, so no success is ever inferred from an absent or partial response; expired failures stay recordable but are not fresh admission evidence.

## Deadlines and failures

The controller supervises input, output and process lifetime. The receiver starts
its own watchdog before reading stdin and retains it through process exit. Once the
request is validated, it enforces the earlier of the command-line ceiling and the
request's budget, measured from receiver start. Slow input cannot reset that budget.

If measurement stalls after request validation, the watchdog emits a request-bound
response whose metrics are `timed-out`. Timeout meaning is carried in the response,
because some Windows SSH shells collapse nonzero child exit codes. A second finite
stop bounds a blocked timeout-response write. If that stop cannot start because
thread capacity is exhausted, the receiver exits immediately. No successful
measurement can be inferred from an absent or incomplete response. Failed observations remain recordable
after expiry; they are not fresh admission evidence.

The pure capacity classifier separately checks worker, policy, job, sample window and
expiry before deciding whether a job may proceed. Unsupported quota measurement
remains explicit. Native SSH measurement and injected blocked-probe checks cover
Linux, macOS and Windows; quota exhaustion, pressure monitoring, dispatch and cleanup
qualification remain owned by WORKER-HEALTH-001.

Source: [docs/architecture/worker-storage-protocol.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/worker-storage-protocol.md) at commit `fcc40bc` (source lines 70–90).
