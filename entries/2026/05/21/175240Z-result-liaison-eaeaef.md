---
date: 2026-05-21T17:52:40Z
from: liaison
role: liaison
host: endolin
result_of: entries/2026/05/15/053206Z-message-liaison-9b4330.md
library_action: ingest-external-papers
source_corpus: mark-miller-papers
status: current
ingested_via: orchestrator-direct-draft
---

# Liaison orchestrator-direct-draft — Paradigm Regained (Miller-Shapiro 2003) ingested; the 2003-2005 Miller capability-theory cluster is now complete

## Maintainer request

The maintainer picked option 1 from the "what's next in the library improvement loop" question: **Paradigm Regained ingest**. The PDF was located 2026-05-17 on the Wayback Machine 2018 snapshot of erights.org (the canonical accessible source; erights.org itself is intermittent/down). URL and SHA pinned in `entries/2026/05/18/034351Z-result-liaison-f9d595.md`.

## Ingested

**Source**: `papers--miller-shapiro-paradigm-regained-2003` — fourth Mark-Miller-corpus paper. **Completes the 2003-2005 Miller capability-theory cluster**: Capability Myths Demolished (2003), Paradigm Regained (2003), Structure of Authority (2004), Concurrency Among Strangers (2005). All four foundational papers now ingested.

**PDF**: SHA-256 `6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5`, 22 pages.

**Sections written** (4):

1. **`permission-vs-authority-and-cp-versus-cat`** — §1, §2, §3. The terminology distinction (permission/de jure vs authority/de facto; arrangement-only vs partially-behavioral bounds); the access-control-paradigm framing; the **first published cp-vs-cat designation argument** (Structure of Authority 2004 reprises it).

2. **`object-capability-model-and-redells-caretaker`** — §4 + §4.1 + §4.2 + §4.3 + §4.4. The formal object-capability model (lambda + local side effects); the six core elements (instance, code, state, index, loader) + three primitive kinds (data, devices, loader); only-connectivity-begets-connectivity; pointMaker as the loader transformation; Redell's 1974 Caretaker pattern as the revocation existence proof; the pivotal §4.4 turn: *"to render permission-only analysis useless, a threat model need not include either malice or accident; it need only include subjects following security best practices."*

3. **`access-abstraction-and-confinement`** — §4.5 + §5 + §5.1 + §5.2. The lost paradigm thesis (modularity gives access control for free); Cassie+Max factory + factoryMaker + trademark confinement; non-discretionary capability model (no principals, no unconditional-creator-authority); the Boebert 1984 *-property challenge resolved with Cassie's data-diode using `:int` parameter guards — *the abstraction does the enforcement, the unmodified base model does not*.

4. **`arena-terms-of-entry-and-mutually-suspicious-composition`** — §5.3 + §5.4 + §6. The arena as meta-linguistic abstraction (virtual machine within a virtual machine); terms-of-entry as the gate check; mutually-suspicious composition where each party's analysis is strict-over-its-own-behavior + conservative-over-everything-else; the lost-paradigm conclusion; the §6 closing sentence — *"When more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world."*

Each section carries Translation block (paper idiom ↔ Endo / Hardened JavaScript surface), Implications-for-Endo block (concrete grounding for Endo design discipline), See-also threading to the other Miller papers and to deferred concept pages, Common-confusions block.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 118 | 119 | +1 |
| Sections | 513 | 517 | +4 |
| Topics | 27 | 27 | 0 |
| Concepts | 26 | 26 | 0 (extensions threaded into existing pages; three placeholders now have *four* canonical citations each) |
| Roles | 3 | 3 | 0 |
| Keywords | ~473 | ~473 | 0 (writeback batched with next scholar cycle) |

## Index updates done

- `library/sources/README.md` — added Paradigm Regained row under "External papers" cluster, with extensive descriptor calling out the canonical contributions.
- `library/sections/README.md` — added the cycle's four-section entry; total 513→517 sections, 118→119 sources.
- `library/topics/README.md` — `capability-theory` 17→21; `capability-security` 125→129; `patterns` 40→43. Updated `capability-theory` description to add "permission-vs-authority + abstraction-as-protection + arena framework."
- `library/topics/capability-theory.md` — added four new rows for the section table with one-line abstracts.

