---
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_title: "Markets and Computation: Agoric Open Systems"
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/markets-and-computation-agoric-open-systems.pdf
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_pdf_pages: 44
ingested: 2026-05-28
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 1988 Miller-Drexler paper that introduces **agoric systems** — software systems using market mechanisms, based on foundations providing for the *encapsulation* and *communication* of *information*, *access*, and *resources* among *objects*. The term *agoric* is coined from *agora* (Greek for meeting and market place); **the Agoric company name and the entire agoric-systems research lineage trace directly to this 1988 paper**. The paper develops the Hayekian argument that decentralized planning via market prices produces *spontaneous order* superior to central planning, applies the argument to computation, defines capability security via a three-mechanism rule (the 1988 ancestor of the 2004 four-ways-to-acquire-references enumeration), introduces the *competence vs performance modularity* distinction (object-orientation modularizes competence; computational markets modularize performance), develops the *business-agent* abstraction for performance-domain delegation, names the *scandal of idle time* as evidence of wasteful resource allocation, predicts charge-per-use software markets supported by hardware encapsulation (opaque boxes — anticipating Intel SGX et al by ~30 years), proposes intelligence as an emergent property of market interactions in the *marketplace of mind*, and takes up the natural skeptical question (*why hadn't agoric systems been built?*) with a careful due-process argument enumerating four sufficient reasons for the absence.

This is **the historical and conceptual seed of the Agoric project**, the earliest paper in the library's Miller capability-theory cluster, and the most ambitious in scope of the six Miller-coauthored papers now in the library. The four-paper 2003-2005 cluster + the 2000 Capability-Based Financial Instruments + this 1988 paper now span **18 years of capability-theory development**, and the library has the complete arc.

## For the Endo / Agoric library

This paper is the **canonical citation** for:

- The *agoric system* term-of-art and the entire Agoric mission.
- The three-mechanism capability-security definition (the 1988 ancestor of the 2004 four-way enumeration; see [[four-ways-to-acquire-references]]).
- The *competence vs performance modularity* distinction — the architectural framing under which object-orientation modularizes *what programs can do* and computational markets modularize *how efficiently they do it*.
- The *business agent* abstraction (performance-domain delegate, vs subcontractor as competence-domain delegate).
- *Initial market strategies* — auction-based processor scheduling and rent-based memory allocation, drawn from the companion paper *Incentive Engineering for Computational Resource Management*.
- The *positive vs negative reputation* taxonomy: positive-reputation systems require only unforgeable identity, negative-reputation systems fail under cheap pseudonyms.
- The *Pareto-preferred compiler* concept.
- The *scandal of idle time* diagnostic frame.
- The *opaque box* hardware-encapsulation pattern (now realized as Intel SGX, AMD SEV, ARM TrustZone, Apple Secure Enclave, AWS Nitro Enclaves, Microsoft Pluton, et al).
- The *marketplace of mind* — intelligence as emergent property of market interactions; the §6.2 separation of intelligence from individuality, consciousness, and will.
- The *issues × levels* matrix (Appendix I): security (encapsulation ↔ skepticism), compatibility (message passing ↔ operability), trust (trust ↔ reputations), reasoning (logic ↔ due-process), coordination (serialization ↔ negotiation).

## The argument arc

1. **The agoric vision.** Software systems using market mechanisms, with capability discipline as the access-control substrate. *Agoric* from *agora*. The mission of what becomes Agoric the company.
2. **Hayek and spontaneous order.** Prices summarize local knowledge; decentralized planning produces coherent system-wide order no central planner could specify.
3. **Encapsulation as property right.** §3.2: encapsulation in software serves the same function as property rights in human affairs.
4. **Capability security in three mechanisms.** §4.1: A can access B only by being born with it, receiving it in a message, or being its creator. The 1988 ancestor of the four-way enumeration.
5. **Competence vs performance modularity.** §4.3: object-orientation modularizes competence; computational markets modularize performance. Markets do for performance modularization what message-passing does for competence modularization.
6. **Currency without encryption.** §4.4: capability-based security + unforgeable unique identifiers are sufficient for a banking system. The 2000 paper's VatID + swiss number is the worked-out form.
7. **Business agents.** §5: agents delegate performance-domain decisions; subcontractors delegate competence-domain work. Data-type agents (lookup-table example) demonstrate transparent implementation-switching based on usage patterns. Reputations scale trust without exhaustive verification. Compilation is investment.
8. **The scandal of idle time.** §5.4: most computing resources sit idle most of the time, evidence of wasteful resource allocation. Post-facto simulation as a partial answer.
9. **Charge-per-use markets.** §6.1: composition-encouraging incentive structure; opaque boxes as the hardware-encapsulation substrate.
10. **Marketplace of mind.** §6.2: intelligence as emergent property of market interactions; intelligence separable from individuality, consciousness, will.
11. **The absence-of-agoric-systems argument.** §7: a careful due-process argument that the 1988 absence of agoric systems is consistent with their being a good idea. Four sufficient reasons enumerated.
12. **Conclusion.** §8: as systems grow in scale and complexity, so will the advantages of market-based computational systems.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [agoric-vision-and-foundations](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations.md) | capability-theory, capability-security, patterns | current |
| [business-agents-and-resource-strategies](../sections/papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies.md) | capability-security, agent-conventions, patterns | current |
| [agoric-in-the-large-and-absence-of-agoric-systems](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems.md) | capability-theory, capability-security, agent-conventions, patterns | current |

The paper's eight sections + two appendices collapse to three argument-cluster sections in the library. §1-§4 → vision and foundations; §5 → business-agent machinery; §6-§8 + Appendix I → agoric-in-the-large + absence + summary. Appendix II's comparison-with-other-systems material is supporting context that the three retained sections cite where relevant rather than re-summarize.

## Provenance

- Fetched 2026-05-28 from `papers.agoric.com/assets/pdf/papers/markets-and-computation-agoric-open-systems.pdf` per the established Agoric-mirror discipline.
- PDF SHA-256 `f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b`, 44 pages.
- Drafted by the liaison via orchestrator-direct-draft. **Sixth Miller-coauthored paper** in the library; the library now spans **18 years (1988-2005)** of capability-theory development plus the 2026 agent-security arxiv paper, making capability-theory the most-cited topic in the library at 26 sections.
