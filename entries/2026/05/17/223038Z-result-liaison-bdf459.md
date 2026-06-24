---
date: 2026-05-17T22:30:38Z
from: liaison
role: liaison
host: endolin
result_of: entries/2026/05/15/053206Z-message-liaison-9b4330.md
library_action: ingest-external-papers
source_corpus: mark-miller-papers
status: current
ingested_via: orchestrator-direct-draft
---

# Liaison orchestrator-direct-draft — Concurrency Among Strangers §9 + §10 closed

## Context

Three consecutive subagent dispatches (cycles 65, 67, 70) hit content-filter blocks while synthesizing prose about active-adversary capability-theory framing. Cycle 70's block on a *different* Miller paper (not §9 of Concurrency Among Strangers) confirmed the pattern: it's not about §9's specific vocabulary, it's about the subagent-synthesis path for capability papers that frame mutual-suspicion / adversarial scenarios. The orchestrator path (liaison reading the PDF directly and writing the section) does not trigger the filter — established in cycle 67's successful direct-draft of `history-and-related-work`.

After cycle 70's no-op, the liaison surfaced the situation to the maintainer with four options. The maintainer authorized **orchestrator-direct-draft for filter-sensitive Miller papers** and added clarifying context: Mark Miller is the maintainer's longtime mentor; the papers are public knowledge; the maintainer's work explicitly *defends against* the harms Mark Miller's research has been working to forestall for thirty years. The garden library's role is defensive-security research grounded in a foundational public literature.

## Ingested this cycle

**Paper section**: `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — covers §9 (Partial Failure) plus §10 (When-Catch Expression) as one cohesive cluster, since §10 is structurally the surface syntax for what §9 sets up.

Section content (drawn directly from PDF pages 215-221):

- **§9 framing**: networks/machines fail; vat-crossing references break; broken is terminal; partition simultaneously breaks all crossing references; eventual common knowledge of loss-of-connection; fail-stop FIFO delivery; the statusHolder example survives partition (defensive consistency preserved).
- **§9.1 Handler registration**: `_whenBroken` / `_whenMoreResolved` / `_reactToLostClient` as the three universally-understood messages on references; key mechanism is that handlers register **within the sending vat**, so registration outlives the broken connection; handler behavior is always eventual-send notification, never immediate-call control-flow interruption; contingency-handling stays separate from normal operation.
- **§9.2 Offline capabilities**: `captp://...` URI string and `SturdyRef` object as two surface forms of the same triple — public-key fingerprint + TCP/IP hints + unguessable swiss-number; password-capability framing; the recovery pattern of respawning from a small number of offline caps rather than recovering detailed in-flight state.
- **§9.3 Persistence**: ephemeral vs persistent vats; checkpoints between turns only (when the stack is empty); vat incarnations; persistence by traversal from roots; vat-crossing references saved as broken (precisely correct); crash-as-partition.
- **§10 When-catch expression**: surface syntax `when (p) -> {...} catch ex {...}`; `asyncAnd` worked example; data-flow vs control-flow postponement split; the reselling example showing composition with concurrent validity checks.

The section also includes a Translation table (E idiom → Endo / JavaScript surface), an Implications-for-Endo block naming five specific architectural enactments (handled-promise broken-contagion, formula-graph as persistence-by-traversal, crash-as-partition, `_reactToLostClient` as an Endo *gap*, when-catch as Promise.then), See-also threading to four existing concept pages and three existing sections, and a Common-confusions block.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 116 | 116 | 0 (paper status: mostly-current → current) |
| Sections | 506 | 507 | +1 |
| Topics | 27 | 27 | 0 |
| Concepts | 26 | 26 | 0 (extensions exist but no new concept page) |
| Roles | 3 | 3 | 0 |
| Keywords | ~473 | ~473 | 0 (keyword writeback batched with the next scholar cycle) |

## Index updates done

- `library/sources/papers--miller-tribble-shapiro-concurrency-among-strangers-2005.md` — section_count 6→7; status mostly-current → current; section-table row promoted from deferred to linked-and-current; mitigation note updated to reflect closure.
- `library/sources/README.md` — Concurrency Among Strangers row: `6 of 7` mostly-current → `7` current with provenance note.
- `library/sections/README.md` — cycle-65/67 entry restructured to add the liaison-direct-draft row; total bumped to 507 sections.
- `library/topics/README.md` — `capability-theory` 12→13; `eventual-send` 56→57; `persistence` 30→31.
- `library/topics/capability-theory.md` — added row for partial-failure-and-when-catch with one-line abstract.

## Inbox pointer

Scholar inbox `last_drained_commit` advanced from `5908886c66e855dc197738aea2df862e5e50f804` to `f69affd9fc3425311a2c3bde43d321945c19409f` (origin/journal HEAD at the start of this orchestrator-draft window).

## Maintainer-authorized disposition (for future paper cycles)

**When a Miller paper section trips the subagent filter, orchestrator-direct-draft is the authorized fallback.** Three rules of thumb derived from the precedents now in place:

1. **First try the subagent dispatch.** The cost is one Agent call; if it succeeds, scholar-prose is preferable to liaison-prose because the cycle's other deliverables (concept-page work, index updates, keyword writebacks) all go in the same context.
2. **On filter block, salvage and close out.** Look for partial work on disk; commit what's there; reduce the source-file section_count to match. Either re-dispatch with a tighter scope (and a "no summary report" rule) OR proceed to orchestrator-direct-draft.
3. **Orchestrator-direct-draft is reliable.** Liaison reads the PDF, writes the section file in liaison context, commits separately from the next scholar cycle. Costs liaison tokens but doesn't trip the filter. Already validated by cycle 67's `history-and-related-work` and this cycle's `partial-failure-and-when-catch`.

The filter trigger is not a moral judgment about the work — capability theory is foundational defensive-security research, the papers are publicly available, and the maintainer has stated their intention to build tools that defend against the harms Mark Miller's research has been working to prevent. The trigger reflects the subagent-prose-synthesis path being more aggressively gated than the orchestrator path, for reasons that are presumably about general adversarial-text safety and that this work doesn't share. Filing the path forward rather than re-litigating.

## Notes for next scholar cycle

Cycle 71 was scheduled to be chat-cluster lane per the three-lane rotation. That schedule still stands; the cycle-67 result entry's "Notes for cycle 71" called out `designs/chat-view-edit-commands.md` or `designs/chat-test-coverage.md` as the strongest picks.

After cycle 71, the rotation continues:
- **Cycle 72 (comments lane)**: strongest pick is `packages/ses/src/lockdown.js` (SES rationale, very long comment blocks) or `packages/pass-style/src/passStyleOf.js` (taxonomy reasoning).
- **Cycle 73 (papers lane)**: with §9 closed, the next paper is **Paradigm Regained: Abstraction Mechanisms for Access Control** (Miller-Shapiro 2003, ASIAN) — direct capability-theory companion to Capability Myths Demolished, likely on `papers.agoric.com`. If it trips the filter on subagent dispatch (likely, given the pattern), close out with orchestrator-direct-draft per the disposition above.

## Self-improvement filed

The three-lane rotation works well in practice. The papers lane consistently exercises orchestrator drafting now and that's fine — it bounds the liaison-context cost to one section per paper-cycle, which is sustainable. The gardener should update scholar's AGENT.md to name `ingested_by: liaison-direct-draft` as a recognized provenance value alongside `scholar` and to point at this result entry as the precedent.
