---
title: Common confusions
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

- **"Unguessable tokens are just nonces."** Structurally, an unguessable token *is* a capability — it is an unforgeable secret that the legitimate page possesses but the attacker does not. Calling it a *nonce* obscures the capability-model migration; calling it a *capability-by-reference* makes the structural connection explicit.
- **"Same Origin Policy + cookies = capability-Web."** The §3.1-§3.2 paper shows the opposite: SOP + cookies = ACL-Web. The CSRF and clickjacking attacks work *because* cookies are ACL-style principal identifiers. The capability-Web replaces the ACL component (cookies as access-decision input) with a capability component (unguessable URLs).
- **"Web-keys require new browser features."** §3.2.1 explicitly says no: *No changes to Web protocols, formats, user agents or server-side infrastructure are required to make this transition.* The only changes are in the *application's URL namespace*. The browser does its standard URL-fetching; the server does its standard URL-lookup. The capability discipline is *at the application layer*.
- **"Clickjacking is fixed by frame-busting."** Frame-busting addresses the *visible* attack vector but not the *structural* problem (cookies-as-principal + attacker-controlled-targeting). The §3.2 paper's wisdom: *stripping the clickjacking attack to its essentials shows that the attacker can cause mischief using only the authority to link to a private page*. Web-keys close the link-to-a-private-page channel structurally.
- **"Click fraud is a separate problem."** §3.3 frames it as the same problem — client-authentication-as-access-decision-input. The *who clicked* question is mislabeled as *whether the click was intended*. Capability fixes for click fraud would require some form of *clicker-intent-token* signed by the user agent, which is harder to deploy than web-keys but structurally analogous.
- **"The §5 migration claim is too optimistic."** Web-keys have not been universally adopted; the §5 *no-infrastructure-change* claim is true *for the technical migration* but does not address the *adoption* problem. Bug-compatibility with existing infrastructure, developer education, and ecosystem effects mean migration has been gradual rather than instant. The §5 claim is *necessary but not sufficient* for actual adoption.
