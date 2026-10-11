---
title: "Worker storage observation protocol: explicit alert history"
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

> Abstract: An opt-in, owner-only, lock-serialized local alert-state file turns repeated inspections into deduplicated transition events (incident, escalation, change, improvement, recovery); missing measurements cannot erase an incident, and suppression never changes the job decision.

## Explicit alert history

Add `--alert-state /private/state/worker-alerts.json` to retain a bounded local
reporting baseline. Its parent must already exist and be free of symlink/reparse
traversal. On POSIX, the state file must belong to the invoking user and exclude
group/other permissions; newly published files use mode 0600. Hardlinked, malformed,
foreign-worker, oversized and changed files refuse. This explicit option updates
the selected state file and a sibling advisory lock; it does not grant cleanup or
execution permission and does not enable general CLI telemetry or MCP writes.

One file holds one worker/policy/job context, at most 80 role/resource records and
64 KiB. History older than 24 hours or from a different policy/job resets visibly.
Foreign-worker state, future history and out-of-order observations refuse. A finite
same-host lock serializes cooperating writers; publication uses an atomic staged
replacement with input, state and directory checks. This is local reporting state,
not distributed coordination or immutable admission evidence.

With persistence selected, JSON retains the complete current `assessment` and
`alerts` snapshot, and adds an `events` array plus `alert_history` metadata.
Consume `events` for deduplicated notifications. Events bind exact observation,
policy and job identities and report initial incidents, escalation, changed
conditions, improvement and recovery. Numeric jitter within the same classification
and reason does not repeat an event. Storage and sustained pressure findings share
that transition history, so unchanged CPU, memory, paging and GPU incidents are also
suppressed and their recovery is explicit. Interactive output reports new events
with measurements, impact and next action, or says there are no new transitions.

A missing measurement becomes unknown and cannot erase a prior incident. Recovery
requires a current healthy finding, including a positively known not-applicable
quota/inode result. Alert suppression never changes the job decision. State update
failure is a visible CLI failure; it never widens a write or removes unrelated data.
Remote collection still keeps this selected reporting state on the controller.

Source: [docs/architecture/worker-storage-protocol.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/worker-storage-protocol.md) at commit `fcc40bc` (source lines 160–192).
