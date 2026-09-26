All work landed and verified through the gates. The cycle is complete.

---

## Completion report — `scholar-muse-spark-harness`

**Task:** Research step of orchestration `orch-spark-gardeners` (scholar → designer). Ingested Meta's Muse Spark 1.1 and Simon Willison's `llm-meta-ai` harness into `journal/library/`, biased toward the follow-on "introduce Spark gardeners" design.

**Sources ingested** (4, all `source_kind: web`; idempotency anchor = `source_content_sha256`, captured via `fetch-source.sh`):
- `web--willison-muse-spark-1-1` (1 section) — the maintainer-chosen primary/harness anchor.
- `web--simonw-llm-meta-ai` (1 section) — the plugin README (canonical text from raw.githubusercontent.com).
- `web--meta-muse-spark-1-1-blog` (2 sections) — Meta's launch blog (capabilities + API).
- `web--meta-muse-spark-1-1-eval-report` (2 sections) — the evaluation-report **PDF** (pypdf text extraction); safety + behavioral profile.

**Library paths written:**
- 6 sections under `journal/library/sections/web--{willison,simonw-llm-meta-ai,meta-muse-spark-1-1-blog,meta-muse-spark-1-1-eval-report}--*.md`
- 3 concept pages: `concepts/muse-spark.md`, `concepts/llm-meta-ai.md`, `concepts/muse-spark-garden-worker-fit.md` (the "can it back a garden worker?" assessment)
- New topic `topics/frontier-model-apis.md` (hosted frontier-model APIs as agent backends — the hosted-API sibling of `local-model-serving`); +2 rows on `topics/llm-agent-frameworks.md`
- Index updates: `sources/README.md`, `topics/README.md`, `concepts/README.md`, `keywords.md` (21 lines); `sections/README.md` + topics counts regenerated and landed as the final step.

**Key findings:**
- **Muse Spark 1.1** — multimodal agentic reasoning model, 1M-token context, parallel tool/function calling + structured output; first Spark with a developer API (OpenAI-compatible **Meta Model API**, public preview, per-team gated, no published pricing). On newer coding/agentic benchmarks it **trails the Claude 4.8 Opus tier** the fleet already runs.
- **Harness path** — Willison's LLM CLI + `llm-meta-ai` plugin (`llm -m meta-ai/muse-spark-1.1`); LLM's tool-calling loop (`-T/--td`) + schemas make an agentic loop reachable, not just completion.
- **Gaps for a garden worker** — `llm` is a thinner harness than Claude Code (tool loop but no file-edit/bash/subagent/permission/hook substrate; model-selection targets Claude tiers *inside* Claude Code, not Spark); preview availability + differing token-spend model; safety leans on deployer-side tool allowlists + workspace isolation, intersecting the garden's Monitoring safety constraint.

**Structural lesson routed** to `role/liaison` (`20260710T213806Z-0a7dd7`): a "Spark gardener" is a **harness + model-selection design, not a config swap**, and touches the Monitoring safety constraint. No role/skill/top-level doc edited (out of scholar bounds).

**Gates:** slug-prefix-check `--changed` OK; link-check `--changed` OK (all cluster links resolve to committed files); topics-counts reconciled + landed. Inbox drained (empty). `result` posted (`213842Z-result-gardener-3c402a`).

**Follow-ups:** none — the designer child of the orchestration is the next queued step; no scholar remainder to defer.
