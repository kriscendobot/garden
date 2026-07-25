---
created: 2026-06-10
updated: 2026-07-25
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

**No implicit Fable — the standing invariant (2026-07-25, via the liaison).** Fable
is **available only on an explicit per-job `model: fable` pin**; it is **never a
default, a fallback, or an implicit choice** for any role, kind, or producer going
forward. The role→model map above already reflects this (no role default resolves to
Fable), and the `worker-spine-kinds-test.sh` § *POLICY INVARIANTS* block now asserts
it as a drift guard: if a future edit re-pins any role on any worker kind to the
Fable id, that test fails. Explicit-request precedence is preserved in both
directions — a maintainer who writes `model: fable` on one job still gets Fable
(§ Overrides), and standing schedules that explicitly carry `model: fable` (the endo
press-driver campaigns) are honored, because those are explicit requests, not
implicit defaults.

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

| Tier | Concrete id | Notes |
| --- | --- | --- |
| `fable` | `claude-fable-5` | **Explicit-only** — a valid per-job `model: fable` pin, but never a role default (§ Standing role policy). |
| `opus` | `claude-opus-4-8` | The default for `designer`/`builder`. |
| `sonnet` | `claude-sonnet-4-6` | |
| `haiku` | `claude-haiku-4-5-20251001` | |

A value that is already a concrete `claude-*` id passes through verbatim. An
unknown or blank value resolves to empty, and the caller falls back to the fleet
default (no `--model`) — a typo must never crash a tick. The `fable` tier still
**binds** (so an explicit pin is honored); it is simply no longer any role's
default.

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

### The `local` provider (the hermit backend) + the journal-backed routing table

The third provider is `local` — the **hermit** worker kind, a codex-cleric pointed
at the box's own Ollama endpoint (worker-kind registry in `common.sh`). Unlike the
two paid providers, the local box's served-model set is **operational reality that
changes as models come and go** (a box pulls a new tag; an old one is dropped), so
the garden does **not** hardcode it. Instead, **which provider owns a `model:` id,
and each provider's fleet-default model, are DATA** read from a journal-backed
**model-routing table**:

- **Seed + fail-safe fallback** — `scripts/jobs/model-routing-defaults.tsv` (tracked
  on `main2`, always present in a fresh checkout). One TSV row per provider:
  `<provider>\t<patterns>\t<fleet-default>`. `patterns` are space-separated shell
  globs matched against a job's resolved `model:` value; a leading `!` marks an
  EXCLUDE glob. A model matching no provider's patterns is **unpinned** (any kind may
  claim it). This is the durable seed and the safe fallback if the journal file is
  unreadable — a missing file never opens the claim path to mis-routing.
- **Per-instance override** — `config/model-routing` on `journal2`, written by
  `scripts/jobs/set-model-routing.sh` (CAS-pushed, **no deploy needed** — a gardener
  re-syncs its clone on its next claim and picks it up). Takes precedence over the
  tracked seed and is read as a **complete table** (the helper seeds a fresh journal
  file from the tracked default, then applies the edit, so it is never partial).

The reading is in `common.sh`: `_model_classify <provider> <id>` (the deterministic
backend-fit predicate the claim path and `resolve_model_tier`'s concrete-id
classification use) and `model_routing_default <provider>` (the fleet-default a
worker rides when a job names no `model:`). `resolve_model_tier` still **binds**
short tier aliases to concrete ids in code (a version bump stays one edit); only the
concrete-id **classification** and the **defaults** are data.

**Current reality (2026-07-14):** garden2's box serves **only qwen** (qwen3.6), so
the seeded table routes `qwen*` → `local` and defaults `local` → `qwen3.6`. The
former `gpt-oss:*` → local mapping is **retired**: a `gpt-oss:*` job now matches no
provider (it is unpinned), *not* auto-local — "hermits only respond to qwen at this
time." To change this (a new served tag, a renamed tier), edit the **journal table**
via `set-model-routing.sh`, not the code:

```sh
scripts/jobs/set-model-routing.sh local 'qwen* mistral*' qwen3.6   # add mistral to the hermit set
scripts/jobs/set-model-routing.sh --remove <provider>              # drop a provider row
scripts/jobs/set-model-routing.sh --show                           # print the effective table
scripts/jobs/set-model-routing.sh --validate [file]                # validate before/without committing
```

### The `moonshot` provider (the mystic backend) — the explicit-only K3 trial lane

The fourth provider is `moonshot` — the **mystic** worker kind, a hosted Moonshot
**Kimi K3** pool driven through the official Kimi Code CLI (worker-kind registry in
`common.sh`; handler `handlers/mystic-kimi.sh`; ops runbook
[context/operations/kimi-k3.md](../../context/operations/kimi-k3.md)). It is the
garden's **conservative, explicit-only reputation lane for low-risk, reversible,
tool-verifiable work** — deliberately narrow, and grounded in evidence rather than a
blanket default:

