---
created: 2026-06-10
updated: 2026-07-02
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
- `role_default_model <role>` — the role→default-model map (designer→Fable,
  builder→Opus; every other role empty, so it rides the fleet default).

This document and those two functions are kept in agreement deliberately: prose is
what the Agent path reads, code is what the fleet path runs, and each names the
other so the policy never drifts.

## Standing role policy

The maintainer's directive (2026-07-02, via the liaison): **the design-only
`designer` role runs on Fable; the mergeable-feature `builder` role runs on the
latest Opus.** These are the only two roles pinned by default today. Web variants
(`web-designer` / `web-builder`) and every other role are unpinned — they ride the
fleet default unless a dispatch or job names a model explicitly.

| Role | Tier | Concrete id | Why |
| --- | --- | --- | --- |
| `designer` | Fable | `claude-fable-5` | Design-only authoring. Fable is the maintainer's chosen fit for drafting design documents and surfacing open questions. |
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

## Procedure

### Agent-dispatch path (orchestrator / judge)

1. Read the role's row in the standing-policy table. For `designer` pass
   `model: fable`; for `builder` pass `model: opus`; for any other role omit the
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
who wants a designer job on Opus for one structurally subtle design writes
`model: opus` and it wins over the Fable default. On the Agent path the maintainer
names the override tier directly at dispatch; the table's assignment stays
canonical for subsequent dispatches.

## Composition with other skills

- The dispatch contract in `CLAUDE.md` § Dispatch contract names this skill as the
  lookup the orchestrator performs when invoking `Agent` (step 3).
- The fleet path's two functions live in `scripts/jobs/common.sh`; the handler
  `scripts/jobs/handlers/gardener-claude.sh` § *model selection* is the caller. The
  `gardener-worktree-test.sh` covers the `model:`/`role:` resolution.

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
