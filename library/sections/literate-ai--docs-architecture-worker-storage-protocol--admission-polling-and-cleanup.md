---
title: "Worker storage observation protocol: workflow admission, polling, and cleanup"
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

> Abstract: Lifecycle commands collect a fresh job-bound observation before substantial work and poll during remote dispatch, holding only later work on critical findings; cleanup is a read-only investigation over task-owned roots, and the local-only apply requires a separate exact, expiring authorization document.

## Workflow admission and polling

Lifecycle `build`, `test`, `run` and package commands accept
`--worker-health-config`. For an explicitly configured worker they collect a fresh
job-identity-bound observation before substantial execution. Critical capacity or
required unknown evidence holds new work; `retry-after-recheck` is retried only up
to the policy bound. `--worker-health-poll-seconds` controls bounded checks while a
remote dispatch remains active. A new critical finding holds only later task-owned
work: it does not cancel the already-running job, kill unrelated processes or reboot.
Failed dispatches recheck the same policy before an allocation retry.

## Cleanup investigation and exact apply

The optional `cleanup` policy names task-owned roots beneath configured storage
bindings, active and completed-use markers, recovery cost and an exact supported
tool argv containing one `{target}` placeholder. Disk warnings and critical findings
automatically scan top-level candidates under entry, depth and time budgets. An
overloaded worker receives a shallower, shorter scan. Links, junctions and reparse
points are not followed. Reports contain opaque target identities and never raw
paths; active or uncertain targets cannot enter an executable proposal.

Local workers scan locally. SSH workers receive a staged stdlib-only scanner bound
to the request digest and configured worker OS. Explicit command workers must route
the same private request when invoked with `--cleanup-investigate`. Remote response
substitution, malformed output, denial and unreachability remain distinct failed
investigation states; the controller never substitutes its own filesystem paths.

`litai worker cleanup plan` recomputes the read-only proposal and explicitly reports
that deletion is unauthorized, using the bound remote investigation when the
selected worker is remote. `litai worker cleanup apply` is local-only and
requires a current `literate-ai/worker-cleanup-authorization@1` document binding the
exact worker, capacity policy, proposal, creation time, complete target-ID set,
`configured-cleanup-tool` operation and expiry. Apply re-scans every target before
calling the configured tool without a shell, then remeasures actual available bytes.
Remote apply refuses rather than acting on controller paths. Administrative access,
release approval and ADR acceptance never substitute for cleanup authorization.

Source: [docs/architecture/worker-storage-protocol.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/worker-storage-protocol.md) at commit `fcc40bc` (source lines 193–228).
