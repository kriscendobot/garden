---
title: "TLS certificate provisioning patterns for first-boot self-custodial nodes"
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
ingested: 2026-06-11
ingested_by: scholar
topics: [tls-provisioning, node-packaging]
status: current
notes: "Synthesized from Let's Encrypt challenge-types documentation and ACME-DNS pattern. TOFU and self-signed patterns drawn from general literature; no single canonical source."
---

## Abstract

A self-custodial node that must be operable after a single first-boot sitting faces a TLS bootstrapping problem: it needs a certificate before the operator can trust its HTTPS endpoint, but obtaining a certificate from a public CA requires proving domain control, which itself requires that the node is running and reachable. This section surveys the four pattern families for resolving this bootstrapping problem, with their trade-offs relevant to a marketplace-deployed appliance.

## Pattern 1: Vendor-delegated subdomain with pre-provisioned CNAME

The vendor pre-registers a subdomain for the node (for example, `<node-id>.nodes.example.com`) before the node boots. A CNAME record at `_acme-challenge.<node-id>.nodes.example.com` points to a vendor-controlled DNS service that the vendor's infrastructure manages. At first boot, the node runs its ACME client with DNS-01 challenge, sends the challenge token to the vendor's DNS service (via a provisioning API call using a node-specific short-lived credential embedded in the AMI), and the vendor's DNS service publishes the TXT record. The ACME CA validates against the vendor's DNS service, and the node receives a certificate with SAN `<node-id>.nodes.example.com`.

Trade-offs:
- No operator DNS configuration required at first boot — the node can obtain a certificate entirely autonomously.
- The vendor controls the namespace; operators who want custom domains need an additional step (CNAME from their own domain to the node's vendor subdomain, or a separate certificate workflow).
- Vendor DNS service is a dependency; vendor must maintain it for all issued nodes.
- The certificate proves control over the vendor subdomain, not the operator's own domain.
- Short-lived provisioning credentials in the AMI are a small attack surface: if the node ID is predictable and the provisioning API has insufficient authorization, an attacker could pre-empt a node's subdomain.

## Pattern 2: Operator-provided domain with DNS-01 at first boot

The operator configures a DNS A record pointing their own domain or subdomain at the node's IP before initiating the first-boot ceremony. The first-boot wizard prompts for the domain name and the DNS provider API credentials (or a pre-generated ACME-DNS delegated credential). The ACME client publishes the DNS-01 challenge record and requests the certificate.

Trade-offs:
- Operator has full control over their domain namespace.
- Requires operator to perform DNS configuration before the ceremony; adds a step.
- DNS propagation delay (minutes to an hour) lengthens the first-boot ceremony.
- API credentials for the operator's DNS provider must be available at first boot (stored in ceremony context, not persisted on disk unless the operator chooses to for renewals).
- Suitable for technically sophisticated operators; less suitable for a marketplace "deploy and go" experience.

## Pattern 3: Self-signed certificate with trust-on-first-use (TOFU)

The node generates a self-signed certificate at first boot (or before, at AMI build time). The operator accesses the node's HTTPS endpoint, sees the browser's "untrusted certificate" warning, and either pins the certificate fingerprint or accepts the risk to proceed with the setup ceremony. After setup is complete, the node may use Pattern 1 or 2 to obtain a CA-signed certificate, or continue operating with the self-signed certificate if the deployment is private.

Trade-offs:
- Zero infrastructure dependency at first boot — the node is immediately accessible over HTTPS with no external calls required.
- Exposes the initial setup endpoint to "certificate is from unknown CA" warnings in all browsers and MCP clients; operators must understand the security model.
- TOFU provides no protection against a man-in-the-middle at first access; the fingerprint must be verified out-of-band (for example, printed in the cloud console as instance metadata, or displayed on the serial console).
- Suitable as a temporary bootstrap layer: use self-signed for the ceremony, then immediately upgrade to a CA-signed certificate.
- Some deployment targets (strict enterprise, MCP clients that refuse self-signed) may not accept this pattern.

## Pattern 4: HTTP-01 with port 80 provisionally open

If the node opens port 80 only during the first-boot ceremony (firewall allows port 80 during AMI startup, closes after certificate is obtained), the ACME client can use HTTP-01 to obtain a certificate without DNS API access. After the certificate is obtained, port 80 is closed or redirected to HTTPS.

Trade-offs:
- No DNS API credential required.
- Requires operator's domain A record to already point at the node's IP.
- Port 80 must be reachable from the internet during the ceremony window.
- Some AWS security groups default to port 80 open; others do not — the CloudFormation template must provision this correctly.
- Simpler than DNS-01 for single-domain certificates; cannot issue wildcards.

## Renewal

All CA-signed certificates from Let's Encrypt expire in 90 days. Automated renewal must be configured at first boot. For DNS-01, this means persistent DNS API credentials (or a delegated CNAME that remains valid). For HTTP-01, port 80 must remain accessible or the ACME client must have a way to temporarily open it. For vendor-delegated subdomains, the vendor provisioning API must remain reachable for renewals throughout the node's lifetime.

Source: Synthesized from [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) and the ACME-DNS delegation pattern at [https://agren.cc/p/acme-dns/](https://agren.cc/p/acme-dns/), retrieved 2026-06-11.
