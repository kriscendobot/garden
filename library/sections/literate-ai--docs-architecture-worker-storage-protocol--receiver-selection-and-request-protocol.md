---
title: "Worker storage observation protocol: receiver selection and request protocol"
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

> Abstract: Storage observations bind one exact worker, OS family, and four to sixteen sorted role/path pairs to a private receiver (local probe, SSH, or an explicit shell-free command) that answers a strict 16 KiB JSON request with a digest-bound probe response; observations never authorize execution, allocation, or deletion.

This implements the storage-collection portion of accepted [ADR 0043](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0043-worker-resource-health.md).
[WORKER-HEALTH-001](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/roadmap/active-work.md#worker-health-001-detect-worker-resource-pressure-and-investigate-bounded-cleanup-candidates)
also owns pressure, workflow admission, investigation and cleanup. Observations do
not authorize execution, allocation or deletion.

## Private receiver selection

`WorkerStorageBindings` binds one exact execution worker, its OS family, four to
sixteen sorted role/path pairs and optional transport configuration into the capacity
policy's private storage-binding identity. Paths must be absolute on that worker;
collection does not create missing paths or substitute their parent directories.

Local workers run a supervised stdlib probe. SSH workers use their configured SSH
transport and an optional private Python executable. A command worker requires an
explicit `WorkerStorageCommand`; its lifecycle dispatcher is never an implicit health
receiver. The command record contains exact argv and optional
`ExecutionWorkerEnvironment` mappings. Its identity includes mapping names and source
variable names, without credential values. Changed commands or mappings require a
new effective policy identity before dispatch.

The command adapter appends `--receive --timeout-ms <budget>` to the configured argv
and invokes it without a shell. The shipped receiver can be selected with:

```text
python -B -m literate_ai.worker_storage_probe
```

An external provider must implement the same operation, route the request to its
exact worker, and return that worker's response. The shipped module measures the
machine where it is executed. It is not a remote scheduler or an authenticated
attestation service. A missing health command reports `unsupported`; a missing
required credential mapping reports `denied` before launch. Lifecycle credentials
and unrelated ambient credentials are not inherited by the health command.

## Request and response

Local private requests use `LITAI_WORKER_STORAGE_REQUEST`; SSH and command requests
use stdin. The request is UTF-8 JSON, limited to 16 KiB. Duplicate or unknown fields
are rejected. Its exact fields are:

| Field | Meaning |
| --- | --- |
| `schema` | `literate-ai/worker-storage-request@1` |
| `worker_id` | Selected portable worker alias |
| `worker_identity` | Exact worker configuration SHA-256 identity |
| `policy_identity` | Effective capacity policy SHA-256 identity |
| `job_identity` | Job SHA-256 identity, or null for inspection |
| `os_family` | `linux`, `macos` or `windows`; must match the receiver before any path measurement |
| `timeout_ms` | Integer probe budget from 1 through 60,000 milliseconds |
| `paths` | Four to sixteen unique, sorted `[role, absolute_path]` pairs |
| `nonce` | Fresh 32-character lowercase hexadecimal nonce |

The receiver validates the request before measurement. The response contains exactly
`schema`, `request_identity`, `os_family` and `samples`; its schema is
`literate-ai/worker-storage-probe@1`. `request_identity` is the SHA-256 digest of the
exact input bytes, including the nonce and complete private context. Samples use the
existing `StorageCapacitySample` contract: portable role and opaque volume aliases,
byte and inode measurements, quota domains, and explicit metric statuses. The
controller requires the expected request digest, platform and exact ordered roles.
It rejects malformed, substituted, extra, duplicate or oversized response fields.

Response stdout is limited to 64 KiB and diagnostic stderr to 4 KiB. Raw commands,
requests, responses and credential-bearing environments are excluded from subprocess
tracing for this operation. Retained observations contain typed metrics and content
identities, without paths, endpoints, arbitrary stderr or credentials. No request
file or persistent receiver service is created.

Source: [docs/architecture/worker-storage-protocol.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/worker-storage-protocol.md) at commit `fcc40bc` (source lines 1–69).
