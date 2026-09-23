---
title: Outbound credential broker and trust boundary
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

> Abstract: A trusted SDK writes real credentials and request bindings to the egress sidecar, while the sandbox sees fake or empty values. Transparent HTTPS interception matches scheme, host, method, and path, injects authentication only on one unambiguous match, and keeps active vault state on a sidecar-local Unix socket outside the normal workload proxy path.

Credential Vault requires both an outbound network policy and `credentialProxy.enabled`. The server attaches the egress sidecar; a control-plane client populates credentials and bindings; and tools inside the sandbox make ordinary HTTPS requests without possessing the real secret. Supported rendering includes bearer, Basic, API-key, custom-header, and substitution-only modes.

The trust boundary includes the lifecycle server, SDK caller, sidecar, transparent TLS interception, and the upstream endpoint. Secret values are write-only through the SDK surface and redacted from vault responses and response headers. Unmatched requests pass unchanged, so egress policy, not vault matching alone, determines which destinations remain reachable.

Source: [docs/guides/credential-vault.md](https://github.com/opensandbox-group/OpenSandbox/blob/e52d1d498e57b84b24b7a711eb2d40e18e65ef75/docs/guides/credential-vault.md) at commit `e52d1d49`.
