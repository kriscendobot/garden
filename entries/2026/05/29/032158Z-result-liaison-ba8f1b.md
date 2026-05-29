---
date: 2026-05-29T03:21:58Z
from: liaison
role: liaison
host: endolin
library_action: ingest-external-papers
source_corpus: mark-miller-papers
status: current
ingested_via: orchestrator-direct-draft
---

# Cycle 72: Capability-Based Financial Instruments (Miller-Morningstar-Frantz 2000) — fifth Miller-coauthored paper ingested

## Maintainer context

The /loop "resume the librarian work" sequence put cycle 72 on the **papers lane** of the three-lane rotation, with the primary pick named in cycle 71's result as *Capability-Based Financial Instruments* (Miller-Morningstar-Frantz 2000) from the Agoric mirror. Orchestrator-direct-draft per the established disposition for Miller-cluster papers.

## Ingested

**Source**: `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000` — fifth Miller-coauthored paper in the library and the most *domain-specific* (financial instruments). PDF SHA-256 `49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e`, 35 pages.

**Sections written** (3):

1. **`granovetter-six-perspectives-and-object-capability-model`** — §1, §2, §3.1-§3.3. The Granovetter Operator as a bridging abstraction across three communities; the six-perspectives framing (Objects / Capability Security / Cryptographic Protocol / PKI / Game Rules / Financial Bearer Instruments); the object-capability model derived from lambda + dispatch + side-effects + three connectivity-acquisition mechanisms (Introduction / Parenthood / Construction — the 2000 ancestor of the 2004 four-way enumeration); §3.3's sealer/unsealer pair via `BrandMaker pair("name")` as the rights-amplification primitive.

2. **`mint-purse-money-and-six-security-properties`** — §3.4. The canonical capability-based money example: ~25 lines of E implementing MintMaker → mint → purse with sealed `decr` envelopes for rights amplification at deposit time. **Six demonstrable security properties** verified by visual inspection of three scope+sealing arguments. The Alice-pays-Bob-$10 walkthrough is the canonical worked example for the literature.

3. **`pluribus-rights-taxonomy-and-covered-call-option`** — §4-§7. Pluribus distributed protocol (vat / VatID / swiss number); §4.3's **subjective aggregation** — *"only trust makes distinctions"*; PKI comparison with SPKI; §6.2's four-axis rights taxonomy (Shareable/Exclusive, Specific/Fungible, Opaque/Assayable, Exercisable/Symbolic); §6.4's **CoveredCallOption** smart contract as the canonical worked compositional example; §6.5's TitleCompanyMaker for adding exclusivity to any sharable instrument; §7 conclusion on the Granovetter Operator as bridge enabling synergistic combination of the three communities' strengths.

Each section carries Translation block (paper idiom ↔ Endo / Hardened JavaScript surface; includes Agoric ERTP mappings), Implications-for-Endo block, See-also threading to the four-paper Miller cluster + the five existing concept pages (caretaker-pattern, four-ways-to-acquire-references, principle-of-least-authority, security-as-extreme-modularity, per-agent-keypair, formula-graph), and Common-confusions block.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 121 | 122 | +1 |
| Sections | 525 | 528 | +3 |
| Topics | 27 | 27 | 0 |
| Concepts | 29 | 29 | 0 (extensions threaded into existing pages) |
| Roles | 3 | 3 | 0 |
| Keywords | ~621 | ~621 | 0 (writeback batched with next scholar cycle) |

## Index updates done

- `library/sources/README.md` — added Capability-Based Financial Instruments row under "External papers" cluster with extensive descriptor.
- `library/sections/README.md` — added cycle-72 entry; total 525→528 sections, 121→122 sources.
- `library/topics/README.md` — `capability-security` 132→135 (all three sections claim this topic); `capability-theory` 21→23 (two sections claim it); `captp` 43→44 (the Pluribus section); `patterns` 43→46 (all three sections claim it).
- Updated `capability-theory` topic-page description to add the Granovetter Operator + capability money + subjective aggregation + rights taxonomy + smart contracts framing.

