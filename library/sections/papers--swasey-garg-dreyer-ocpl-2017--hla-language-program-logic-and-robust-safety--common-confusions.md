---
title: Common confusions
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017 (Long Version with full appendices) — Max Planck Institute for Software Systems (MPI-SWS), Saarland Informatics Campus"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "1-9 (§1 Introduction + §2 Robust Safety and OCPL through §2.3 Metatheory)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--hla-language-program-logic-and-robust-safety
---

- **"OCPL is just another Hoare logic."** It is *Hoare logic plus the high/low location classification + the lift Ψ logical relation + the RobustSafety meta-theorem*. The combination is what makes it suitable for *compositional* OCP verification.
- **"Low values are simple values."** No — *functional* values can be low. A closure that takes a low argument and produces a low result is itself low (per the LiftRec rule). The logical relation handles higher-order types.
- **"The high/low distinction is in the language."** No — it is *only in the logic*. The operational semantics treats all locations identically; the high/low classification is a verification-time annotation that lets the proof track *which locations the verifier trusts versus which the verifier shares*.
- **"The goodness-bit is a runtime overhead."** It is a *model-state* construct; in practice, OCPL is a verification-time technology. The goodness bit doesn't need to exist in production code; it only exists in the logical specification to let OCPL distinguish *failed assertions* from *stuck execution*.
- **"Iris is just separation logic."** It is *concurrent* separation logic with higher-order ghost state + step-indexed Kripke models + Iris-proof-mode tactics in Coq. OCPL inherits this rich machinery; without it, the lift Ψ logical relation would not be well-founded.
- **"RobustSafety = type safety."** No. Type safety guarantees *the verified code does not produce ill-typed behavior*. Robust safety guarantees *the verified code's internal invariants are preserved when linked with arbitrary adversarial code* — a *much stronger* claim that requires the OCPL framework to support.
- **"The adversarial context cannot have assertions."** The §RobustSafety framing's `AdvCtx` defines *contexts containing neither locations nor assertions*. The exclusion of assertions reflects the model: assertions are the *verified code's* invariants; untrusted code, by definition, doesn't have its own invariants to check. If untrusted code had assertions and they failed, *whose fault would it be*? The framing avoids the question by forbidding assertions in adversarial contexts.
