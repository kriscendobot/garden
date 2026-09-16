---
title: "Avoiding excess authority in chained access"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-June.txt.gz
source_content_sha256: 8cbb4cb659ac9deb86d73395a2ef63dc0462094c805a3a7d6730c8ae515e8072
source_authors: [Alan Karp, Mark Miller, David Barbour, David Wagner, Bill Frantz]
source_date: 2011-06-21 to 2011-06-22
thread_subject: "Avoiding excess authority in chained access"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. The thread continues in 2011-October (deferred to a later cycle)."
---

Abstract: Alan Karp brought a question raised by designers building a system on ZBAC (authorization based on attributes carried in the request), reworded into object-capability terms. Alice holds a reference to Bob, and Bob holds a reference to Carol; Alice invokes a method on Bob that requires Bob to reach Carol. The design question is whether Bob should act with his *own* authority to Carol, or use authority that Alice supplies, and how that interacts with whether Alice holds no reference to Carol, a reference to a Carol facet, or a reference to full Carol. Mark Miller sketched an E solution using a sealed box branded by Carol, so Carol can inspect the box before honoring Bob's request, but noted the hard cases (how the box is obtained when Alice has never heard of Carol, and how it updates when Alice acquires a Carol facet from a third party). David Barbour cut to the security principle: Alice must never be able to *gain* authority by throwing a capability away, so the choice of whose authority Bob uses should be static, decided by Bob's design, not by what Alice happens to present. David Wagner untangled the problem into two independent axes (whose authority, and what reference Alice holds) yielding a two-by-three matrix, and Bill Frantz objected to the premise that Bob's authority to Carol is a *superset* of Alice's, since facets span a wide range and there may be no single "full" authority.

## The confused-deputy shape of delegation

The scenario is the confused deputy generalized to a call chain. If Bob sometimes uses his own authority and sometimes Alice's, depending on what Alice hands him, then Alice can influence which authority is exercised, which is precisely the lever a confused deputy attack pulls. Barbour's rule closes it: the decision of whose authority Bob acts with is a static property of Bob, and Alice presenting or withholding a reference must never *increase* her reach. Miller's sealed-box construction is the mechanism for the case where Bob should act only on a Carol that Alice can legitimately designate: Alice supplies a box that Carol's brand can open and validate, so Bob forwards a request that Carol will accept only if the designation is authentic. The residual difficulty is bootstrapping and update, the parts Miller flagged: obtaining the box when Alice has no prior knowledge of Carol, and keeping it consistent when Alice's Carol facet arrives by another path.

Wagner's decomposition is the clarifying move. Two questions are being conflated: (1) does Bob use his own authority or Alice's, and (2) does Alice hold nothing, a Carol facet, or full Carol? These are independent, so the honest design space is the full two-by-three matrix, and Karp's problem statement smuggled in a coupling between them. Frantz's objection removes another hidden premise: talking about Bob's authority as a superset of Alice's assumes facets form a linear order with a maximum, but facets can attenuate along many independent dimensions, so there need not be any single facet that dominates the others.

## Bearing on Endo

This is the core delegation question Endo answers by construction. Authority in Endo travels only as an explicitly granted reference, and attenuation is done by handing out a specific facet, so Bob acts on Carol through whatever reference Bob was granted, and Alice cannot change which authority is exercised by varying what she presents. Barbour's invariant (never gain authority by discarding a capability) is a design rule for any Endo intermediary that forwards requests: the intermediary either forwards the caller's supplied capability or uses its own, and that choice is fixed in its code, not selected at call time by the caller. Miller's sealed-box pattern maps onto Endo's sealer/unsealer and branded-value patterns for the case where a caller must present a designation the callee can independently authenticate. Frantz's caution against a "full authority" facet is exactly why Endo prefers narrow purpose-built facets over a single powerful reference that clients then attenuate. The bootstrapping problem Miller flagged is the introduction problem Endo's powerbox and introduction protocols exist to handle.

Source: [cap-talk 2011-June archive](http://www.eros-os.org/pipermail/cap-talk/2011-June/) (Internet Archive original-bytes `id_` snapshot of `2011-June.txt.gz`, sha256 `8cbb4cb6`), thread "Avoiding excess authority in chained access", 2011-06-21 to 2011-06-22.
