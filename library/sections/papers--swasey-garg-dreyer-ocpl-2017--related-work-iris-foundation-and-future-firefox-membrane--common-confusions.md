---
title: Common confusions
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "22-24 (§6 Related Work + §7 Conclusion and Future Work)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane
---

- **"OCPL is just one more formal-verification paper."** It is *the third foundation paper in the capability-theory cluster*. The trilogy (Drossopoulou cycle 85; Taly cycle 91; Swasey-Garg-Dreyer cycle 94) covers Hoare-logic, Datalog-static-analysis, and Iris-separation-logic — three complementary formal frameworks for capability-program verification.
- **"The Devriese 2016 paper is more important."** Devriese is the *closest comparable predecessor*; OCPL extends it with *compositionality* (verifies patterns not just programs) and *machine-checked Coq proofs*. The two papers are complementary; OCPL is the more practical for general OCP-pattern verification.
- **"RustBelt is unrelated to OCPL."** They share the *Iris* foundation. Iris's higher-order ghost state, step-indexed Kripke models, and Coq proof mode were developed for RustBelt and then *reused* by OCPL. The infrastructure investment in Iris pays off across both projects.
- **"The Firefox same-origin-policy membrane is just a marketing claim."** It is a *concrete, ongoing-work-in-2017* direction. The same-origin policy *is* a sophisticated membrane (separating origins, sandboxing iframes, mediating postMessage, etc.); formally verifying it would be substantial. OCPL was *positioning itself* for that future work, not claiming completion.
- **"Drossopoulou's Hoare logic is *inadequate*."** OCPL's §6 critique names a specific gap (*it lacks a rule for dynamic allocation*) and notes the *focus on one example* (escrow exchange). The critique is *technical-precise*, not *general dismissal*. Drossopoulou's Hoare-logic remains the canonical formalization for the *trust-and-risk* dimension; OCPL covers the *compositional-safety* dimension. Both are needed.
- **"OCPL's specs are tedious."** §7 acknowledges this: *additional research is needed to scale such proofs up to realistic languages and improve automation*. The paper's contribution is *foundational*, not *automation-complete*. Practical automation is recognized as future work.
- **"OCPL can't handle the §1 readonly example fully."** It can — the §1 paper proves `{T} !ℓ {x. lowval x} ⇒ {T} readonly ℓ {f. lowval f}` formally. The motivating example is *fully treated* in §2.2. The three OCPs (§§3-5) extend the approach to more complex patterns.
- **"The Iris dependency is bloat."** Iris provides the *expressive power* (higher-order ghost state, step-indexed models, Coq proof mode) that lets OCPL handle higher-order OCPs with concurrency. Building OCPL on a less expressive foundation would require either limiting the language or reinventing Iris's machinery.
