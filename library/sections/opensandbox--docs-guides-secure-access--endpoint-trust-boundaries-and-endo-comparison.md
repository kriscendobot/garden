---
title: Endpoint trust boundaries and Endo comparison
source: docs/guides/secure-access.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 918dea19e399aea5a1ee56070c273a6b22ec0c89
source_date: 2026-08-05
source_authors: [高然, Quentin Carbonneaux]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security]
status: current
---

> Abstract: Secure Access trusts lifecycle endpoint discovery, signing-key distribution, gateway routing, and server-proxy enforcement. It is independent of the execd access token and outbound Credential Vault, so deploying all three creates layered credentials rather than one transitive authorization boundary.

Secure Access is Kubernetes gateway functionality; Docker rejects it. The gateway covers HTTP and WebSocket and strips both the access header and signed URI prefix. URI-like path segments are interpreted as credentials only when secure access is enabled, preserving ordinary workload paths otherwise.

Compared with Endo, the token is closer to a password capability than a Model-4 object capability: it is an unforgeable-enough bit string whose holder can designate and reach one endpoint. It can provide useful coarse designation-with-authority, but it does not by itself eliminate ambient authority inside the served process, constrain which application methods the holder may invoke, or make further delegation non-discretionary.

Source: [docs/guides/secure-access.md](https://github.com/opensandbox-group/OpenSandbox/blob/918dea19e399aea5a1ee56070c273a6b22ec0c89/docs/guides/secure-access.md) at commit `918dea19`.
