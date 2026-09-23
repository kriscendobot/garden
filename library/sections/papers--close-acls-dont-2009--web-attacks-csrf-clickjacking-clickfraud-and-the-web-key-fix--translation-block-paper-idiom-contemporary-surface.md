---
title: Translation block (paper idiom → contemporary surface)
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

| 2009 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| Web-key | The canonical capability-by-reference mechanism for the Web; ancestor of the contemporary `sturdyref` / `swissnumber` concepts in OCapN and Endo. |
| Unguessable URL | An unforgeable secret carried as a URL component; structurally similar to `@endo/captp`'s wire-level capability identifiers. |
| Same Origin Policy as integrity boundary | The Web's analogue of `@endo/marshal`'s vat-boundary integrity discipline. |
| CSRF as Confused Deputy | Cross-Site Request Forgery is structurally identical to the compilation Confused Deputy attack; the *unguessable-token-in-FORM* defense is a capability retrofit. |
| Clickjacking as Confused Deputy | The Browser is the deputy; the attacker controls targeting; the user's session cookie is the principal identifier. The web-key fix prevents the attacker from loading the page. |
| Click fraud as client-authentication-misled | Client authentication tells you *who relayed* the click, not *whether it was intended*. The same wisdom as §2.5. |
| §5 no-infrastructure-change migration | Capability-model adoption is *deployable* in stages; applications can migrate locally without waiting for system-wide infrastructure change. |
