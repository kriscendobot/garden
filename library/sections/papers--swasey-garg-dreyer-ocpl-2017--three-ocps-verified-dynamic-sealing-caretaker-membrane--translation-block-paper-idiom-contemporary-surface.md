---
title: Translation block (paper idiom → contemporary surface)
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

| 2017 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| Dynamic sealing with representation invariant φ | Agoric ERTP's *Issuer*-as-Sealer + *Purse*-as-Unsealer; the brand is the γ; the *amount* type is the φ. |
| Sealer-unsealer for data abstraction | The contemporary `WeakMap`-keyed private state in `@endo/exo`; the WeakMap is the table; the key is the proxy. |
| API caretaker | The Agoric *governance* pattern of revocable capabilities. |
| Location caretaker | The `harden` + reference-counted-revoke pattern. |
| Membrane lifting | The `@endo/marshal` + `@endo/captp` *Remotable* + transparent-proxy discipline. |
| Public membrane = Caja language-invariants membrane | The contemporary `taming-membrane.js` in Google Caja. |
| Backward-compatible invariant via shadow location | The contemporary upgrade discipline: introduce new invariants behind a wrapper without breaking the old API surface. |
