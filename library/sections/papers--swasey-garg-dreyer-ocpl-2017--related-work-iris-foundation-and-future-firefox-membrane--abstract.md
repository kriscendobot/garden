---
title: Abstract
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

§6 *Related Work* surveys the predecessors and contemporaries of OCPL in four categories. **Robust safety**: the concept arose in cryptographic-protocol verification — Gordon-Jeffrey 2001 used typing for correspondence-properties of crypto protocols modeled in spi-calculus; Bengtson et al. 2011 generalized robust safety to integrity properties for RCF (the F7 refinement-type-checker's calculus). OCPL's contributions: (a) *applying robust safety to OCPs, a completely different domain*, and (b) *encoding low-integrity values directly in modern separation logics using a simple logical relation*. **Object capabilities specifications**: very preliminary prior work — Morris 1973 proposed informal reasoning principles; *Drossopoulou et al. 2015a* (the cycle-85 PLAS'15 *Swapsies on the Internet* paper) and *Drossopoulou et al. 2015b* (the cycle-85 ECSTR-15-08 technical report) proposed `obeys` / `MayAccess` / `MayAffect` predicates and Hoare-style reasoning *but only for one example* (escrow exchange); *Devriese et al. 2016* is the closest comparable work — Kripke logical relations for higher-order state, but *no way to compositionally specify what an OCP does, and only considered very simple capability patterns*. **Other OCP verification**: Sumii-Pierce 2004 bisimulation for dynamic-sealing contextual equivalence; Bengtson et al. 2011 ideal-cryptographic dynamic-sealing in RCF; *Van Cutsem and Miller 2013* (the cycle-82-adjacent *Trustworthy Proxies* paper) language-invariants membrane; Spiessens-Van Roy 2005, Spiessens 2007, Murray 2010 model-and-refinement-checking; *Taly et al. 2011* (the cycle-91 paper, cited as ref) — ENCAP's Datalog analysis. **Ownership types**: Clarke et al 1998 owners-as-dominators; Banerjee-Naumann state-based ownership; Patrignani et al 2011 ownership-types-for-join-calculus. The §6 framing positions OCPL as *the first compositional* OCP-specification logic with *machine-checked proofs in Coq*. §7 *Conclusion* names two future directions: (a) **Firefox's same-origin policy membrane** (Mozilla 2016; Barth 2011) — a much more sophisticated automatic membrane than the §5 public membrane; OCPL would need to scale to richer settings to verify it; (b) **better Coq automation** — Iris proof mode enables relatively high-level Coq proofs *but such manual proofs are nonetheless often tedious and routine; additional research is needed to scale such proofs up to realistic languages and improve automation*. §Acknowledgments names the funding: *Microsoft Research PhD Scholarship + European Research Council Consolidator Grant for the RustBelt project (grant agreement no. 683289)* — a notable RustBelt linkage. The Coq formalization is *online* at *http://plv.mpi-sws.org/iris/* (the OCPL 2017 tag in the Iris project).
