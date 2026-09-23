---
date: 2026-05-21T18:06:59Z
from: liaison
role: liaison
host: endolin
library_action: write-concept-pages
status: current
ingested_via: orchestrator-direct-draft
---

# Liaison: three deferred Miller-cluster concept pages written; the library's POLA / four-ways / security-as-modularity placeholders are retired

## Maintainer request

The maintainer continued from the prior "what's next" turn: write the three deferred concept pages now that all four Miller papers (Capability Myths Demolished, Paradigm Regained, Structure of Authority, Concurrency Among Strangers) are anchored. The compound move identified in `entries/2026/05/21/175240Z-result-liaison-eaeaef.md`.

## Written

**Three concept pages** under `library/concepts/`:

1. **`principle-of-least-authority.md`** — the canonical POLA page. **Four citations across the Miller 2003-2005 cluster**: CMD §advantages-pola-confused-deputy (the two practical advantages); Paradigm Regained §2 + §4.5 (the permission-vs-authority distinction; "POLA simply adds that authority should be handed out only on a need-to-do basis"); SoA Table 1 + multiplicative-modularity (the strict-reading-of-information-hiding framing); CAS §7.2 (defensive correctness + POLA as access-control discipline). Includes the Saltzer-Schroeder least-permission-vs-least-authority ambiguity and the convention that Endo / Agoric library reads it as least *authority*. Six Common-confusion entries that disambiguate from least-privilege, ACL discipline, kernel-only enforcement, and permission-only verification.

2. **`four-ways-to-acquire-references.md`** — the canonical exhaustive enumeration. **Three citations**: SoA §3.4 (the enumeration itself: Introduction / Parenthood / Endowment / Initial Conditions); Paradigm Regained §4 + §4.2 (only-connectivity-begets-connectivity as the structural rule; the loader transformation as the pure Endowment mechanism); CAS §9.2 (offline capabilities as the Initial Conditions mechanism in distributed form). Plus a CMD citation linking the four-ways enumeration to the seven-properties characterization. Six Common-confusion entries pinning the exhaustiveness claim, the Endowment-vs-Parenthood distinction, the "GC reachability is just optimization" misread, and the "four ways are sufficient for POLA" overclaim.

3. **`security-as-extreme-modularity.md`** — Table 1 + the underlying thesis. **Six citations**: SoA multiplicative-pola-and-security-as-modularity (the canonical Table 1 exposition); Paradigm Regained §4.5 (the 2003 thesis that Table 1 operationalizes in 2004); SoA fractal-structure-of-authority (Simon + Hayek as structural justification); SoA excess-authority-and-designation (the 2004 cp-vs-cat reprise framed via information-hiding); CAS defensive-correctness-and-pola (the concurrency-side application); CAS history-and-related-work (the historical demonstration via the five-precursor E lineage). Six Common-confusion entries disambiguating from "OO with security stickers", "trivial security analysis", and the "Forbid mutable static state is impossible in JS" misread.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 119 | 119 | 0 |
| Sections | 517 | 517 | 0 |
| Topics | 27 | 27 | 0 |
| Concepts | 26 | **29** | **+3** |
| Roles | 3 | 3 | 0 |
| Keywords | ~473 | **~535** | **+~62** |

## Index updates done

- `library/concepts/README.md` — added three new rows for the new concept pages, each with a one-line abstract noting the citation sources and the 2026-05-21 date.
- `library/keywords.md` — added ~62 keyword rows mapping aliases to the three new concept-ids:
  - POLA / "principle of least authority" / "principle of least privilege" / "least privilege" / "least authority" / "need to do" / "authority-driven design" / etc. → `principle-of-least-authority`.
  - "four ways" / "Introduction" / "Parenthood" / "Endowment" / "Initial Conditions" / "only connectivity begets connectivity" / "ways B can come to know about C" → `four-ways-to-acquire-references`.
  - "security as extreme modularity" / "Table 1" / "the lost paradigm" / "abstraction as protection" / "nested POLA" / "multiplicative attack-surface reduction" / "spawning tree" → `security-as-extreme-modularity`.
  - Plus ~25 surrounding paper-specific terms (Cassie + Max, FactoryStamp, controlled subject / uncontrolled subject, Boebert 1984, *-property, data diode, diodeWriter / diodeReader, arena, terms of entry, meta-linguistic abstraction, mutually suspicious composition, failures of conservatism, pointMaker, loader.load, DVH, Karger-Herbert, Chander-Dean-Mitchell) routed to the appropriate Paradigm Regained section files.

