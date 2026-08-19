---
created: 2026-08-19
author: designer
---

# Design: a "muse" worker kind (Meta Muse Code / Muse Spark)

| Status | Proposed — design only, not yet a build |
| Job | `design-muse-worker-kind` |
| Base | garden `main2`, direct (no PR; CLAUDE.md § Conventions) |

## Problem

Meta shipped **Muse Code** (`https://developer.meta.com/ai/products/muse-code/`):
an agentic coding CLI (`curl -fsSL https://dev.meta.ai/install.sh | bash`) backed
by the **Muse Spark 1.2** model, reachable via the **Meta Model API** with
**OpenAI-SDK compatibility**. It is **in beta**, gated behind a `dev.meta.ai` API
login, and **metered per token in real dollars** (two tiers — Contributor
$0.10/$0.002/$0.20 per Mtok in/cached/out; Standard $1.25/$0.15/$4.25 per Mtok;
1M-token context). Its headline feature is that it *itself* coordinates multiple
agents on one task — "workers in parallel, reviewers in the background."

The question this design answers is whether — and precisely how — to add Muse as a
new **worker kind** in the fleet registry, mirroring the established shape
(`monk`/`cleric`/`hermit`/`mystic`/`fireworker`), and it names the decisions that
are genuinely the maintainer's to make rather than guessing them.

## Scope

In scope: the worker-kind registration surface (registry rows, handler, systemd,
scaler wiring, `set-workers` support, model routing, budget/cost accounting,
provisioning gate) and the two design tensions the job brief flags —
**integration shape** (native CLI vs OpenAI-compatible API) and **nested
orchestration**. Out of scope: any upstream Meta ToS negotiation, the beta-access
grant itself, and the follow-up build (which happens only after this is reviewed).

## Precedent this follows

Every non-Anthropic kind is already a solved instance of "add a metered,
credential-gated, OpenAI-compatible or CLI backend":

| kind | provider | agent_bin | handler | how it's driven |
| --- | --- | --- | --- | --- |
| `monk` (legacy `gardener`) | `anthropic` | `claude` | `handlers/monk-claude.sh` | native Claude CLI |
| `cleric` | `openai` | `codex` | `handlers/cleric-codex.sh` | Codex, real OpenAI endpoint |
| `hermit` | `local` | `codex` | `handlers/cleric-codex.sh` | Codex → local Ollama `/v1` |
| `mystic` | `moonshot` | `kimi` | `handlers/mystic-kimi.sh` | native Kimi CLI |
| `fireworker` | `fireworks` | `codex` | `handlers/cleric-codex.sh` | **Codex → custom OpenAI-compatible base_url + `FIREWORKS_API_KEY`** |

`fireworker` is the load-bearing precedent: a hosted, metered, real-dollar,
OpenAI-compatible provider driven through the **existing Codex harness** with
**zero new handler file** — just registry rows, a provider preflight, and a
`model_providers.<name>.base_url`/`env_key` pair in
`handlers/codex-provider-common.sh`. Muse's OpenAI-SDK compatibility puts it in
exactly this bucket.

## Decision 1 (central) — integrate Muse through the Codex harness as an OpenAI-compatible provider, **not** the native `muse` CLI

**Recommendation: mirror `fireworker`.** Point Codex at the Meta Model API's
OpenAI-compatible base URL with a Muse-specific `env_key`, and register `muse` as
a Codex-harness kind (`agent_bin: codex`, `handler: handlers/cleric-codex.sh`).

Why the API path over the native `muse` CLI:

1. **It sidesteps the nested-orchestration tension by construction** (Decision 2).
   The native CLI *is* Muse's multi-agent orchestrator; the OpenAI-compatible API
   exposes Muse Spark as a plain completions model that Codex — the garden's
   harness — drives single-agent. The garden's own orchestration (job board,
   gardening state machine, panel review) stays the sole authoritative
   orchestrator, with full cost/timing/sub-task visibility.
