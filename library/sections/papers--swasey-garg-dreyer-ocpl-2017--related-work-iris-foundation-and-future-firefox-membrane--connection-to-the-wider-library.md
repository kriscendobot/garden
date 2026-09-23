---
title: Connection to the wider library
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

This section is the **canonical placement of OCPL in the formal-verification-of-capability-systems literature**. Three threads:

1. **Cycle 85 (Drossopoulou) → Cycle 91 (Taly) → Cycle 94 (OCPL) is the formal-foundations trilogy**. Drossopoulou provides Hoare-logic for *trust-and-risk* in open-world OCPs; Taly provides Datalog points-to + soundness theorem for *API confinement*; OCPL provides Iris separation logic + RobustSafety for *compositional pattern verification*. The three papers together cover the formal-foundations of capability programming.

2. **The Iris-built tooling is reusable**. OCPL is one Iris-instantiation; RustBelt is another. The library can cite the OCPL paper whenever a design needs to *instantiate Iris for a new verification domain*. The Iris infrastructure provides higher-order ghost state, step-indexed Kripke models, and the Coq proof mode.

3. **The Firefox-same-origin-policy future-work direction** signals that OCPL's approach should scale to *much richer settings*. Any future verification of Web-application security (CSP, postMessage isolation, Service Worker boundaries) could draw on OCPL's foundation.
