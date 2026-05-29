---
date: 2026-05-29T06:19:46Z
from: liaison
role: liaison
host: endolin
result_of: entries/2026/05/29/053818Z-result-liaison-18e585.md
library_action: write-concept-pages
status: current
ingested_via: orchestrator-direct-draft
---

# Cycle 76 — Decomposition batch one: four concept pages from accumulated Miller-cluster material

## Maintainer directive

The cycle-75 result entry (`entries/2026/05/29/053818Z-result-liaison-18e585.md`) recorded the maintainer's mid-cycle directive: *"We should soon start decomposing these sources into sections, topics, and concepts."* Cycle 76 picks up that directive as primary task. This is the second concept-page batch in the library's history (the first was 2026-05-21's POLA / four-ways / security-as-extreme-modularity batch).

## Written

**Four concept pages** under `library/concepts/`:

1. **`granovetter-operator.md`** — the three-object reference-passing primitive. Canonical citations: 2000 *Capability-Based Financial Instruments* §1.2 (canonical naming + six-perspectives), 2004 *Structure of Authority* §3.4 (Introduction mechanism), 2003 *Paradigm Regained* §4 (formal loader-based model), 1988 *Markets and Computation* §1.2 (structural ancestor), 2003 *Capability Myths Demolished* §four-models (Properties A and D rest on the constraint). **Five canonical citations.**

2. **`agoric-system.md`** — software systems using market mechanisms based on capability-security foundations. Canonical citations: 1988 *Markets and Computation* all three sections (naming + foundations + business agents + agoric-in-the-large), 2000 *Capability-Based Financial Instruments* mint-purse-money + CoveredCallOption (currency-layer enactment), 2005 *Concurrency Among Strangers* vat model (unit of isolation), 2004 *Structure of Authority* security-as-extreme-modularity (access-layer foundation). **Seven canonical citations.** Library-defining concept; the Agoric mission anchor.

3. **`subjective-aggregation.md`** — "only trust makes distinctions"; the per-bundle trust model substrate. Canonical citations: 2000 *Capability-Based Financial Instruments* §4.3 (canonical exposition with the aphorism), 2005 *Concurrency Among Strangers* vat-as-TCB framing, 1988 *Markets and Computation* Appendix I.3 degrees-of-trust ancestor, 2003 *Paradigm Regained* §5.4 mutually-suspicious composition, 2026 *Sleeper Channels* D2 gate's source-tag function τ. **Six canonical citations.**

4. **`vat-and-compartment.md`** — the cross-pillar translation between the 2005 vat model and Endo's bundle + compartment. Long-deferred (originally flagged cycle 65/67). Canonical citations: 2005 *Concurrency Among Strangers* §3 vat-and-event-loop-model (canonical definition), 2005 *Concurrency Among Strangers* §9 partial-failure-and-when-catch (persistence semantics), 2000 *Capability-Based Financial Instruments* §4.1-§4.2 cryptographic-identity layer, 2005 *Concurrency Among Strangers* §11 history (Joule lineage), 1988 *Markets and Computation* §3.5 Coase / computational firms ancestor, Endo daemon-persistence (the Endo enactment), handled-promise.js comment fragment (the eventual-send substrate). **Seven canonical citations.**

## Index updates

- `library/concepts/README.md` — added four new rows (in alphabetical position) with one-line abstracts noting the citations and the 2026-05-29 date.
- `library/keywords.md` — added **~62 new keyword aliases** routing search terms to the four new concept pages:
  - **granovetter-operator** (10 aliases): Granovetter Operator, Granovetter Diagram, Granovetter step, Mark Granovetter, three-object reference-passing, bob.foo(carol), b.foo(c), introduction by message passing, six perspectives (Granovetter), the strength of weak ties.
  - **agoric-system** (24 aliases): agoric system, agoric open system, agoric approach, agora-style computation, market-based computation, computational market, Agoric (the company), Miller-Drexler 1988, The Ecology of Computation, Huberman 1988, encapsulation as property right, charge-per-use, opaque box, marketplace of mind, the scandal of idle time, business agent, spontaneous order, competence vs performance modularity, post-facto simulation, Pareto-preferred compiler, plus more.
  - **subjective-aggregation** (13 aliases): subjective aggregation, only trust makes distinctions, mistrust is ignorance, vat as TCB, vat as Trusted Computing Base, per-bundle trust model, inter-vat mutual suspicion, inter-object mutual suspicion, reason as if only suspicious of objects, economy of suspicion, fully paranoid actor, monolithic conspiracy assumption.
  - **vat-and-compartment** (15 aliases): vat, vat model, compartment, HardenedJS compartment, SES compartment, Endo compartment, vat-compartment translation, vat as unit of {persistence, migration, partial failure, resource control, DoS-defense}, vat incarnation, Joule tank, heap + thread + pending-delivery queue, unit of sequentiality, turn boundary, computational firm.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 125 | 125 | 0 |
| Sections | 539 | 539 | 0 |
| Topics | 27 | 27 | 0 |
| Concepts | 29 | **33** | **+4** |
| Roles | 3 | 3 | 0 |
| Keywords | ~756 | **~818** | **+~62** |

## What changes for library users

Four placeholder `[[wiki-link]]` references retire — across many existing section files. The most-impacted sections are:

- **`papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--*`** — all three sections used `[[vat-and-compartment]]` placeholders; now resolve.
- **`papers--miller-tribble-shapiro-concurrency-among-strangers-2005--*`** — multiple sections used `[[vat-and-compartment]]` and `[[subjective-aggregation]]` placeholders.
- **`papers--miller-tulloh-shapiro-structure-of-authority-2004--*`** — the fractal-structure-of-authority section's Introduction mechanism now has the dedicated `[[granovetter-operator]]` concept page.
- **`papers--miller-drexler-markets-and-computation-1988--*`** — all three sections used `[[agoric-system]]` references that the new concept page anchors.

The library's `[[wiki-link]]` syntax now resolves to four more concept pages than it did before this cycle. Per the cycle-71 keyword-batch discipline, library-lookup is correspondingly more effective: a future searcher arriving with any of ~62 newly-indexed aliases — *"the scandal of idle time"*, *"only trust makes distinctions"*, *"vat"*, *"Granovetter"*, *"Agoric"* — now finds the right concept page on the first lookup.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `70a3b1dcd8a5f71adbb950dd4e5187ad3733c022` to `dad4c62a7b9c74f9fb0121202ae4c49018ca15a6`.

## Notes for next cycle (decomposition batch two)

The cycle-75 result entry listed 12 candidates for concept-page promotion. Four are now landed; **eight remain**. Ranked by citation count (highest payoff first):

1. **`mint-purse-money`** (or **`capability-based-money`**) — 4+ citations; Agoric ERTP ancestor; the canonical worked example of capability composition.
2. **`competence-vs-performance-modularity`** — 3+ citations; the §4.3 1988 architectural distinction; cross-cuts the whole library.
3. **`business-agent`** — 3+ citations; performance-domain delegate (vs subcontractor); foundational for agent-conventions topic.
4. **`brand-and-trademark`** — extending or sibling to `caretaker-pattern`; the sealer/unsealer + FactoryStamp family.
5. **`positive-vs-negative-reputation`** — 1988 §5.3.3 taxonomy; foundational for trust-system design.
6. **`smart-contract`** — Szabo's term; capability-composition discipline.
7. **`marketplace-of-mind`** — intelligence as emergent property of market interactions; the §6.2 1988 visionary anchor.
8. **`opaque-box`** — hardware-encapsulation pattern; 1988 prediction now realized as SGX et al.

The natural next batch: **batch two could draft 3-4 of these** in a single cycle. Strongest combinations:

- *Coherent batch*: `mint-purse-money` + `brand-and-trademark` + `smart-contract` (the capability-currency cluster).
- *Architectural batch*: `competence-vs-performance-modularity` + `business-agent` + `positive-vs-negative-reputation` (the agoric-machinery cluster).
- *Mixed batch*: `mint-purse-money` + `competence-vs-performance-modularity` + `business-agent` + `marketplace-of-mind` (a broad sampling).

The first two batches together would complete the *concept-page decomposition* the maintainer's directive invited and would leave the library with **~37 concepts** plus a complete cross-citation web across the six-paper Miller cluster.

After the decomposition is complete, the three-lane rotation (chat / papers / comments) can resume with the most-load-bearing concept anchors in place.

## Self-improvement

- The two-concept-page-batch precedents (2026-05-21 and this cycle) are now well-grooved. The pattern: read the recent sections' `[[wiki-link]]` placeholders to identify the highest-citation-count candidates, then draft 3-4 concept pages per cycle. Keyword batches scale roughly as 15-25 aliases per concept page.
- The 4-concept-page batch this cycle was slightly larger than the previous 3-concept-page batch (2026-05-21) but stayed within liaison-context budget. Future batches should stay in the 3-4 range; 5+ would strain the per-cycle context budget.
