---
date: 2026-05-17T22:47:20Z
from: liaison
role: liaison
host: endolin
result_of: entries/2026/05/15/053206Z-message-liaison-9b4330.md
library_action: ingest-external-papers
source_corpus: mark-miller-papers
status: current
ingested_via: orchestrator-direct-draft
---

# Liaison orchestrator-direct-draft — The Structure of Authority (Miller, Tulloh, Shapiro 2004) ingested as third Miller-corpus paper

## Context

Following the maintainer's earlier-same-day authorization ("I'll draft filter-sensitive Miller papers directly") and the maintainer's clarifying context ("Mark Miller has been my mentor for fifteen years and these papers are public knowledge"), the liaison began drafting the next Miller paper directly. The originally-targeted paper was *Paradigm Regained: Abstraction Mechanisms for Access Control* (Miller-Shapiro 2003, ASIAN), but probing the Agoric mirror showed no matching PDF. Falling back to the next-strongest candidate from cycle 67's notes: **The Structure of Authority: Why Security Is Not a Separable Concern** (Miller-Tulloh-Shapiro 2004, MOZ 2004 / Springer LNAI 3389). 19 pages, available at `papers.agoric.com`, PDF SHA-256 `f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d`.

## Ingested

**Source**: `papers--miller-tulloh-shapiro-structure-of-authority-2004` — three argument-cluster sections covering the paper's full content (the paper's eight subsections collapse to three substantive arguments).

**Sections written**:

1. **`excess-authority-and-designation`** — §1, §1.1, §2, §2.1 — the gateway-to-abuse framing; cp-vs-cat as the canonical designation lesson; object-capability model as the alignment of designation with authority; information-hiding (need-to-know) and POLA (need-to-do) as two readings of the same modular discipline.
2. **`fractal-structure-of-authority`** — §2.2, §3 intro, §3.4 — Simon's hierarchy + Hayek's local-knowledge argument; four major levels of composition; **§3.4's exhaustive four-ways-to-acquire-references**: Introduction, Parenthood, Endowment, Initial Conditions. Only connectivity begets connectivity; the reference graph IS the access graph.
3. **`multiplicative-pola-and-security-as-modularity`** — §3.5-§3.8, §4 — nested TCBs follow the spawning tree; subcontracting forms dynamic authority networks; legacy boundaries managed incrementally; **multiplicative attack-surface reduction** across nested layers. Table 1 — "security as extreme modularity" — maps ten software-engineering practices to their strict capability-discipline readings.

Each section includes a Translation block (paper-idiom → Endo / Hardened JavaScript surface), an Implications-for-Endo block, See-also threading to existing concept pages and related paper sections, and Common-confusions blocks where the paper's framing is easy to misread.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 116 | 117 | +1 |
| Sections | 507 | 510 | +3 |
| Topics | 27 | 27 | 0 |
| Concepts | 26 | 26 | 0 (extensions threaded into existing pages; new POLA concept page deferred) |
| Roles | 3 | 3 | 0 |
| Keywords | ~473 | ~473 | 0 (writeback batched with next scholar cycle) |

## Index updates done

- `library/sources/papers--miller-tulloh-shapiro-structure-of-authority-2004.md` — new source file with `source_kind: paper` schema, three-section table, plus an extended "For the Endo / Agoric library" framing explaining the paper's role in the corpus.
- `library/sources/README.md` — added The Structure of Authority row under "External papers" cluster.
- `library/sections/README.md` — added the cycle's three-section entry; total bumped from 507 to 510.
- `library/topics/README.md` — `capability-theory` 13→16; `capability-security` 120→122 (excess-authority and multiplicative sections both claim that topic); `patterns` 38→40 (fractal-structure and multiplicative sections both touch patterns).
- `library/topics/capability-theory.md` — added three new rows for the section table with one-line abstracts.

## Deferred concept-page work

Three concept pages would naturally pull material from this paper but are deferred to scholar's next cycle for budgetary reasons:

1. **`principle-of-least-authority`** — long-promised concept page (placeholder existing since cycle 63). This paper's Table 1 and §1.1 cp/cat argument are the canonical exposition; combined with `defensive-correctness-and-pola` from Concurrency Among Strangers and `advantages-pola-confused-deputy` from Capability Myths Demolished, scholar has three strong source-sections to anchor a concept page.
2. **`four-ways-to-acquire-references`** — §3.4's Introduction/Parenthood/Endowment/Initial-Conditions enumeration deserves a concept page. The pattern recurs throughout Endo (formula-graph evolution, marshal pass-style discipline, bundle endowment) and naming it explicitly would make it more grep-able for future designers.
3. **`security-as-extreme-modularity`** — Table 1 is iconic enough to deserve its own page. The ten rows would be useful as a checklist when reviewing new bundle designs for capability discipline.

Filing for scholar's next cycle. None block library use.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `f69affd9fc3425311a2c3bde43d321945c19409f` to `4eb8a7f4aafd4dcf50ef86ae3d1a9ef330096812` (origin/journal HEAD at the start of this orchestrator-direct-draft window).

## Notes for next scholar cycle

The three-lane rotation continues. Scholar's existing schedule (per cycle 70's "no-op" replaced by this direct-draft) puts the *next* cycle on **chat lane** — strongest pick remains `designs/chat-view-edit-commands.md` per cycle 67's notes. The cycle after that returns to comments lane (`packages/ses/src/lockdown.js` or `packages/pass-style/src/passStyleOf.js` are strong picks). The cycle after *that* is papers lane again — recommended pick: **Capability-Based Financial Instruments** (Miller-Morningstar-Frantz 2000) from the Agoric mirror, OR continue with another short Miller-coauthored paper (`reasoning-about-risk-and-trust-in-an-open-world`, `acls-dont` — though `acls-dont` is Tyler Close, not Miller).

If the next paper cycle is also liaison-direct-draft (likely), the rotation cost is bounded: ~one paper-section batch's worth of liaison context per paper-cycle. The cost is acceptable in exchange for completing the Miller corpus.

## Self-improvement filed for gardener

The orchestrator-direct-draft pattern has now been validated three times (cycle 67 `history-and-related-work`, cycle 67-followup `partial-failure-and-when-catch`, and this cycle's three sections of Structure of Authority). The pattern is robust enough to formalize:

1. **Add `ingested_via: orchestrator-direct-draft` as a recognized provenance value** in scholar's AGENT.md, alongside the default scholar-dispatched path.
2. **Document when to use it**: any Miller-coauthored capability-theory paper that involves mutual-suspicion / adversarial-protocol framing in its body, especially papers from the 2003-2005 cluster (Capability Myths Demolished was the exception that proved the rule by going through fine; *Concurrency Among Strangers* and *Structure of Authority* both required the direct-draft path).
3. **Bound the cost**: one section batch (3-5 sections) per paper-cycle, drafted in liaison context. Source file + indexes + result entry are negligible additions.

Filed for the gardener to land in a future garden-meta cycle.
