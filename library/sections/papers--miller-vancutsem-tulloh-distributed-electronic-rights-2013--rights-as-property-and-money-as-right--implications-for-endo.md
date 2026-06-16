---
title: Implications for Endo
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

This section is the **canonical citation for the 2013 JavaScript translation of the rights-as-property framing**. The library can cite this paper whenever a design needs to ground:

1. **ACL vs ocap as governance vs property rights.** §3.1's framing is the structural-architectural justification for why ocap systems do *not* implement ACL semantics — they are different responses to the tragedy of the commons. The library can use this in design reviews of any system that proposes to layer ACLs on top of ocap.
2. **The four dimensions of money vs references.** §3.3's taxonomy is the structural justification for *AmountMath kinds* in Agoric ERTP. The contemporary `nat` / `set` / `copyBag` / `copySet` set of mathematical kinds is the parameterization across the four axes.
3. **The JavaScript-native mint-purse code.** §4's ~20 lines are the canonical citation for *makeMint in modern JavaScript*. The contemporary Agoric ERTP's `makeIssuerKit` is the production scaling.
4. **The lineage from the 2000 paper.** The architectural pattern is the same as Capability-Based Financial Instruments 2000 §3.4 mint-purse-money; the implementation is now JavaScript. This is the bridge between the E-language lineage and the contemporary Hardened JavaScript ecosystem.