- **Research grounding.** The researcher brief `research-harness-kimi-k3` and the
  scholar ingest `scholar-fireworks-kimik3-fable` established that K3 is **hosted-only**
  (2.8T MoE, ~1.5 TB even at Q4 — the local box is off by >10×, so no hermit path),
  OpenAI-compatible at `api.moonshot.ai/v1`, and priced ~1/3 of Fable. "Fable" in that
  research is **Claude Fable 5** as a routing partner, not a serving technique — adding
  a K3 arm realizes the "K3+Fable mixture" the source described. The **live canary**
  `kimi-k3-canary-20260725-f` proved the harness end to end: a mystic worker on
  `moonshot / kimi-k3 / medium`, work_class **`gardener:s`**, tool-verified file
  create → readback → remove, `accepted: true`, reputation arm scoped to
  `worker_kind: mystic` / `provider: moonshot` / `model: kimi-k3`.

- **Zero-default, explicit-only.** `resolve_model_tier moonshot <t>` binds **no short
  alias** — only the exact concrete `model: kimi-k3` selects it (an abbreviated
  `model: k3` resolves to empty on purpose). `role_default_model mystic <role>` is
  **empty for every role**: no design/build or other role default can ever route to
  K3. The mystic pool also **ships disabled** (`set-mystics.sh 0`) and is scaled only
  by a maintainer for a bounded trial — landing the harness does not arm it.

- **Never a high-stakes route.** The claim-path eligibility filter
  (`claim-job.sh` § 1.3, `job_eligible_for_kind`) accepts a job for the mystic pool
  **only** when it carries the exact `model: kimi-k3` pin **and** its `role:` is not
  `designer`/`builder`; an unpinned job, a short-alias job, and any design/build job
  are all refused. So an explicit K3 request rides in for **gardener/researcher/
  scholar-style** work (the `gardener:s`, `researcher:*`, `scholar:*` reversible,
  tool-verifiable classes the canary exercised) and is structurally barred from
  design, build, merges, and external side effects.

- **Trial classes (guidance, not a routing rule).** When choosing whether to *pin* a
  job to `model: kimi-k3` for reputation-building, prefer **low-risk, reversible,
  tool-verifiable gardener/research work**: file-scoped chores, read-and-report
  research/scholar briefs, and other tasks a tool result can confirm and a peer can
  cheaply undo. Do **not** pin K3 on design, build, merge/ferry, or any job whose
  effect is hard to reverse — those stay on Opus (designer/builder) or the fleet
  default. K3 remains zero-default: this is a lane for *explicit* opt-in, never an
  automatic assignment.

To scale a bounded trial (leader host, after the ops runbook's key + probe steps):

```sh
scripts/jobs/set-mystics.sh 1   # arm exactly one mystic worker for a bounded canary
scripts/jobs/set-mystics.sh 0   # return the pool to zero after the trial
```

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
  resolution (designer/builder → Opus, explicit `model: fable` override); the mystic
  handler is `handlers/mystic-kimi.sh`. `worker-spine-kinds-test.sh` covers the
  provider-scoped tiers, the per-kind role defaults for all four backends, the mystic
  claim-eligibility gate, and the § *POLICY INVARIANTS* drift guard (no role default
  on any kind resolves to Fable; K3 zero-default; K3 binds under no non-moonshot
  provider).
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
- _2026-07-14_: **model routing made data-driven from journal state** (job
  `model-routing-journal-state-hermit-qwen`, maintainer-directed). The
  provider-classification (which backend may claim a `model:` id) and the per-provider
  fleet defaults moved out of hardcoded `case` arms into a journal-backed
  model-routing table (tracked seed `scripts/jobs/model-routing-defaults.tsv` +
  per-instance `config/model-routing` override, edited via `set-model-routing.sh`).
  Seeded to the current reality: the `local`/hermit provider recognizes the **qwen**
  family and defaults to **qwen3.6**, retiring the stale `gpt-oss:*` → local mapping
  (a gpt-oss job is now unpinned, not auto-local). Tests: `model-routing-test.sh`
  (classification, defaults, override, fail-safe, the edit helper) and the updated
  `worker-spine-kinds-test.sh` eligibility cases.
- _2026-07-25_: **no-implicit-Fable invariant + explicit K3 trial lane documented**
  (job `tune-fable-k3-model-assignments`, maintainer-directed). Audited every live
  assignment surface (roles, `role_default_model`/`resolve_model_tier`, the
  claim-path eligibility gate, the model-routing seed, foreman/scaler, schedules,
  docs, tests) and confirmed the code policy already carries the 07-13 walk-back — no
  role default on any of the four worker kinds resolves to Fable. Made the invariant
  **explicit and drift-guarded**: this skill now states Fable is explicit-only, and
  `worker-spine-kinds-test.sh` § *POLICY INVARIANTS* fails if any role default on any
  kind ever re-binds to the Fable id. Documented the pre-existing **mystic/moonshot
  Kimi K3** backend as the conservative, **explicit-only, zero-default** trial lane
  for low-risk/reversible/tool-verifiable gardener/research work — grounded in
  `research-harness-kimi-k3`, `scholar-fireworks-kimik3-fable`, and the accepted live
  canary `kimi-k3-canary-20260725-f` (work_class `gardener:s`). No routing/eligibility
  code changed (the machinery already expresses the lane: mystic claims only exact
  `model: kimi-k3` and refuses designer/builder). Also fixed a pre-existing staging
  gap in `gardener-worktree-test.sh` (it did not copy `quota-panel.sh`, which
  `common.sh` now sources, so the model-selection assertions could not run). The
  standing schedules that explicitly pin `model: fable` (the endo press campaigns) are
  left untouched — explicit requests, honored by policy, not implicit defaults.
