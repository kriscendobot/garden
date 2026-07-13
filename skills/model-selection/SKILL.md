---
created: 2026-06-10
updated: 2026-07-13
author: gardener
---

# Skill: model-selection

The canonical role→model policy for the garden. A unit of work resolves the Claude
model it runs on from one map, consulted on two paths that must agree:

- **Agent-dispatch path** — an orchestrator (liaison, steward) or a judge passes a
  `model` tier to the `Agent` tool at dispatch time, chosen from this skill's
  table, and records it as the `model:` field on the `dispatch` journal entry
  (`CLAUDE.md` § Dispatch contract, step 3).
- **Scripted-fleet path** — a job on the board runs through
  `scripts/jobs/handlers/gardener-claude.sh`, which resolves the model from the
  job's leading YAML frontmatter: an explicit `model:` first, else a per-role
  default from the job's `role:` field.

The **executable source of truth** for the fleet path is two functions in
`scripts/jobs/common.sh`:

- `resolve_model_tier <tier-or-id>` — binds the short tier names to concrete
  `claude-*` ids (a concrete id passes through). One edit here retargets a
  Claude-version bump for the whole fleet.
- `role_default_model <role>` — the role→default-model map (designer→Opus,
  builder→Opus; every other role empty, so it rides the fleet default).

This document and those two functions are kept in agreement deliberately: prose is
what the Agent path reads, code is what the fleet path runs, and each names the
other so the policy never drifts.

## Standing role policy

The maintainer's directive (2026-07-13, via the liaison): **the design-only
`designer` role and the mergeable-feature `builder` role both run on the latest
Opus.** (This supersedes the 2026-07-02 policy that ran `designer` on Fable; every
role formerly assigned to Fable is now on Opus, so no role defaults to Fable
today.) These are the only two roles pinned by default today. Web variants
(`web-designer` / `web-builder`) and every other role are unpinned — they ride the
fleet default unless a dispatch or job names a model explicitly.

| Role | Tier | Concrete id | Why |
| --- | --- | --- | --- |
| `designer` | Opus | `claude-opus-4-8` | Design-only authoring — drafting design documents and surfacing open questions. Moved to the latest Opus (2026-07-13), the same tier `builder` uses. |
| `builder` | Opus | `claude-opus-4-8` | Substantive, mergeable implementation within a single well-scoped dispatch, where correctness compounds. The latest Opus. |

Any other role: no default pin — omit the `model` parameter on an `Agent`
dispatch, and post its job without a `model:`/`role:`-driven pin, so it runs on the
fleet default. Add a row here (and a case in `role_default_model`) when the
maintainer pins another role.

## Tiers

The short tier names bind to concrete model ids (`resolve_model_tier` in
`common.sh`). The current binding (2026-07-02):

| Tier | Concrete id |
| --- | --- |
| `fable` | `claude-fable-5` |
| `opus` | `claude-opus-4-8` |
| `sonnet` | `claude-sonnet-4-6` |
| `haiku` | `claude-haiku-4-5-20251001` |

A value that is already a concrete `claude-*` id passes through verbatim. An
unknown or blank value resolves to empty, and the caller falls back to the fleet
default (no `--model`) — a typo must never crash a tick.

### Provider-scoped tiers (the codex/cleric backend)

`resolve_model_tier` is **provider-scoped**: `resolve_model_tier <provider> <tier>`,
with the provider defaulting to `anthropic` when omitted (so every bare
`resolve_model_tier opus` is unchanged). The second provider is `openai`, the
backend the **cleric** worker kind drives via `codex` (worker-kind registry in
`common.sh`; design [`cleric-worker-bid-auction-reputation.md`](../../designs/cleric-worker-bid-auction-reputation.md)).
The codex ids and effort ladders come from the catalog §2 (re-verify live before a
version bump):

| Tier | Concrete id | Supported effort (unified axis) |
| --- | --- | --- |
| `terra` | `gpt-5.6-terra` | low·medium·high·xhigh·max·**ultra** (effective codex default) |
| `luna` | `gpt-5.6-luna` | low·medium·high·xhigh·max |
| `frontier` | `gpt-5.5` | low·medium·high·xhigh |
| `mini` | `gpt-5.4-mini` | low·medium·high·xhigh |

A concrete `gpt-*` / `o<n>` / `codex-*` id passes through verbatim; a claude tier
passed to the `openai` provider (and vice versa) resolves to empty, so a job can
never cross-pin a backend it cannot run. The cleric handler
(`handlers/cleric-codex.sh`) maps the job's optional `effort:` header (else the
role default — `high` for designer/builder, `medium` otherwise) onto the unified
thoughtfulness axis and **normalizes it down** to the model's nearest supported
level via `-c model_reasoning_effort=<level>`, recording the honored level.

