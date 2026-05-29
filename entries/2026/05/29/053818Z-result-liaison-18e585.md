---
date: 2026-05-29T05:38:18Z
from: liaison
role: liaison
host: endolin
library_action: ingest-external-papers
source_corpus: mark-miller-papers
status: current
ingested_via: orchestrator-direct-draft
---

# Cycle 75: Markets and Computation (Miller-Drexler 1988) — sixth Miller-coauthored paper; library now spans 1988-2026

## Maintainer context

The /loop continuing-librarian-work sequence put cycle 75 on the **papers lane** with the primary pick named in cycle 74's result as *Markets and Computation: Agoric Open Systems* (Miller-Drexler 1988) from the Agoric mirror. Orchestrator-direct-draft per the established disposition.

**During the cycle, the maintainer issued a structural directive:**

> "We should soon start decomposing these sources into sections, topics, and concepts."

This result entry handles the cycle-75 close-out *and* documents the directive as the steering signal for cycle 76 and beyond.

## Ingested

**Source**: `papers--miller-drexler-markets-and-computation-1988` — sixth Miller-coauthored paper; the **oldest paper in the library** and the **historical conceptual seed of the Agoric project**. PDF SHA-256 `f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b`, 44 pages.

**Sections written** (3):

1. **`agoric-vision-and-foundations`** — §1-§4. Hayek's spontaneous order; encapsulation as property right; the three-mechanism capability-security definition (1988 ancestor of the 2004 four-way enumeration); competence-vs-performance modularity (object-orientation modularizes competence; markets modularize performance); the §4.4 currency-without-encryption framing (capability + unforgeable identifiers, no cryptography required).

2. **`business-agents-and-resource-strategies`** — §5. Business agents (performance-domain delegates) vs subcontractors (competence-domain); data-type agents (lookup-table example); positive vs negative reputation taxonomy; compilation-as-investment + Pareto-preferred compiler; **the scandal of idle time** as diagnostic.

3. **`agoric-in-the-large-and-absence-of-agoric-systems`** — §6, §7, §8, Appendix I. Charge-per-use software markets; opaque-box hardware encapsulation (anticipating Intel SGX/AMD SEV/Apple Secure Enclave by ~30 years); marketplace-of-mind (intelligence as emergent property of market interactions); the absence-of-agoric-systems argument (a careful due-process due-process-reasoning move); issues × levels matrix (security: encapsulation ↔ skepticism; trust: trust ↔ reputations; reasoning: logic ↔ due-process; etc.).

## The Miller cluster is now SIX papers spanning 18 years

| Year | Paper | Sections |
|------|-------|----------|
| **1988** | **Markets and Computation (Miller-Drexler)** | **3 (this cycle)** |
| 2000 | Capability-Based Financial Instruments (Miller-Morningstar-Frantz) | 3 |
| 2003 | Capability Myths Demolished (Miller-Yee-Shapiro) | 6 |
| 2003 | Paradigm Regained (Miller-Shapiro) | 4 |
| 2004 | Structure of Authority (Miller-Tulloh-Shapiro) | 3 |
| 2005 | Concurrency Among Strangers (Miller-Tribble-Shapiro) | 7 |

**Total: 26 sections of foundational capability-theory across six Miller papers spanning 1988-2005**, plus the 2026 Maloyan-Namiot Sleeper Channels paper extending the lineage to the present. The library now holds the complete arc.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 124 | 125 | +1 |
| Sections | 536 | 539 | +3 |
| Topics | 27 | 27 | 0 |
| Concepts | 29 | 29 | 0 (none new this cycle; see decomposition directive below) |
| Roles | 3 | 3 | 0 |
| Keywords | ~756 | ~756 | 0 (writeback batched with the decomposition cycle) |

## Decomposition directive — the next priority

The maintainer's mid-cycle directive shifts the loop's near-term focus. The library now has substantial accumulated material across the Miller cluster (six papers, 26 sections + cross-cited concept anchors) that **introduces named terms-of-art not yet promoted to concept pages**. The most-cited unanchored candidates, surfaced across recent ingest cycles:

### Strongest candidates for concept-page promotion

1. **`granovetter-operator`** — the three-object reference-passing primitive. Cited in 2000 paper (canonical name); related framing in 1988 (encapsulation-and-communication-of-access) and 2003/2004 (four-ways-to-acquire-references is the structural counterpart). Would anchor ≥5 sections.

