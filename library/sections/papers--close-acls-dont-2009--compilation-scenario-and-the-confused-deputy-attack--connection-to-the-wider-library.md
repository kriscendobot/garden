---
title: Connection to the wider library
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto; references span Hardy 1988 to Close 2008 + Hansen-Grossman 2008 — published ~2009)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "1-3 (§1 Introduction + §2 Access Matrix through §2.3 Confused Deputy attack)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack
---

This section is the **canonical worked example of the Confused Deputy attack and the ACL-vs-capability access-decision divergence** at the introductory-paper level. Three threads:

1. **The compilation scenario is reusable** as a teaching example for any capability-security audience. Three principals, one mediating software agent, one usage-log file — the minimal setup that makes the difference visible. The library can cite this section whenever a design needs the canonical Confused Deputy walk-through.

2. **The access-matrix-as-shared-abstraction framing** is the bridge between the 1971 Protection paper's vocabulary and contemporary capability-system literature. Anyone reading Lampson 1971 + Miller-Yee-Shapiro 2003 should pair them with this paper, which makes the access-matrix-as-shared-abstraction-but-not-shared-decision-procedure observation explicit.

3. **The construction-time-vs-receipt-time check distinction** is the structural insight. Capability systems perform access checks *when the message is constructed*; ACL systems perform access checks *when the message is received*. The receipt-time check loses the *which principal supplied the identifier* context — which is precisely what the Confused Deputy attack exploits.