Per-kind role defaults live in `role_default_model <kind> <role>` and
`role_default_effort <kind> <role>` (kind defaulting to `gardener`): the cleric
side pins `designer`/`builder` to `gpt-5.6-terra` (at `high`), every other role
unpinned (fleet default `gpt-5.6-terra` at `medium`).

## Procedure

### Agent-dispatch path (orchestrator / judge)

1. Read the role's row in the standing-policy table. For `designer` pass
   `model: opus`; for `builder` pass `model: opus`; for any other role omit the
   `model` parameter (fleet default).
2. Pass the tier to the `Agent` tool's `model` parameter at dispatch time.
3. Record the choice in the `dispatch` journal entry's `model:` frontmatter.

### Scripted-fleet path (job producers and the handler)

1. A producer stamps the performing role on the job so the handler can key on it:
   - `post-plan.sh --role <role> …` (planned jobs), or
   - `post-job.sh --role <role> …` (direct posts), or
   - the foreman's `ROLE <role>` block line (threaded to `post-job.sh --role`).
   The role lands as a `role:` field in the job's leading frontmatter.
2. `gardener-claude.sh` resolves the model when it claims the job:
   explicit `model:` (via `resolve_model_tier`) wins; absent that, `role:` selects
   the per-role default (via `role_default_model`); absent both, no `--model`
   (fleet default). See the *Overrides* section.

## Overrides

An **explicit per-job `model:` always overrides the role default.** The handler
applies the role default only when no `model:` field is present, so a maintainer
who wants a designer job on Fable for one particular design writes `model: fable`
and it wins over the Opus default. On the Agent path the maintainer
names the override tier directly at dispatch; the table's assignment stays
canonical for subsequent dispatches.

## Composition with other skills

- The dispatch contract in `CLAUDE.md` § Dispatch contract names this skill as the
  lookup the orchestrator performs when invoking `Agent` (step 3).
- The fleet path's functions live in `scripts/jobs/common.sh`
  (`resolve_model_tier`, `role_default_model`, `role_default_effort`); the callers
  are `scripts/jobs/handlers/gardener-claude.sh` (anthropic/claude) and
  `scripts/jobs/handlers/cleric-codex.sh` (openai/codex), each in its § *model
  selection*. The `gardener-worktree-test.sh` covers the claude `model:`/`role:`
  resolution; `worker-spine-kinds-test.sh` covers the provider-scoped tiers and the
  per-kind role defaults for both backends.
- The **cross-provider model catalog**
  ([`designs/provider-model-catalog.md`](../../designs/provider-model-catalog.md))
  is the reference behind this policy: it lists every Claude id (with context window,
  effort levels, and rate-card pricing) and every selectable Codex model, and defines
  the unified `(provider, model, thoughtfulness)` axis the bid/accept market
  ([`designs/gardener-bid-accept-market.md`](../../designs/gardener-bid-accept-market.md))
  keys reputation on. It also flags that the `sonnet` tier here still binds the
  previous-generation `claude-sonnet-4-6`, not Sonnet 5.

## Notes from the field

- _2026-06-10_: original skill landed for the v1 Agent-dispatch world (a full
  per-role tier table across orchestrators, judges, and jurors), then was left
  behind when the tree moved to the `main2` v2 fleet — `CLAUDE.md` kept pointing at
  it but the file was absent.
- _2026-07-02_: restored and rewritten for the v2 two-path reality (job
  `set-designer-fable-builder-opus-model-policy`). Narrowed to the maintainer's
  standing pin — designer on Fable, builder on Opus — with every other role riding
  the fleet default rather than an inherited large table, and reconciled against
  the executable `role_default_model` / `resolve_model_tier` source of truth in
  `common.sh`.
- _2026-07-13_: **designer moved from Fable to Opus** (job
  `downgrade-fable-roles-to-opus`, maintainer-directed). Every role formerly
  defaulting to Fable is now on the latest Opus — `designer` and `builder` share
  the `opus` tier, and no role defaults to Fable anymore. The `fable` tier id
  remains valid in `resolve_model_tier` (still selectable via an explicit per-job
  `model: fable` pin), it is simply no longer a role DEFAULT. Per-job/per-schedule
  `model: fable` pins are unaffected (two standing schedules still carry one).
