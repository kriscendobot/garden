---
id: workflow-md-policy
aliases: ["WORKFLOW.md", "workflow.md", "workflow contract", "repo-owned workflow policy", "workflow front matter", "prompt template contract", "policy layer"]
topics: [agent-fleet-orchestration]
status: current
---

# workflow-md-policy

**`WORKFLOW.md`** is Symphony's repository-owned, version-controlled policy file — the single artifact that carries both the per-issue **prompt template** and the runtime **configuration**, so a team versions its agent policy alongside its code. It is Markdown with optional YAML front matter: the front matter parses into typed config under six top-level keys (`tracker`, `polling`, `workspace`, `hooks`, `agent`, `codex`, with unknown keys ignored for forward compatibility), and the trimmed Markdown body is the prompt template, rendered with a strict Liquid-compatible engine (unknown variables or filters fail rendering) over an `issue` object and an `attempt` integer. Workflow file read / YAML errors block new dispatches until fixed; template render errors fail only the affected run attempt. The design intent is that `WORKFLOW.md` be self-contained enough to describe and run different workflows without out-of-band service config, and that changes reload live without a restart. It is the "policy layer" of Symphony's six-layer decomposition, and the direct analogue of the garden's `roles/*/AGENT.md` + `skills/*/SKILL.md` read just-in-time by a worker.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [SPEC §5 WORKFLOW.md contract](../sections/web--openai-symphony-codex-orchestration--spec-workflow-md-contract.md) | The repo-owned WORKFLOW.md format, six-key front-matter schema, strict prompt rendering, and error taxonomy. |
| [SPEC §6 configuration](../sections/web--openai-symphony-codex-orchestration--spec-configuration.md) | How WORKFLOW.md front matter becomes effective config, dynamic reload, and dispatch preflight. |
| [spec-driven dogfooding](../sections/web--openai-symphony-codex-orchestration--spec-driven-dogfooding.md) | WORKFLOW.md captures the previously-implicit human development workflow so agents follow it. |

## See also

- [[symphony-orchestrator]] — the service that loads and enforces `WORKFLOW.md`.
- [[ticket-as-control-plane]] — the model the workflow policy operationalizes.
