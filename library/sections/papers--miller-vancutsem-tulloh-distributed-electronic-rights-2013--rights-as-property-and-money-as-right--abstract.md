---
title: Abstract
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

§3 develops the **rights-as-property** framing for distributed computational systems. The §3 paper opens with Ostrom's *Governing the Commons* observation that *historically two broad strategies for avoiding the tragedy of the commons have emerged: a governance strategy and a property rights strategy*. **Access-control-list systems implement a governance strategy** (restricting access to members + regulating use; perimeter security); **object-capability systems implement a property-rights strategy** (decentralized division of rights among individual agents who can decide their use). The §3 architectural payoff: as the number of users and types of access increases, governance breaks down — perimeter security cannot cope with the pressure for increased access, and ACLs cannot keep up with dynamic requests for changes in access rights. Property-rights systems handle this complexity by partitioning the commons into separate domains under the control of specific agents who can decide its use *as long as the use is consistent with the rights of others*. §3 closes with **four dimensions along which money differs from object references**: object references are *shareable* (Alice copying a reference to Bob preserves Alice's access), *specific* (designates a particular object), *opaque* (clients can invoke but don't know the implementation), and *exercisable* (the right is to invoke); money is the *opposite* on all four — *exclusive*, *fungible*, *measurable* (assayable), and *symbolic* (no exercise; value only in exchange). §4 walks the **makeMint code in JavaScript**, ~20 lines that produce a money-like rights issuer using only the §2 SES + Q primitives. The §4 mint-purse code reprises the 2000 *Capability-Based Financial Instruments* §3.4 mint-purse pattern in modern JavaScript — `WeakMap` replaces the BrandMaker pair, `def` replaces the E `def`-defensible-object syntax, but the security properties are identical: only the mint can mint; only same-currency transfer works; balance is protected by closure scope; the deposit method's rights-amplification via WeakMap-lookup-on-source-purse enforces same-currency invariant.
