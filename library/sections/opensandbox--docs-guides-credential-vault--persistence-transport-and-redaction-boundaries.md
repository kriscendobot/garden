---
title: Persistence, transport, and redaction boundaries
source: docs/guides/credential-vault.md
source_repo: opensandbox-group/OpenSandbox
source_commit: e52d1d498e57b84b24b7a711eb2d40e18e65ef75
source_date: 2026-08-12
source_authors: [高然, epha, 贾岛]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security]
status: current
---

> Abstract: Vault entries live only in egress-sidecar memory and disappear when a Kubernetes pause/resume recreates the Pod or whenever the sidecar restarts. A trusted external control plane must re-inject them. Vault mutation transport can require TLS or loopback, and only configured proxy CIDRs may assert forwarded HTTPS.

Credential state is not stored in the sandbox filesystem, snapshot, or `BatchSandbox` Pod template. After a resumed Kubernetes sandbox reaches `Running`, a trusted client must recreate the vault before credential-dependent work resumes. Operators are warned not to preserve secrets in sandbox metadata, environment, snapshots, or logs. Docker pause retains processes, but sidecar replacement still clears state.

Transport enforcement for create, patch, and delete is opt-in. `OPENSANDBOX_EGRESS_CREDENTIAL_VAULT_REQUIRE_TLS` accepts TLS, loopback, or an HTTPS forwarding assertion from a configured trusted proxy CIDR. With the default setting off, an authenticated mutation request can arrive over plaintext transport. Redaction reduces accidental disclosure but does not repair an untrusted mutation channel or compromised sidecar.

Source: [docs/guides/credential-vault.md](https://github.com/opensandbox-group/OpenSandbox/blob/e52d1d498e57b84b24b7a711eb2d40e18e65ef75/docs/guides/credential-vault.md) at commit `e52d1d49`.
