---
title: "ACME challenge types: HTTP-01, DNS-01, TLS-ALPN-01 compared"
source_kind: web
source_url: https://letsencrypt.org/docs/challenge-types/
source_date: 2026-02-18
ingested: 2026-06-11
ingested_by: scholar
topics: [tls-provisioning, node-packaging]
status: current
notes: "Let's Encrypt canonical reference. DNS-PERSIST-01 variant documented at https://letsencrypt.org/2026/02/18/dns-persist-01 (future challenge type, not yet widely deployed)."
---

## Abstract

ACME (Automated Certificate Management Environment) defines challenge types that let a certificate authority verify domain control before issuing a TLS certificate. For a self-custodial node that must obtain a certificate during a one-sitting first-boot ceremony, the choice of challenge type determines what infrastructure must exist before the ceremony begins. DNS-01 is the most flexible for automated provisioning because it requires neither a running web server nor port-80 access, but it introduces DNS propagation delays and API credential requirements. HTTP-01 is the simplest but requires port 80 and cannot issue wildcard certificates. TLS-ALPN-01 has limited tooling support.

## HTTP-01

**How it works**: The ACME client places a file at `http://<YOUR_DOMAIN>/.well-known/acme-challenge/<TOKEN>` containing the token plus an account key thumbprint. Let's Encrypt retrieves this file over HTTP.

**Requirements**:
- Port 80 must be reachable from the internet (fixed; not configurable to other ports).
- Only accepts redirects to `http:` or `https:` and only to ports 80 or 443.
- No other listener on port 80 at validation time.
- In multi-server setups, the file must be accessible on all servers.

**Capabilities and constraints**:
- Cannot issue wildcard certificates.
- Can validate individual domain names (including IP addresses).
- Easy automation; ACME clients handle server configuration without DNS provider access.

**First-boot relevance**: Works well when port 80 is available and the node already has a minimal HTTP server running (or the ACME client can temporarily occupy port 80). Blocked by some ISPs at the residential level; cloud nodes generally have port 80 open by default.

## DNS-01

**How it works**: The ACME client creates a TXT record at `_acme-challenge.<YOUR_DOMAIN>` derived from the token and account key. Let's Encrypt queries DNS to verify the record.

**Requirements**:
- Programmatic access to the DNS provider API for automation.
- DNS propagation time (typically minutes; occasionally up to an hour).
- The domain must resolve (DNS lookup succeeds), but the node does not need to be publicly accessible.

**CNAME/delegation**: You can use CNAME or NS records to delegate `_acme-challenge` to a separate DNS zone or service (for example, `acme-dns`). This isolates DNS API credentials to the validation service rather than exposing full-zone write access on the node.

**Capabilities and constraints**:
- Only challenge type that can issue wildcard certificates.
- Works for non-publicly-exposed servers (private networks, behind firewalls).
- DNS propagation delay introduces timing uncertainty in automated flows.
- Cannot validate IP addresses.
- DNS API credentials on the node are a security concern; scoped credentials or delegated zones are recommended.

**First-boot relevance**: Best choice for nodes that do not have port 80 accessible at boot time, or where a wildcard certificate covering `*.node.example.com` style subdomains is desired. Requires that the operator pre-configure a DNS record pointing at the node's IP and that the node has DNS API credentials (or that a vendor-delegated subdomain is pre-provisioned). If the vendor pre-provisions a delegated CNAME pointing `_acme-challenge.<nodesubdomain>` at a vendor-controlled DNS service, the node can obtain a certificate during first boot without the operator configuring DNS at all.

## TLS-ALPN-01

**How it works**: Uses TLS on port 443 with a custom ALPN protocol. Only servers aware of this challenge type respond to validation requests.

**Requirements**:
- Port 443 accessible from the internet.
- TLS configuration control; multi-server setups require all servers to respond identically.

**Capabilities and constraints**:
- Cannot validate wildcard domains.
- Limited ACME client support (intended primarily for TLS-terminating reverse proxy authors).
- In multi-server setups, requires synchronized response across all instances.
- Can validate IP addresses.
- Works when port 80 is blocked but port 443 is accessible.

**First-boot relevance**: Rarely the right choice; minimal ecosystem support makes setup and troubleshooting difficult. Only relevant when port 80 is unavailable and DNS-01 is impractical.

## DNS-PERSIST-01 (emerging)

A new Let's Encrypt challenge variant (announced February 2026) designed to reduce the propagation-delay problem by using a persistent DNS record that survives across renewals. Not yet widely supported by ACME clients as of mid-2026. Referenced for awareness; DNS-01 remains the operational standard.

Source: [Challenge Types - Let's Encrypt](https://letsencrypt.org/docs/challenge-types/) retrieved 2026-06-11. DNS-PERSIST-01 reference: [https://letsencrypt.org/2026/02/18/dns-persist-01](https://letsencrypt.org/2026/02/18/dns-persist-01).
