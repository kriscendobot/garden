---
title: See also
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

- [[confused-deputy]] — *placeholder*. The A4 scenario is one canonical citation; the implementation sketch (gating at `cron-tool.ts:637`) is the operational answer.
- [[principle-of-least-authority]] — *placeholder*. The D3 Agents-Rule-of-Two construction is POLA at the agent-runtime layer.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity` — the paper's "fractal hollowing of attack surface" argument and this paper's "mediation hooks at every artifact-creating code path" prescription are the same architectural idea at different abstraction levels.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — the partial-failure handler-registration discipline (handlers register *within the sending vat*, outliving the broken connection) is structurally analogous to "attestations bind to action-bytes, outliving the model's emission of those bytes."
