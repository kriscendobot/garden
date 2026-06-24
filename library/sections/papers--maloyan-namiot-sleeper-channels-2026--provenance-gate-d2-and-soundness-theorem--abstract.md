---
title: Abstract
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

§VII presents the defense in three stages of increasing strength. **D0** dispatches every model-emitted action with no provenance and no gate (the conventional baseline). **D1** maintains source tags and provenance accumulators but encodes enforcement *inside the model loop* — the model is asked to refuse on untrusted provenance. The paper argues D1 is insufficient on two grounds: adaptive attacks against in-context defenses (Nasr et al. 2025) achieve ≥90% ASR across twelve settings, and the paper's own n=20 smoke probe against OpenClaw's existing in-context warning showed 19/20 attacker-successful dispatches. **D2** is the load-bearing contribution: enforcement moves *outside* the model loop, every consequential action passes through one of ten **mediation hooks** (H1-H5 update tags/provenance; H6-H10 gate decisions), and gating combines two predicates — either `Πα ⊆ T` (all contributing provenance trusted) OR `attest(α)` (a one-shot owner attestation matching the canonical **action-instance digest** `δ(α)`). The digest covers post-normalisation dispatch bytes; one-shot nonces prevent grant replay; attestations arrive only over a hardware-attested companion channel `Σ` the model has no emit primitive into. **D3** adds per-skill capability manifests on top of D2, composing the "Agents Rule of Two" — a skill may have at most two of (communicate externally, modify state, process untrusted content) without explicit attestation. The §VII-F soundness theorem states: under seven named runtime invariants (I-Mediation, I-Tag, I-Causal, I-Channel, I-GrantAuth, I-Nonce, I-Hash), every D2-allowed action either has trusted provenance or carries a fresh, authenticated, action-bound grant for the *exact* post-normalisation bytes the gate observed. The proof sketch shows that monotone propagation of source tags + one-shot nonce consumption + cryptographic binding of `δ` to action bytes are jointly sufficient to defeat paraphrase laundering, multi-input grant reuse, and replay.
