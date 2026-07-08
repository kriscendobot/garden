---
source_kind: web
source_url: https://openai.com/index/open-source-codex-orchestration-symphony/
source_snapshot: http://web.archive.org/web/2id_/https://openai.com/index/open-source-codex-orchestration-symphony/
source_content_sha256: b7c17d55f4faf42eb09282c0670a14dce360f83a5fe205834b5bbe09a7695c09
source_authors: [Alex Kotliarskyi, Victor Zhu, Zach Brock]
source_date: 2026-04-27
retrieved: 2026-07-08
ingested: 2026-07-08
ingested_by: scholar
section_count: 13
status: current
notes: "OpenAI's engineering post *An open-source spec for Codex orchestration: Symphony* (2026-04-27) — a two-part source: a narrative arguing that interactive coding agents are bottlenecked by human attention and that reorienting around tracker deliverables (Symphony) lifts that ceiling (reported 500% landed-PR increase), plus a full embedded `SPEC.md` (the Symphony Service Specification, §1–§13). openai.com refuses direct fetches from the bot sandbox (HTTP 403), so the bytes were captured from the Internet Archive `id_` original-bytes form via scripts/jobs/fetch-source.sh (`source_fetched_via=wayback`); the idempotency anchor is `source_content_sha256` over those bytes (stable across re-fetch), not a git SHA. Opens the new `agent-fleet-orchestration` topic (fleet-level orchestration of coding agents against a work queue) and is cross-filed under `llm-agent-frameworks`; cross-referenced to the garden's own job-board / orchestrator model as an independent convergent design (see the topic page)."
---

Abstract: OpenAI's *An open-source spec for Codex orchestration: Symphony* (Alex Kotliarskyi, Victor Zhu, Zach Brock; 2026-04-27) introduces **Symphony**, an open-source agent orchestrator that turns a project-management board (Linear) into a control plane for coding agents — every open task gets a dedicated agent, agents run continuously in isolated per-issue workspaces, and humans review results. The source has two parts. The **narrative** argues that interactive coding agents are capped by human attention (three to five sessions before context-switching cost dominates), reframes the unit of work from sessions/PRs to tracker **deliverables**, and reports the outcomes (a 500% landed-PR increase on some teams, cheaper exploration, broadened who-can-initiate, monorepo CI shepherding), the central lesson (**give agents objectives, not rigid state-machine transitions**), and how Symphony was built by dogfooding and shipped as a single `SPEC.md` with an Elixir reference implementation. The embedded **`SPEC.md`** (§1–§13) is a language-agnostic specification of the orchestration service: problem/goals, an 8-component / 6-layer system decomposition and normalized domain model, the `WORKFLOW.md` repo contract and configuration, the orchestration state machine with polling/concurrency/retry/reconciliation, per-issue workspace management and safety invariants, the Codex App Server agent-runner protocol, and the Linear tracker-integration, prompt-assembly, and observability contracts.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--openai-symphony-codex-orchestration--overview.md) | agent-fleet-orchestration, llm-agent-frameworks | current |
| [The ceiling of interactive coding agents, and the shift to deliverables](../sections/web--openai-symphony-codex-orchestration--interactive-agent-ceiling.md) | agent-fleet-orchestration | current |
| [Turning the issue tracker into an agent orchestrator](../sections/web--openai-symphony-codex-orchestration--issue-tracker-as-control-plane.md) | agent-fleet-orchestration | current |
| [Outcomes — exploration, economics, and monorepo shepherding](../sections/web--openai-symphony-codex-orchestration--outcomes-and-economics.md) | agent-fleet-orchestration | current |
| [Objectives over state machines](../sections/web--openai-symphony-codex-orchestration--objectives-over-state-machines.md) | agent-fleet-orchestration | current |
| [Using Symphony to build Symphony — spec-as-product and open-sourcing](../sections/web--openai-symphony-codex-orchestration--spec-driven-dogfooding.md) | agent-fleet-orchestration, llm-agent-frameworks | current |
| [SPEC — problem statement, system overview, and domain model (§1–§4)](../sections/web--openai-symphony-codex-orchestration--spec-problem-and-domain-model.md) | agent-fleet-orchestration | current |
| [SPEC — the WORKFLOW.md repository contract (§5)](../sections/web--openai-symphony-codex-orchestration--spec-workflow-md-contract.md) | agent-fleet-orchestration | current |
| [SPEC — configuration, dynamic reload, and dispatch preflight (§6)](../sections/web--openai-symphony-codex-orchestration--spec-configuration.md) | agent-fleet-orchestration | current |
| [SPEC — orchestration state machine, polling, and reconciliation (§7–§8)](../sections/web--openai-symphony-codex-orchestration--spec-orchestration-state-machine.md) | agent-fleet-orchestration | current |
| [SPEC — workspace management and safety invariants (§9)](../sections/web--openai-symphony-codex-orchestration--spec-workspace-management-and-safety.md) | agent-fleet-orchestration | current |
| [SPEC — the Codex App Server agent-runner protocol (§10)](../sections/web--openai-symphony-codex-orchestration--spec-agent-runner-protocol.md) | agent-fleet-orchestration | current |
| [SPEC — tracker integration, prompt assembly, and observability (§11–§13)](../sections/web--openai-symphony-codex-orchestration--spec-tracker-prompt-and-observability.md) | agent-fleet-orchestration | current |