2. **`agoric-system`** — the umbrella term and Agoric mission anchor. Cited in 1988 (origin) + 2000 (worked-out money example) + multiple sections. Would anchor ≥6 sections. **Library-defining concept; high priority.**

3. **`competence-vs-performance-modularity`** — the §4.3 1988 architectural distinction. Cited in 1988 + 2004 (security-as-extreme-modularity is the competence-side; performance-side remains under-articulated in the library). High structural value.

4. **`business-agent`** — performance-domain delegate. Cited heavily in 1988 §5; referenced in 2005 vat framing. Anchors agent-conventions topic.

5. **`positive-vs-negative-reputation`** — the §5.3.3 1988 taxonomy. Foundational for trust-system design.

6. **`subjective-aggregation`** — "only trust makes distinctions"; the §4.3 2000 paper's architectural justification for per-bundle Endo trust model. Pivotal claim.

7. **`mint-purse-money`** (or **`capability-based-money`**) — the canonical capability-based money example. Six demonstrable security properties via visual inspection. The Agoric ERTP design ancestor.

8. **`vat-and-compartment`** — long-deferred from cycle 65/67; the cross-pillar translation page. Now has strong anchoring across CMD/CAS/Paradigm-Regained/Capability-Financial.

9. **`brand-and-trademark`** (or extending the existing `caretaker-pattern`): the sealer/unsealer + FactoryStamp + brand-stamp family. Cited heavily.

10. **`smart-contract`** — Szabo's term, capability-composition discipline. Cited in 2000 paper.

11. **`marketplace-of-mind`** — intelligence as emergent property of market interactions; the §6.2 1988 framing. High visionary value.

12. **`opaque-box`** — hardware-encapsulation pattern; 1988 prediction now realized as SGX et al. Useful as historical-anchor concept.

### Recommended cycle 76 plan

A *decomposition cycle* that surveys the accumulated section material, picks the **highest-payoff 4-6 concept pages** to draft (criterion: ≥3 source-section citations each), and writes them. The compound move that mirrors the 2026-05-21 *three-Miller-concept-pages-batch* cycle.

Suggested initial batch:

- `granovetter-operator` (5+ citations available)
- `agoric-system` (umbrella; 6+ citations)
- `subjective-aggregation` (3+ citations + Endo-implications anchor)
- `vat-and-compartment` (long-deferred; 4+ citations across 4 papers)

These four would retire ~12-20 placeholder `[[wiki-link]]` references across existing sections and produce some of the highest-impact concept pages the library has ever drafted. Per the cycle-71 keyword-batch discipline, ~80-100 keyword aliases would land alongside them.

After that batch, additional cycles can pick from the remaining 8 candidates above as bandwidth permits. The three-lane rotation (chat / papers / comments) can resume after the decomposition catches up.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `b4cedc0600297e624024a39b5a79af08e2e62767` to `70a3b1dcd8a5f71adbb950dd4e5187ad3733c022`.

## Notes for next cycle

**Cycle 76 picks the decomposition directive** as primary task. The three-lane rotation pauses until the most-load-bearing unanchored concepts are promoted to pages. Expected cycle output: 4-6 new concept pages, ~80-100 new keyword aliases, ~12-20 retired `[[wiki-link]]` placeholders across existing sections.

If the decomposition cycle requires liaison-direct-draft (likely, given the cross-paper threading involved), the per-section commit discipline still applies: one commit per concept page, one indexing commit, one result entry. ~7 commits typical.

After the initial batch, future cycles can revisit the remaining 8 candidates (positive-vs-negative-reputation, business-agent, competence-vs-performance-modularity, mint-purse-money, brand-and-trademark, smart-contract, marketplace-of-mind, opaque-box) at the rate of 2-3 per dedicated decomposition cycle.

## Self-improvement

- The library now has six Miller-coauthored papers spanning 1988-2005 plus the 2026 Maloyan-Namiot paper. Capability-theory at 25 sections is the largest concept-anchor in the library.
- The maintainer's "we should soon start decomposing" directive validates the architectural framing the library has been implicitly following: sources → sections → concepts → keywords are layered with each layer indexing the next. The decomposition cycle will be the *explicit* enactment of the layered discipline that has been *implicit* in the cycle-66+ post-section concept threading.
- The Agoric-mirror anchor remains robust: six fetches now, six successes. The 1988 paper's PDF SHA-256 is pinned.
