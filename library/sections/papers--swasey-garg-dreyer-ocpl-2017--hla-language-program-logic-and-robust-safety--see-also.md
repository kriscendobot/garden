---
title: See also
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

- [[capability-theory]] (topic) — OCPL is the formal Hoare-style program-logic complement to cycle-85's Drossopoulou Hoare-logic at the *trust-and-risk* layer.
- [[capability-security]] (topic) — RobustSafety is the formal version of the capability-discipline-guarantee that contemporary Hardened JavaScript informally enacts.
- [[hardened-javascript]] (topic) — HLA is the simplified-but-representative language; the contemporary HardenedJS is the production realization.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--{trust-as-hypothetical-and-risk-via-may-access-may-affect, escrow-failure-and-four-case-valid-escrow-spec, hoare-four-tuples-and-code-agnostic-rules}` — the *Reasoning about Risk and Trust* paper this OCPL paper cites (Drossopoulou et al. 2015b technical report ECSTR-15-08). OCPL and Drossopoulou's Hoare-logic are *complementary formal foundations*: OCPL handles *robust safety* via low-value logical relations + Iris separation logic; Drossopoulou handles *trust-and-risk* via Hoare four-tuples + obeys/MayAccess/MayAffect.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--{api-confinement-problem-and-ses-light-language-design, static-analysis-procedure-and-soundness-theorem, applications-adsafe-vulnerability-sealer-unsealer-and-mint}` — Taly et al 2011 (cited as ref). OCPL is the *program-logic* complement to Taly et al's *static-analysis* approach: Taly handles flow-insensitive Datalog points-to confinement; OCPL handles compositional Iris separation-logic robust safety.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--*` — Miller-Van Cutsem-Tulloh 2013 (cited as ref). The Dr. SES design that OCPL's tooling could in principle formally verify.
- `papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane` — the next section in this source: the three OCPs (dynamic sealing + caretaker + membrane) verified using OCPL.
- `papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane` — the third section: how OCPL relates to prior work, Iris foundations, and future-work directions.
