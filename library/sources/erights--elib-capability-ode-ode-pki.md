---
source_kind: web
source_url: https://erights.org/elib/capability/ode/ode-pki.html
source_effective_url: https://erights.github.io/erights-org-website/elib/capability/ode/ode-pki.html
source_fetched_via: mirror
source_content_sha256: 23d89b7958af168db2c3374274295f21f2d546b35c0562c1a876492d0985743d
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  HTML companion chapter ("Capabilities As A Public Key Infrastructure") of the 2000
  Financial Cryptography paper "Capability-Based Financial Instruments". Fetched
  2026-06-27 from the erights.github.io mirror via scripts/jobs/fetch-source.sh
  (source_fetched_via=mirror). Idempotency anchor is source_content_sha256. This is
  the one Ode chapter whose substance the FC2000 paper sections deliberately
  dropped (the FC2000 source-index records §5's PKI comparison as supporting
  material not retained), so it adds the capability-vs-SPKI comparison that the
  library otherwise lacks.
---

The HTML companion to the FC2000 paper's PKI chapter, comparing the object-capability model against a public key infrastructure using **SPKI (RFC 2693)** as the most capability-like example. It walks SPKI's authorization-certificate mechanism (Issuer signs a certificate; Subject presents a certificate chain to a verifier) and reads the Granovetter Diagram for a PKI to surface four structural differences from a capability system (no direct Issuer-Subject link / offline, unconfinable issuance; resource need not be an object; auditing falls out of the key structure; confused-deputy risk from undesignated resources), closing on SPKI's per-decision signature-verification cost versus Pluribus's connection-setup-only cost. The FC2000 library sections omit this comparison; this source is the canonical capability-vs-PKI treatment in the library.

| Section | Topics | Status |
|---------|--------|--------|
| [capabilities-as-a-public-key-infrastructure](../sections/erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure.md) | capability-security, capability-theory | current |
