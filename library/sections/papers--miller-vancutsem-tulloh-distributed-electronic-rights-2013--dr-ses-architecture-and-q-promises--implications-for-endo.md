---
title: Implications for Endo
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "1-10 (§1 Smart Contracts for the Rest of Us; §2 Dr. SES with §2.1-§2.5)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, eventual-send, captp, persistence]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises
---

This section is the **historical-link citation** for the entire contemporary Hardened JavaScript stack. The library can cite this paper whenever a design needs to ground:

1. **The Hardened JavaScript lineage.** Dr. SES → @endo/ses + lockdown. The contemporary stack is the direct successor of the §2 1988 design.
2. **The Q library lineage.** Q → @endo/eventual-send. The `!` operator → `E()`; the HandledPromise primitive is the modern realization.
3. **The OCapN lineage.** Web-keys → formula identifiers; RESTful pass-by-reference → CapTP wire protocols.
4. **The persistence lineage.** Ken → @endo daemon's formula-graph + cycle-47 daemon-persistence design.
5. **The contract-host lineage.** The §6 Contract Host (covered in `escrow-exchange-and-contract-host`) → Agoric Zoe contract framework.

The library's existing `vat-and-compartment` concept page anchors the structural-isolation primitive; this section is the *JavaScript-implementation* citation for that primitive's contemporary realization. The library's `smart-contract` concept page now has a clear lineage anchor between the 2000 paper's E-language smart contracts and Agoric Zoe's JavaScript contracts.
