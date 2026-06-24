# tls-provisioning

TLS certificate acquisition and management for self-hosted, self-custodial, or appliance-like nodes. Covers ACME challenge types (HTTP-01, DNS-01, TLS-ALPN-01), the provisioning pattern space for a first-boot ceremony on a fresh cloud node (vendor-delegated subdomain with CNAME delegation, operator-provided domain with DNS-01, TOFU self-signed bootstrap, HTTP-01 with temporary port 80), and renewal automation for 90-day Let's Encrypt certificates. For the Endo gateway's first-boot ceremony and the gateway-oauth-bonding design gap, this topic covers how an operator can obtain a trusted HTTPS endpoint before any other channel of trust exists.

## Sections

| Section | One-line summary |
|---|---|
| [ACME challenge types: HTTP-01, DNS-01, TLS-ALPN-01](../sections/web--acme-challenge-types--http01-dns01-tls-alpn01.md) | What each ACME challenge requires, constraints (ports, DNS propagation, wildcard support), and first-boot relevance. |
| [TLS provisioning patterns for first-boot self-custodial nodes](../sections/web--tls-first-boot-patterns--vendor-delegated-and-tofu.md) | Four pattern families (vendor-delegated subdomain, operator DNS-01, TOFU self-signed, HTTP-01) with trade-offs for marketplace-deployed appliance nodes. |

## See also

- cloud-marketplace — AWS Marketplace listing requirements constrain how and when a node gets a TLS certificate (it must be operable at launch).
- node-packaging — TLS provisioning is a first-boot ceremony dependency for Phase 11.
- signed-updates — signed update channels for always-online nodes share the key-management concerns of TLS certificate management.
