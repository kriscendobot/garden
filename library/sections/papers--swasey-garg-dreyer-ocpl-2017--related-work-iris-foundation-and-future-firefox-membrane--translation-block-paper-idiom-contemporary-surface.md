---
title: Translation block (paper idiom → contemporary surface)
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

| 2017 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| RustBelt Iris infrastructure | The contemporary verification-tooling foundation — Iris in Coq, used across multiple domains (RustBelt for Rust, OCPL for OCPs, MoSeL for general separation-logic). |
| Devriese et al 2016 Kripke logical relations | The predecessor formal-verification work; OCPL improves via separation-logic + compositionality + Coq mechanization. |
| Drossopoulou Hoare-logic (cycle 85) | The complementary trust-and-risk framework; OCPL handles robust safety; Drossopoulou handles the dynamic-trust dimension. |
| Taly et al 2011 ENCAP (cycle 91) | The complementary static-analysis framework; OCPL is compositional program logic; ENCAP is flow-insensitive Datalog. |
| Van Cutsem-Miller 2013 Trustworthy Proxies | The cycle-82-adjacent paper on language-invariants membranes; OCPL verifies the membrane pattern formally. |
| Firefox same-origin policy membrane (future work) | The contemporary Web-security frontier — formal verification of browser-level security mechanisms. |
| Coq proof mode + Iris-Proof | The contemporary mechanized-verification toolchain. |
