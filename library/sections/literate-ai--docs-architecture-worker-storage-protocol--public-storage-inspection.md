---
title: "Worker storage observation protocol: public storage inspection"
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

> Abstract: `litai worker health` inspects one configured worker once against a strict private health file, returning a typed observation, assessment, and alerts with exit codes for permit, hold, or retry; an optional sustained-pressure policy treats denied or stale evidence as unknown and never dispatches or writes state implicitly.

## Public storage inspection

Run `litai worker health --worker-id ID --health-config /private/health.json` with
an existing private worker catalog (or select one with `--worker-config`). The
versioned `literate-ai/private-worker-health@1` file contains `worker_id`, `os_family`,
sorted absolute `paths` pairs, optional `python_executable` and `health_command`
values (null when unused), and a `capacity` object. Capacity contains `roles`,
`write_heavy`, `maximum_age_ms`, `probe_timeout_ms`, `maximum_retries` and
`warning_headroom_bytes`; role fields match `StorageRoleCapacityPolicy`. The shipped
`worker-health-configuration.schema.json` describes this private file.

Every workspace/temp/cache/output role must appear in both paths and capacity.
Use the worker's paths and OS, not controller paths. The CLI derives the binding
identity from the selected worker, paths and receiver; users do not transcribe that
digest. Both input files are guarded across measurement. Duplicate JSON fields,
unknown fields, role mismatches and changed inputs refuse with redacted errors.
Configuration is limited to 64 KiB and the worker catalog to 1 MiB. This command
uses existing local, SSH or explicit command receivers and never creates role paths.

`--json` emits `literate-ai/worker-storage-health-result@1` with `scope: storage`,
a typed observation, an assessment and actionable alerts. Interactive output names
worker/role aliases, measured deficits and next actions. Exit 0 means this storage
assessment permits the requested footprint; 1 means hold and 2 means retry after a
fresh check. Optional unknown metrics remain visible even when the decision permits
work. `--job-identity sha256:...` binds the result to an exact job without authorizing
it. Each invocation inspects once; dispatch owns its future bounded retry state.

An optional `pressure` policy adds a bounded sustained sample window, CPU threshold,
available-memory floor, paging threshold, GPU-memory floor and required/optional
metric flags. Local and SSH workers use the framework receiver; an explicit command
worker must route `--pressure-receive`. Denied, unsupported, stale, malformed and
unreachable pressure evidence stays unknown. High CPU/GPU utilization with progress
is not overload; stalled progress, queue impact, paging or allocation failure changes
classification. The command performs no dispatch, host update, MCP discovery or
implicit health-state write. File debug output and MCP discovery flags refuse. Without an alert-state selection, repeated inspections report current findings
each time. Pressure sampling, automatic investigation and dispatch/polling
use the same application classifier.

Source: [docs/architecture/worker-storage-protocol.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/worker-storage-protocol.md) at commit `fcc40bc` (source lines 122–159).
