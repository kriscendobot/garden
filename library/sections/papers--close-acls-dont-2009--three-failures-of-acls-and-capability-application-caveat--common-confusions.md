---
title: Common confusions
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

- **"Stack introspection solves Confused Deputy."** Partially — it handles the *call-chain-supplied-identifier* case, but two structural gaps remain: (a) identifiers can come from lexical state outside the call chain; (b) multi-argument operations need a *single-authorization-chain-per-argument*, which stack introspection cannot provide. The capability model handles both natively.
- **"Client authentication is wrong."** Not exactly — *client authentication itself is not wrong*, but *using it as the input to an access decision is misleading*. Client authentication tells you *who relayed the message*; it does not tell you *who supplied the operation's parameters*. The §2.5 paper's wisdom is *separate these two questions*.
- **"Capability applications are automatically immune."** The §2.7 caveat: capability applications can re-introduce Confused Deputy by re-implementing ACL design. The structural test is *does an object identifier pass through a deputy without being checked?* If yes, vulnerability remains. The fix is *capabilities-by-reference everywhere*.
- **"The Horton protocol is the only accountability solution."** It is *a* canonical solution mentioned in §2.6, but the structural insight is *capability-identity-equality enables delegation-chain tracking*. Any system that preserves capability identity across delegations can implement this kind of accountability. Horton is the systematic implementation.
- **"Web cookies are ACLs."** Yes — and the same Confused Deputy vulnerabilities apply. The §3 paper develops CSRF and clickjacking as worked examples of this; the §2.7 fix (file descriptors not filenames, capabilities not strings) translates to *unguessable web-keys not URLs* per §3.2.1.
- **"Stack introspection is just a special case of capability transfer."** Not quite. Stack introspection *implicitly* tracks the call-chain principals as a side effect of the function-call mechanism; capability transfer *explicitly* tracks per-argument principals as a primary mechanism. The capability model is *more general* and *less prone to silent failures*.
