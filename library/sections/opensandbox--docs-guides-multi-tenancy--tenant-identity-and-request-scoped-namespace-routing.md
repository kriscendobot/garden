---
title: Tenant identity and request-scoped namespace routing
source: docs/guides/multi-tenancy.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5
source_date: 2026-08-14
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, multi-tenant-platform]
status: current
---

> Abstract: In Kubernetes mode, a tenant API key resolves to a `TenantEntry` whose namespace is injected into a request-scoped `ContextVar`. Lifecycle and proxy operations then use that namespace, and list results are namespace-filtered; Docker mode is rejected because it cannot supply this tenant boundary.

Each tenant has a human-readable name, one pre-created Kubernetes namespace, and one or more globally unique API keys. Authentication middleware performs the key lookup before lifecycle dispatch. A successful lookup establishes the namespace for create, list, get, delete, and proxy routes; a miss returns `401`. Multi-tenant proxy calls must carry `OPEN-SANDBOX-API-KEY`, unlike the legacy single-tenant proxy path.

Tenant identity is therefore bearer-key identity joined to a namespace selector. The request context prevents accidental cross-tenant routing in ordinary server operations, but the namespace is not an unforgeable object reference held by the tenant. Correct confinement also depends on middleware coverage, server implementation, Kubernetes authorization, and every API being tenant-scoped.

Source: [docs/guides/multi-tenancy.md](https://github.com/opensandbox-group/OpenSandbox/blob/138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5/docs/guides/multi-tenancy.md) at commit `138ce5cb`.