2. **Less new surface, no new beta binary to sandbox/audit.** The native CLI is a
   new, beta, third-party binary installed by piping a remote script to `bash`
   (`curl … | bash`) — a supply-chain and sandboxing burden. The Codex path reuses
   a harness already audited and running for four kinds.
3. **It is the proven pattern.** `fireworker` demonstrates a metered hosted
   OpenAI-compatible provider end to end (preflight, key handoff, rate card,
   reputation arm, tests). Muse re-treads it.

The cost of the API path is that we **give up Muse's own worker/reviewer
orchestration**. Per the job brief's own framing, that is **desirable to give up**
here, not a loss: a second orchestrator running invisibly inside a claimed job
would double up on the garden's panel/fix-loop and hide its spend. If a future use
case genuinely wants Muse's multi-agent mode, that is a separate, later design
(see Open questions), not this kind.

**Rejected for now: the native `muse` CLI** (a `handlers/muse-*.sh` mirroring
`mystic-kimi.sh`). It mirrors the existing pattern most literally and would be the
choice if Muse had *no* OpenAI-compatible API — but it drags in the beta binary,
the `curl | bash` install, and Muse's own orchestrator. Keep it named as the
fallback if the API path proves inadequate (e.g. the API omits agentic
tool-calling that Codex needs).

## Decision 2 — constrain garden jobs to single-agent Muse; multi-agent mode is out of scope

The garden already owns orchestration. A Muse instance spawning parallel workers +
background reviewers *inside* one gardener-claimed job is invisible to the fleet
(cost, timing, sub-task state) and duplicates the panel/fix-loop. **Decision:
`muse` runs single-agent for garden jobs.** The Codex-harness integration
(Decision 1) delivers this automatically — Muse Spark is consumed as a completions
model, not as its own agent runner. No knob is needed to "turn off" multi-agent
mode because the API path never turns it on. Whether Muse's multi-agent mode is
ever usable within a garden job's bounds is left as an **explicit open question**,
not papered over.

## Decision 3 — no automatic routing; explicit-model-only, disabled by default, provisioning-gated

Because Muse is **metered in real dollars** (unlike the flat-rate Claude Max
accounts the fleet mostly runs on), `muse` follows the `fireworker`/`mystic`
posture, not the `monk` posture:

