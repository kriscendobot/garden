---
title: "Trusted relationship UI over SSL"
source_kind: paper
source_url: https://www.w3.org/2005/Security/usability-ws/papers/02-hp-petname/
source_content_sha256: 8c8fef18371588f6000f0957760fd8b1b7011b9bd52fe3cf4a1fb851ff8e09f8
source_authors: [Tyler Close]
source_date: 2005
ingested: 2026-10-08
ingested_by: scholar
topics: [petnames, identity, capability-security]
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
---

Abstract: Close moves website recognition away from attacker-selected page, URL, and certificate text into a browser-controlled petname field containing the user's own reminder about the relationship. The tool distinguishes insecure, unknown-authenticated, and known-authenticated states, and its security depends on a trusted UI path the website cannot spoof.

The proposal treats phishing as a relationship-recognition failure. Once a user assigns a reminder note, the browser redisplays it whenever later TLS authentication reaches the same relationship identifier. The page cannot read or choose that note. A user following an emailed bank link therefore checks for the remembered relationship rather than trying to find a discrepancy in attacker-curated content.

The prototype stores the petname as a bookmark name and binds it to a hash of the certificate authority's public key plus selected subject distinguished-name fields. This is intentionally not a raw key or single domain binding: a site can rotate keys and use several domains without discarding the user's relationship name. The three UI states are insecure-and-untrusted, TLS-authenticated-but-untrusted, and TLS-authenticated with a user petname.

The paper names two limits. The browser must reserve trustworthy chrome or an unguessable visual treatment so a page cannot counterfeit the widget. The tool protects established relationships but does not by itself authenticate a first introduction. Close proposes a further automation boundary: password managers should bind generated credentials to the same secure relationship identifier, preventing a hurried user from submitting a password to a phisher.

Source: [*Petname Tool: Enabling web site recognition using the existing SSL infrastructure*](https://www.w3.org/2005/Security/usability-ws/papers/02-hp-petname/), retrieved 2026-10-08, sha256 `8c8fef18`.
