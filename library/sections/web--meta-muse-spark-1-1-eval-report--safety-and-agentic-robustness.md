---
title: "Muse Spark 1.1 safety and agentic robustness (prompt injection, tool-call attack surface, coding/computer-use benchmarks)"
source_kind: web
source_url: https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report
source_content_sha256: cd25634e0c8a3960d47dadfe6f49eefd3c12f6f62ad0dfbdf1cb4c96b5b5ade9
source_authors: [MSL Preparedness & Red Teaming & Alignment Team, AI Security Team]
source_date: 2026-07-09
ingested: 2026-07-10
ingested_by: scholar
topics: [frontier-model-apis, agent-conventions]
status: current
---

## Abstract

The parts of Meta's Muse Spark 1.1 Evaluation Report that bear on running the model as an agent: the API's developer-controlled tool/function calling as an attack surface, the prompt-injection robustness profile (improved over 1.0 but still trailing SOTA on some scenarios such as file injection), Meta's explicit recommendation that deployments add **system-level controls — policy-aligned safeguards, strict tool allowlists, and workspace isolation** because the standalone API ships with none, the pre-mitigation "high risk" catastrophic-domain findings, and the agentic coding/computer-use benchmarks (SWE-Bench, Terminal-Bench, OSWorld). This is the section that intersects the garden's own Monitoring safety constraint.

## Tool calling as an attack surface

The report is explicit that "the Muse Spark 1.1 API exposes developer-controlled tool and function calling, so agentic" settings are evaluated directly, "with particular attention to direct misuse and prompt injection attacks in agentic settings." Red-team scenarios include indirect prompt injection carried in **tool output (MCP results)**, with exfiltration attempted over channels such as GitHub issue comments. Because tool calling is developer-controlled, these settings are "directly" exercised in the evaluation rather than hypothesized.

## Prompt injection and jailbreak robustness

On **indirect prompt injection**, evaluated on public and private benchmarks with both internal automated attacks and external red teamers, Meta observe "a significant improvement in robustness against prompt injection for Muse Spark 1.1 compared to Muse Spark 1.0," while "trailing the state-of-the-art performance on some specific scenarios such as file injection." On jailbreaks, the model shows a lower false-refusal rate on benign sets than peers such as GPT-5.5 (greater helpfulness) "while maintaining comparatively strong robustness."

The crucial deployment caveat, verbatim in spirit: "Since Muse Spark 1.1 is released as a standalone API, its application deployments will differ in design and safeguards. The evaluation in this section isolates model-level behavior with no system-level defenses, so any resistance comes from the model itself. We recommend that deployments pair Muse Spark 1.1 with system-level controls, including application policy-aligned safeguards, **strict tool allowlists, and workspace isolation**."

## Catastrophic-risk thresholds

Under Meta's Advanced AI Scaling Framework, *pre-mitigation* the model reaches the "high risk" threshold in **Chemical & Biological** and cannot be ruled out in **Cybersecurity**; **Loss of Control** stays "moderate or lower." Post-mitigation, residual risk is reduced to "moderate or lower" across domains, which is why Meta released it. (Relevant to the garden only as context on what a hosted frontier model carries; the garden does not exercise these domains.)

## Coding and computer-use benchmarks

- **Coding:** Muse Spark 1.1 resolved, at least once, **24 of 42** unique tasks on SWE-Bench Verified; on newer, more robust benchmarks (Terminal-Bench 2.1, SWE-Bench Pro) it "trails Claude 4.8 Opus and/or GPT." A SAVE-Bench Multi-Turn (with Scale AI) adapts SWE-Bench tasks to multi-turn.
- **Computer use:** evaluated on **OSWorld-Verified** and **OSWorld 2.0** (108 long-horizon real-world workflows on a full Ubuntu desktop VM), with Gemini 3.1 Pro and Claude Opus 4.8 among the compared systems.
- **Tool-calling breadth:** an agentic tool-use benchmark exercises ~600 tools across many applications exposed via MCP servers (GitHub, Notion, filesystem), and a Scale AI set of 36 real MCP servers / 220 tools.

The takeaway for the garden: Muse Spark 1.1 is a capable agentic/coding model but, on the current benchmarks, **trails the Claude Opus tier the fleet already runs** — so it is not an obvious capability upgrade, and its safety posture explicitly leans on system-level controls the *deployer* must supply. See [[muse-spark-garden-worker-fit]].

Source: [Muse Spark 1.1 Evaluation Report](https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report) by Meta Superintelligence Labs, published 2026-07-09; PDF content SHA-256 `cd25634e0c8a3960d47dadfe6f49eefd3c12f6f62ad0dfbdf1cb4c96b5b5ade9`.
