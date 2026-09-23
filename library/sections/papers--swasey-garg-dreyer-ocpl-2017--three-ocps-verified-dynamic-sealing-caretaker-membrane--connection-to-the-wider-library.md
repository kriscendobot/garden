---
title: Connection to the wider library
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "9-22 (§3 Dynamic Sealing + §4 Caretaker + §5 Membrane)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane
---

This section is the **canonical formal-verification of three OCPs at the program-logic level**. Three threads:

1. **The dynamic-sealing-with-representation-invariant pattern** generalizes beyond OCPL. The §3 spec structure (`isseal γ s φ` / `isunseal γ u φ` / `issealed γ v v' φ` / `SealedInv` / `SealedAgree`) is reusable for any sealer-unsealer-style abstraction.

2. **The caretaker-as-temporary-invariant-break pattern** is reusable for any code that wants to make non-atomic updates while exposing access to untrusted clients. *Disable → break-invariant → restore → enable* lets the verified code modify high-integrity state without exposing the intermediate state to untrusted observers.

3. **The membrane-as-value-transformation-lift pattern** is the deepest. *Any* location-to-location transformation can be lifted to a value-to-value transformation by recursive instantiation. The public-membrane variant is the *backward-compatibility-preserving* discipline that lets a library introduce internal invariants without breaking existing clients.