## What changes for library users

Three structural improvements compound:

1. **`[[wiki-link]]` placeholders resolve.** The library has been carrying `[[principle-of-least-authority]]`, `[[four-ways-to-acquire-references]]`, and `[[security-as-extreme-modularity]]` placeholder links in many section files (cycles 63, 65, 67, 71 + the orchestrator-direct-drafts and today's Paradigm Regained ingest). All three placeholders now resolve to real concept pages. The conceptual links the library was making become navigable.

2. **`library-lookup` becomes much more effective for POLA-related queries.** A future searcher arriving with "POLA" or "Saltzer-Schroeder" or "Table 1" or "four ways" in mind now finds the concept page directly via `keywords.md`. Cycle 63 established the indexing-on-the-fly discipline; this batch is one of the largest *retroactive* applications of it.

3. **Cross-paper threading is explicit.** Each new concept page has a Sections-table threading 3-6 section files from across the four Miller papers. A future designer or builder reading any one Miller paper's section finds the others via the concept-page back-link. The library is becoming the kind of densely-cross-referenced structure the conventions doc imagined from the beginning.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `dd03bf97134dbb503a9971decbb61348f0ba2400` to `9beb361504c0b59a4bfafc9be23fb47dde7201b7` (origin/journal HEAD at the start of this dispatch's commit window).

## Notes for next move

The library improvement loop's next natural slots:

1. **Resume scholar's three-lane rotation** (chat / papers / comments). Chat backlog: `designs/chat-view-edit-commands.md`, `designs/chat-test-coverage.md`. Comments backlog: `packages/ses/src/lockdown.js`, `packages/pass-style/src/passStyleOf.js`. Papers slot: with the Miller 2003-2005 cluster complete, candidate papers from the Agoric mirror are *Capability-Based Financial Instruments* (Miller-Morningstar-Frantz 2000, brand/sealer patterns), *Markets and Computation: Agoric Open Systems* (Miller-Drexler 1988, historical/foundational), or *Robust Composition* (Mark's PhD thesis 2006, ~250 pages, multi-cycle chapter-by-chapter).

2. **Sweep `[[wiki-link]]` placeholders across existing sections to resolve them now that the concept pages exist.** This is mechanical but high-payoff: a future searcher arriving at any cycle 63-71 paper section finds the working concept-page link directly rather than the placeholder marker. ~30-40 cross-link rewrites across ~10 section files. Could be a scholar cycle or a quick liaison sweep.

3. **Address an open question from the garden-as-primer-and-journal design** — the design proposal currently on the `garden-as-primer-and-journal-design` branch in `endojs/endo-but-for-bots`. Q7 (what shipped `@endo/agent-harness` shape) and Q8 (where the journal exo lives) are the most concrete. Returns to design work rather than library work.

## Self-improvement

- The concept-page-batch-after-paper-cluster-complete pattern is a useful one: when a cluster of related papers all land, write the concept pages that depended on multiple of them in one follow-on cycle. The cross-paper threading is much easier to compose when all the source sections are in hand.
- The keywords-batch-with-concept-pages discipline pays off in retroactive search: ~62 new keyword rows added in one pass means any future searcher arriving with a Miller-cluster term in mind finds the right concept page on the first lookup. This is the most-leverage form of the `library-lookup` *Indexing on the fly* discipline.
