---
created: 2026-08-22
updated: 2026-08-22
author: gardener, designer
---

# Design: OpenRouter as a garden provider

| Field | Value |
| --- | --- |
| Status | **Implemented, disabled by default.** The wiring and per-request no-collection/ZDR enforcement are present; one currently compliant NAMED free model is inventoried. The stealth/promotional lane (option b) is now **also built** as a second kind, `openrouter-promo` — a journal-backed, cadence-gated cloaked lane, shipped inert (pool zero, empty ledger). See § The stealth/promotional lane. |
| Directive | kriskowal, 2026-08-22: *"harness and configure OpenRouter as a new garden provider so the fleet can reach more models through it,"* motivated in part by OpenRouter's rotating free/promotional (cloaked "stealth") models whose terms are *"at least allegedly fine"* but not rigorously vetted. |
| Decision | Add a single `openrouter` worker kind reusing the existing Codex custom OpenAI-compatible handler (one kind per provider — [opencode-alternate-harness](opencode-alternate-harness.md) option C). Admit only **stable, named** `:free` models via ordinary reviewed inventory rows; **exclude cloaked/stealth ids** from the closed inventory. Ship at pool zero, explicit-model-only, no automatic/unpinned route. Every inference request is forced to `provider: { data_collection: "deny", zdr: true }`; an endpoint that cannot satisfy both is unavailable rather than a policy fallback. |

## Mechanism — pure reuse of the Codex custom-provider path (no new harness)

OpenRouter's API is OpenAI-chat compatible at `https://openrouter.ai/api/v1` with
bearer-token auth. That is **exactly** the surface the Codex custom-provider path
already fronts: `handlers/cleric-codex.sh` + `handlers/codex-provider-common.sh`
drive the paid-OpenAI `cleric`, the local `hermit`, and the Fireworks `fireworker`
off one code path, parameterized by a per-provider `base_url` + `env_key` and a
namespaced routing id. [opencode-alternate-harness](opencode-alternate-harness.md)
already settled the shape question this design would otherwise re-litigate: **one
kind per provider, reusing one handler** (its option C), never a many-provider kind
(breaks eligibility) and never "harness" as a new arm dimension (redundant with
`kind`). OpenRouter is the same generalization as `fireworker`, not a new harness.

Concretely, OpenRouter and Fireworks are the *same* class of backend — a separately
credentialed, OpenAI-compatible, bearer-key custom provider with a rotating catalog
addressed by a namespaced routing id. So rather than copy the Fireworks branches,
this design **factors them**: the two share a `$custom_openai_compat` flag in the
handler and a `openai_compat_provider_preflight` / `openai_compat_retryable_failure`
pair in `codex-provider-common.sh`. `fireworks_*` names remain as thin wrappers so
the fireworker path and its tests are untouched. A *third* such provider is now a
registry row plus an adapter case, with no new handler branches.

### The routing namespace

Garden routing ids are namespaced `openrouter/<wire-id>`, and the handler strips
`openrouter/` before the request goes out — identical to `fireworks/<wire-id>`. This
matters more for OpenRouter than for Fireworks because OpenRouter's wire ids already
contain slashes and a `:free` suffix (`z-ai/glm-5.2:free`), so the garden id reads
`openrouter/z-ai/glm-5.2:free` and the wire id is the exact
`z-ai/glm-5.2:free`. The namespace keeps OpenRouter ids
in a disjoint space from every other provider's, so a pin classifies to exactly one
provider and no cross-provider leak is possible.

## The wiring (the Fireworks commit `2c21ea3f2c` as the mechanical checklist)

The "add a provider" diff shape, applied for `openrouter` (kind name == provider
name, harmless — the two live in separate namespaces):

- **`common.sh`** — `GARDEN_OPENROUTER_BASE_URL` + retry knobs; a `worker_kind_field
  openrouter` registry row (handler `cleric-codex.sh`, provider `openrouter`, unit
  `garden-openrouter@`, count_key/state_ns `openrouters`); `openrouter` added to
  `worker_kinds`, `canonical_worker_kind`, `resolve_model_tier`, `role_default_model`
  (empty — explicit model only), `role_default_effort`, `job_provider_constraint`,
  and the inline routing-table fallback.
