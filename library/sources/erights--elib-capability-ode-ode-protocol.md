---
source_kind: web
source_url: https://erights.org/elib/capability/ode/ode-protocol.html
source_effective_url: https://erights.github.io/erights-org-website/elib/capability/ode/ode-protocol.html
source_fetched_via: mirror
source_content_sha256: ff1dbcf5e0bc3327d33e73c53b8c767559f2992532c9530f91b023e66ea17fc3
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  HTML companion chapter ("Capabilities As A Cryptographic Protocol") of the 2000
  Financial Cryptography paper "Capability-Based Financial Instruments". Fetched
  2026-06-27 from the erights.github.io mirror via scripts/jobs/fetch-source.sh
  (source_fetched_via=mirror; erights.org refuses sandbox connections). Idempotency
  anchor is source_content_sha256, not a commit. SOFT-FLAG overlap with the FC2000
  paper section pluribus-rights-taxonomy-and-covered-call-option, which summarizes
  Pluribus as one argument cluster; this chapter is the standalone protocol-mechanics
  treatment and is kept current for the handshake detail the paper section omits.
---

The HTML companion to the FC2000 paper's distributed-protocol chapter. It describes **Pluribus**, E's communications protocol, as the cryptographic enactment of the Granovetter Operator across separate vats and machines: vats as persistent key-bearing address-spaces (public-key fingerprint = VatID), proxies as local stand-ins for remote objects, the four-step encode-send-decode-deliver message path, the unguessable per-object swiss number, and the inductive SSL-shaped handshake (no certificates, perfect forward secrecy via Diffie-Hellman) that builds a secure Bob-to-Carol arrow from preexisting Alice-Bob and Alice-Carol arrows. It names the impostor problem at both ends (VatID stops a fake Carol; swiss number stops a fake Bob) and closes with the subjective-aggregation argument. The library's FC2000 paper section summarizes this material; this source preserves the protocol mechanics the summary drops.

| Section | Topics | Status |
|---------|--------|--------|
| [distributed-pluribus-cryptographic-protocol](../sections/erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol.md) | captp, capability-security, capability-theory | current |
