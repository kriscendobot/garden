---
title: Implications for Endo
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "7-14 (§4 The Object-Capability Paradigm, including §4.1 Model, §4.2 A Taste of E, §4.3 Redell's Caretaker, §4.4 Analysis and Blind Spots)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker
---

The §4 model + the §4.3 Caretaker pattern are *foundational* to Endo's whole posture, and §4.4's analysis-and-blind-spots argument is the most-cited library citation for why Endo design reviews cannot rely on arrangement-only reasoning:

1. **The reference graph is the access graph.** Endo's formula graph is its enactment of *the reference graph as the access graph*. Cycle 47's daemon-persistence ingest names this: persistence by traversal from petname roots. The §4 framing is the structural justification.
2. **Loader-style explicit endowment.** Endo's bundle-compartment endowment object IS `loader.load(code, [...index ⇒ reference...])`. Every bundle's compartment is born under this discipline; "all linking happens only by virtue of these associations."
3. **Caretaker pattern is a library concept.** The existing `caretaker-pattern` concept page (anchored from Capability Myths Demolished's irrevocability-myth section and Concurrency Among Strangers' POLA section) gains a *third* canonical citation here, with the §4.3 worked code as the canonical implementation.
4. **Design reviews must reason about authority, not just permission.** The §4.4 *to render permission-only analysis useless...* claim is the deepest reason design reviews of Endo bundles need to be authority-reviews, not just structural-permission audits. A reviewer who only checks "what does this exo's endowment hold?" misses every Caretaker-style attenuation; they need to ask "what authority does this exo *ultimately mediate*?"
5. **JavaScript almost falls outside the model.** §4's parenthetical that "Smalltalk and Java fall outside the object-capability model because their mutable static variables enable objects to interact outside the reference graph" applies equally to plain JavaScript. *SES is the lockdown discipline that puts JavaScript inside the object-capability model* — by freezing intrinsics and forbidding mutable global state.
