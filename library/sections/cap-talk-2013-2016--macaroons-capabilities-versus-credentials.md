---
title: "Macaroons: capability-like attenuation versus credential pools"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-December/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-December.txt.gz
source_content_sha256: 77b7414497546fdad3fcae2a1b45ba2e771719b00ba0fa610155d7bb8edb9b21
source_authors: [Tony Arcieri, David Barbour, Alan Karp]
source_date: 2014-12-10 to 2014-12-12
thread_subject: "Macaroons: capabilities vs credentials"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Macaroons are bearer tokens that any holder can attenuate by adding HMAC-chained caveats, including expiry, request-specific limits, and third-party discharge requirements. Arcieri asks whether that makes them capabilities. Barbour's objection is behavioral: a capability tightly couples designation with the authority selected for one action, whereas a credential with contextual caveats may require searching a pool of other credentials to prove facts about the bearer. That weak coupling can reintroduce confused-deputy choices about which credentials a request implicitly consumes.

Karp's pragmatic verdict is that bearer tokens such as OAuth tokens or macaroons *can be used* as capabilities but do not force capability use. The primitive is therefore capability-friendly, not capability-secure by construction. A macaroon design becomes capability-shaped when each token designates a specific resource or protocol facet and the caller explicitly selects it; it remains credential-shaped when a verifier asks who the bearer is or what unrelated proofs the bearer can assemble.

Source: [cap-talk 2014-December archive](http://www.eros-os.org/pipermail/cap-talk/2014-December/) (Internet Archive original-bytes `id_` snapshot of `2014-December.txt.gz`, sha256 `77b74144`), thread "Macaroons: capabilities vs credentials", 2014-12-10 to 2014-12-12.
