---
source_kind: web-essay
source_url: https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
source_content_sha256: c2c4d69629704c6520e18dc730aa871acf17ff3be0e240d6f7a26d791d24006b
source_author: Randy Farmer
source_date: 2008-10-17
retrieved: 2026-07-11
ingested: 2026-07-11
ingested_by: scholar
section_count: 5
status: current
notes: |
  Fourth ingest from **habitat-chronicles.com** (the dashed live domain; the non-dashed
  `habitatchronicles.com` is STALE/dead — always cite the dashed form). Randy Farmer's
  canonical **identity-decomposition pattern**: a user's identity should be split into
  three separable identifiers — the **account identifier** (the permanent, inert, random,
  capability-free database key), the **login identifier(s)** (session-authenticating
  name/password pairs, or federated **capability-based logins** adopted from OpenID / OAuth
  / Facebook Connect), and the **public identifier(s)** (the non-unique, compound, mutable,
  context-plural social face). Germane to the garden's ocap access-control lineage: the
  account anchor carries **no ambient public capabilities** (POLA applied to identity), the
  login credential from an external provider is a delegated session-establishing capability,
  and the 2008-11-12 IIW update's key insight — a relying party should see only the Public ID
  plus a **permission-bound session key**, never a publicly-shared identifier used for
  authentication — is the capability discipline stated for identity. Fetched live
  (`source_fetched_via=direct`); the content hash is the idempotency anchor. Seeds the new
  `identity` topic and the new `tripartite-identity` concept; cross-links the
  `object-capability` concept (capability-based logins; the inert-anchor / no-ambient-authority
  discipline), `confused-deputy` (separating the inert DB key from capability-bearing
  identifiers), `delegates-and-epithets` (the Endo daemon's kindred identity-relationship
  model), and the sibling habitat-chronicles.com concept `habitat-unum`. Ingested under
  maintainer job `scholar-ingest-source-habitat-chronicles-4`; a follow-on `-5` job carries
  the remaining germane post (Adventures in LLM Land, the dense 2026 AI-revolution essay).
---

## Abstract

Randy Farmer's canonical **tripartite identity pattern**: user-identity management is "one of
the most misunderstood patterns in social-media design" because designers **conflate the many
roles required by different user identifiers**, and by conjoining engineering requirements
(sessions, DB records) with users' requirements (recognizability, self-expression) the older
engineering-centric models (Yahoo!, eBay, AOL) actively **discourage participation** — the
motivating datum being Yahoo!'s finding that **fear of spammers farming their e-mail address**
was the number-one reason users abandoned creating user-generated content. The fix is to split
identity into **three separable identifiers**: the **account identifier** (one permanent,
unique, random, user-invisible/inert database key with **no inherent public capabilities** —
not an e-mail, login name, public name, or IM address); the **login identifier(s)** (session
authentication via name/password pairs, or federated **capability-based logins** adopted from
OpenID / OAuth / Facebook Connect, whose separation from the account buys customization,
mitigated data-migration, account-crack protection, and multi-supplier aggregation); and the
**public identifier(s)** (the deliberately non-unique, compound, mutable, **context-plural**
social face — multiple personas per context, never authenticating). The 2008-11-12 update
records the model's Internet Identity Workshop presentation and its key insight: **no publicly
shared identifier is required or desirable for session authentication** — a relying party
should see only the Public ID plus a **permission-bound session key**. The essay is directly
germane to the garden's ocap access-control lineage — the inert, capability-free account
anchor is POLA applied to identity, and the permission-bound session key is the capability
discipline stated for identity.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [The Tripartite Identity Pattern — the problem and the three-component thesis](../sections/habitat-chronicles--tripartite-identity-pattern--overview.md) | identity, capability-security | current |
| [Account Identifier (DB Key) — the permanent, inert, capability-free anchor](../sections/habitat-chronicles--tripartite-identity-pattern--account-identifier.md) | identity, capability-security | current |
| [Login Identifier(s) (Session Authentication) — federated capability-based logins and the separation payoff](../sections/habitat-chronicles--tripartite-identity-pattern--login-identifier.md) | identity, oauth-credentials, capability-security | current |
| [Public Identifier(s) (Social Identity) — the non-unique, compound, context-plural face](../sections/habitat-chronicles--tripartite-identity-pattern--public-identifier.md) | identity | current |
| [Presentation at the Internet Identity Workshop — the key insight, three critiques, and capability-based identifiers as out of scope](../sections/habitat-chronicles--tripartite-identity-pattern--iiw-critiques-and-scope.md) | identity, capability-security | current |
