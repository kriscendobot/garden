# Reference: cross-provider model and harness catalog

| Created | 2026-07-13 |
| Updated | 2026-09-01 |
| Author  | gardener, gardener (scholar) |
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

## Harness x provider matrix

This is the top-level map of which agent harness can drive each inference provider.
The provider is the API, billing, and reputation boundary, not necessarily the model
author. For example, a Kimi model served by Fireworks remains on the `fireworks`
row. A cell records technical reach and integration maturity, not automatic job
eligibility: the closed model inventory, provider constraints, explicit-model-only
rules, credentials, and worker counts still gate every run.

| Inference provider | Claude Code (`claude`) | Codex CLI (`codex`) | Kimi Code (`kimi`) | OpenCode (`opencode`) |
| --- | --- | --- | --- | --- |
| Anthropic | ✅ `monk` / `gardener` | — no Anthropic protocol | 🔬 native Anthropic adapter | 🔬 landed `opencode-anthropic` probe lane |
| OpenAI | — no OpenAI protocol | ✅ `cleric` | 🔬 native OpenAI Responses adapter | 🔬 native provider mapping |
| Local Ollama | 🔬 Ollama Anthropic Messages compatibility | ✅ `hermit` | ❓ generic OpenAI-compatible route | 🔬 documented Ollama integration |
| Ollama Cloud | 🔬 Ollama Anthropic Messages compatibility | 🔬 Ollama Responses compatibility | ❓ generic OpenAI-compatible route | 🔬 documented Ollama integration |
| Moonshot | — no Anthropic protocol | ❓ OpenAI compatibility does not establish Codex Responses parity | ✅ `mystic` | 🔬 `moonshotai` provider mapping |
| Fireworks | — no Anthropic protocol | ✅ `fireworker` | ❓ generic OpenAI-compatible route | ❓ custom OpenAI-compatible route |
| OpenRouter | 🔬 Anthropic Messages compatibility | ✅ `openrouter` | ❓ generic OpenAI-compatible route | 🔬 provider-catalog route |
| Google Gemini | — Claude Code's Google route serves Claude, not Gemini | — Gemini's compatibility surface does not provide Codex Responses parity | 🔬 native Gemini adapter | 🔬 native `google` provider mapping |

Legend:

- ✅ **Garden-integrated:** a worker kind and handler route exist. The lane may still
  be disabled, explicit-only, or awaiting credentials and a bounded canary.
- 🔬 **Direct route to probe:** the harness or provider documents a direct adapter,
  or a garden probe exists, but this provider/harness pair is not a production lane.
- ❓ **Plausible, unproved route:** only a generic compatibility adapter connects the
  pair. Auth, streaming tools, resume, error classification, transcript capture, and
  cost accounting still need an end-to-end probe.
- — **No supported route:** the required API protocol is absent or, for Codex, the
  available compatibility surface does not establish Responses API parity.

The ✅ cells are detailed in the provider sections below. The OpenCode column and
the one-kind-per-provider safety boundary come from
[`opencode-alternate-harness.md`](opencode-alternate-harness.md); the landed
Anthropic probe and its remaining live-canary gap are recorded in
[`context/operations/opencode-anthropic.md`](../context/operations/opencode-anthropic.md).
The unintegrated Ollama routes are deliberately kept at 🔬 or ❓: Ollama documents
Claude Code, Codex, and OpenCode integrations for local and cloud models, but the
garden currently has only the local Codex `hermit` lane. In particular, the Cloud
route needs its own paid-provider identity, credential handoff, quota handling, and
rate card rather than inheriting `provider: local`.

