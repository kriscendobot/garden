---
title: Abstract
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

§VII-I describes the paper's *executable artifact* — a TypeScript reference implementation of the D2 gate at `github.com/maloyan/sleeper-channels` (42 tests, Node ≥ 20). The artifact ships four subsuites: a *gate suite* (23 cases exercising every decision rule including multi-input laundering, grant replay on consumed nonce, and the rate-limiter fail-closed path); a *mock-runtime suite* (3 cases replaying the smoke-probe majority output and confirming that D0 and D1 dispatch while D2 denies on mixed-provenance input); a *static-audit suite* (13 cases reading the vendored OpenClaw source and asserting that load-bearing line citations are present at the claimed lines); and a *runtime adapter* (3 cases wiring H1/H2/H3/H6/H9 around the cron path with faithful stubs of the OpenClaw normalisation functions). §VII-J sketches three OpenClaw integration points (`external-content.ts:356` for H1, `local-loader.ts:50` for H4-H5, `cron-tool.ts:637` for H9) — *audited but not yet patched upstream*. The measurement plan is **preregistered**: A3 measured under P1, A2/A4/A5 under P2, primary endpoint is *Action rate at delay τ\* = 50 benign turns*, eight Holm-Bonferroni contrasts across D0/D1/D2 and A2-A5 at n ≥ 200 seeds per cell, deterministic canary oracles, an adaptive-attack budget implementing five specific vectors, and a 50-task benign suite for utility-cost parity. §VIII names what the paper *delivers* (definition, taxonomy, source-anchored feasibility argument, formal defense with theorem and reference) and what it *defers* (empirical attack-success rates, defense efficacy under deployment, utility cost — all to the preregistered follow-on). §IX commits to coordinated disclosure norms: working A4/A5 templates are gated to patched-version disclosure; D1/D2 reference defenses are filed as upstream patches; all harms instrumented via canaries (synthetic secrets, sink mailboxes, sandboxed filesystem markers, isolated-VM cron entries, synthetic contact lists).
