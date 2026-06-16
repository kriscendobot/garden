---
title: Translation block (paper idiom → contemporary surface)
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

| 2017 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| OCPL = Logic for OCPs | The formal verification framework for capability-based programs; complements cycle-85's Drossopoulou Hoare-logic for trust-and-risk. |
| Low-integrity value | A value safe to share with untrusted code; the contemporary `harden`-and-`@endo/pass-style` discipline produces low values via passable-value classification. |
| High vs low locations | The contemporary `WeakMap`-private-state (high) vs `Far()`-exposed-handle (low) discipline at the JavaScript level. |
| RobustSafety theorem | The capability-discipline guarantee: verified code remains safe even when linked with untrusted code (modulo OCPL's HLA simplifications). |
| AdvCtx (adversarial context) | The contemporary *guest compartment* — code that we don't trust to assert correctness about its own behavior. |
| Iris-built OCPL | The contemporary tooling-vision: Iris-as-Coq-mechanized-meta-logic for capability-program verification. |
| Progressive vs non-progressive triples | The *stuck-but-not-failing* discipline; untrusted code may stick verified code but should not violate its invariants. |
