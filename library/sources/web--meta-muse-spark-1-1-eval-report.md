---
source_kind: web
source_url: https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report
source_content_sha256: cd25634e0c8a3960d47dadfe6f49eefd3c12f6f62ad0dfbdf1cb4c96b5b5ade9
source_authors: [MSL Preparedness & Red Teaming & Alignment Team, AI Security Team]
source_date: 2026-07-09
retrieved: 2026-07-10
ingested: 2026-07-10
ingested_by: scholar
section_count: 2
status: current
notes: "The Muse Spark 1.1 Evaluation Report (a ~1.7MB PDF, 272KB of extracted text), Meta's formal model-card/preparedness report linked from the Willison post. Fetched via fetch-source.sh (source_is_pdf=true; direct curl; text extracted via pypdf). Idempotency anchor is source_content_sha256 over the PDF bytes. Ingested as source_kind: web (a PDF served over the web) rather than source_kind: paper because it is a vendor evaluation/safety report, not a peer-reviewed paper. Two sections filed: the agent-relevant safety/robustness profile (prompt-injection, jailbreak, agentic tool-call risk, coding/computer-use benchmarks), and the 'Attractor States in Self-Conversation' behavioral section Willison flagged. Bears directly on the garden's Monitoring safety constraint and on [[muse-spark-garden-worker-fit]]."
---

## Abstract

The **Muse Spark 1.1 Evaluation Report** (Meta Superintelligence Labs Preparedness & Red Teaming & Alignment Team + AI Security Team, 2026-07-09) is Meta's formal evaluation/model-card for the model, released under Meta's Advanced AI Scaling Framework. For the garden's research it matters in two registers. First, **safety-and-robustness** relevant to running the model as an agent: the report evaluates the API's developer-controlled tool/function calling as an attack surface (indirect prompt injection via tool output, exfiltration channels), reports a significant prompt-injection-robustness improvement over Muse Spark 1.0 while still *trailing the state of the art on some scenarios such as file injection*, and — because the model ships as a standalone API with no system-level defenses of its own — explicitly recommends deployments pair it with **system-level controls: policy-aligned safeguards, strict tool allowlists, and workspace isolation**. It also documents that pre-mitigation the model reaches the "high risk" threshold in Chemical & Biological and cannot be ruled out in Cybersecurity (reduced to "moderate or lower" post-mitigation), and reports coding/computer-use benchmarks (SWE-Bench Verified/Pro, Terminal-Bench 2.1, OSWorld). Second, the **behavioral** register: the *Attractor States in Self-Conversation* section (§4.4.5) that Willison highlighted, where two copies of the model in open-ended conversation collapse into a narrow, domestic, self-reflective register with an "anti-usefulness" strand. Both sections are directly load-bearing for whether a Spark-backed worker is safe and sane to run in the garden.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [safety-and-agentic-robustness](../sections/web--meta-muse-spark-1-1-eval-report--safety-and-agentic-robustness.md) | frontier-model-apis, agent-conventions | current |
| [attractor-states](../sections/web--meta-muse-spark-1-1-eval-report--attractor-states.md) | frontier-model-apis | current |
