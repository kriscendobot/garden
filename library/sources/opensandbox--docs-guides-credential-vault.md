---
source: docs/guides/credential-vault.md
source_repo: opensandbox-group/OpenSandbox
source_commit: e52d1d498e57b84b24b7a711eb2d40e18e65ef75
source_date: 2026-08-12
source_authors: [高然, epha, 贾岛]
ingested: 2026-08-14
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: Credential Vault is an outbound credential broker in OpenSandbox's egress sidecar. A trusted host client writes secrets and request bindings outside the workload, then transparent HTTPS interception injects credentials only into matching destinations while the workload uses placeholders. Its security depends on default-deny nft-enforced egress, precise non-ambiguous bindings, trusted control-plane transport, and sidecar integrity; it attenuates network credential use but does not turn bearer secrets into Endo object capabilities.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [outbound-credential-broker-and-trust-boundary](../sections/opensandbox--docs-guides-credential-vault--outbound-credential-broker-and-trust-boundary.md) | sandbox-platforms, networking, capability-security | current |
| [request-scoped-injection-and-placeholder-substitution](../sections/opensandbox--docs-guides-credential-vault--request-scoped-injection-and-placeholder-substitution.md) | sandbox-platforms, networking, capability-security | current |
| [persistence-transport-and-redaction-boundaries](../sections/opensandbox--docs-guides-credential-vault--persistence-transport-and-redaction-boundaries.md) | sandbox-platforms, capability-security | current |
| [binding-discipline-residual-trust-and-endo-comparison](../sections/opensandbox--docs-guides-credential-vault--binding-discipline-residual-trust-and-endo-comparison.md) | sandbox-platforms, networking, capability-security | current |

## Provenance

Source: [docs/guides/credential-vault.md](https://github.com/opensandbox-group/OpenSandbox/blob/e52d1d498e57b84b24b7a711eb2d40e18e65ef75/docs/guides/credential-vault.md) at file-specific commit `e52d1d49`.
