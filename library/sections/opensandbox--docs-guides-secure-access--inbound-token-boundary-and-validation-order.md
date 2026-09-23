---
title: Inbound token boundary and validation order
source: docs/guides/secure-access.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 918dea19e399aea5a1ee56070c273a6b22ec0c89
source_date: 2026-08-05
source_authors: [高然, Quentin Carbonneaux]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, networking, capability-security]
status: current
---

> Abstract: For a sandbox created with `secureAccess: true`, endpoint discovery returns an opaque per-sandbox token. Both ingress gateway and server proxy require that token for HTTP and WebSocket traffic, compare it in constant time, and strip it before the workload receives the request.

The static credential travels in `OpenSandbox-Secure-Access`, and SDKs can propagate it from endpoint discovery automatically. Validation is ordered: if the header is present, a mismatch returns `401` with no fallback to signed-URL validation; only an absent header selects the signed-token path. This avoids allowing a malformed stronger-looking credential to fall through to another mechanism.

The token authorizes reachability to the sandbox endpoint, not a method-level application capability within the workload. Anyone who acquires it can exercise the exposed HTTP or WebSocket service until the sandbox or token changes.

Source: [docs/guides/secure-access.md](https://github.com/opensandbox-group/OpenSandbox/blob/918dea19e399aea5a1ee56070c273a6b22ec0c89/docs/guides/secure-access.md) at commit `918dea19`.
