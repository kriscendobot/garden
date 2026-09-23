---
created: 2026-06-10
updated: 2026-09-13
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
| mentat | Anthropic Fable 5 (`claude-fable-5`; Mythos is equivalent when enabled), OpenAI GPT-6 Astra (`gpt-6-astra`) | Manual only. Use `post-manual-job.sh`; it stamps `dispatch: manual`. Multi-provider like mentor: a manual mentat job is claimable by whichever provider's worker is live (monk on Fable, cleric on GPT-6 Astra); the manual-dispatch gate is keyed on the tier string, not a provider, so no automatic path reaches any mentat model regardless of provider. |
| mentor | Anthropic Opus 5.5 (`claude-opus-5-5`; Opus 5 `claude-opus-5` stays selectable behind it), OpenAI Sol (`gpt-5.6-sol`), Moonshot Kimi K3 (`kimi-k3`), Fireworks GLM 5.2 (`fireworks/accounts/fireworks/models/glm-5p2`) and Kimi K3 (`fireworks/accounts/fireworks/models/kimi-k3`) | Highest tier automatic producers may emit, and the anthropic automatic ceiling. Multi-provider: a mentor job is claimable by whichever provider's worker is live (monk on Opus 5.5, cleric on Sol, mystic on Kimi, fireworker on Fireworks). Opus 5.5 is the first-match anthropic mentor row, so it is the anthropic mentor default; Opus 5 remains selectable by the `opus5` alias / concrete pin. See the collision note below: a Fireworks mentor job resolves to GLM 5.2, so the registered Fireworks K3 is not yet independently selectable. |
| minion | Anthropic Opus 4.x, OpenAI/Codex models below Sol, served local Qwen (`hermit` lane RETIRED 2026-09-13 — pool pinned 0, no worker claims it), Fireworks Deepseek V4 Pro (`fireworks/accounts/fireworks/models/deepseek-v4-pro`), OpenRouter GLM 5.2 free (`openrouter/z-ai/glm-5.2:free`), Ollama Cloud Qwen 3.5 (`qwen3.5:cloud`) | The tier below mentor; the automatic fallback tier. |
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

