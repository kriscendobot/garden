---
date: 2026-05-18T03:43:51Z
from: liaison
role: liaison
host: endolin
library_action: ingest-external-papers
ingested_via: orchestrator-direct-draft
status: current
---

# Liaison: arXiv:2605.13471 Sleeper Channels ingested; Paradigm Regained located on Wayback Machine

## Maintainer request

The maintainer asked for two things:

1. **Expand the search for Paradigm Regained** (Miller-Shapiro 2003, ASIAN). Cycle 70's initial probe of `papers.agoric.com` returned 404; the maintainer authorized expanded search.
2. **Add `https://arxiv.org/pdf/2605.13471`** — a specific arxiv URL identified by short ID only.

## Paradigm Regained — found, queued for next paper-cycle

**Located** at the Wayback Machine 2018 snapshot of `erights.org/talks/asian03/`:

- URL: `https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf`
- PDF SHA-256: `6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5`
- Pages: 22
- Note: The PDF's internal Title field reads "Paradigm Lost: Abstraction Mechanisms for Access Control" — Miller-Shapiro's earlier working title. The published version cited as [Miller03] in *Structure of Authority* is "Paradigm Regained: Abstraction mechanisms for access control" (ASIAN 2003, Springer LNCS 2896). Same paper, title evolved between the talks page and the proceedings.

**Why not ingested this turn**: 22 pages is twice the length of the cycle-71 *Structure of Authority* ingest. Doing both arxiv (8 pages, explicit ask) and Paradigm Regained (22 pages, found-now) in a single liaison turn would overrun context. Queueing Paradigm Regained for the next paper-cycle slot is the bounded move.

**Recommended next paper-cycle action**: liaison orchestrator-direct-draft of Paradigm Regained, likely 4-5 sections. Source URL and SHA above are pinned for idempotency.

## arxiv:2605.13471 — ingested as 3 sections

**Paper**: *Sleeper Channels and Provenance Gates: Persistent Prompt Injection in Always-on Autonomous AI Agents* (Maloyan, Namiot; arXiv:2605.13471 [cs.CR]; 2026-05-13; 8 pages).

**PDF SHA-256**: `c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5`

**Slug**: `papers--maloyan-namiot-sleeper-channels-2026` — **first non-Miller external paper** in the library. The `papers--<lastname-first>-<title>-<year>` slug convention generalizes cleanly.

**Sections written**:

1. **`sleeper-channel-taxonomy-and-running-scenario`** — §I-§VI — defines the OS-live agent class; the persistence × firing-separation 5×5 taxonomy; the A4 cron-via-confused-deputy walk-through at file/line granularity in OpenClaw.
2. **`provenance-gate-d2-and-soundness-theorem`** — §VII A-H — formal D2 defense: source tags `τ`, accumulated provenance `Π`, action-instance digest `δ(α)`, the ten mediation hooks H1-H10, the gate decision rule, and the seven-invariant (I-Mediation, I-Tag, I-Causal, I-Channel, I-GrantAuth, I-Nonce, I-Hash) soundness theorem. Plus the D3 capability-manifest extension and the five-vector adaptive-attack discussion.
3. **`executable-policy-and-measurement-plan`** — §VII I-J + §VIII + §IX + §X — the TypeScript reference at `github.com/maloyan/sleeper-channels` (42 tests across 4 subsuites); three OpenClaw integration points audited but not patched; preregistered measurement plan; coordinated-disclosure ethics.

Each section carries:

- Translation block (paper formalism ↔ garden / Endo equivalent).
- Implications-for-the-garden block (the garden's *steward* posture is structurally an OS-live agent; the seven invariants apply as a *diagnostic checklist* for current dispatch / monitoring discipline; the garden is roughly at D1 today and the gap to D2 is the absence of a hardware-attested companion channel).
- See-also threading to existing paper sections (confused-deputy companion in Capability Myths Demolished; multiplicative-modularity companion in Structure of Authority; partial-failure companion in Concurrency Among Strangers).
- Common-confusions block.

## Why this paper matters for the garden

The Implications blocks across the three sections converge on one architectural point: **the garden's existing posture is approximately D1 in the paper's hierarchy**. The garden has source tags (journal frontmatter), implicit provenance propagation (journal authorship chains), and in-context enforcement (the maintainer reading and exercising judgment). What the garden lacks for D2:

- **Hardware-attested companion channel**: maintainer authorization comes over the same chat surface the model emits to. I-Channel does not currently hold.
- **Action-instance digests + one-shot nonces**: `identity_switch_authorized: true` is plaintext in a journal entry, reusable without consumption.
- **Mediation hooks H6-H10**: the garden has H1-equivalent (dispatch-prepare names the source) but no analog of H6/H9 (per-action gate before dispatch).

**This is not a prescription to move the garden toward D2.** The garden's threat model is narrower than the paper's (maintainer is in-the-loop, not absent-trampolined). The paper is useful as a *diagnostic vocabulary* — it names where the garden's procedural discipline relies on conventions, and lets the maintainer reason about which conventions would benefit from cryptographic enforcement if the autonomy posture were to widen.

## Library state after this cycle

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 117 | 118 | +1 |
| Sections | 510 | 513 | +3 |
| Topics | 27 | 27 | 0 |
| Concepts | 26 | 26 | 0 (placeholders for `confused-deputy` and `principle-of-least-authority` now have three canonical citations each; concept-page writing deferred to scholar) |
| Roles | 3 | 3 | 0 |
| Keywords | ~473 | ~473 | 0 |

## Index updates done

- `library/sources/README.md` — added Sleeper Channels row under "External papers".
- `library/sections/README.md` — added the cycle entry; total 510→513 sections, 117→118 sources.
- `library/topics/README.md` — `capability-security` 122→125; `capability-theory` 16→17 (the soundness-theorem section claims this topic); `agent-conventions` 46→49.
- (No `library/topics/capability-theory.md` per-section table update this turn — the three sections live primarily in `capability-security` and `agent-conventions`; only the soundness-theorem section dual-claims `capability-theory`.)

## Inbox pointer

`last_drained_commit` advanced from `4eb8a7f4aafd4dcf50ef86ae3d1a9ef330096812` to `bc2f7285e6f65908ad469a8dfa8c00186b26b60a` (origin/journal HEAD at the start of this dispatch's commit window).

## Notes for next paper-cycle slot

**Strongest pick**: Paradigm Regained (Miller-Shapiro 2003) per the discovery above. URL and SHA pinned. The paper is the direct companion to *Structure of Authority* — the two papers share the "Abstraction Mechanisms for Access Control" tagline and are often cited together. Filing Paradigm Regained as the very next paper-cycle pick is the natural close-out of the Miller-2003-2004 cluster.

Alternative if Paradigm Regained ingest is deferred further: any other paper from the Agoric mirror not yet ingested — `capability-based-financial-instruments` (Miller-Morningstar-Frantz 2000), `the-digital-path-smart-contracts-and-the-third-world` (Miller-Stiegler), or `markets-and-computation-agoric-open-systems` (Miller-Drexler 1988, historical/foundational).

## Self-improvement

The slug convention `papers--<lastname-first>-<title>-<year>` worked cleanly for a non-Miller paper. The `papers--maloyan-namiot-sleeper-channels-2026` slug is grep-able and unambiguous. The library's `source_kind: paper` schema generalizes beyond the Miller corpus without modification.
