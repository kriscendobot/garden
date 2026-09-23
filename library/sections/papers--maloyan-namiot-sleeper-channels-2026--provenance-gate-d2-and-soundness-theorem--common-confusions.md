---
title: Common confusions
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

- **"Provenance tagging alone is the defense."** No — that's D1, which the paper argues is insufficient (90% ASR against adaptive attacks; 19/20 against OpenClaw's deployed warning). The defense is D2's *combination* of provenance with action-instance digests and out-of-loop attestations.
- **"The seven invariants are independent."** They are *coordinated*: dropping any one of them (e.g., relaxing I-Nonce to allow grant reuse) opens an attack path. The proof sketch uses all seven.
- **"The model can issue its own attestations."** No — I-Channel and I-GrantAuth jointly forbid this. The model has *no emit primitive* into `Σ`. The owner must authorize each unique action-instance digest separately.
- **"D2 prevents all prompt injection."** No — D2 prevents *consequential effects* from untrusted-provenance content. The model can still be coerced into emitting attacker-favored text; what changes is that side-effecting actions on that text deny at the gate.
