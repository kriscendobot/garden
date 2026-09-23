---
title: See also
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "3-7 (§2.4 ACLs don't authorize correctly through §2.7 Avoiding Confused Deputy within a capability application)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat
---

- [[four-ways-to-acquire-references]] — the *capability transfer* path of acquisition is the §2.7 mechanism for avoiding Confused Deputy.
- [[object-capability]] — the §2.7 paper's caveat is essential: ocap infrastructure is necessary but not sufficient.
- [[principle-of-least-authority]] — the §2.4 enumeration is the catalog of how non-capability access models violate POLA in multi-party scenarios.
- [[brand-and-trademark]] — the §2.6 *capability-identity-equality* discipline for accountability is the structural ancestor of brand identity in Agoric ERTP.
- `papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack` — the first section in this source: the worked example this section's enumeration generalizes.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--{excess-authority-and-designation, fractal-structure-of-authority, multiplicative-pola-and-security-as-modularity}` — the *cp-vs-cat* + *only-connectivity-begets-connectivity* + *security-as-extreme-modularity* framework that Tulloh-Shapiro-Miller 2004 builds; this section is the introductory-paper counterpart.
- `papers--miller-shapiro-paradigm-regained-2003--{permission-vs-authority-and-cp-versus-cat, access-abstraction-and-confinement}` — the formal permission-vs-authority framework that grounds this section's informal argument.
