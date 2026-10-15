---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
priority: high
---
# Codex tier parity: an OpenAI analog for every tier, and Codex-capable panel stages

Garden repo (kriscendobot/garden), land directly on `main2` per the repo convention (no PR). Maintainer direction (liaison session 2026-10-15, kriskowal): "There should be analogous models for every tier in Codex. Please fix that." Motivation: the Anthropic pool `claude-endolin1` is at its weekly high-water mark (258.7M of 271M, reset about 2026-10-17 03:00Z) while `codex-endolin` sits at 68-72%, and a garden-book gauntlet stage (`kriscendobot-garden-book-pr15-gauntlet-panel-5`) cannot be claimed by a cleric because the panel is Anthropic-only.

## Part 1: the model inventory has no OpenAI myrmidon

`scripts/jobs/model-tier-inventory.tsv` lists openai at mentat (`gpt-6-astra`), mentor (`gpt-5.6-sol`), and minion (`gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`, `gpt-5.4-mini`) only. Anthropic has all four tiers (Sonnet and Haiku are myrmidon). So `tier_model_for_provider myrmidon openai` (`scripts/jobs/common.sh`) finds nothing. Fix: give OpenAI a real myrmidon row. Prefer `gpt-5.6-luna` and `gpt-5.4-mini` at myrmidon, leaving `gpt-5.6-terra` and `gpt-5.5` at minion; verify the capability ordering from the models' own documentation and the existing reputation or cost evidence before moving anything, and record the evidence. Moving a model out of minion narrows what a cleric can take for an automatic minion job: confirm minion fallback for openai still resolves to a model. Update `skills/model-selection/SKILL.md` (tier table and prose), `scripts/jobs/model-routing-defaults.tsv` comments if they restate tiers, and any test that pins the inventory (grep `scripts/jobs/test`). Audit all four tiers for every enabled provider and report any other provider with a missing tier, without inventing models.

## Part 2: panel stages must be runnable by a Codex worker

`scripts/jobs/gardening/panel.sh` runs every juror seat, the decider (foreperson), and the appellate pass as `claude -p`, with per-seat tiers `opus|sonnet|haiku` from `seat-model-tiers.tsv` (read by `seat_model_flag`). Make the panel provider-aware:

1. A single runner function (for example `panel_llm`) that dispatches on the running worker's provider: `claude -p` for anthropic, `codex exec` for openai, matching how `scripts/jobs/handlers/cleric-codex.sh` invokes Codex (sandbox flags, `-m`, reasoning effort, prompt on stdin, structured output for the decider; schema-constrained disposition must still be enforced for the foreperson). Seat gates (`seat-gate-*.sh`) that call `claude` must go through the same runner.
2. Tier-to-model mapping per provider: `opus` (inherit the ceiling) maps to the job's resolved model for either provider; `sonnet` maps to the provider's minion-class model; `haiku` maps to its myrmidon model (Part 1). Keep Anthropic behavior byte-identical for Anthropic workers.
3. Make `panel_budget_args` and any usage accounting provider-aware, or explicitly skip them for Codex with the reason logged. Preserve the PR-review output shape (verdict blocks, `<!-- gauntlet-stage-result: panel=... -->` marker) exactly.
4. Confirm a cleric can actually claim and run a `handler-budget-role: panel` gauntlet stage end to end (claim eligibility, `cleric-codex.sh`, the gauntlet driver, the 10800s timeout). Fix whatever blocks it. The stage must still fail closed if neither provider's CLI is available.
5. Do NOT change the quality bar silently: record in the report that seats now run on a different model family when a cleric runs the panel, and add the provider to the panel run record so reputation and later analysis can separate the arms.

## Tests and constraints

Add tests under `scripts/jobs/test/` for: the inventory having all four tiers for anthropic and openai; `tier_model_for_provider` for each; `seat_model_flag`/runner selection for both providers; the foreperson schema enforcement on the Codex path using a stub `codex` on PATH (no real model calls in tests). Run the existing suites that touch these files. Do not post other jobs, do not touch the live board, and do not claim or modify any gauntlet job. Report what changed, test results, the evidence for the OpenAI tier assignments, and any other provider with a tier gap.
