---
title: See also
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "7-12 (§3 Contemporary examples through §5 Conclusion)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix
---

- [[object-capability]] — the §3.2.1 web-key is the Web-native capability-by-reference mechanism.
- [[four-ways-to-acquire-references]] — the unguessable URL is *introduced* by the legitimate page; the attacker cannot *fabricate* it.
- [[brand-and-trademark]] — the unguessable token's *unforgeability* is the brand-identity-at-the-Web-layer property.
- [[principle-of-least-authority]] — the Web's CSRF problem is a multi-party POLA violation; the web-key fix restores POLA.
- [[smart-contract]] — the §3.1-§3.2 worked examples generalize to any multi-party-mediated Web contract; the §5 migration path applies.
- `papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack` — the first section in this source: the OS-flavored worked example this section transposes to the Web.
- `papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat` — the second section: the catalog of ACL failures this section's contemporary examples instantiate.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises` — Dr. SES's *web-key as pass-by-reference encoding* is the JavaScript-native realization of this §3.2.1 web-key mechanism.
- `papers--miller-capability-myths-demolished-2003--{access-models-introduction, irrevocability-myth-and-the-caretaker-pattern}` — Miller-Yee-Shapiro 2003 is the prior paper that elaborated the access-model-difference argument; this paper is the access-matrix-formalized companion.
