---
title: Connection to the wider library
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

This section is the **canonical formal-foundation paper for *robust safety in object-capability programs***. Three threads:

1. **The *low-integrity-value* concept** generalizes beyond OCPL. Any system that wants to characterize *which values can be safely shared with untrusted code* should use the low-value logical-relation device. The library can cite this section whenever a design needs the *extensional-safety-by-logical-relation* approach.

2. **The progressive/non-progressive triple distinction** is reusable. When verifying code that may legitimately get stuck due to untrusted-code-induced dynamic type errors (vs. code that must always make progress), the two-flavored triple discipline lets each piece be verified at its appropriate strength.

3. **The high/low location separation** is the *verification-time* analog to the *operational-runtime* distinction between *private state* and *capability-shareable state*. Generalizes to any separation-logic verification of capability-based code.
