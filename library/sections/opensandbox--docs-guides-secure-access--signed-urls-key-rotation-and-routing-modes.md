---
title: Signed URLs, key rotation, and routing modes
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

> Abstract: Endpoint discovery can mint a shareable URL token containing sandbox ID, port, base-36 expiry, signature, and signing-key ID. Wildcard-host, routing-header, and URI-prefix modes carry the token differently; the gateway checks expiry and signature, then removes routing credentials before forwarding.

Signed access requires an active one-character key ID and one or more base64 signing secrets configured in both lifecycle server and gateway. Environment variables or a Kubernetes Secret can keep key material out of the TOML file. Rotation adds a new verification key before making it active; old keys remain until every token they signed has expired.

The signed URL is an attenuated bearer credential along the time dimension and is convenient for delegation. It remains copyable, and its sandbox/port scope is encoded and verified by the gateway rather than carried as an unforgeable object reference.

Source: [docs/guides/secure-access.md](https://github.com/opensandbox-group/OpenSandbox/blob/918dea19e399aea5a1ee56070c273a6b22ec0c89/docs/guides/secure-access.md) at commit `918dea19`.
