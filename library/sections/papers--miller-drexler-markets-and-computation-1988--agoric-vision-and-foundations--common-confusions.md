---
title: Common confusions
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "133-148 (§1 Introduction + §1.1-§1.2; §2 Overview; §3 Computation and economic order with subsections §3.1-§3.7; §4 Foundations with subsections §4.1-§4.5)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations
---

- **"Agoric systems are about cryptocurrency."** No — the 1988 paper predates cryptocurrencies by 21 years. *Agoric* describes any computational system using market mechanisms for resource allocation, with capability discipline as the access-control substrate. The 1988 currency framing (§4.4) is capability-rooted, not cryptography-rooted. The 2000 paper's capability-based money is the earliest worked-out form; production Agoric (the company) builds on this lineage but is broader than its monetary aspect.
- **"Three vs four mechanisms is a contradiction."** No — the 1988 enumeration combines Endowment + Initial Conditions into the single mechanism "being born with it"; the 2004 refinement splits them because the *time of creation* (Endowment) and the *universe-of-discourse origin* (Initial Conditions) are mechanically distinct. The 2004 refinement is the canonical form.
- **"Competence vs performance is just safety vs liveness."** No — competence subsumes safety and liveness (the *what* of a program). Performance is the *how efficient* dimension. The §4.3 Figure 4 explicitly maps competence to the safety/liveness pair and performance to its own dimension.
- **"This paper is about replacing programming with economics."** No — the §3.5 Coase argument explicitly anticipates *firms* in the computational market: small objects will bundle into low-overhead computational "firms" where internal accounting is not warranted. Markets are not a universal solvent; they are most appropriate at *intermediate-and-larger scales* where transaction costs are dominated by inefficient-decision costs.
- **"Spontaneous order is hand-wavy."** §3.4's spontaneous-order argument is rigorous to the extent Hayek's economic argument is rigorous: prices summarize local knowledge into globally-actionable signals, and the system as a whole exhibits coherent behavior that no individual planner could reproduce. The §3.4 claim is testable in principle and rests on the §3.2 *encapsulation = property rights* structural argument.
