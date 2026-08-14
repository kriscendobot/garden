---
title: Provider caching, key rotation, and failure modes
source: docs/guides/multi-tenancy.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5
source_date: 2026-08-14
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, multi-tenant-platform, capability-security]
status: current
---

> Abstract: File-backed tenants fail fast on duplicate keys and missing namespaces, then hot-reload every two seconds while retaining the last valid parse. HTTP-backed lookup delegates identity to an IAM endpoint, caches each key by a returned TTL, and may serve stale authority during a bounded outage before failing with `503`.

The file provider loads `tenants.toml`, requires at least one unique key per tenant, forbids simultaneous legacy `server.api_key`, and validates all namespaces at startup. Hot reload makes additions and removals effective without restart; a parse failure retains the preceding configuration, while file deletion invalidates every tenant key.

The HTTP provider sends the presented API key to an external lookup endpoint and accepts a namespace plus TTL. It cannot enumerate namespaces at startup, so it skips fail-fast namespace validation. When IAM is unavailable, cached mappings remain authoritative until `max_stale_seconds` expires. Multiple simultaneous keys permit staged rotation.

Compared with revocable object references, revocation is provider-state driven and may deliberately lag through polling, TTL, or stale-cache windows. Operators must include those windows in the authority lifetime they promise.

Source: [docs/guides/multi-tenancy.md](https://github.com/opensandbox-group/OpenSandbox/blob/138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5/docs/guides/multi-tenancy.md) at commit `138ce5cb`.