- **`model-routing-defaults.tsv`** + **`model-tier-inventory.tsv`** — reviewed exact
  NAMED selectors only (never a wildcard, never a stealth id).
- **`claim-job.sh`** — `openrouter` joins the opt-in exclusion (an unclassified/
  absent-tier job is not auto-eligible) **and** an explicit-model-only gate: the kind
  claims only a `provider: openrouter` canary or an `openrouter/<wire-id>` pin, so no
  automatic/unpinned board job — including a reaper reroute to a tier OpenRouter
  serves a model at — can reach it.
- **`reputation.sh`** — an `openrouter-unconfigured` arm fallback.
- **`comment-provenance.sh`** — `openrouter` → `codex` harness label.
- **`rate-card-defaults.md`** — a provisional `openrouter` row (the codex lane emits
  no dollars; see § Cost).
- **`set-openrouters.sh`** — the count helper (wraps `set-workers.sh openrouter`).
- **`garden`** + **`seed-api-key-handoff.sh`** — forward `OPENROUTER_API_KEY` through
  the tmpfs handoff (its `sk-or-v1-…` shape passes the base64url validator).
- **systemd** — the `garden-openrouter@` unit renders automatically from the single
  `garden-worker@.service.in` template (no per-kind unit file).
- **Privacy enforcement** — Codex's custom-provider schema has no arbitrary JSON-body
  injection field. The handler therefore starts a per-job loopback adapter and points
  Codex only at it. The adapter overwrites every request body's provider preferences
  with `data_collection: "deny"` and `zdr: true`, then forwards to the fixed HTTPS
  OpenRouter origin. If Node or the adapter is unavailable, the path fails closed.
- **Tests** — `openrouter-harness-test.sh` (new, mirrors the fireworker one) plus
  openrouter cases across `worker-spine-kinds-test.sh` and `api-key-handoff-test.sh`.
  The harness exercises a real local HTTP hop and asserts that attempted permissive
  values are overwritten before the mock upstream receives the body.
- **Docs** — [`context/operations/openrouter.md`](../context/operations/openrouter.md)
  (bounded-probe activation and enforced privacy posture) and a `model-selection` note.

## The crux: closed inventory vs. rotating "stealth" models

`skills/model-selection/SKILL.md` is explicit and load-bearing: the inventory is
**closed** — every enabled model gets exactly one **reviewed row with a stable id**,
and wildcard/pattern routes are **forbidden** so an unreviewed model can never
silently acquire an automatic route. OpenRouter's value proposition includes cloaked
"stealth" models (`openrouter/stealth/…`-style) that are **anonymous by design and
rotate identity/availability without notice**. That is in direct structural tension
with "reviewed row, stable id": a reviewed row is supposed to mean *a specific,
reviewed model*, but a stealth id may **reappear as a different model** under the
same string — silently violating the invariant's *intent*, not merely its letter.

Two admissible policies, and the recommendation:

- **(a) Exclude stealth ids from the closed inventory** until they de-cloak under a
  real vendor/model name; then they earn an ordinary reviewed row like any other
  model. Simple, preserves the invariant exactly. Cost: the fleet cannot use a
  stealth model *while it is cloaked* — which is when the directive most wants it.
- **(b) A separate, explicitly-labeled promotional lane** for stealth ids, with a
  short mandatory re-review cadence and a documented rip-cord for when the id
  vanishes or reappears as something else. Satisfies the directive's motivation, but
  it (1) weakens the closed-inventory invariant to "reviewed *as of date X*, may now
  be something else," (2) requires net-new machinery (a cadence timer, a re-review
  step, a tombstone/rip-cord path) the garden does not have, and (3) is exactly where
  the terms/provenance risk is worst — a cloaked model's operator and data policy are
  undisclosed **by definition**, so "allegedly fine" cannot be discharged.

**Original recommendation: ship (a), design-and-defer (b).** The initial cut implemented
(a): stable **named** free models get ordinary reviewed rows only after the same
ZDR/data-policy review as any paid route; cloaked/stealth ids fail closed exactly like
any unreviewed selector (asserted in tests). The 2026-08-22 review found only one
text/tool-capable, zero-price `:free` endpoint in OpenRouter's public ZDR inventory, so
the closed inventory contains only `z-ai/glm-5.2:free`.

