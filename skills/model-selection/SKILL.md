---
created: 2026-06-10
updated: 2026-08-14
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
| mentor | Anthropic Opus 5 (`claude-opus-5`), OpenAI Sol (`gpt-5.6-sol`), Moonshot Kimi K3 (`kimi-k3`), Fireworks GLM 5.2 (`fireworks/accounts/fireworks/models/glm-5p2`) and Kimi K3 (`fireworks/accounts/fireworks/models/kimi-k3`) | Highest tier automatic producers may emit. Multi-provider: a mentor job is claimable by whichever provider's worker is live (monk on Opus 5, cleric on Sol, mystic on Kimi, fireworker on Fireworks). See the collision note below: a Fireworks mentor job resolves to GLM 5.2, so the registered Fireworks K3 is not yet independently selectable. |
| minion | Anthropic Opus 4.x, OpenAI/Codex models below Sol, served local Qwen, Fireworks Deepseek V4 Pro (`fireworks/accounts/fireworks/models/deepseek-v4-pro`) | The tier below mentor; the automatic fallback tier. |
| myrmidon | Sonnet, Haiku, Fireworks gpt-oss-120b (`fireworks/accounts/fireworks/models/gpt-oss-120b`) | Expedient tier; not an automatic escalation path. |

**Fireworks mentor collision (GLM 5.2 vs Kimi K3).** Both Fireworks mentor models
are registered with wire ids verified against the provider's model pages, but the
tier resolver is first-match, so a `provider: fireworks` + `tier: mentor` job
resolves to **GLM 5.2**. Fireworks-served K3 is therefore not yet independently
tier-selectable, and it is distinct from the Moonshot/mystic K3 lane (different
provider, endpoint, credential, reputation arm — the two never pool). Making K3
independently reachable is a maintainer routing decision documented in
[`context/operations/fireworks.md`](../../context/operations/fireworks.md)
§ Registered routes; do not invent a tier or a Fast-router id to force it.

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
Claude handler and the backend-fit predicate (`job_eligible_for_kind`,
`claim-job.sh`) both refuse `tier: mentat` unless the job carries
`dispatch: manual`. **Mentat is the only tier they gate on** — the handler serves
every other tier normally.

That distinction is load-bearing. Until 2026-08-01 the handler refused *anything*
that was not manual-mentat, while the predicate happily let an anthropic gardener
CLAIM a `tier: mentor` job (Anthropic does have a model at mentor). Claim said
yes, handler said no, and a host with `gardeners: N>0` would claim/die/requeue
across the whole board in a hot loop. That is why both endolin hosts sat at
`gardeners: 0`. The two are now consistent, and
`test/gardener-claude-tier-serving-test.sh` asserts the agreement per tier.

### The anthropic automatic-work cost ceiling

The closed inventory puts `claude-opus-5` at mentor, but the standing ceiling for
**automatic** fleet work is `claude-opus-4-8`. Rather than restate the inventory —
which the auction, the claim predicate, and the rate card all read — the Claude
handler **serves an automatic mentor job at the minion model** and logs that it
did. An explicit `dispatch: manual` mentor job is still honoured at mentor: a
human asking for Opus 5 by hand is not the automatic path this ceiling governs.

Consequence for the other providers: a mentor job claimed by a cleric, mystic, or
fireworker resolves at mentor as before. The downshift is anthropic-only, because
the ceiling is about Claude spend.

Two invariants keep the reaper's one-hop reroute (`reroute_job_model`,
`scripts/jobs/common.sh`) honest about this downshift and about the per-role tier
map above:

- **Per-role floor.** The reroute refuses to demote a job below its role's
  canonical tier (`role_tier_floor`): `designer`/`builder` (and their web variants)
  floor at **mentor**, every other role at **minion**. A refusal leaves the job at
  its floor tier and requeues it unchanged, so a designer/builder job is never
  dropped to a tier that cannot design or build — which would convert one transient
  failure into a guaranteed doom (the `proposal-compartments-xs-source-phase-design`
  designer doom, 2026-08-17).
- **Never burn an unserved tier.** Because an anthropic worker serves an automatic
  mentor job at the minion model (above), a failure of an **anthropic-served** mentor
  job is evidence about minion, not mentor. The reaper suppresses the reroute in that
  case — it does not record `model-burned: mentor` or demote — and requeues at mentor
  so a true-mentor provider (cleric/mystic/fireworker) can still take a genuine mentor
  attempt.

Coverage: `scripts/jobs/test/reroute-role-floor-test.sh`.

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
