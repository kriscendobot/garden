---
title: Connection to the wider library
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

This section is the **canonical worked example of the Confused Deputy attack class on the contemporary Web** + **the canonical statement of the no-infrastructure-change migration path to capability-Web**. Three threads:

1. **The Web-attack-as-Confused-Deputy mapping is reusable.** Any new Web vulnerability class can be tested against the *is this a Confused Deputy attack?* diagnostic. The diagnostic: does the attacker control the *targeting* of the deputy's request while the deputy carries the victim's principal identifier? If yes, it is a Confused Deputy attack, and the capability-model fix applies.

2. **The web-key as capability-by-reference for the Web is the canonical deployable capability-Web mechanism.** Unguessable URLs, no infrastructure change, application-local URL-namespace migration. Mark Miller's Dr. SES + Q + NodeKen architecture (cycle 82's *Distributed Electronic Rights in JavaScript*) builds on the web-key mechanism for the JavaScript-native capability layer.

3. **The §5 *no-infrastructure-change* migration claim is the deployable-capability-theory bridge.** The library can cite this section whenever a design needs to argue *capability-model adoption does not require system-wide infrastructure change* — the application can migrate locally, and the rest of the stack is unchanged.
