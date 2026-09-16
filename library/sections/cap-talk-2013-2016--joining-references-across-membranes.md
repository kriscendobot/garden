---
title: "Joining references across membranes changes revocation semantics"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2016-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2016-January.txt.gz
source_content_sha256: 506e6bfcc7289a1e2ac255d90759690f5d061e8c2aa81ffc68a29d635e06882e
source_authors: [Kenton Varda, Bill Frantz, Chip Morningstar, Alan Karp, Matt Rice, Guido van Rossum, David Bruant, Raoul Duke, Ihab Awad, Mark S. Miller, Marc Stiegler, Kevin Reid, Rob Meijer, Sandro Magi, John Levine]
source_date: 2016-01-04 to 2016-01-20
thread_subject: "Joins on capabilities that have passed through different membranes"
ingested: 2026-09-16
ingested_by: scholar
topics: [revocation, distributed-objects, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Two references may ultimately route to one endpoint yet carry different attenuation and revocation paths. Varda asks whether joining them should produce a reference revoked when **either** input is revoked (intersection) or only when **both** are revoked (union). The first lets either grantor disrupt the joined result; the second may preserve authority one grantor intended to withdraw. Morningstar concludes that neither policy is universally correct, while Karp warns that unification can itself create a confused deputy. The intended protocol — escrow, multi-party approval, redundancy, or mere equality testing — must choose the semantics.

Karp's “Ask Bob” protocol tests endpoint sameness without a global equality oracle: send different nonces along the two paths and ask the endpoint to return each by the other path. Success shows that one cooperative endpoint sees both references; failure cannot distinguish inequality from refusal. Even a positive answer does not erase the membranes' distinct policy. Equality of destination is therefore weaker than substitutability of authority.

## Bearing on Endo

Endo should not canonicalize remote presences solely because a lower transport layer discovers one endpoint. A presence may embody path-specific ordering, attenuation, revocation, or audit provenance. Any join must be an explicit protocol object whose policy is visible to all grantors.

Source: [cap-talk 2016-January archive](http://www.eros-os.org/pipermail/cap-talk/2016-January/) (Internet Archive original-bytes `id_` snapshot of `2016-January.txt.gz`, sha256 `506e6bfc`), thread "Joins on capabilities that have passed through different membranes", 2016-01-04 to 2016-01-20.
