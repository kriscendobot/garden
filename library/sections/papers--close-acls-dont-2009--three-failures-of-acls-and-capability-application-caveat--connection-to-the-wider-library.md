---
title: Connection to the wider library
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

This section is the **canonical catalog of ACL's three structural failures + the *capability-applications-can-recreate-ACL* caveat**. Three threads:

1. **The three-failure enumeration is reusable.** *Authorization, authentication, accountability* — ACLs get all three wrong in multi-party scenarios. The library can cite the three-failure list whenever a design needs to explain *why* an ACL-only solution is insufficient.

2. **The delaying-the-access-check structural property is the load-bearing observation.** RBAC, ABAC, IBAC, setuid, stack introspection all share the *check-at-receipt-time-instead-of-construction-time* property. The capability model's *check-at-construction-time* property is what gets the access decision right.

3. **The §2.7 caveat is essential.** A capability system *infrastructure* does not automatically grant a *capability application*'s correctness — the application can still re-implement ACL-style lookups on top of capabilities. The *crucial step* test (does an object identifier pass through a deputy without being checked against the access matrix?) is the diagnostic. The canonical fix is *capabilities-by-reference everywhere* — file descriptors not filenames, web-keys not URLs (per §3.2.1).
