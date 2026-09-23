---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-10T21:38:43Z
---
role: scholar
job: scholar-muse-spark-harness
subject: Ingested Meta Muse Spark 1.1 + Simon Willison's llm-meta-ai harness into the library

Research step of orchestration orch-spark-gardeners (scholar -> designer): ingested
the maintainer-chosen source (Simon Willison's 2026-07-09 post on Muse Spark 1.1) and
its outbound links (Meta's launch blog, the Muse Spark 1.1 Evaluation Report PDF, and
the llm-meta-ai plugin README) into journal/library/, biased toward what the follow-on
"introduce Spark gardeners" design needs.

Sources ingested (4, all source_kind: web; idempotency anchor = source_content_sha256):
- web--willison-muse-spark-1-1 (1 section) — sha f7866e7c; the harness-anchor primary.
- web--simonw-llm-meta-ai (1 section) — sha 18f2be95; canonical README from raw.githubusercontent.com.
- web--meta-muse-spark-1-1-blog (2 sections) — sha 12f0e1c9; vendor capability + API claims.
- web--meta-muse-spark-1-1-eval-report (2 sections) — sha cd25634e; PDF (source_is_pdf=true, pypdf text); safety + behavioral.

Sections written (6): willison overview; llm-meta-ai invocation-and-features; meta blog
capabilities + access-and-api; eval-report safety-and-agentic-robustness + attractor-states.

Concept pages written (3): muse-spark; llm-meta-ai; muse-spark-garden-worker-fit (the
focused "can this back a garden worker?" assessment the deliverable asked for).

Topic pages: new topics/frontier-model-apis.md (hosted frontier model APIs as agent
backends — the hosted-API sibling of local-model-serving); 2 rows added to existing
topics/llm-agent-frameworks.md via insert-sections-table-row.sh.

Indexes updated by hand: sources/README.md (4 web rows), topics/README.md Index (new
frontier-model-apis row), concepts/README.md (3 seed lines), keywords.md (21 lines).
Regenerated as final step: sections/README.md (regenerate-sections-index.sh) and
topics/README.md counts (regenerate-topics-counts.sh) — both landed.

Key findings:
- Muse Spark 1.1 (Meta Superintelligence Labs, 2026-07-09): multimodal agentic reasoning
  model, 1M-token context, parallel tool/function calling + structured output, computer
  use; first Spark with a developer API (OpenAI-compatible Meta Model API, public preview,
  per-team gated, no published pricing). On newer coding/agentic benchmarks (SWE-Bench
  Pro, Terminal-Bench 2.1, OSWorld) it TRAILS the Claude 4.8 Opus tier.
- Harness path: Simon Willison's LLM CLI + `llm-meta-ai` plugin. `llm install llm-meta-ai;
  llm keys set meta-ai; llm -m meta-ai/muse-spark-1.1 "..."`. Supports LLM's tool-calling
  loop (-T/--td) and schemas — so an agentic loop is reachable, not just text completion.
- Gaps for a garden worker: (1) `llm` is a thinner harness than Claude Code (tool loop but
  no built-in file-edit/bash/subagent/permission/hook substrate; model-selection targets
  Claude tiers inside Claude Code, not Spark); (2) preview availability + differing token-
  spend model; (3) safety leans on deployer-side tool allowlists + workspace isolation
  (Meta's own recommendation; injection robustness trails SOTA on file injection) — this
  intersects the garden's Monitoring safety constraint.

Structural lesson routed to liaison (msgs/role/liaison 20260710T213806Z-0a7dd7): a "Spark
gardener" is a harness + model-selection design, not a config swap, and touches the
Monitoring safety constraint. Did not edit any role/skill/top-level doc.

Integrity gate (step 8): library-slug-prefix-check --changed OK; library-link-check
--changed OK (10 cluster links resolve to committed files); topics-counts --check was
STALE pre-regeneration (expected) and reconciled + landed in step 9.

Follow-on jobs: none — the designer child of orch-spark-gardeners is the next step and is
already queued by the orchestration; no scholar remainder to defer.

Self-improvement: nothing this time. The web source-kind ingest path (fetch-source.sh for
hashes incl. PDF text extraction, staging clone, insert-sections-table-row, land-journal-
edit, regenerate-*) worked as documented; no gotcha warranting a role/skill change.
