# Reference: cross-provider model catalog (Claude + Codex)

| Created | 2026-07-13 |
| Updated | 2026-07-13 |
| Author  | gardener (scholar) |
| Status  | Reference |

A catalog of the models the garden can drive across both agent backends — **Claude**
via the `claude` CLI, and **Codex** via the `codex` CLI — with each model's concrete
id, tier, supported thoughtfulness (reasoning-effort) levels, relative
capability/cost, and intended use. It exists to ground two consumers:

- the **model-selection policy** ([`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md)),
  the canonical role→model map, and
- the **bid/accept market + reputation ledger**
  ([`designs/gardener-bid-accept-market.md`](gardener-bid-accept-market.md) §2.2 Axis B,
  §3), which differentiates gardeners by *(role, model)* and keys reputation on a
  cost-per-acceptance estimate per model. The **cross-provider thoughtfulness axis**
  (§3 below) is the load-bearing output that lets a downstream reputation system key
  uniformly on `(provider, model, thoughtfulness)` regardless of backend.

**Provenance.** Every id below is transcribed from a live query, not from memory:

- Claude: [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) +
  `scripts/jobs/common.sh` (`resolve_model_tier`) for the garden's tier bindings, and
  the bundled `claude-api` skill's `shared/models.md` catalog (cached 2026-06-24) +
  this host's session context for ids, context windows, and rate-card pricing.
- Codex: `codex --version` (**codex-cli 0.144.3**), `codex login status` (logged in via
  ChatGPT), and `codex debug models` — the CLI's own **raw model catalog as JSON**,
  the authoritative selectable set for the authenticated account. Queried
  2026-07-13 on host `endolin-garden`.

Anything not directly verifiable is marked **[unverified]** rather than guessed.

---

## 1. Claude (Anthropic), via `claude`

Reasoning-effort levels across the Claude line: **`low` / `medium` / `high` / `xhigh`
/ `max`** (passed as `output_config.effort` on the API; surfaced in Claude Code as an
effort setting). Support is **per-model** — see the "Effort" column. `xhigh` was added
with Opus 4.7; `max` is unavailable on Haiku and pre-5 Sonnets; **Haiku 4.5 rejects the
effort parameter entirely**. Fable 5's thinking is **always on** (the `thinking`
parameter cannot be disabled); depth is still controlled by `effort`.

| Tier | Concrete id | Context / max output | Effort levels | Input/Output $ per MTok | Relative capability & intended use |
| --- | --- | --- | --- | --- | --- |
| Fable 5 | `claude-fable-5` | 1M / 128K | low·medium·high·xhigh·max (thinking always on) | $10 / $50 | Most capable widely-released model; hardest reasoning and long-horizon agentic work. Highest cost. |
| Opus 4.8 | `claude-opus-4-8` (1M-context variant `claude-opus-4-8[1m]`) | 1M / 128K | low·medium·high·xhigh·max | $5 / $25 | Top Opus tier; state-of-the-art agentic execution, knowledge work, memory. The garden's default Opus. |
| Opus 4.7 | `claude-opus-4-7` | 1M / 128K | low·medium·high·xhigh·max | $5 / $25 | Previous-generation Opus; highly autonomous. |
| Sonnet 5 | `claude-sonnet-5` | 1M / 128K | low·medium·high·xhigh·max | $3 / $15 ($2 / $10 intro through 2026-08-31) | Near-Opus quality on coding/agentic work at Sonnet cost; adaptive thinking on by default. |
| Sonnet 4.6 | `claude-sonnet-4-6` | 1M / 128K | low·medium·high·xhigh·max | $3 / $15 | Previous-generation Sonnet. **The `sonnet` tier in `common.sh` still binds here** — see §4. |
| Haiku 4.5 | `claude-haiku-4-5` (dated: `claude-haiku-4-5-20251001`) | 200K / 64K | **none** (effort param errors) | $1 / $5 | Fastest, cheapest; simple/speed-critical tasks. |

Also released but **not in the garden's tier map**: **Mythos 5** (`claude-mythos-5`) —
identical capabilities/pricing/API to Fable 5, but reachable only through Project
Glasswing; use `claude-fable-5` unless the org participates. Legacy ids
(`claude-opus-4-6`, `claude-opus-4-5`, `claude-sonnet-4-5`, …) remain selectable but
are not garden defaults.

### Garden role→model policy (Claude-only today)

The fleet resolves a Claude model per job from `role_default_model` / `resolve_model_tier`
in `scripts/jobs/common.sh`, mirrored in prose by
[`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md):

| Garden tier | Binds to | Roles defaulting here |
| --- | --- | --- |
| `fable` | `claude-fable-5` | *(none — no role defaults to Fable as of 2026-07-13)* |
| `opus` | `claude-opus-4-8` | `designer`, `builder` |
| `sonnet` | `claude-sonnet-4-6` | *(none — explicit `model: sonnet` pins only)* |
| `haiku` | `claude-haiku-4-5-20251001` | *(none)* |

Every other role omits a model and rides the fleet default. `designer` and `builder`
are the only two roles pinned by default (both Opus, per the maintainer's 2026-07-13
directive).

---

## 2. Codex (OpenAI), via `codex`

`codex debug models` renders the CLI's authoritative model catalog. The **selectable**
set (catalog `visibility: "list"`) for the ChatGPT-authenticated account on codex-cli
0.144.3 is four models, all agentic-coding tuned, all with a **272K-token context
window** and **text+image** input. Selection: `codex -m <slug>` / `codex exec -m <slug>`,
or `-c model=<slug>` (config `model` key). There is **no top-level `default_model`
field** in the catalog; models carry a `priority` (lower = higher in the picker), and
`gpt-5.6-terra` (priority 2) is the effective default.

Reasoning effort is set with **`-c model_reasoning_effort=<level>`** (config keys:
`model_reasoning_effort`, `model_reasoning_summary`, `model_verbosity`). Each model's
**default effort is `medium`**. Supported levels are **per-model** (below). The wider
enum baked into the binary is `minimal · low · medium · high · xhigh` plus catalog-only
`max` and `ultra`; **`minimal` is not offered by any current selectable model**, and
`ultra` ("maximum reasoning with automatic task delegation") is offered only by
`gpt-5.6-terra`.

| Slug (model id) | Display | Context / input | Default effort | Supported effort levels | Priority | Intended use |
| --- | --- | --- | --- | --- | --- | --- |
| `gpt-5.6-terra` | GPT-5.6-Terra | 272K / text+image | medium | low·medium·high·xhigh·max·**ultra** | 2 | Balanced agentic coding for everyday work (effective default). |
| `gpt-5.6-luna` | GPT-5.6-Luna | 272K / text+image | medium | low·medium·high·xhigh·max | 3 | Fast, affordable agentic coding. |
| `gpt-5.5` | GPT-5.5 | 272K / text+image | medium | low·medium·high·xhigh | 7 | Frontier model for complex coding, research, real-world work. |
| `gpt-5.4-mini` | GPT-5.4-Mini | 272K / text+image | medium | low·medium·high·xhigh | 23 | Small, fast, cost-efficient; simpler coding tasks. |

Effort-level semantics (from the catalog's own descriptions): `low` = fast/lighter
reasoning; `medium` = balanced; `high` = greater depth for complex problems; `xhigh` =
extra-high depth; `max` = maximum depth for the hardest problems; `ultra` (terra only)
= maximum reasoning **with automatic task delegation** (a super-max tier above `max`).

A hidden catalog entry, `codex-auto-review` (`visibility: "hide"`, priority 43), is
Codex's internal auto-approval **code-review** model, not a user-selectable coding
model; noted for completeness only.

**Cost.** The CLI is authenticated via **ChatGPT plan metering**, not an API key, so it
exposes **no per-token dollar price** for these models — spend is drawn against the
plan, not billed per token. **[unverified: per-token $]** For a dollar-normalized cost
(what the reputation ledger needs, §3), Codex usage must be run through OpenAI's
platform **API** with a rate card, or the plan cost amortized — the CLI catalog does
not surface it. `codex --oss` additionally allows local providers (lmstudio / ollama)
whose models are outside this catalog.

> The Codex catalog is **account- and version-scoped and server-resolved** (the CLI
> ships a `resolve-latest-model-info` path and the selectable set is fetched, not
> hard-coded). Re-run `codex debug models` on the target host to confirm the live set
> before pinning; do not treat this table as frozen.

---

## 3. Cross-provider thoughtfulness axis (the load-bearing mapping)

Both providers expose an ordinal reasoning-effort ladder. They share the middle four
rungs verbatim (`low`/`medium`/`high`/`xhigh`); the ends differ. The **unified
thoughtfulness axis** — what a `(provider, model, thoughtfulness)` reputation key
should range over — is:

```
minimal  <  low  <  medium  <  high  <  xhigh  <  max  <  ultra
(codex,           ── shared by both ──          (both)   (codex,
 legacy)                                                  terra)
```

| Unified level | Claude (`output_config.effort`) | Codex (`-c model_reasoning_effort`) | Notes |
| --- | --- | --- | --- |
| minimal | *(none — use `low`)* | *(enum-only; no current model)* | Below `low`; not live on either side today. |
| low | `low` | `low` | 1:1. |
| medium | `medium` | `medium` | 1:1; **default on both** (Claude API default is `high`, but Codex + garden lean `medium`). |
| high | `high` | `high` | 1:1. |
| xhigh | `xhigh` (Opus 4.7+, Sonnet 5/4.6, Fable 5) | `xhigh` | 1:1 where supported. |
| max | `max` (Fable 5, Opus 4.6+, Sonnet 5/4.6) | `max` (terra, luna) | 1:1 where supported. |
| ultra | *(none — closest is `max` + subagent delegation)* | `ultra` (terra only) | Codex super-max with **automatic task delegation**; no single-model Claude analog. |

**Keying rule for the reputation ledger.** Store the *unified* level, and record
**support**, not just request: a request for `xhigh` on Haiku 4.5 (no effort param) or
`max` on `gpt-5.5` (unsupported) is not comparable to the same level where the model
honors it — normalize an unsupported request down to the model's nearest supported
level and flag it, so `(provider, model, thoughtfulness)` arms stay apples-to-apples.
`ultra` and `minimal` are single-provider tails: an arm at `ultra` exists only for
`(codex, gpt-5.6-terra, ultra)`, and nothing at `minimal` is live on either side yet.

This lets `E[cost-to-acceptance]` (bid-market §3.3) be estimated per
`(provider, model, thoughtfulness)` arm uniformly: effectiveness is the acceptance
gate, and cost — **once Codex dollar cost is sourced (§2)** — normalizes to the same
dollars-and-duration units the ledger already defines for Claude.

---

## 4. Caveats & follow-ups

- **`sonnet` tier drift.** `resolve_model_tier` binds `sonnet` → `claude-sonnet-4-6`,
  but the current Sonnet is **Sonnet 5** (`claude-sonnet-5`). No role defaults to the
  `sonnet` tier today, so nothing runs on the stale id automatically, but a maintainer
  who pins `model: sonnet` gets the previous generation. Worth a one-line bump in
  `common.sh` + the tiers table in [`model-selection`](../skills/model-selection/SKILL.md)
  if Sonnet 5 is intended. Not changed here (out of scope for a reference doc).
- **Codex has no garden tier map yet.** The role→model policy is Claude-only. If/when
  the bid market differentiates gardeners by backend, a Codex tier binding (analogous
  to `resolve_model_tier`) and a Codex dollar rate card are prerequisites — see the
  cost caveat in §2.
- **Codex dollar cost is unresolved** under ChatGPT-plan auth (§2). The reputation
  ledger's dollar dimension needs an API-priced source for Codex before Codex arms can
  be cost-compared against Claude arms.
- **Both catalogs are living.** Claude ids here track `shared/models.md` (cached
  2026-06-24) + this host's context; Codex ids track a live `codex debug models` on
  codex-cli 0.144.3. Re-query both before relying on a specific id in automation.
