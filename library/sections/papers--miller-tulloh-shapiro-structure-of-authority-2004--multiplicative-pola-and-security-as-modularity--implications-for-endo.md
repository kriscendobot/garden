---
title: Implications for Endo
source: "The Structure of Authority: Why Security Is Not a Separable Concern (MOZ 2004, LNAI 3389)"
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_paper_pages: "15-18 (§3.5 Nested TCBs, §3.6 Subcontracting, §3.7 Legacy, §3.8 Multiplicative Reduction, §4 Conclusions)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity
---

This section is the paper's *practical-discipline* anchor for Endo. The Table 1 mapping is the *concrete checklist* an Endo bundle author can follow to ensure they are practicing capability discipline rather than merely using a capability-shaped library:

1. **Authority-driven design.** When designing a new Endo exo, ask "what authority does this exo *need* to fulfill its role?" before asking "what authority will I give it?". The answer to the first question defines the endowment; the answer to the second should be the strict subset that the first requires.
2. **Omit needless vulnerability.** Where a bundle accepts a broad capability today because "it's easier," check whether the receiving method actually uses the full breadth. If not, narrow the parameter type to the actual usage.
3. **Forbid mutable static state.** SES lockdown makes most realm-globals immutable; bundle authors should resist re-introducing ambient state via singleton modules. Every module's exports should be invokable without depending on prior import-order side effects.
4. **Mean only what you say.** Marshal's pass-style discipline already enforces this at serialization boundaries. Bundle authors should follow it at the API boundaries too: a method's signature is its contract; surprises (hidden side effects, undocumented capability acquisition) are violations of the discipline this paper names.
5. **Nesting depth multiplies, so go deep.** §3.8's multiplicative argument is the architectural justification for Endo's appetite for layers: daemon, bundle, compartment, exo, method. Each is an opportunity for POLA. The compositional argument says shallow systems lose disproportionately.
