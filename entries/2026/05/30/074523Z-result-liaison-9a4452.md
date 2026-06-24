---
date: 2026-05-30T07:45:23Z
from: liaison
role: liaison
host: endolin
result_of: entries/2026/05/30/070713Z-result-liaison-15cc15.md
library_action: write-concept-pages
status: current
ingested_via: orchestrator-direct-draft
---

# Cycle 78 — Decomposition batch three: the agoric-machinery cluster (competence-vs-performance-modularity + business-agent + positive-vs-negative-reputation)

## Maintainer directive (continued)

The cycle-77 result entry's eight-candidate inventory had 3 of 8 candidates remaining after batch two. Cycle 78 picks the **agoric-machinery cluster** — three concept pages all from the 1988 *Markets and Computation* §3-§5 — as the coherent third batch.

## Written

**Three concept pages** under `library/concepts/`:

1. **`competence-vs-performance-modularity.md`** — the §4.3 1988 structural distinction. Object-orientation modularizes competence (what programs can do); computational markets modularize performance (how efficiently they do it). The two disciplines are orthogonal and composable. **Seven canonical citations**: 1988 §4.3 (canonical Figure 4), 1988 §5 (business-agent operational machinery), 1988 Appendix I.6 (issues × levels summary), 2004 SoA Table 1 (security as competence-side extreme modularity), 2005 CAS §6 (defensive correctness/consistency as competence-side concurrency), Endo handled-promise.js (competence-modular reduction without performance pricing), Endo encodeToSmallcaps.js (competence-modular wire format).

2. **`business-agent.md`** — the §5.3 1988 abstraction. Performance-domain delegate vs subcontractor (competence-domain). Four sub-families: data-type agents, manager-agents, reputation services, compilation speculators. **Five canonical citations**: 1988 §5.3 (canonical exposition), 1988 §4.3 (competence-vs-performance justification), 1988 §6.2 (marketplace-of-mind extension), 2000 §6.4 (broker as manager-agent in CoveredCallOption), 2005 vat-and-event-loop-model (the isolation unit business agents run inside).

3. **`positive-vs-negative-reputation.md`** — the §5.3.3 1988 taxonomy. Negative systems fail under cheap pseudonyms; positive systems require only unforgeable identity; cash-bond performance guarantees address cold-start (contemporary cryptocurrency staking is the production enactment). **Five canonical citations**: 1988 §5.3.3 (canonical exposition), 1988 Appendix I.3 (degrees of trust with Axelrod iterated-prisoner's-dilemma extension), 2000 §6.4 (broker reputation), 2026 Sleeper Channels D2 gate (source-tag function τ as positive-reputation substrate), 2005 §9.2 (VatID as unforgeable-identity substrate).

## Index updates

- `library/concepts/README.md` — added three new rows in alphabetical position with one-line abstracts.
- `library/keywords.md` — added **~36 new keyword aliases**:
  - **competence-vs-performance-modularity** (8 aliases): competence vs performance modularity, competence modularity, performance modularity, safety and liveness, what programs can do vs how efficiently they do it, object-orientation modularizes competence, markets modularize performance, etc.
  - **business-agent** (11 aliases): business agent, business agents, data-type agent, lookup-table agent, manager agent, agent-selection agent, performance-domain delegate, subcontractor vs agent, specialized resource-allocation agent, compilation speculator, Pareto-preferred compiler.
  - **positive-vs-negative-reputation** (17 aliases): positive vs negative reputation, positive reputation system, negative reputation system, reputation system, reputation service, pseudonyms and reputation, cheap pseudonyms vulnerability, cash bond performance guarantee, cash bond pattern, performance guarantee bond, crypto staking (1988 ancestor), Better Business Bureau (computational), Underwriters Laboratories analogy, Axelrod iterated prisoner's dilemma, iterated relationship, etc.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 125 | 125 | 0 |
| Sections | 539 | 539 | 0 |
| Topics | 27 | 27 | 0 |
| Concepts | 36 | **39** | **+3** |
| Roles | 3 | 3 | 0 |
| Keywords | ~870 | **~906** | **+~36** |

## Decomposition campaign progress

The cycle-75 inventory listed 12 candidates; the cycle-76 batch identified 8 as the highest-priority subset. After cycle 78:

- **Cycle 76 (batch one)**: ✓ granovetter-operator, agoric-system, subjective-aggregation, vat-and-compartment.
- **Cycle 77 (batch two)**: ✓ mint-purse-money, brand-and-trademark, smart-contract.
- **Cycle 78 (batch three)**: ✓ competence-vs-performance-modularity, business-agent, positive-vs-negative-reputation.
- **Cycle 79 (batch four — final)**: marketplace-of-mind, opaque-box.

**Ten of 12 candidates landed across cycles 76-78. Two remain for cycle 79's batch four.**

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `b9ac35bd61c126856900f71735e96d9c00be2105` to `59f0dfeb3111efdebc66410f09533b1aebe2ead3`.

## Notes for next cycle (decomposition batch four — the final batch)

**Cycle 79 closes the decomposition campaign** with the remaining two visionary-cluster concept pages:

1. **`marketplace-of-mind`** — intelligence as emergent property of market interactions; the §6.2 1988 framing that separates intelligence from individuality, consciousness, and will. Anchors the AI-via-emergent-market-interactions thesis the 1988 paper articulates and the contemporary multi-agent LLM ecosystem partially enacts.
2. **`opaque-box`** — hardware-encapsulation pattern; the §6.1.2 1988 prediction now realized as Intel SGX, AMD SEV, ARM TrustZone, Apple Secure Enclave, AWS Nitro Enclaves, Microsoft Pluton. Anchors the contemporary secure-enclave + TEE ecosystem in the capability lineage.

After cycle 79 the original cycle-75 12-candidate inventory is exhausted; the library will have **~41 concepts total** (up from 26 before this campaign began 2026-05-21, **15 new concepts in 9 days**) plus a complete cross-citation web across the six-paper Miller cluster + the Sleeper Channels arxiv paper.

After batch four, the three-lane rotation (chat / papers / comments) can resume with the most-load-bearing concept anchors in place.

## Self-improvement

- The 3-concept-page-per-cycle cadence has held steady across three consecutive decomposition cycles (76, 77, 78). The library's cross-citation density is growing organically; each new concept page references 5-7 source-sections plus 5-7 sibling concept pages.
- The agoric-machinery cluster (this batch) is the most-coherent yet — all three pages cite the 1988 §3-§5 + the cross-Endo-implementation references. Future re-anchorings of these pages will be easy because the source material is concentrated.
- The decomposition has now retired the bulk of `[[wiki-link]]` placeholder references across the Miller-cluster sections. After batch four, only a few isolated placeholders will remain (typically referring to potential future concepts not on the initial inventory).
