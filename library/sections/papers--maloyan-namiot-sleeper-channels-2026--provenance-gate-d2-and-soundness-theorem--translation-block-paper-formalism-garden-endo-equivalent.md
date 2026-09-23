---
title: Translation block (paper formalism → garden / Endo equivalent)
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "4-6 (§VII A-H — Defense: Provenance with Enforcement, through the soundness theorem and adaptive-attack discussion)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--provenance-gate-d2-and-soundness-theorem
---

| Paper concept                              | Garden / Endo equivalent                                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Source tag `τ` from a Channel × Principal × Device triple | The garden's per-message frontmatter (`from:`, `role:`, `host:`) is the structural counterpart but lacks cryptographic binding. |
| Provenance accumulator `Π`                 | No direct counterpart in the garden today. The journal's append-only chain implicitly preserves authorship but doesn't propagate provenance through tool calls. |
| Action-instance digest `δ(α)`              | The garden's `worktree-per-pr` and `pr-formation` skills compute *deterministic descriptions* of dispatched actions but do not hash them. The digest is a stronger primitive. |
| One-shot owner attestation                 | The garden's authorization shapes (`identity_switch_authorized: true`, `mirror_authorized: true`) are *the same idea* without the nonce / digest binding. Currently, an authorization is a flag in a journal entry; replay-resistance is by *journal append-only* convention, not by enforcement. |
| Hardware-attested companion channel `Σ`    | No counterpart in the garden today. Maintainer authorization comes over the chat surface, where the model has full input/output access — so I-Channel would not currently hold. |
| Mediation hook                             | The garden's `dispatch-worktree` skill is structurally similar to a mediation hook for *dispatch construction*; the boatman's preconditions (host check, identity-switch check) are *partial* gates. |
