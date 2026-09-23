---
date: 2026-05-30T07:07:13Z
from: liaison
role: liaison
host: endolin
result_of: entries/2026/05/29/061946Z-result-liaison-4bd033.md
library_action: write-concept-pages
status: current
ingested_via: orchestrator-direct-draft
---

# Cycle 77 — Decomposition batch two: the capability-currency cluster (mint-purse-money + brand-and-trademark + smart-contract)

## Maintainer directive (continued)

Cycle 76 wrote the first decomposition batch of four pages (granovetter-operator, agoric-system, subjective-aggregation, vat-and-compartment). Cycle 77 picks up the cycle-76 result entry's eight-candidate inventory and writes the next three — the **capability-currency cluster** that the cycle-76 result entry proposed as the coherent batch.

## Written

**Three concept pages** under `library/concepts/`:

1. **`mint-purse-money.md`** — the canonical capability-based money example from *Capability-Based Financial Instruments* (Miller-Morningstar-Frantz 2000) §3.4. ~25 lines of E implementing MintMaker → mint → purse with sealed `decr` envelopes. **Six demonstrable security properties via visual inspection.** Citations across the Miller cluster: 2000 §3.3 (sealer/unsealer primitive), 2000 §3.4 (canonical exposition), 2000 §6.4 (CoveredCallOption builds on it), 1988 §4.4 (currency-without-encryption ancestor), 2003 §5 Paradigm Regained (factory-pattern generalization), 2005 §7.2 CAS (statusGetter/statusSetter facet split as the *same pattern* applied to non-currency), encodeToSmallcaps.js comment fragment (wire-format substrate). **Seven canonical citations.**

2. **`brand-and-trademark.md`** — the family of rights-amplification primitives (sealer/unsealer pairs, BrandMaker, FactoryStamp, interface guards). Types-by-fiat without cryptography; the can-and-can-opener analogy. Citations: 2000 §3.3 (canonical naming), 2000 §3.4 (canonical use in mint-purse), 2003 §5 Paradigm Regained (factoryStamp generalization + Cassie+Max confinement), 2003 §4.3 Paradigm Regained (Caretaker as complement), encodeToSmallcaps.js comment fragment (Endo enactment), handled-promise.js comment fragment (safe-vs-passable brand verification), 2005 §7.2 CAS (statusGetter/statusSetter as brand at the method-surface level). **Seven canonical citations.**

3. **`smart-contract.md`** — partially self-enforcing computational embodiment of a contract (Szabo 1996); composition of capability primitives rather than per-contract bespoke cryptographic protocol; CoveredCallOption is the canonical worked example; Agoric Zoe is the production enactment. Citations: 2000 §6.1 (Szabo coinage + cooperation-problem framing), 2000 §6.4 (CoveredCallOption code), 2000 §6.5 (TitleCompanyMaker exclusivity-by-composition), 2000 §3.4 (mint-purse-money foundational primitive), 2000 §1.2 (Granovetter Operator as financial-bearer-instrument), 1988 §4.3 (competence-vs-performance modularity framing), 2003 Paradigm Regained §5.3-§5.4 (arena + mutually-suspicious composition), 2005 CAS vat/partial-failure (isolation unit + atomicity machinery). **Eight canonical citations.**

## Index updates

- `library/concepts/README.md` — added three new rows in alphabetical position with one-line abstracts.
- `library/keywords.md` — added **~52 new keyword aliases**:
  - **mint-purse-money** (13 aliases): MintMaker, mint, purse, sealed decr, capability-based money, six security properties (mint-purse), Alice pays Bob $10, Agoric ERTP ancestor, ERTP issuer-kit ancestor, makeIssuerKit, issuer-kit, plus others.
  - **brand-and-trademark** (20 aliases): brand, brands, trademark, trademarks, sealer/unsealer, sealer-unsealer pair, sealer, unsealer, BrandMaker, BrandMaker pair, FactoryStamp, interface guards, rights amplification primitive, envelope and can-opener, can and can-opener, can-opener analogy, @endo/marshal brand, Endo brand, makeBrand, types-by-fiat.
  - **smart-contract** (16 aliases): smart contract, smart contracts, Szabo smart contract, Nick Szabo, Szabo 1996, computational contract, self-enforcing computational contract, CoveredCallOption, covered call option, CoveredCallOptionMaker, Zoe contract, Agoric Zoe, Agoric contract, TitleCompanyMaker, escrowedStock, escrowedMoney.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 125 | 125 | 0 |