- **`role_default_model muse <role>` returns empty** for every role — there is no
  safe catalog default for a hosted, beta, changing, priced fleet (identical to
  `fireworker`'s branch). A `muse` worker runs only a job that carries an explicit
  `model: meta/<wire-id>`.
- **No automatic producer emits it.** `post-job.sh`/`post-plan.sh` stamp
  `tier: mentor` and never pin a provider; a `muse` worker is claimable by such a
  job only if a `muse` worker is the live provider AND the job's model resolves to
  a `meta/*` id — which the automatic path never sets. In practice muse is
  reached only by a hand-posted or explicitly-pinned job, exactly like
  `fireworker` today (`skills/model-selection/SKILL.md`: some tiers are
  manual-only/opt-in).
- **Count 0 by default; `set-workers.sh muse N` is refused until the backend probe
  passes** on the declaring host (the `gnome-backend-verified-autotune` gate), with
  `GARDEN_FORCE_DECLARE=1` the staging override.

**Tier placement:** Muse Spark 1.2 (1M context, priced above Kimi/Fireworks on the
Standard tier) is a heavy model → register it at **mentor** in
`model-tier-inventory.tsv`. But mentor is a multi-provider *automatic* ceiling;
placing `meta/muse-spark-1.2` at mentor does **not** make it automatically
selected (the choke points never pin a `meta/*` id), so this is a classification
for when a job explicitly asks, not an automatic escalation path. It must **not**
become a reroute target (leave it off `role_tier_floor` escalation, like the other
paid non-Claude kinds).

## Decision 4 — budget guardrails ride the existing per-call dollar ledger

Muse spend is genuinely **per-call metered in real dollars**, so it is covered by
the same mechanism as `fireworker`/`mystic`, not a new one, and it must **not**
become an unmetered worker class that bypasses admission:

- Per `designs/live-budget-admission.md` §3, the non-Claude pools are "genuinely
  per-call metered in real dollars, so the `usage/` ledger's dollar rows are the
  right source for them." The `muse` handler writes a per-invocation
  `GARDEN_USAGE_FILE` row (input/output/cached tokens, and — because Muse returns
  real prices — priced dollars where available), exactly as the codex and kimi
  handlers do. That row flows into the CostRecord ledger the budget-admission gate
  and `cost.sh` read.
- Because there is no automatic routing (Decision 3) and no flat-rate pool, a
  `muse` worker cannot silently accrue background spend the way a foreman
  `claude -p` can — every `muse` job is an explicit, budgeted act.
- **Muse's published, transparent per-token rate card is a genuine advantage
  for budget attribution, not just a risk to guard against.** The fleet's
  dominant cost source — flat-rate Claude Max accounts — has no real per-job
  price at all: the `journal/usage/*.jsonl` `total_cost_usd` field is notional
  list-price accounting that overstates true spend by roughly 8.7x (the
  garden actually runs on two flat $200/mo subscriptions), so most job costs
  in the ledger are an estimate, not a fact. Muse's published Contributor/
  Standard per-Mtok rates give every `muse` job an **actual, auditable dollar
  cost**, the same real-metering property `fireworker`/`mystic` already have.
  This makes `muse` jobs useful data points for calibrating the notional
  ledger against reality, not just another cost center to bound.
- **The Contributor-vs-Standard pricing tier is a data-governance decision, not a
  cost optimization** (see Open questions): the Contributor tier is ~12× cheaper
  *because Meta uses the submitted data to improve its products*. Sending a
  maintainer's or a fork's source through a training-eligible tier is a privacy
  choice only the maintainer may make. The design **defaults to the Standard
  tier** (data not used for training) and treats Contributor as an explicit,
  per-instance opt-in, never the default.

## Decision 5 — credential/access gate follows the `FIREWORKS_API_KEY` pattern

Mirror the established metered-provider credential shape:

- **Env var:** a Muse-specific API key, provisionally **`META_API_KEY`**, seeded
  into the container creation environment and handed to the user manager by
  `scripts/systemd/seed-api-key-handoff.sh` (extend its
  `ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY` allowlist with the exact
  chosen name). **Exact name is an open question** — confirm what the Meta Model
  API / OpenAI-compatible client actually reads (it may be `META_API_KEY`,
  `LLAMA_API_KEY`, or an OAuth credential file written by the `dev.meta.ai` login
  rather than a bearer key at all).
- **Base URL:** `GARDEN_META_BASE_URL` (default the Meta Model API OpenAI-compatible
  endpoint — **exact URL is an open question**; the product page says "point your
  existing OpenAI SDK compatible client at Meta Model API" but does not print the
  base URL). Wire it into `handlers/codex-provider-common.sh` as
  `model_providers.meta.base_url` + `model_providers.meta.env_key`, mirroring the
  Fireworks block.
- **Backend probe:** add a `meta`/`muse` case to `worker_backend_probe`
  (`_worker_backend_probe_dispatch`) — a new `muse_provider_preflight` alongside
  `fireworks_provider_preflight`: `command -v codex` + `META_API_KEY` non-empty +
  a bounded bearer `curl` to `$GARDEN_META_BASE_URL/models` (2xx pass, 429/503
  retryable — the scaler hysteresis already absorbs those). This is the same code
  that gates a real job, so provisioning and job-time can never drift.
- **Beta access is a real precondition outside the garden's control.** The probe
  proves a *credential is present*; it cannot prove Meta has *granted beta access*
  to that account. Muse Code is beta and may require a waitlist/approval at
  `dev.meta.ai` before an API login yields a usable key. Surface this in the
  operator flow: `set-workers.sh muse N` will refuse until a real (beta-approved)
  credential is seeded, and `GARDEN_FORCE_DECLARE=1` is the "staging ahead of the
  grant" override — never a way to fake the grant.

## Registry surface (the build's concrete inventory)

Mirror `fireworker`'s footprint exactly. One row per file; no new service, no new
journal schema.

| File | Change |
| --- | --- |
| `scripts/jobs/common.sh` — `worker_kind_field` | add a `muse` case: `handler=handlers/cleric-codex.sh`, `agent_bin=codex`, `provider=meta`, `unit=garden-muse@`, `count_key=muses`, `state_ns=muses`, `label=garden-muse`. |
| `scripts/jobs/common.sh` — `worker_kinds()` | append `muse`. |
| `scripts/jobs/common.sh` — `canonical_worker_kind` | add `muse` to the known-v2 set (`monk\|cleric\|hermit\|mystic\|fireworker\|muse`). |
| `scripts/jobs/common.sh` — `role_default_model` | add a `muse)` branch returning empty for all roles (no safe default; explicit `model:` only). |
| `scripts/jobs/common.sh` — `resolve_model_tier` | add a `meta)` provider case: accept a `meta/*` selector iff `_model_classify meta` admits it (mirror the `fireworks)` clause). |
| `scripts/jobs/common.sh` — `_worker_backend_probe_dispatch` | add a `meta)` case calling `muse_provider_preflight` (or a generic OpenAI-compatible probe against `$GARDEN_META_BASE_URL/models`). |
| `scripts/jobs/handlers/codex-provider-common.sh` | add `muse_provider_preflight` + the `model_providers.meta.{base_url,env_key}` config block (mirror the Fireworks block); teach `cleric-codex.sh`'s provider dispatch the `meta` provider. |
| `scripts/jobs/model-tier-inventory.tsv` | add `meta	meta/muse-spark-1.2	mentor` (exact wire id TBD — open question). |
| `scripts/jobs/model-routing-defaults.tsv` | add a `meta` row: reviewed exact `meta/*` selector(s), **no fleet default** (like fireworks). |
| `scripts/jobs/set-muses.sh` | new thin wrapper → `exec set-workers.sh muse "$@"` (mirror `set-fireworkers.sh`). |
| `scripts/systemd/seed-api-key-handoff.sh` | add the chosen key name (e.g. `META_API_KEY`) to the handoff allowlist. |
| systemd | none new — `garden-muse@N.service` renders from the shared `garden-worker@.service.in` template via the `unit`/`label` registry fields; `install-units.sh scale muse N` and the existing scaler tick reconcile it (already generic over `worker_kinds`). |
| `scripts/jobs/comment-provenance.sh` | ensure the `meta`/`muse` provider labels in the GitHub-comment provenance footer (mirror fireworker). |
| `scripts/jobs/reaper.sh`, bulletin, proxy, metrics | already iterate `worker_kinds`/registry helpers — verify each enumerates `muse` with no literal-kind special-casing (the monk design's standing requirement). |
| `scripts/jobs/test/` | extend `worker-spine-kinds-test.sh`, `backend-autotune-test.sh`, `scaler-desired-count-test.sh`, `api-key-handoff-test.sh`, and add a `muse-harness-test.sh` mirroring `fireworker-harness-test.sh`. |
| docs | `skills/model-selection/SKILL.md`, `designs/provider-model-catalog.md`, and a `context/operations/meta-muse.md` operator page (mirror `context/operations/fireworks.md`). |

## Naming

`muse` fits the fleet's solitary/archetype vocabulary (monk, cleric, hermit,
mystic) and echoes the product, the way `mystic`↔moonshot and
`fireworker`↔fireworks already do. The provider token is `meta` (the Meta Model
API), keeping worker-kind and provider separate as the registry requires. The build
must first assert **no existing `muse` token/path/unit/role collision** in the
repo, journal, and any host's rendered units (the monk design's naming-collision
gate). A quick check found none in `roles/`, `skills/`, or the registry.

