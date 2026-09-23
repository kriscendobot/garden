---
title: See also
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft (referenced as Drossopoulou-Noble *Swapsies on the Internet* PLAS 2015 [17] in the bibliography; the full technical report is ECSTR-15-08, VUW, 2015 [18])"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "1-7 (§1 Introduction; §2.2 Modelling Trust and Risk: obeys, MayAccess, and MayAffect)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, spec-to-implementation]
status: current
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect
---

- [[object-capability]] — the §2.2 constructs are the spec-language formalization of the ocap model. *Only connectivity begets connectivity* (Miller PhD 2006 [30]) is the rule that justifies `MayAccess` as the transitive points-to closure.
- [[principle-of-least-authority]] — `MayAffect` is the POLA bound: an object can affect only what it has authority to affect.
- [[four-ways-to-acquire-references]] — `MayAccess` formalizes the *introduction* arm: a reference to `p` from `o` arises only along a chain that was already reachable before the call.
- [[smart-contract]] — the §1 paper motivates the methodology by pointing to smart-contract specification (specifically the escrow exchange). The §2.2 constructs are the spec-language groundwork; the §2.5-§2.6 application is the worked example.
- [[mint-purse-money]] — the §2.3 *ValidPurse* specification (the next section in this source) is the §2.2 constructs *applied* to formalize the Miller-Drexler mint-purse pattern.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host` — the escrow exchange this paper formalizes. The §2.2 constructs let us verify that the §5 escrow exchange of the 2013 paper is *not as strong* as originally thought; the §2.5 *deal_version2* is the revision.
