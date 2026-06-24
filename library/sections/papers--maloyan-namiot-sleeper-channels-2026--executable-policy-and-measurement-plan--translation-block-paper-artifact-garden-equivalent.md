---
title: Translation block (paper artifact → garden equivalent)
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

| Paper artifact                              | Garden / Endo equivalent                                                                                       |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `d2-gate/` TypeScript pure-function gate    | No counterpart in the garden today. Closest analog is the boatman's *host preconditions* check, which is procedural (a bash check) rather than a pure decision function. |
| Static-audit suite                          | The garden has no static audit of its own source. The closest existing discipline is `journal/inventory/*.md` audits run periodically by the inventory role. |
| Runtime adapter wiring H1/H2/H3/H6/H9       | The garden's `dispatch-worktree` is the structural analog for H1-equivalent (the source of a dispatch is named at prepare-time). No counterpart for H6/H9. |
| Preregistration of measurement design       | The garden has no precedent for preregistration. The `roadmap-projection` and `journalism` skills are the closest discipline — capturing intent before action. |
| Canary instrumentation for harms            | The garden's monitor daemons read real events from real surfaces; there is no canary substrate today. If the garden ever needed to test its own defenses, canaries would be the right primitive. |