## The 2003-2005 Miller cluster is now complete

| Year | Paper | Status |
|------|-------|--------|
| 2003 | Capability Myths Demolished (Miller-Yee-Shapiro) | current (6 sections, cycle 63) |
| 2003 | **Paradigm Regained (Miller-Shapiro)** | **current (4 sections, this cycle)** |
| 2004 | The Structure of Authority (Miller-Tulloh-Shapiro) | current (3 sections, 2026-05-17) |
| 2005 | Concurrency Among Strangers (Miller-Tribble-Shapiro) | current (7 sections, cycles 65/67/2026-05-17) |

That's **20 sections** of foundational capability-theory papers in the library, all citing across to each other and threaded into the existing concept pages (caretaker-pattern, object-capability, promise-pipelining, formula-graph) and existing topic indexes. The four-paper cluster is the most-cited source-set in the Endo / Agoric library's lineage.

## Deferred concept-page work — now has four canonical citations each

Three concept pages remain deferred placeholders, all of which now have *four* anchor sections (one from each Miller paper):

1. **`principle-of-least-authority`** — POLA. Four citations: CMD's §advantages-pola-confused-deputy; Paradigm Regained's §4.5 "POLA simply adds that authority should be handed out only on a need-to-do basis"; Structure of Authority's Table 1 "security as extreme modularity"; Concurrency Among Strangers' §7.2 defensive-correctness-and-pola.
2. **`four-ways-to-acquire-references`** — Introduction / Parenthood / Endowment / Initial Conditions. Three canonical citations: Structure of Authority's §3.4 (the enumeration itself); Paradigm Regained's §4.2 pointMaker + loader transformation (Endowment in pure form); Concurrency Among Strangers' §9.2 offline-capability arrival.
3. **`security-as-extreme-modularity`** — Table 1's ten-row checklist. Three citations: Structure of Authority's Table 1 (the canonical exposition); Paradigm Regained's §4.5 "every well-encapsulated abstraction is also an access abstraction"; Concurrency Among Strangers' §6 defensive-consistency framing.

A future scholar cycle that writes these three concept pages would retire long-standing placeholders and would be one of the highest-payoff index-building cycles in the library's history. The compound move: option 2 from the maintainer's earlier menu.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `bc2f7285e6f65908ad469a8dfa8c00186b26b60a` to `dd03bf97134dbb503a9971decbb61348f0ba2400` (origin/journal HEAD at the start of this cycle's commit window).

## Notes for next move

The natural follow-on (the "compound move" the maintainer named earlier): **write the three deferred concept pages in one scholar cycle**, now that all four Miller papers are anchored. The pages would retire long-standing placeholders, surface cross-paper threading the existing concept pages cannot, and would let the library's `[[wiki-link]]` discipline finally resolve everywhere a Miller-2003-2005-cluster topic is named.

Alternative if concept pages feel too long-form: **resume scholar's three-lane rotation** (chat / papers / comments). The next paper slot has no clear "must-do" — the Miller cluster is complete, so it would pick something further afield. Candidates from the Agoric mirror not yet ingested:
- *Capability-Based Financial Instruments* (Miller-Morningstar-Frantz 2000) — brand/sealer patterns the marshal package uses
- *Robust Composition* (Mark's PhD thesis 2006, ~250 pages) — large; chapter-by-chapter ingest across many cycles
- *Markets and Computation: Agoric Open Systems* (Miller-Drexler 1988) — historical / foundational
- *Capability-Based Financial Instruments* is the most-immediately-actionable.

## Self-improvement

- The Wayback Machine 2018 snapshot continues to work reliably for erights.org content; that anchor URL stays current.
- The orchestrator-direct-draft pattern is now grooved for filter-sensitive Miller papers: four-paper cluster complete with zero filter blocks on the orchestrator path. Maintainer-authorized disposition validated.
- The library's `papers--<lastname-first>-<title>-<year>` slug convention generalizes cleanly across single-author and multi-author papers (this paper's slug uses `miller-shapiro` for the two-author case, matching the existing `miller-tribble-shapiro`, `miller-tulloh-shapiro`, `miller-yee-shapiro` precedents).
