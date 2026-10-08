---
title: "The original naming trilemma, its scope, and its explicit non-proof"
source_kind: web-essay
source_url: http://zooko.com/distnames.html
source_snapshot: http://web.archive.org/web/2001id_/http://zooko.com/distnames.html
source_content_sha256: 354d22ccf4c42634a56edeeeedaeb3900b056391fa0caf9a61ae869750fdf7af
source_authors: [Zooko Wilcox-O'Hearn]
source_date: 2001-10-12
retrieved: 2026-10-08
ingested: 2026-10-08
ingested_by: scholar
topics: [petnames, identity, capability-theory]
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
---

Abstract: Zooko Wilcox-O'Hearn's version 0.9.1 essay of October 12, 2001 is the originating statement usually compressed into “Zooko's triangle.” It says a namespace cannot simultaneously be distributed across trust boundaries, secure against attacker-forced incorrect lookup results under a universal ownership policy, and use human-usable names. The essay calls this a reasoned doubt, not a proof, explicitly invites a counterexample, and already presents a local petname-translating agent as a fourth design alternative.

The three properties are narrower than the later labels often suggest:

- **Distributed** means no central authority controls the namespace, so it spans trust boundaries.
- **Secure** means an attacker cannot force a lookup to return an incorrect value, where “incorrect” follows a universal name-ownership policy.
- **Human-usable** means people can read and remember the names rather than handling self-authenticating hashes or public-key identifiers.

Wilcox-O'Hearn explains the three easy pairings. DNS-like systems offer secure, human-usable names only by centralizing trust. A distributed human-readable namespace can allow arbitrary rebinding and is therefore insecure. Hashes, public-key-rooted names, SPKI certificates, Freenet CHKs/SSKs, and SFS names can be distributed and secure but are not human-usable.

The essay's final alternative is the important limit on later “counterexample” claims. A loyal local agent can translate self-authenticating global names into human-readable local names. That system offers all three benefits across layers without making one global human-readable namespace satisfy all three. The essay also says the impossibility was not proved and asks any claimed counterexample to specify its universal ownership policy and justify the security claim.

Source: [*Names: Distributed, Secure, Human-Readable: Choose Two*](http://web.archive.org/web/2001id_/http://zooko.com/distnames.html), version 0.9.1, 2001-10-12, sha256 `354d22cc`.
