---
source: docs/guides/secure-access.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 918dea19e399aea5a1ee56070c273a6b22ec0c89
source_date: 2026-08-05
source_authors: [高然, Quentin Carbonneaux]
ingested: 2026-08-14
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: Secure Access protects inbound sandbox HTTP and WebSocket endpoints with a per-sandbox static bearer token or signed expiring routing URL. The gateway and server proxy validate then strip credentials before forwarding. Static tokens, signing keys, route handling, and endpoint discovery remain control-plane authority, distinct from execd authentication, outbound Credential Vault, and Endo's reference-based confinement.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [inbound-token-boundary-and-validation-order](../sections/opensandbox--docs-guides-secure-access--inbound-token-boundary-and-validation-order.md) | sandbox-platforms, networking, capability-security | current |
| [signed-urls-key-rotation-and-routing-modes](../sections/opensandbox--docs-guides-secure-access--signed-urls-key-rotation-and-routing-modes.md) | sandbox-platforms, networking, capability-security | current |
| [endpoint-trust-boundaries-and-endo-comparison](../sections/opensandbox--docs-guides-secure-access--endpoint-trust-boundaries-and-endo-comparison.md) | sandbox-platforms, capability-security | current |

## Provenance

Source: [docs/guides/secure-access.md](https://github.com/opensandbox-group/OpenSandbox/blob/918dea19e399aea5a1ee56070c273a6b22ec0c89/docs/guides/secure-access.md) at file-specific commit `918dea19`.