## Alternatives considered

1. **Native `muse` CLI kind** (`handlers/muse-codex`-style, mirroring
   `mystic-kimi.sh`). Most literal mirror of the existing pattern; the right choice
   only if there were no OpenAI-compatible API. Rejected as the default because it
   imports a beta `curl | bash` binary and Muse's own orchestrator (Decision 1/2).
   Retained as the named fallback.
2. **A bare OpenAI-SDK API client** (a fresh lightweight handler, no Codex).
   Smallest wire surface, but diverges from how every other kind is driven, forgoes
   Codex's agentic tool-calling/worktree plumbing, and re-implements the
   preflight/metering/reputation glue Codex already gives fireworker. Rejected.
3. **No new kind — route Muse through `fireworker`.** Tempting since both are
   Codex-custom-provider metered kinds, but pooling them collapses two distinct
   credentials, endpoints, rate cards, and reputation arms (the design deliberately
   keeps these separate, cf. the mystic-vs-fireworks-K3 note). Rejected.
4. **Enable Muse's multi-agent mode inside a garden job.** Rejected for garden
   jobs (Decision 2); left as an open question for a separate design.

## Open questions (for the maintainer — do not guess these)

1. **Beta access / ToS.** Is a `dev.meta.ai` beta grant available for the fleet's
   account, and does Meta's beta ToS permit an automated agent fleet and sending
   fork/maintainer source to the Meta Model API at all? This is a precondition the
   garden cannot satisfy itself.
