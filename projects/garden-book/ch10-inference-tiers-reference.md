---
created: 2026-09-30
author: gardener (job book-revise-content)
grounded-on: main2 c63c16cad57, journal2 as of 2026-09-30
---

# Chapter 10: Inference tiers reference

A lookup reference for how the garden decides which model runs a job. Use it
to answer "what tier does role X get, which worker can serve it, and what
happens when that provider is unavailable." The canonical source is
[model-selection](../../skills/model-selection/SKILL.md); the executable data
is [`scripts/jobs/model-tier-inventory.tsv`](../../scripts/jobs/model-tier-inventory.tsv)
and [`scripts/jobs/model-routing-defaults.tsv`](../../scripts/jobs/model-routing-defaults.tsv),
read by `resolve_model_tier`, `role_default_model`, and `role_tier_floor` in
[`scripts/jobs/common.sh`](../../scripts/jobs/common.sh). Where this chapter
and those files disagree, the files win.

## Tiers

Four tiers, in descending thoughtfulness. A job names a tier, never a model;
the worker that claims it resolves the tier to a concrete model for its own
provider.

| Tier | Rank | How jobs reach it | Role in routing |
| --- | --- | --- | --- |
| `mentat` | 0 | **Manual only**, via `scripts/jobs/post-manual-job.sh`, which stamps `dispatch: manual`. One scoped exception (below). | The most capable models; never emitted by any automatic producer. |
| `mentor` | 1 | **Automatic default.** Every automatic post lands here. | The ordinary working tier, and the ceiling for automatic work. |
| `minion` | 2 | Automatic **fallback** (`fallback-tier: minion`). | Where a failed mentor job is retried, subject to role floors. |
| `myrmidon` | 3 | Named explicitly by a producer or a role brief. | The expedient tier; never an automatic escalation or fallback target. |

A `tier:` value outside these four is treated as no tier at all (the resolver
fails closed and logs a warning). Writing `tier: builder` is the classic
mistake: `role:` is a separate field.

## Models per tier

From `model-tier-inventory.tsv` (one row per enabled model; an unlisted model
is unclassified and cannot get an automatic route). The first row per
provider and tier is that provider's default for the tier.

| Tier | Anthropic | OpenAI | Other providers |
| --- | --- | --- | --- |
| mentat | `claude-fable-5` (Mythos `claude-mythos-5` equivalent when enabled) | `gpt-6-astra` | none |
| mentor | `claude-opus-5-5` (default), `claude-opus-5` (by alias `opus5` or pin) | `gpt-5.6-sol` | Moonshot `kimi-k3`; Fireworks GLM 5.2 (resolves first) and Kimi K3 |
| minion | `claude-opus-4-8`, `claude-opus-4-8[1m]`, `claude-opus-4-7` | `gpt-5.6-terra` (OpenAI routing default), `gpt-5.6-luna`, `gpt-5.5`, `gpt-5.4-mini` | Fireworks DeepSeek V4 Pro; OpenRouter GLM 5.2 free; Ollama Cloud `qwen3.5:cloud`; local `qwen3.6` (lane retired) |
| myrmidon | `claude-sonnet-5`, `claude-sonnet-4-6`, `claude-haiku-4-5` | none | Fireworks gpt-oss-120b |

Two notes that trip people up:

- **Anthropic's automatic ceiling is the mentor model itself.** Since
  2026-09-23 a monk serves an automatic mentor job at `claude-opus-5-5`, at
  its default `medium` effort. The earlier mentor-to-minion downshift on
  Anthropic is retired.
- **Fireworks mentor is first-match.** A `provider: fireworks` mentor job
  resolves to GLM 5.2; the Fireworks-hosted Kimi K3 is registered but not yet
  independently selectable, and is a separate lane from the Moonshot K3.

## Worker kinds