**Maintainer decision (kriskowal, 2026-08-22): ALSO build (b).** The maintainer wants to
use the rotating cloaked "stealth" models *while cloaked*, accepting the stated risk
(undisclosed provenance, no reviewed stable id) but **only** that risk — the ZDR /
deny-collection constraint is inherited unconditionally, because "we accept not knowing
which model this is" is a different risk than "we accept our prompts being logged." (b)
is now built as the second kind `openrouter-promo`; see the next section.

## The stealth/promotional lane (option b, `openrouter-promo`)

Built per the maintainer decision above. It is a **second kind**, `openrouter-promo`,
reusing the same handler, the same OpenRouter endpoint/key, and the same fail-closed
ZDR/deny-collection privacy proxy as `openrouter` — diverging only in **kind**,
**provider**, and **routing namespace** (`openrouter-promo/<wire-id>`). That divergence
is the whole point: the arm is keyed on `(kind, provider, model, thoughtfulness)`, so a
distinct kind + provider + namespace means a cloaked model's short-lived,
separately-re-reviewed reputation **never pools** with a stable named model's
([opencode-alternate-harness](opencode-alternate-harness.md) option-C reasoning: a
distinct kind keeps distinct risk profiles distinctly scored). `openrouter/*` does not
glob-match `openrouter-promo/*`, so the two lanes' selectors can never cross-bind, and
each lane's worker leaves the other's pins in `todo/` (asserted in the spine test).

**Journal-backed, cadence-gated inventory (not the tracked closed inventory).** A
cloaked id is anonymous by design and can vanish or silently become a different model at
any moment, so — unlike the stable lane's tracked `model-tier-inventory.tsv` (a row ==
a specific reviewed model, changed only by a deploy) — the promo lane's enabled set
lives in a **journal ledger** (`config/openrouter-promos`, one TSV row per id:
`<wire-id>  <tier>  <attested_at ISO8601>  <attested_by>`). Journal-backed so it is
mutable with **no deploy** (a daily-rotating id cannot wait for one) and so a timer on
any host can prune it.

**The re-review cadence is enforced in two layers, and the primary one needs no daemon:**

- **Read-side (primary).** `common.sh` admits a ledger row **only while its
  `attested_at` is within `GARDEN_OPENROUTER_PROMO_CADENCE_SECS` (default 24h) of now.**
  A row that is not re-attested inside the window simply **stops classifying** — the id
  fails closed at claim time, auto-disabled *by construction*, even if no timer ever
  fires. This is the load-bearing guarantee.
- **Janitor (on top).** `openrouter-promo-recheck.sh` is a deterministic, LLM-free sweep
  (wired as a daily **schedule preflight**, so it runs in plain code and dispatches no
  agent): it prunes the expired rows for real, and — when the key is present — 404-probes
  each surviving id against OpenRouter's live listing and **drops any that has rotated
  away**, raising one deduped maintainer alert per disable. It never auto-drops on a
  transient (429/503/network); only a definitive 404 or a stale attestation disables.

**Re-attestation and the rip-cord.** `openrouter-promo-attest.sh <wire-id> <tier> [by]`
adds/refreshes a row (stamping `attested_at=now`) — running it *is* the periodic
re-review. The **rip-cord** is two independent levers: `set-openrouter-promos.sh 0`
zeroes the pool (no worker runs a cloaked model), and `openrouter-promo-drop.sh
<wire-id>` removes a specific id's row so it can never be re-dispatched even at pool > 0.
The janitor calls the same drop path automatically.

**Inherited privacy.** Every `openrouter-promo` request goes through the identical
`openrouter-privacy-proxy.mjs` loopback adapter that forces `data_collection: "deny"`
and `zdr: true`; a missing Node/adapter fails the request closed. This lane cannot relax
those fields — the authorization is for undisclosed *provenance*, never for logging.