2. **Contributor vs Standard pricing tier.** Standard ($1.25/$4.25 per Mtok, data
   not used for training) is the design default. Is the ~12× cheaper Contributor
   tier ($0.10/$0.20, *data used to improve Meta's products*) ever acceptable for
   this fleet's code? This is a data-governance call, not a cost one.
3. **Exact credential mechanism and env var.** Does the OpenAI-compatible client
   read a bearer `META_API_KEY` (name?), or does the `dev.meta.ai` login write an
   OAuth credential file (like Claude Code's `.credentials.json`)? The probe and
   `seed-api-key-handoff.sh` allowlist depend on the answer.
4. **Exact Meta Model API base URL and the Muse Spark wire model id(s).** The
   product page states OpenAI-SDK compatibility but prints neither the base URL nor
   the exact model id string. Both are required for the routing table and the
   Codex `base_url` config.
5. **Does Muse's OpenAI-compatible API expose agentic tool-calling** (function
   calling / tool use) that Codex needs to run a coding job, or is it
   chat-completions only? If the latter, the native-CLI fallback (Alternative 1)
   becomes necessary.
6. **Is Muse's multi-agent mode ever wanted inside the garden?** If yes, that is a
   separate design (an orchestrator-in-a-job with cost/state visibility), not this
   kind.

## Phased implementation (for the follow-up build, after review)

0. **Resolve the blocking open questions (1–5).** No build starts until beta
   access, the tier decision, the credential mechanism, the base URL, and the wire
   model id are known. Items 3–5 in particular gate the handler.
1. **Registry + probe, disabled everywhere.** Add the `worker_kind_field`/
   `worker_kinds`/`canonical_worker_kind`/`role_default_model`/`resolve_model_tier`
   rows, the `meta` provider block and `muse_provider_preflight` in
   `codex-provider-common.sh`, the inventory/routing rows, `set-muses.sh`, and the
   key-handoff allowlist entry. No host declares `muses > 0`; runtime behavior
   unchanged. Land the harness/backend-autotune/spine/key-handoff tests green.
2. **Single-host provisioning trial.** On one host with a real beta credential,
   `set-workers.sh muse 1` (probe passes), post one explicit
   `model: meta/<wire-id>` job, confirm: the job claims/completes through the Codex
   spine as `muse/meta`; a per-call priced `usage/` row lands; the provenance
   footer, reaper, bulletin, proxy, and metrics all enumerate `muse`; the budget
   ledger sees the dollars.
3. **Documented enable path, still opt-in.** Ship `context/operations/meta-muse.md`
   and the `skills/model-selection` note. `muse` stays count-0-by-default and
   explicit-model-only; no automatic producer emits it. Revisit multi-agent mode
   (open question 6) only as a later, separate design.