| Sections | 539 | 539 | 0 |
| Topics | 27 | 27 | 0 |
| Concepts | 33 | **36** | **+3** |
| Roles | 3 | 3 | 0 |
| Keywords | ~818 | **~870** | **+~52** |

## What changes for library users

The library's `[[wiki-link]]` cross-reference web is now densely populated for the capability-currency story:

- **mint-purse-money** ← cited as `[[mint-purse-money]]` by `agoric-system`, `brand-and-trademark`, `smart-contract`, multiple Miller-cluster sections.
- **brand-and-trademark** ← cited by `mint-purse-money`, `caretaker-pattern` (sibling pattern), `smallcaps-encoding` (wire-format substrate), `vat-and-compartment` (cross-vat verification).
- **smart-contract** ← cited by `agoric-system` (broader framing), `mint-purse-money` (foundational primitive), `brand-and-trademark` (verification substrate), `four-ways-to-acquire-references` (structural safety).

A future searcher arriving with any of ~52 newly-indexed aliases — *"MintMaker"*, *"CoveredCallOption"*, *"Agoric Zoe"*, *"can-opener analogy"*, *"types-by-fiat"*, *"Szabo 1996"*, *"escrowedStock"*, *"ERTP issuer-kit ancestor"* — finds the right concept page on the first lookup.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `dad4c62a7b9c74f9fb0121202ae4c49018ca15a6` to `b9ac35bd61c126856900f71735e96d9c00be2105`.

## Notes for next cycle (decomposition batch three)

The cycle-76 result entry's eight-candidate inventory is now **5 down, 3 remaining**:

1. ~~`mint-purse-money`~~ — done this cycle.
2. ~~`brand-and-trademark`~~ — done this cycle.
3. ~~`smart-contract`~~ — done this cycle.
4. **`competence-vs-performance-modularity`** — 3+ citations; the §4.3 1988 architectural distinction; cross-cuts the whole library.
5. **`business-agent`** — 3+ citations; performance-domain delegate (vs subcontractor); foundational for agent-conventions topic.
6. **`positive-vs-negative-reputation`** — 1988 §5.3.3 taxonomy; foundational for trust-system design.
7. **`marketplace-of-mind`** — intelligence as emergent property of market interactions; the §6.2 1988 visionary anchor.
8. **`opaque-box`** — hardware-encapsulation pattern; 1988 prediction now realized as SGX et al.

The remaining five fall into two groups:

- **The agoric-machinery cluster (#4-6)**: competence-vs-performance-modularity, business-agent, positive-vs-negative-reputation. These three are all from the 1988 paper §3-§5; they form a coherent batch for cycle 78.
- **The visionary cluster (#7-8)**: marketplace-of-mind, opaque-box. Both from the 1988 paper §6; one each cycle (or both in one cycle) closes the decomposition.

**Recommended cycle 78**: write the agoric-machinery cluster (competence-vs-performance-modularity + business-agent + positive-vs-negative-reputation) as the third batch. This completes the *structural* decomposition — every load-bearing 1988-2005 concept gets a concept page.

**Recommended cycle 79**: write marketplace-of-mind + opaque-box as the fourth (and final initial-inventory) batch. After this, the eight-candidate inventory from cycle 75 is exhausted.

After cycle 79, the three-lane rotation (chat / papers / comments) can resume with the library having ~41 concepts total — roughly doubled from the 26 concepts before this decomposition campaign started (2026-05-21).

## Self-improvement

- The cycle-76 → cycle-77 cadence is now well-grooved: 3-4 concept pages per cycle, ~15-20 keyword aliases each, single liaison-direct-draft turn per batch. The pattern scales.
- The 7-8 canonical citations per concept page is the new normal (up from 4-6 in cycle 76's batch). The library's cross-citation density is growing organically; concept pages now form the navigation backbone the library was designed for.
- Capability-currency cluster (mint-purse-money + brand-and-trademark + smart-contract) is the most-tightly-interrelated batch yet — each page cites the other two in See-also and Sections tables. Future batches may have even tighter coupling depending on which three concepts get grouped together.
