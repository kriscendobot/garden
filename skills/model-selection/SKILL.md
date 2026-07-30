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
| mentor | Anthropic Opus 5 (`claude-opus-5`), OpenAI Sol (`gpt-5.6-sol`), Moonshot Kimi K3 (`kimi-k3`), Fireworks Kimi K3 (`fireworks/accounts/fireworks/models/kimi-k3`) and GLM 5.2 (`fireworks/accounts/fireworks/models/glm-5p2`) | Highest tier automatic producers may emit. Multi-provider: a mentor job is claimable by whichever provider's worker is live (monk on Opus 5, cleric on Sol, mystic on Kimi, fireworker on Fireworks Kimi/GLM). |
| minion | Anthropic Opus 4.x, OpenAI/Codex models below Sol, Fireworks Deepseek V4 Pro (`fireworks/accounts/fireworks/models/deepseek-v4-pro`) | The tier below mentor; the automatic fallback tier. |
| myrmidon | Sonnet, Haiku, served local Qwen, Fireworks gpt-oss-120b (`fireworks/accounts/fireworks/models/gpt-oss-120b`) | Expedient tier; not an automatic escalation path. |

## Current route

`post-job.sh` and `post-plan.sh` are the automatic producer choke points. They
rewrite every body to `tier: mentor`, `fallback-tier: minion`, and `dispatch:
automatic`. They never pin a provider or concrete model. `tier:` is authoritative.
This covers schedules, watchers, foreman, follow-ups, auctions, and role-produced
jobs. Mentor is now a multi-provider tier (Opus 5, Sol, Kimi K3), so a mentor job
makes progress on whichever provider's worker is live: a monk claims it on
`claude-opus-5`, a cleric on `gpt-5.6-sol`, a mystic on `kimi-k3`. On a genuine
failure the reaper advances only the qualified non-Claude fallback. This routing is
reversible by changing the choke-point policy; the four-tier inventory remains
unchanged.

No automatic path may emit Fable/mentat or any other manual-only pin. The gardener
Claude handler and backend-fit predicate accept only `dispatch: manual` Fable.

## Deployment migration

After deploying this revision, run
`scripts/jobs/migrate-model-tier-routing.sh` once on the leader. It CAS-rewrites
existing `jobs/todo` and `jobs/plan` automatic entries to `tier: mentor` (stripping
any temporary concrete model pin), while leaving explicit `dispatch: manual`
mentat jobs untouched. New jobs are normalized by the posting primitives, so the
migration is idempotent and does not need to remain on.

## Adding or changing a model

Add its exact provider/id/tier row to `model-tier-inventory.tsv`, add the same
exact id to `model-routing-defaults.tsv`, and extend regression coverage before
enabling it. Do not add wildcard provider patterns: that would classify a newly
introduced model silently. A provider-constrained canary names `provider:` and
`tier:`, never a concrete `model:`. Update this document and
[`designs/provider-model-catalog.md`](../../designs/provider-model-catalog.md).