**OpenRouter (explicit-model-only, disabled by default).** The `openrouter` kind
reuses the same custom OpenAI-compatible Codex handler as the fireworker. Its routing
ids are namespaced `openrouter/<wire-id>` and only **stable, NAMED** free models earn
reviewed inventory rows; **cloaked/stealth ids are deliberately excluded** and fail
closed like any unreviewed selector (the closed inventory's whole point). No
automatic/unpinned job reaches it — it claims only a `provider: openrouter` canary or
an `openrouter/<wire-id>` pin. Its sole current row is GLM 5.2 free at minion: the
2026-08-22 review found it in OpenRouter's public ZDR endpoint inventory and removed
the former DeepSeek/Llama free rows, which had empty endpoint lists. Every request is
forced through the no-collection/ZDR adapter. Policy:
[`designs/openrouter-provider.md`](../../designs/openrouter-provider.md); activation:
[`context/operations/openrouter.md`](../../context/operations/openrouter.md).

**OpenRouter-promo (the cloaked/stealth lane, disabled + inert by default).** A
**second** OpenRouter kind, `openrouter-promo`, deliberately admits the rotating cloaked
"stealth" ids *while cloaked* (maintainer decision, 2026-08-22). Same handler, endpoint,
key, and fail-closed ZDR/deny-collection adapter as `openrouter`, but its **own**
provider/unit/namespace (`openrouter-promo/<wire-id>`) and reputation arm, so a cloaked
model's separately-re-reviewed risk never pools with a named model's. Unlike the closed
inventory, its enabled ids live in a **journal ledger** (`config/openrouter-promos`) and
are **cadence-gated**: a row not re-attested within 24h **fails closed automatically**
(no daemon), and a deterministic recheck auto-disables an id that 404s or goes stale.
Explicit-model-only like the stable lane. Attest/rip-cord tooling and the recheck
schedule: [`context/operations/openrouter.md`](../../context/operations/openrouter.md)
§ The promo (stealth) lane.

**Local Qwen (`hermit`) — RETIRED (2026-09-13).** The on-box Ollama lane (`hermit`
worker, provider `local`, e.g. `qwen3.6`) is dropped by maintainer decision: the
served default is too small to be useful and a larger MoE would cost tens of GiB of
watched disk. The kind stays registered (the shared `local` provider machinery, the
qwen3.6 mentor-shaped trial, and old journal records still resolve) but is pinned
inert — the scaler clamps its count to 0 and `set-hermits.sh` refuses a nonzero
count, so no host arms it and the `local qwen3.6` inventory row never earns a claim.
The friar (Ollama Cloud) lane below is unaffected — a separate, paid, external
provider.

**Ollama Cloud (`friar`, explicit-model-only, disabled by default).** The `friar`
kind runs **Claude Code** (`claude`) against **Ollama Cloud** (ollama.com's
Anthropic-compatible endpoint) — a paid, metered, external provider (`ollama-cloud`),
distinct from `anthropic` and from local (`hermit`). It authenticates from the
container's tmpfs handoff of `OLLAMA_CLOUD_API_KEY`; the key never enters a unit,
journal, worktree, image, or report. Like the mystic/fireworker/openrouter arms it
ships at **zero** pool size and refuses unconstrained work: no automatic/unpinned job
reaches it — it claims only a `provider: ollama-cloud` canary or a `model: qwen3.5:cloud`
pin. Its sole current row is Qwen 3.5 (`qwen3.5:cloud`) at **minion**. Design:
[`designs/claude-ollama-cloud-worker-kind.md`](../../designs/claude-ollama-cloud-worker-kind.md);
activation: [`context/operations/ollama-cloud.md`](../../context/operations/ollama-cloud.md).

## Current route

`post-job.sh` and `post-plan.sh` are the automatic producer choke points. They
rewrite every body to `tier: mentor`, `fallback-tier: minion`, and `dispatch:
automatic`. They never pin a provider or concrete model. `tier:` is authoritative.
This covers schedules, watchers, foreman, follow-ups, auctions, and role-produced
jobs. Mentor is now a multi-provider tier (Opus 5.5, Sol, Kimi K3), so a mentor job
makes progress on whichever provider's worker is live: a monk claims it on
`claude-opus-5-5`, a cleric on `gpt-5.6-sol`, a mystic on `kimi-k3`. On a genuine
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

### The anthropic automatic ceiling (claude-opus-5-5)

The anthropic automatic ceiling is **`claude-opus-5-5`** — the mentor model itself
(design [`opus55-tier.md`](../../designs/opus55-tier.md), Option B, resolved
2026-09-23). Opus 5.5 is cheaper than the former ceiling model (Opus 4.8) and
succeeds the mentor-tier Opus 5, so there is **no longer a mentor→minion
downshift**: an automatic mentor job is served AT mentor by every provider,
anthropic included. A monk resolves a mentor job to `claude-opus-5-5` (the
first-match anthropic mentor row); Opus 5 stays selectable behind it via the
`opus5` alias or a concrete pin. Automatic effort is `medium`, which is Opus 5.5's
own default, so no effort flag is plumbed through the handler.

*(History: until this change the handler downshifted an automatic anthropic mentor
job to the minion model — `claude-opus-4-8` — because the inventory's mentor model,
Opus 5, cost more than the standing ceiling. Opus 5.5 removed that gap, so the
downshift and its reaper mirror are retired.)*

One invariant keeps the reaper's one-hop reroute (`reroute_job_model`,
`scripts/jobs/common.sh`) honest about the per-role tier map above:

- **Per-role floor.** The reroute refuses to demote a job below its role's
  canonical tier (`role_tier_floor`): `designer`/`builder` (and their web variants)
  floor at **mentor**, every other role at **minion**. A refusal leaves the job at
  its floor tier and requeues it unchanged, so a designer/builder job is never
  dropped to a tier that cannot design or build — which would convert one transient
  failure into a guaranteed doom (the `proposal-compartments-xs-source-phase-design`
  designer doom, 2026-08-17).

The former "never burn an unserved tier" ceiling-suppression case is gone: because a
mentor job is now genuinely served at mentor on anthropic too, a mentor failure is
real evidence about mentor and the per-role floor reroute applies uniformly across
providers.

Coverage: `scripts/jobs/test/reroute-role-floor-test.sh`.

## Panel juror seats (a separate, intra-panel tier map)

The four-tier vocabulary above governs how a *job* is dispatched. The gardening
review **panel** has its own, orthogonal per-seat tiering: each juror seat's
`claude -p` runs at a seat-specific model rather than uniformly at the ceiling.
The map is `scripts/jobs/gardening/seat-model-tiers.tsv` (`<seat> opus|sonnet|haiku`),
resolved by `panel.sh`; because a seat's `claude -p` runs in the panel job's
Anthropic environment the reachable models are Anthropic-only, so `opus` means
"inherit the job's resolved ceiling model" and the map only ever downshifts. The
per-seat justification (which seats keep Opus and why) and the coupled metering
fix are in [`designs/panel-seat-metering-and-tiering.md`](../../designs/panel-seat-metering-and-tiering.md).
This is deliberately NOT part of the closed fleet inventory: it is a cost lever
inside one supervised script, not a dispatch route.

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
