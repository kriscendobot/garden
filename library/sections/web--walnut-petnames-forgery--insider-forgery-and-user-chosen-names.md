---
title: "Insider forgery and user-chosen names"
source_kind: web
source_url: http://wiki.erights.org/wiki/Walnut/Secure_Distributed_Computing/Capability_Patterns#Petnames_and_Forgery_among_partially_trusted_participants
source_snapshot: http://web.archive.org/web/20260428045612id_/http://wiki.erights.org/wiki/Walnut/Secure_Distributed_Computing/Capability_Patterns
source_content_sha256: 70e58fd537cfc26bf8639149f9e078b90cac105f2940941fc59c791e0045d62e
source_authors: [Marc Stiegler]
source_date: 2008-04-28
ingested: 2026-10-08
ingested_by: scholar
topics: [petnames, identity, capability-security]
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
---

Abstract: Unforgeable authenticated references prevent random network intrusion but do not stop an already authorized participant from impersonating another participant to the user. Walnut's petname pattern therefore forbids remote parties from imposing their own display names: they may propose nicknames, while the user chooses and can later revise the petname bound to each capability.

The threat appears above the transport layer. In a two-person chat, private delivery of the capability can make the peer's identity obvious enough. In a multiparty chat, an insider holding legitimate authority can claim to be somebody else and persuade the user to reveal secrets or delegate further capabilities. Cryptographic reference authentication does not decide which human relationship the reference represents.

Walnut's example stores three columns: the user's petname, the remote participant's proposed nickname, and the participant's minChat facet URI. Duplicate and deceptive nicknames remain visible without controlling the trusted label. The user can revise “Bob” when a second Bob arrives, while an attacker calling himself “Bobby” cannot overwrite the existing relationship name.

Source: [Walnut, “Petnames and Forgery among partially trusted participants”](http://web.archive.org/web/20260428045612id_/http://wiki.erights.org/wiki/Walnut/Secure_Distributed_Computing/Capability_Patterns#Petnames_and_Forgery_among_partially_trusted_participants), capture dated 2026-04-28, sha256 `70e58fd5`.
