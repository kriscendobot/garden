---
title: Implications for the garden
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

The seven invariants are useful as a *diagnostic checklist* for the garden's existing dispatch-and-monitoring posture. Walking the invariants against the garden as-is:

1. **I-Mediation**: *Partially holds.* The journal entries are append-only and authorship-bound, so journal writes traverse a clear path. Dispatch construction via `dispatch-prepare.sh` is similarly structured. *But* monitor daemons read event bodies directly into agent context without a corresponding tag write — they don't enact H1.
2. **I-Tag**: *Holds at the journal layer.* Journal frontmatter `from:`/`role:`/`host:` is set at write time by the authoring dispatch; the model cannot rewrite a frontmatter field through normal channels. Cryptographic binding is absent (the bot identity authenticates to GitHub but the journal entry's `from:` is plain text).
3. **I-Causal**: *Approximately holds, by convention.* A dispatch's causal set is the journal entries it reads + the role/skill files it loads + the source files it inspects. The dispatch worktree triple makes this enumerable. The garden doesn't formally compute `causal(α)`, but the architecture is compatible with the concept.
4. **I-Channel**: *Does not hold.* Maintainer authorization comes over the same chat surface the model emits to. There is no companion device the model cannot reach. This is the *largest gap* between the garden and the paper's D2 baseline.
5. **I-GrantAuth**: *Does not hold.* `identity_switch_authorized: true` is plaintext in a journal entry; the model could in principle author such a flag if it had write access to the journal. The garden's mitigation is procedural (only maintainer-authored journal entries should bear this flag), not cryptographic.
6. **I-Nonce**: *Approximately holds, by convention.* The journal's append-only nature means a given entry is referenced by its path, which is unique. But there's no consumption ledger — a journal authorization is *reusable* unless the maintainer adds a `consumed: true` note.
7. **I-Hash**: *Holds trivially.* The garden uses git commits as content-addressed identifiers; SHA-1 / SHA-256 are baked into the substrate.

The diagnostic suggests the garden is roughly at **D1** in the paper's hierarchy: tags exist (frontmatter), propagation is implicit (journal authorship), and enforcement is *in-context* (the maintainer reading the journal and exercising judgment). D2 would require: a hardware-attested authorization channel, action-instance digests with one-shot nonces, and runtime gate hooks before dispatch.

**Whether the garden should move toward D2 is a separate question.** The garden's threat model is narrower than the paper's (the maintainer is in-the-loop, not an absent owner being trampolined). The paper's framing is useful for *naming* where the garden's procedural discipline relies on conventions, and for thinking about which conventions would benefit from cryptographic enforcement if the garden's autonomy posture were to widen.