External compatibility evidence is provider-owned: Ollama's
[Anthropic](https://docs.ollama.com/api/anthropic-compatibility) and
[OpenAI](https://docs.ollama.com/api/openai-compatibility) API surfaces plus its
[three-harness launch guide](https://ollama.com/blog/launch), Kimi Code's
[native and compatibility provider types](https://moonshotai.github.io/kimi-cli/en/configuration/providers.html),
OpenRouter's
[Claude Code integration](https://openrouter.ai/docs/guides/coding-agents/claude-code-integration),
and Gemini's
[Chat Completions compatibility surface](https://ai.google.dev/gemini-api/docs/openai).
These sources establish a route, not garden readiness, which is why undocumented
generic pairings remain ❓ and direct but unintegrated pairings remain 🔬.

## Dispatch vocabulary (current)

The executable closed inventory is `scripts/jobs/model-tier-inventory.tsv`.
Its tiers are: mentat = Fable (manual-only), mentor = Anthropic Opus 5, OpenAI
Sol, Moonshot Kimi K3, and Fireworks Kimi K3 / GLM 5.2 (the multi-provider automatic
ceiling), minion = Opus 4.x, the OpenAI/Codex models below Sol, Fireworks Deepseek
V4 Pro, and OpenRouter DeepSeek V3 free (the automatic fallback), and myrmidon = the
expedient Sonnet/Haiku/local models plus Fireworks gpt-oss-120b and OpenRouter Llama
3.3 70B free. The OpenRouter minion/myrmidon rows are explicit-model-only (no
automatic job reaches them). Unknown ids are unclassified, not wildcarded. All
automatic producer output has durable `tier: mentor` intent with no concrete model pin,
so a mentor job is claimable by whichever provider's worker is live (monk on Opus 5,
cleric on Sol, mystic on Kimi, fireworker on Fireworks Kimi/GLM); only
`post-manual-job.sh` may create a Fable job.

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

### 2.5 Local (Ollama), the `provider: local` codex-cleric (`hermit`)

The **local** provider is the paid-OpenAI codex driven against an **on-box Ollama
`/v1` endpoint** (`http://127.0.0.1:11435/v1`) instead of ChatGPT — the `hermit`
worker kind (registry provider `local`, `resolve_model_tier local`). Model ids are the
**served Ollama tags**, not paid slugs; the tier map's short names track the guide's
two picks. Grounded in `context/operations/local-inference-amd.md` (host: AMD Ryzen AI
Max+ 395 / Radeon 8060S, gfx1151, 125 GiB unified memory).

| Tier | Served tag | Type | ~size | tg128 t/s (measured) | Intended use |
| --- | --- | --- | --- | --- | --- |
| `20b` | `gpt-oss:20b` | MoE (MXFP4) | ~12 GB | ~72 | Interactive everyday hermit default. |
| `120b` | `gpt-oss:120b` | MoE (MXFP4) | ~63 GB | ~51 | Flagship this box runs; heavier roles (needs GPU budget ≥ ~96 GB). |

**Cost — very cheap, NOT free (guide §5).** Local inference has no per-token invoice,
only electricity + amortized hardware. Pricing it at literally $0 would make one lucky
local success look infinitely efficient and starve exploration of the paid arms it
should be measured against, so the reputation/bid cost model prices a local arm on an
**amortized** basis:

| Provider | $ per MTok (in/out, flat) | `price_basis` | Derivation |
| --- | --- | --- | --- |
| `local` | **1.50 / 1.50** | `amortized` | ~$2,000 box / 3-yr life @ ~30% duty ≈ $0.25/hr; at ~50 tok/s ≈ $1.40/MTok; power (~120 W @ 50 tok/s, $0.30/kWh) ≈ $0.20/MTok. Combined ≈ **$1–2/MTok**, vs paid $5–50/MTok. |

Local has no input/output asymmetry (one flat rate). Replace the box price and kWh
rate with the measured values (and `amd-smi` power draw) when known; the figure is
seeded illustratively (guide §5). This row is the canonical rate for the `local`
provider that the token-cost ledger (§3, not yet wired) will apply, and that a journal
`reputation/rate-card.md` row mirrors per-instance.

### 2.6 Moonshot Kimi K3, hosted through the Kimi Code CLI (`mystic`)

The `mystic` worker kind uses the official Kimi Code CLI headless interface
(`kimi --prompt`, with `kimi --continue` on a requeue), not Codex's
OpenAI-compatible adapter. It supplies `MOONSHOT_API_KEY` only to Kimi's supported
temporary `KIMI_MODEL_*` configuration channel, maps garden selector `kimi-k3` to
Kimi Code's documented wire model id `k3`, and gives every base a private persisted
`KIMI_CODE_HOME`. The pool has no routing default: only
an exact `model: kimi-k3` job can claim it. It has no design/build default and is
not eligible for builder or designer jobs. It is landed disabled until a maintainer
deliberately sets a positive Mystic count.

**Provisional rate card.**

| Provider | Concrete id | Endpoint | Advertised context | Cached input / fresh input / output $ per MTok | `price_basis` |
| --- | --- | --- | --- | --- | --- |
| `moonshot` | garden `kimi-k3` -> Kimi Code `k3` | `https://api.moonshot.ai/v1` | 1M [unverified] | $0.30 / $3.00 / $15.00 [provisional, unverified] | `provisional` |

**Compatibility boundary.** The Kimi Code CLI's documented prompt, resume,
temporary-model, and `KIMI_CODE_HOME` interfaces are the supported harness surface.
The endpoint, authentication shape, advertised 1M context, and prices still require
a bounded live canary before the pool is enabled. It must not become a default for
design, build, or another high-stakes role.

---

### 2.7 Fireworks GLM 5.2, through the Codex-compatible `fireworker`

The closed inventory (`scripts/jobs/model-tier-inventory.tsv`) contains four
reviewed Fireworks selectors, one per tier where a live fit was verified against the
provider's own model page: `fireworks/accounts/fireworks/models/glm-5p2` (`mentor`),
`fireworks/accounts/fireworks/models/kimi-k3` (`mentor`),
`fireworks/accounts/fireworks/models/deepseek-v4-pro` (`minion`), and
`fireworks/accounts/fireworks/models/gpt-oss-120b` (`myrmidon`). None is a fleet
default; the mentor lane is reached only by a `--provider-canary fireworks mentor`
job. That canary body records a provider and capability tier, never the concrete
model; the resolver chooses the selector and the handler sends the wire id without
the garden `fireworks/` prefix. Unknown Fireworks ids, unknown providers, and
provider/tier pairs with no inventory row fail closed.

GLM 5.2 and the Fireworks-served Kimi K3 sit at the **same** `mentor` tier, and the
resolver is first-match (`tier_model_for_provider`), so a `provider: fireworks` +
`tier: mentor` job resolves to **GLM 5.2** (the first mentor Fireworks row); the K3
row is registered with a verified wire id but is not independently tier-selectable
until the maintainer resolves the collision. This is deliberate — see
[context/operations/fireworks.md](../context/operations/fireworks.md) §
"The GLM 5.2 / K3 mentor-tier collision" for the three options and their costs. The
Fireworks K3 lane stays strictly separate from the working Moonshot/mystic K3 lane
(`provider: moonshot`, bare `model: kimi-k3`): no re-routing, no shared reputation.

The Fireworks lane is deliberately bounded: it starts at zero workers, needs a
secret-safe authenticated availability probe, and is returned to zero after the
canary. Its Codex-compatible harness currently has no reliable token accounting, so
the reputation arm is censored rather than assigned a guessed cost.

### 2.8 OpenRouter free models, through the Codex-compatible `openrouter`

OpenRouter is an OpenAI-compatible model aggregator (`https://openrouter.ai/api/v1`),
so it rides the **same** custom-provider Codex path as the fireworker (they share the
`$custom_openai_compat` code). Its garden routing ids are namespaced
`openrouter/<wire-id>`; the handler strips `openrouter/` before sending. The closed
inventory admits only **stable, NAMED** free selectors — seeded with
`openrouter/z-ai/glm-5.2:free` (`minion`), the sole zero-price text/tool endpoint in
OpenRouter's public ZDR inventory during the 2026-08-22 review. The former DeepSeek
V3 0324 and Llama 3.3 70B free rows had empty endpoint lists and were removed rather
than silently retained. **Cloaked/stealth ids are deliberately excluded** and
fail closed like any unreviewed selector: a reviewed row must mean a reviewed model,
and a stealth id (anonymous, rotating identity) cannot honor that. None is a fleet
default; the lane is explicit-model-only and reached only by an `openrouter/<id>` pin
or a `--provider-canary openrouter <tier>` canary. Unknown ids, unknown providers, and
provider/tier pairs with no inventory row fail closed. Like Fireworks, the lane starts
at zero, needs a secret-safe status probe, returns to zero after the canary, and has
no token accounting (censored arm). Its handler forces both no-data-collection and
ZDR provider preferences on every request. Whether to ever admit a stealth
promotional lane remains open in
[designs/openrouter-provider.md](openrouter-provider.md) § Open questions.

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