**Shipped inert.** No ledger file exists at ship, so every promo id fails closed and the
lane does nothing until a maintainer attests an id and sets the pool > 0 — a separate,
host-side, maintainer-directed step (like the stable lane's first canary).

## Disabled by default

Same posture as `fireworker`/`mystic`: pool at zero (no `openrouters:` line declared
anywhere), explicit-model-only, and — verified in `claim-job.sh` and the spine test —
**no automatic or unpinned job can reach it**. The eligibility fence proves it: an
unpinned job, a tier-only job, a foreign-provider job, and a cloaked-id pin are all
**left**; only a reviewed `openrouter/<id>` pin or a `provider: openrouter` canary is
claimable. The sole reviewed seed sits at **minion**, below mentor, so even the tier
resolver has no OpenRouter model for an automatic `tier: mentor` job to bind. There
is no OpenRouter myrmidon row merely to preserve the former two-row shape. Key
provisioning and the first canary stay a separate, maintainer-directed step (this
change supplies and spends nothing).

## Cost

The Codex lane reports tokens but **no provider-computed dollars** (the fireworker
established this fleet-wide). So an OpenRouter reputation event stays
`agentic_dollars: censored` and its arm is priced from a provisional rate-card row.
The reviewed free endpoint is $0-list but rate-limited; a paid OpenRouter route, if
later enabled, would want its own reviewed row and a revisited rate.

## Relationship to prior designs

- [opencode-alternate-harness](opencode-alternate-harness.md) — this design is a
  concrete instance of its **option C** (one kind per provider, one shared handler),
  and its § "What reach it actually adds" already noted the codex custom-provider path
  "already reaches OpenRouter." This wires exactly that.
- [`context/operations/fireworks.md`](../context/operations/fireworks.md) — the
  bounded-probe onboarding playbook this lane follows verbatim.

## Open questions (maintainer decisions)

1. **Resolved — terms / data-retention.** Logging, retention, and training on garden
   inputs are not acceptable. Current OpenRouter documentation distinguishes two
   request controls: `provider.data_collection: "deny"` excludes endpoints that may
   collect/train, while `provider.zdr: true` restricts routing to endpoints with a
   zero-data-retention policy. The garden forces **both** on every OpenRouter inference
   request; account/guardrail ZDR settings OR with the request and cannot relax it.
   OpenRouter itself says it does not store prompt/response content unless an account
   owner explicitly opts into content logging; it still retains non-content request
   metadata. OpenRouter documents no per-request override for that owner-controlled
   opt-in, so key provisioning must leave its two content-logging settings off. Cost:
   many free endpoints become ineligible and a request with no
   compliant endpoint fails instead of falling back to a logging/training route.
   Sources: [provider routing](https://openrouter.ai/docs/guides/routing/provider-selection),
   [ZDR](https://openrouter.ai/docs/guides/features/zdr), and
   [data collection](https://openrouter.ai/docs/guides/privacy/data-collection).
2. **Resolved — the stealth/promotional lane (policy option b).** kriskowal, 2026-08-22:
   **yes**, admit cloaked/stealth ids *while cloaked*, accepting undisclosed provenance
   but **only** that risk. Built as the second kind `openrouter-promo` (§ The
   stealth/promotional lane): a journal-backed, cadence-gated ledger (a row that is not
   re-attested within a 24h window fails closed with no daemon), a deterministic
   auto-disable recheck (stale attestation OR a 404 → the row is dropped), and a
   two-lever rip-cord. It inherits the forced ZDR/deny-collection request fields from (1)
   unconditionally — that is not relaxable. Shipped inert (pool zero, empty ledger).
3. **Resolved — named seed-model review.** On 2026-08-22 the public
   `GET /api/v1/endpoints/zdr` inventory returned `z-ai/glm-5.2:free` as the sole
   text/tool-capable endpoint whose prompt and completion prices were both zero. It
   advertised `tools`, `tool_choice`, and `reasoning_effort`; this is now the sole
   seed row. The former DeepSeek V3 0324 and Llama 3.3 70B `:free` ids returned empty
   endpoint lists and were removed. This proves catalog/ZDR eligibility, not an
   authenticated completion; the status-only canary remains required before enablement.
