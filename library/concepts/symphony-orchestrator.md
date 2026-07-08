---
id: symphony-orchestrator
aliases: ["Symphony", "Symphony orchestrator", "Codex orchestration", "Symphony SPEC.md", "Symphony Service Specification", "open-source spec for Codex orchestration", "always-on agent orchestrator"]
topics: [agent-fleet-orchestration, llm-agent-frameworks]
status: current
---

# symphony-orchestrator

**Symphony** is OpenAI's open-source agent orchestrator (Kotliarskyi/Zhu/Brock, 2026-04-27) that turns a project-management board like **Linear** into a control plane for coding agents: every open task gets a dedicated agent running continuously in an isolated per-issue workspace, and humans review results instead of supervising sessions. It is distributed as a single **`SPEC.md`** (a language-agnostic specification, not a maintained product) with an Elixir reference implementation, and the authors invite readers to point their own coding agent at the spec to generate a tailored version. Symphony is a scheduler/runner and tracker *reader*: ticket writes are performed by the coding agent, and a successful run may end at a handoff state (e.g. `Human Review`) rather than `Done`. It grew out of a "no human-written code" repo experiment and reportedly produced a 500% landed-PR increase on some teams. The garden's own job-board / gardener / orchestrator model is the closest in-corpus analogue (an independent convergent design).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview](../sections/web--openai-symphony-codex-orchestration--overview.md) | Symphony turns a Linear board into a control plane for coding agents; ships as a SPEC.md; 500% landed-PR increase. |
| [spec-driven dogfooding](../sections/web--openai-symphony-codex-orchestration--spec-driven-dogfooding.md) | Symphony is technically just a SPEC.md; built by dogfooding; Elixir reference impl; open-sourced as a reference, not a product. |
| [SPEC §1–§4 problem and domain model](../sections/web--openai-symphony-codex-orchestration--spec-problem-and-domain-model.md) | The scheduler/runner+tracker-reader boundary; 8 components, 6 layers, normalized domain model. |

## See also

- [[ticket-as-control-plane]] — the core idea Symphony is built on.
- [[codex-app-server]] — the headless Codex mode Symphony drives.
- [[workflow-md-policy]] — Symphony's repo-owned prompt+config contract.
- [[objectives-over-state-machine]] — Symphony's central design lesson.
