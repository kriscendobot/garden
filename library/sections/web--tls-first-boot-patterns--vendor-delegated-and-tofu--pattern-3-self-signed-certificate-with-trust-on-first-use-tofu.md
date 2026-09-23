---
title: "Pattern 3: Self-signed certificate with trust-on-first-use (TOFU)"
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
ingested: 2026-06-11
ingested_by: scholar
topics: [tls-provisioning, node-packaging]
status: current
notes: "Synthesized from Let's Encrypt challenge-types documentation and ACME-DNS pattern. TOFU and self-signed patterns drawn from general literature; no single canonical source."
parent: web--tls-first-boot-patterns--vendor-delegated-and-tofu
---

The node generates a self-signed certificate at first boot (or before, at AMI build time). The operator accesses the node's HTTPS endpoint, sees the browser's "untrusted certificate" warning, and either pins the certificate fingerprint or accepts the risk to proceed with the setup ceremony. After setup is complete, the node may use Pattern 1 or 2 to obtain a CA-signed certificate, or continue operating with the self-signed certificate if the deployment is private.

Trade-offs:
- Zero infrastructure dependency at first boot — the node is immediately accessible over HTTPS with no external calls required.
- Exposes the initial setup endpoint to "certificate is from unknown CA" warnings in all browsers and MCP clients; operators must understand the security model.
- TOFU provides no protection against a man-in-the-middle at first access; the fingerprint must be verified out-of-band (for example, printed in the cloud console as instance metadata, or displayed on the serial console).
- Suitable as a temporary bootstrap layer: use self-signed for the ceremony, then immediately upgrade to a CA-signed certificate.
- Some deployment targets (strict enterprise, MCP clients that refuse self-signed) may not accept this pattern.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