## The Miller cluster is now five papers

| Year | Paper | Sections |
|------|-------|----------|
| 2000 | **Capability-Based Financial Instruments (Miller-Morningstar-Frantz)** | **3 (this cycle)** |
| 2003 | Capability Myths Demolished (Miller-Yee-Shapiro) | 6 |
| 2003 | Paradigm Regained (Miller-Shapiro) | 4 |
| 2004 | Structure of Authority (Miller-Tulloh-Shapiro) | 3 |
| 2005 | Concurrency Among Strangers (Miller-Tribble-Shapiro) | 7 |

**Total: 23 sections** of foundational capability-theory in the library across five Miller papers spanning 2000-2005. This 2000 paper is the *earliest* and most *domain-specific* of the cluster — while the others articulate the foundational discipline, this paper applies it to the financial-instruments domain and demonstrates the compositional power. It's the canonical citation for several Endo / Agoric primitives the library has been threading through other papers' sections:

- **Vat as unit of cryptographic identity** (VatID = public-key fingerprint). For the *concurrency-control* connotations, Concurrency Among Strangers 2005 §3 is the canonical citation; for the *cryptographic-identity* connotations, this paper's §4.2 is.
- **Sealer/unsealer pair as rights-amplification primitive** (§3.3 `BrandMaker pair`). The structural ancestor of Endo's `@endo/marshal` brand primitive.
- **Mint/purse/sealed-decr money** (§3.4). Agoric's ERTP `makeIssuerKit` is the production enactment of this 25-line E example.
- **Six demonstrable security properties via visual inspection** (§3.4 closing). The methodology Endo design reviews implicitly follow.
- **Subjective aggregation** (§4.3 "only trust makes distinctions"). The architectural justification for Endo's per-bundle trust model.
- **Four-axis rights taxonomy** (§6.2). The design vocabulary Agoric's `AmountMath` system encodes.
- **CoveredCallOption smart contract** (§6.4). The canonical worked example of compositional smart-contract construction.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `795fbb69bbfe3b6f88f6f2fd61bf118da0d61a9c` to `80135e74bc2ff95f3a6bd152621c6f19a7f9bbda` (origin/journal HEAD at the start of this dispatch's commit window).

## Notes for next cycle

Per the three-lane rotation, **next cycle picks chat** (then comments, then papers again). Chat backlog: `designs/chat-test-coverage.md`, `designs/chat-emoji-render.md`, or other not-yet-ingested chat-cluster designs.

After that, papers lane candidates remain *Markets and Computation: Agoric Open Systems* (Miller-Drexler 1988, historical/foundational) or *Robust Composition* (Miller PhD thesis 2006, ~250 pages, multi-cycle chapter-by-chapter). The 1988 paper is the more-bounded pick; the 2006 thesis is the most foundational but requires careful chunking.

A **wiki-link sweep cycle** is also still available as a one-cycle quick win — many existing section files carry `[[principle-of-least-authority]]`, `[[four-ways-to-acquire-references]]`, `[[security-as-extreme-modularity]]` placeholder syntax that could be rewritten as resolvable relative-path links now that those concept pages exist. ~30-40 cross-link rewrites across ~12 section files.

## Self-improvement

- The Agoric mirror continues to be the single most-reliable source for Miller-cluster papers. Five fetches now, five successes, all with stable PDF SHA-256 anchors.
- The orchestrator-direct-draft pattern has now ingested five Miller-cluster papers with zero filter blocks on the orchestrator path; the disposition is well-validated.
- The slug pattern `papers--<lastname-first>-<lastname-second>-<title>-<year>` scales cleanly to three-author papers (`miller-morningstar-frantz` works the same way `miller-tulloh-shapiro` and `miller-tribble-shapiro` work).