A worker kind is a provider binding, not a tier. Slot counts and budgets never
change a job's tier. Capacity is set per host with
`scripts/jobs/set-workers.sh <kind> <count>` (or the target host's sysop).

| Kind | Unit | Provider / harness | Status on 2026-09-30 |
| --- | --- | --- | --- |
| `monk` | `garden-monk@` | Native Anthropic, Claude Code | **Live.** The only kind with slots on any host (4, 1, and 3 across the three hosts). |
| `cleric` | `garden-cleric@` | OpenAI (Codex) | Installed; 0 slots on every host. |
| `mystic` | `garden-mystic@` | Moonshot Kimi | 0 slots; its role defaults are disabled while Moonshot credit is exhausted. |
| `fireworker` | `garden-fireworker@` | Fireworks | Ships at 0; claims only provider-constrained or pinned work. |
| `friar` | `garden-friar@` | Claude Code against Ollama Cloud | Disabled by default, 0 slots; claims only a `provider: ollama-cloud` canary or a `qwen3.5:cloud` pin. |
| `openrouter`, `openrouter-promo` | `garden-openrouter@`, `garden-openrouter-promo@` | OpenRouter | Explicit-model-only; disabled by default. |
| `hermit` | `garden-hermit@` | Local served model | **Retired** 2026-09-13; pool pinned to 0. |

"Gardener" is the shared worker role and spine that all of these run, not a
kind; the old `gardener` kind and `set-gardeners.sh` are retired. Host slot
counts are the `monks:`, `clerics:`, and so on lines in each host's
`journal/hosts/<GARDEN>` file.

## How a job gets its tier

1. **Automatic producers.** `post-job.sh` and `post-plan.sh` are the choke
   points for everything automatic: schedules, watchers, the foreman,
   follow-ups, auctions, role-produced jobs. They rewrite each body to
   `tier: mentor`, `fallback-tier: minion`, `dispatch: automatic`, and never
   pin a provider or a model.
2. **Manual work.** `post-manual-job.sh` posts at `tier: mentat` with
   `dispatch: manual`. Both the claim predicate (`job_eligible_for_kind`,
   `claim-job.sh`) and the monk and cleric handlers refuse `tier: mentat`
   without that stamp. Mentat is the only tier they gate on.
3. **The scoped Ironhorse exception.** A foreman promotion of an
   `ironhorse-test262-press-<UTC stamp>` plan may carry `tier: mentat` with
   `dispatch: ratchet-delegated`, under the maintainer's 2026-09-28 delegation.
   Claim and handlers check the active journal authorization, the basename,
   the arc marker, and the canonical task text. No fallback, pin, or provider
   override rides that path.
4. **Claiming.** Mentor, mentat, and minion are multi-provider: whichever live
   kind has a model at that tier may claim. Today that means a monk, on
   `claude-opus-5-5` for mentor.

## Per-role tier floors

`role_tier_floor` sets the lowest tier a role may be demoted to on reroute.

| Role | Floor |
| --- | --- |
| `designer`, `builder`, `web-designer`, `web-builder` | **mentor** |
| every other role | **minion** |

Role briefs may also call for a lower working tier: the
[americanizer](../../roles/americanizer/AGENT.md) and
[deslopper](../../roles/deslopper/AGENT.md) are described as
`myrmidon`-tier fixer variants. Panel juror seats have their own separate
per-seat map (`scripts/jobs/gardening/seat-model-tiers.tsv`, `opus`, `sonnet`,
or `haiku`) inside the panel script; it only ever downshifts from the panel
job's model and is not part of the fleet inventory.

`role_default_model` supplies a model only for a job that carries no `tier:`
at all, which automatic posting never produces. For a monk it maps
`designer`/`builder` to Opus, `cleaner`/`retcon`/`yarn-lock`/`journalist` to
Haiku, and `weaver`/`conductor`/`pages-shepherd` to Sonnet; clerics have a
parallel map on OpenAI models.

## Fallback when a provider is unavailable

Two different situations look alike and are handled differently.

**No live worker for the provider.** Nothing is rerouted. A mentor job simply
waits on the board until some live kind with a mentor model claims it. Because
mentor spans Anthropic, OpenAI, Moonshot, and Fireworks, the job makes
progress on whichever of those has slots; today that is always a monk.

**A genuine failure while running.** The reaper's one-hop reroute
(`reroute_job_model` in `common.sh`) advances the job along its fallback
chain: `tier: mentor` becomes `tier: minion`, the head of `fallback-tier:` is
popped, and the burned tier is appended to `model-burned:`. Then the role
floor applies. If the next tier would fall below the role's floor (a designer
or builder going from mentor to minion), the reroute is refused, the job stays
at its floor tier, and it is requeued unchanged for triage rather than doomed
at a tier that cannot do the work. Every other role may drop to minion. There
is no hop below minion, since myrmidon is never a fallback target.

## Quick lookup

| Question | Answer |
| --- | --- |
| What tier does an ordinary automatic job run at? | `mentor`, with `fallback-tier: minion`. |
| What model does a monk use for it? | `claude-opus-5-5`, medium effort. |
| How do I get Fable or GPT-6 Astra? | Post with `post-manual-job.sh` (mentat, manual). |
| A designer or builder job failed at mentor. Now what? | It stays at mentor and is requeued; the floor forbids minion. |
| A shepherd (or any non-design/build role) failed at mentor? | It is retried at minion (`claude-opus-4-8` on a monk). |
| No OpenAI workers are up; will a mentor job starve? | No, any live kind with a mentor model (today, monks) claims it. |
| Can a job be pinned to a concrete model? | Automatic producers never pin. A provider canary names `provider:` and `tier:`, not `model:`. Migration pins are stripped by `migrate-model-tier-routing.sh`. |
| How do I add a model? | Add its provider/id/tier row to `model-tier-inventory.tsv` and the id to `model-routing-defaults.tsv`, extend the regression tests, and update model-selection. No wildcard rows. |
