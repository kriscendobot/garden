---
created: 2026-08-22
updated: 2026-08-22
author: designer
---

# Design: OpenRouter as a garden provider

| Field | Value |
| --- | --- |
| Status | **Implemented, disabled by default.** The wiring for stable NAMED free models landed with this design; the stealth/promotional lane is deferred as an open question. |
| Directive | kriskowal, 2026-08-22: *"harness and configure OpenRouter as a new garden provider so the fleet can reach more models through it,"* motivated in part by OpenRouter's rotating free/promotional (cloaked "stealth") models whose terms are *"at least allegedly fine"* but not rigorously vetted. |
| Decision | Add a single `openrouter` worker kind reusing the existing Codex custom OpenAI-compatible handler (one kind per provider — [opencode-alternate-harness](opencode-alternate-harness.md) option C). Admit only **stable, named** `:free` models via ordinary reviewed inventory rows; **exclude cloaked/stealth ids** from the closed inventory. Ship at pool zero, explicit-model-only, no automatic/unpinned route. Terms/data-retention is a maintainer decision surfaced below, not a settled premise. |

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
contain slashes and a `:free` suffix (`deepseek/deepseek-chat-v3-0324:free`), so the
garden id reads `openrouter/deepseek/deepseek-chat-v3-0324:free` and the wire id is
the exact `deepseek/deepseek-chat-v3-0324:free`. The namespace keeps OpenRouter ids
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
- **Tests** — `openrouter-harness-test.sh` (new, mirrors the fireworker one) plus
  openrouter cases across `worker-spine-kinds-test.sh` and `api-key-handoff-test.sh`.
- **Docs** — [`context/operations/openrouter.md`](../context/operations/openrouter.md)
  (bounded-probe activation, kimi-k3 shape) and a `model-selection` note.

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

**Recommendation: ship (a), design-and-defer (b).** This design implements (a): stable
**named** free models (`:free` ids with a real vendor/model name, e.g.
`deepseek/deepseek-chat-v3-0324:free`, `meta-llama/llama-3.3-70b-instruct:free`) get
ordinary reviewed rows now; cloaked/stealth ids fail closed exactly like any
unreviewed selector (asserted in tests). This already delivers "more models through
OpenRouter" — the whole named-free catalog is now reachable one reviewed row at a
time — without weakening the invariant. The promotional lane (b) is left as an **open
question** because it both weakens a load-bearing invariant and is inseparable from
the unresolved terms/provenance question below; it is the maintainer's call, not a
guess a design should bake in. If authorized, (b) would most cleanly be a *second*
kind (`openrouter-promo`) — one kind per lane, the same option-C shape — so its
distinct, short-lived, re-reviewed arms never pool with the stable lane's.

## Disabled by default

Same posture as `fireworker`/`mystic`: pool at zero (no `openrouters:` line declared
anywhere), explicit-model-only, and — verified in `claim-job.sh` and the spine test —
**no automatic or unpinned job can reach it**. The eligibility fence proves it: an
unpinned job, a tier-only job, a foreign-provider job, and a cloaked-id pin are all
**left**; only a reviewed `openrouter/<id>` pin or a `provider: openrouter` canary is
claimable. The two seed models sit at **minion** and **myrmidon** — deliberately
below mentor, so even the tier resolver has no OpenRouter model for an automatic
`tier: mentor` job to bind. Key provisioning and the first canary stay a separate,
maintainer-directed step (this change supplies and spends nothing).

## Cost

The Codex lane reports tokens but **no provider-computed dollars** (the fireworker
established this fleet-wide). So an OpenRouter reputation event stays
`agentic_dollars: censored` and its arm is priced from a provisional rate-card row.
Free models are $0-list but rate-limited and often logged (below); a paid OpenRouter
route, if later enabled, would want its own reviewed row and a revisited rate.

## Relationship to prior designs

- [opencode-alternate-harness](opencode-alternate-harness.md) — this design is a
  concrete instance of its **option C** (one kind per provider, one shared handler),
  and its § "What reach it actually adds" already noted the codex custom-provider path
  "already reaches OpenRouter." This wires exactly that.
- [`context/operations/fireworks.md`](../context/operations/fireworks.md) — the
  bounded-probe onboarding playbook this lane follows verbatim.

## Open questions (maintainer decisions — not settled here)

1. **Terms / data-retention.** OpenRouter's **free** model variants commonly require,
   at the account level, that prompt/response **logging and provider training be
   enabled** — otherwise the free endpoint is unavailable; zero-data-retention (ZDR)
   routing excludes non-ZDR providers and is generally a paid posture. Garden job
   prompts frame the job body as data but still carry repo context. **Is
   logging/training-on-inputs acceptable for garden work on the free lane, or should
   only a paid/ZDR route be enabled?** The directive named the free models as
   "allegedly fine"; the maintainer decides what is fine — this design only surfaces
   the tradeoff. Until decided, keep the pool at zero.
2. **The stealth/promotional lane (policy option b).** Should the garden ever admit
   cloaked/stealth ids at all — and if so, via the deferred `openrouter-promo` second
   kind with a re-review cadence and rip-cord, accepting a weakened inventory
   invariant and undisclosed provenance? Recommended answer for now: **no** (option a
   only). Reopen only with an explicit terms answer from (1).
3. **Named seed-model verification.** The two seed inventory ids were transcribed,
   not live-verified (the authoring worktree had no key). Confirm each with the
   status-only probe (a 200 vs a 404) before enabling; a rotated-away `:free` id is
   removed from the inventory, not dispatched.
