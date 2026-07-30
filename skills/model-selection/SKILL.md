---
created: 2026-06-10
updated: 2026-07-29
author: gardener
---

# Skill: model-selection

The fleet dispatch vocabulary, in descending thoughtfulness, is **mentat**,
**mentor**, **minion**, and **myrmidon**.  The executable inventory is
[`scripts/jobs/model-tier-inventory.tsv`](../../scripts/jobs/model-tier-inventory.tsv).
It is closed: every enabled model has exactly one row; an unknown model is
unclassified and cannot acquire an automatic route.

| Tier | Fleet models | Dispatch boundary |
| --- | --- | --- |
| mentat | Claude Fable 5 (`claude-fable-5`; Mythos is equivalent when enabled) | Manual only. Use `post-manual-job.sh`; it stamps `dispatch: manual`. |
| mentor | Moonshot Kimi K3 (`kimi-k3`) and Fireworks GLM 5.2 (`fireworks/accounts/fireworks/models/glm-5p2`) | Provider-constrained canaries only; Moonshot remains disabled while its credits are exhausted. |
| minion | Anthropic Opus and every selectable OpenAI/Codex model | Current automatic-dispatch tier. New jobs redundantly carry `model: gpt-5.6-terra` during the fleet upgrade. |
| myrmidon | Sonnet, Haiku, served local Qwen, and configured Fireworks selector | Expedient tier; not an automatic escalation path. |

## Current quota route

`post-job.sh` and `post-plan.sh` are the automatic producer choke points. They
rewrite every body to `tier: minion`, `model: gpt-5.6-terra`, `fallback-tier:
minion`, and `dispatch: automatic`. `tier:` remains authoritative; the compatible
concrete model pin is temporary deployment compatibility, never a replacement for
durable tier intent.
This covers schedules, watchers, foreman, follow-ups, auctions, and role-produced
jobs. Schedules receive the same transform at tick time, including an old schedule
body that still carries a Kimi pin. Mystic workers remain at zero. A stale Kimi
claim that exits for quota exhaustion is requeued on the minion/Codex route without
touching a live claim. This temporary routing is reversible by changing the
choke-point policy; the four-tier inventory remains unchanged.

No automatic path may emit Fable/mentat or any other Claude pin. The gardener
Claude handler and backend-fit predicate accept only `dispatch: manual` Fable.

## Deployment migration

After deploying this revision, run
`scripts/jobs/migrate-model-tier-routing.sh` once on the leader. It CAS-rewrites
existing `jobs/todo` and `jobs/plan` automatic entries to `tier: minion` plus the
compatible `gpt-5.6-terra` model pin, while leaving explicit `dispatch: manual`
mentat jobs untouched. New jobs are normalized by the posting primitives, so the
migration is idempotent and does not need to remain on.

## Adding or changing a model

Add its exact provider/id/tier row to `model-tier-inventory.tsv`, add the same
exact id to `model-routing-defaults.tsv`, and extend regression coverage before
enabling it. Do not add wildcard provider patterns: that would classify a newly
introduced model silently. A provider-constrained canary names `provider:` and
`tier:`, never a concrete `model:`. Update this document and
[`designs/provider-model-catalog.md`](../../designs/provider-model-catalog.md).
