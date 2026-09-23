---
title: Common confusions
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "10-14 (§3 Toward Distributed Electronic Rights; §4 Money as an Electronic Right)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, patterns]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--rights-as-property-and-money-as-right
---

- **"ACLs and ocaps can be unified."** §3.1's framing is they are *different* responses to the tragedy of the commons. Unification would require either (a) abandoning ACL's perimeter-security focus (degenerates to ocap), or (b) abandoning ocap's possessory-rights focus (degenerates to ACL). Hybrid systems exist (Endo's daemon hosts include both ocap inside and ACL-ish auth outside), but the structural-architectural choice between governance vs property is a binary at the design layer.
- **"The four dimensions are arbitrary."** The four axes (Shareable/Exclusive, Specific/Fungible, Opaque/Measurable, Exercisable/Symbolic) cover the orthogonal *value-bearing* properties an electronic right can have. The §3.3 framing originates in the 2000 paper §6.2 and has been the design vocabulary for Agoric ERTP's `AmountMath` for over a decade. Other axes can be added (e.g. *perishable vs durable* from CoveredCallOption analysis) but these four are the canonical core.
- **"WeakMap is just a hash table."** Functionally yes; semantically no. WeakMap is *object-identity-keyed* (not value-keyed) and the references it holds are *weak* (objects can be garbage-collected even if WeakMap-referenced). The combination makes WeakMap the structural primitive for *rights amplification*: only the holder of the WeakMap can map an object to a value; non-holders cannot enumerate or even ask about which objects are in the WeakMap. This is the JavaScript-native primitive that makes the §4 mint-purse pattern possible.
- **"This paper is just the 2000 paper in JavaScript."** Closer to *yes-and-more*. The §4 makeMint code is the JavaScript translation of the 2000 §3.4 E code. But the paper also adds: §2's Dr. SES architecture (Q + NodeKen are new), §5's escrow-exchange contract (new structural pattern), §6's generic Contract Host (new architectural primitive). The translation is faithful where it overlaps; the additions extend the lineage.
- **"Money's exclusivity comes from cryptography."** No — §3.3 is explicit that exclusivity comes from *the structure of the rights system*, not from cryptography. In Dr. SES, exclusivity is enforced by the deposit-and-decrement-atomic-commit pattern: Bob's purse increments only if Alice's purse decrements, and both happen atomically inside the deposit method. The cryptography is for *wire transport* (web-keys); the exclusivity is structural.
