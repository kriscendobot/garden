---
id: robust-composition-thesis
aliases: ["Robust Composition", "Miller thesis", "markm-thesis", "Miller 2006 dissertation", "Robust Composition: Towards a Unified Approach to Access Control and Concurrency Control", "the dissertation", "E thesis"]
topics: [capability-theory, capability-security, eventual-send]
---

# robust-composition-thesis

Mark S. Miller's PhD dissertation, *Robust Composition: Towards a
Unified Approach to Access Control and Concurrency Control* (Johns
Hopkins University, May 2006, 229 pages), the consolidated statement of
the E-language research program and the intellectual foundation of the
Endo / Hardened JavaScript / OCapN stack. Structure: chapters 1-2
(introduction, approach and contributions), Part I "The Software
Composition Problem" (3 Fragile Composition, 4 Programs as Plans,
5 Forms of Robustness, 6 A Taste of E, 7 A Taste of Pluribus), Part II
"Access Control" (8 Bounding Access Rights, 9 The Object-Capability
Paradigm, 10 The Loader, 11 Confinement, 12 Summary), Part III
"Concurrency Control" (13 Interleaving Hazards, 14 Two Ways to Postpone
Plans, 15 Protection from Misbehavior, 16 Promise Pipelining, 17 Partial
Failure, 18 The When-Catch Expression, 19 Delivering Messages in
E-ORDER), Part IV "Emergent Robustness" (20-22), Part V "Related Work"
(23-27). It borrows liberally (its own acknowledgement) from the
2000-2005 papers the library already indexes, notably Concurrency Among
Strangers 2005 (Part III's substance) and Capability-Based Financial
Instruments 2000 (Pluribus, VatID, swiss numbers).

**Source and licensing facts** (verified against the PDF title page,
2026-07-07): canonical at `erights.org/talks/thesis/markm-thesis.pdf`
(erights.org is intermittently unreachable; erights.github.io mirrors
the site); reliable mirror at
`papers.agoric.com/assets/pdf/papers/robust-composition.pdf`; archival
record at JHU JScholarship handle `1774.2/873`. The title-page grant
permits **verbatim copies** and **cited excerpts** only; it does not
cover derivative works, so any modernized or translated edition needs
the author's explicit permission.

## Sections that touch this concept

The library has not ingested the thesis itself as a source; the closest
ingested material is the paper it shares Part III with:

| Section | One-line summary |
|---|---|
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) | The vat model that thesis ch 14 presents; same authors, same year, overlapping text. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch.md) | Thesis ch 17-18 material (partial failure, when-catch). |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) | Thesis Part V lineage (ch 23). |
| [erights--elang-index--overview](../sections/erights--elang-index--overview.md) | The E documentation the thesis's code examples assume. |

The `endojs/endo-but-for-bots` design `designs/thesis-translation.md`
(PR #631, 2026-07-07) plans a modernized edition under `docs/thesis/`
(E code to Jessie, Pluribus/CapTP to OCapN, verbatim prose, flagged
substitutions, publication gated on author permission) and carries the
full chapter-by-chapter treatment inventory and the normative E-to-Jessie
and Pluribus-to-OCapN mapping tables.

## See also

- [[e-language]] — the language the thesis presents and the examples are written in.
- [[kernel-e]] — the semantic core behind chapter 6's grammar.
- [[vat-and-compartment]] — chapter 14's vat and its Endo enactment.
- [[promise-pipelining]] — chapter 16's subject, carried into `@endo/eventual-send`.
- [[object-capability]] — chapter 9's paradigm.
- [[granovetter-operator]] — the connectivity-by-introduction primitive of chapter 9.
