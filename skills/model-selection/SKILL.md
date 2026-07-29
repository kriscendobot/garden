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
| mentor | Moonshot Kimi K3 (`kimi-k3`) | Highest tier automatic producers may emit. |
| minion | Anthropic Opus and every selectable OpenAI/Codex model | Never selected by automatic dispatch during the Claude quota route. A Kimi retry may use the qualified Codex fallback `gpt-5.6-terra`. |
| myrmidon | Sonnet, Haiku, served local Qwen, and configured Fireworks selector | Expedient tier; not an automatic escalation path. |

## Current quota route

`post-job.sh` and `post-plan.sh` are the automatic producer choke points. They
rewrite every body to `tier: mentor`, `fallback-tier: minion`, and `dispatch:
automatic`. They never pin a provider or concrete model.
This covers schedules, watchers, foreman, follow-ups, auctions, and role-produced
jobs. The Kimi claim predicate does not require a Claude fallback, so builder work
is mechanically claimable. On a genuine Kimi failure the reaper advances only the
qualified non-Claude fallback. This temporary routing is reversible by changing
the choke-point policy; the four-tier inventory remains unchanged.

No automatic path may emit Fable/mentat or any other Claude pin. The gardener
Claude handler and backend-fit predicate accept only `dispatch: manual` Fable.

## Deployment migration

After deploying this revision, run
`scripts/jobs/migrate-model-tier-routing.sh` once on the leader. It CAS-rewrites
existing `jobs/todo` and `jobs/plan` automatic entries to `tier: mentor` while leaving
explicit `dispatch: manual` mentat jobs untouched. New jobs are normalized by the
posting primitives, so the migration is idempotent and does not need to remain on.

## Adding or changing a model

Add its exact provider/id/tier row to `model-tier-inventory.tsv`, add the same
exact id to `model-routing-defaults.tsv`, and extend regression coverage before
enabling it. Do not add wildcard provider patterns: that would classify a newly
introduced model silently. Update this document and
[`designs/provider-model-catalog.md`](../../designs/provider-model-catalog.md).
