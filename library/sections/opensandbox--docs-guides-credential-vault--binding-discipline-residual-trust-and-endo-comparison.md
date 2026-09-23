---
title: Binding discipline, residual trust, and Endo comparison
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

> Abstract: Safe deployment requires `dns+nft` interception, default-deny egress, explicit allowed hosts, narrow methods and paths, and no competing transparent service-mesh sidecar. These controls reduce where bearer credentials can be exercised, but the broker and upstream still hold real secrets and the workload can invoke every request shape its bindings permit.

DNS-only enforcement is rejected because direct-IP traffic can bypass name policy. A second transparent interceptor such as Istio or Envoy is unsupported because interception order and ownership become ambiguous. Operators should disable mesh injection, disable Credential Vault, or move credential handling outside the Pod. Bindings should avoid broad host or path wildcards and deprecated default-allow policies.

The authority claim is bounded: the sandbox cannot read a stored secret through the documented vault API, but it can cause matching requests and observe their effects. A malicious workload may exploit an overly broad upstream API even without learning its token. Endo confinement reasons from explicit references and the behavior of attenuating objects; Credential Vault reasons from network mediation and request predicates. Combining them can be useful, but one cannot infer non-discretionary object-capability confinement from secret non-disclosure alone.

Source: [docs/guides/credential-vault.md](https://github.com/opensandbox-group/OpenSandbox/blob/e52d1d498e57b84b24b7a711eb2d40e18e65ef75/docs/guides/credential-vault.md) at commit `e52d1d49`.
