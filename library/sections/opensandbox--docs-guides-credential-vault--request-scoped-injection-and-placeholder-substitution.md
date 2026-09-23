---
title: Request-scoped injection and placeholder substitution
source: docs/guides/credential-vault.md
source_repo: opensandbox-group/OpenSandbox
source_commit: e52d1d498e57b84b24b7a711eb2d40e18e65ef75
source_date: 2026-08-12
source_authors: [高然, epha, 贾岛]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, networking, capability-security]
status: current
---

> Abstract: Bindings can inject headers or replace exact placeholders in selected path, query, header, and body surfaces. Rewriting is single-pass, context-encoded, and guarded against path traversal and ambiguous matches, which narrows a credential to a request shape instead of revealing it to the calling tool.

Each binding names a credential and matches request scheme, host, method, and path. Substitutions are disabled unless explicitly configured and are literal, case-sensitive replacements. Path and query values are URL-encoded; JSON and form bodies use format-aware encoding; sensitive and hop-by-hop headers cannot be rewritten. Inserted values are not rescanned, preventing one secret from triggering another placeholder.

Ambiguous path segments, encoded separators that cross a binding boundary, and overlapping equal-precedence bindings are rejected. The placeholder and its raw and encoded secret forms join the redaction set. Small rejected requests receive `403`; large or streaming bodies may require the sidecar to drop the connection, but are not forwarded.

This resembles attenuation by a caretaker: the workload can exercise a narrowly described network operation without acquiring the credential value. Unlike an object capability, however, authority remains derived from matching mutable request text against ambient proxy configuration.

Source: [docs/guides/credential-vault.md](https://github.com/opensandbox-group/OpenSandbox/blob/e52d1d498e57b84b24b7a711eb2d40e18e65ef75/docs/guides/credential-vault.md) at commit `e52d1d49`.
