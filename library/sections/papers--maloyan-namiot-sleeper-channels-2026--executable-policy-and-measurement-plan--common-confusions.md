---
title: Common confusions
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "6-7 (§VII I-J — Executable Policy Specification and Integration Sketch; §VIII Discussion; §IX Ethics and Disclosure; §X Conclusion)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--executable-policy-and-measurement-plan
---

- **"The artifact is a production runtime."** No — it is a *reference implementation* of the gate decision function and the static audit. Production deployment would require integrating H1-H10 into the live runtime, providing the hardware-attested companion channel, and the deployment work the paper explicitly defers.
- **"Preregistration replaces empirical evidence."** The paper is careful here: preregistration is a *commitment about how the follow-on study will be run*. It doesn't replace the study; it constrains it.
- **"Canaries are real attack instrumentation."** Canaries in this paper's sense are *synthetic substitutes* for real harms. Real secrets, real mail recipients, real filesystem targets are never the experimental subject. The discipline is structurally analogous to *honeypot* design but for measuring defense efficacy rather than for attracting attackers.
- **"D2 must be deployed to be useful."** The paper's contribution is partly *the formalism itself* — the seven invariants give the garden (or any agent system) a checklist to diagnose how close its existing architecture is to D2-equivalent. The "Implications for the garden" subsection above is one such diagnostic.
