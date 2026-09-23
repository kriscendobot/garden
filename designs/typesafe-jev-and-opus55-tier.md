---
created: 2026-09-23
updated: 2026-09-23
author: gardener
---

# Design: Opus 5.5 tier placement, and TypeSafe Jev for classification work

| Field | Value |
| --- | --- |
| Status | **Draft — carries open questions.** Landed on `main2` and presented as a PR answer-surface per the garden's-own-repo open-questions carve-out ([`roles/designer/AGENT.md`](../roles/designer/AGENT.md) § Operating norms). Not a pending merge. |
| Directive | kriskowal, 2026-09-23: the garden now has access to two new models — TypeSafe AI's **Jev** and Anthropic's **Opus 5.5**. (1) Where does Opus 5.5 sit in the tier vocabulary — existing tier or a new one, and does a cheaper Opus 5.5 change the automatic-work cost ceiling? (2) Is Jev a fit for classification-shaped work (triage, muster)? |
| Decision (thread 1) | Opus 5.5 slots at the **existing `mentor` tier** — **no new tier**. It Pareto-dominates the incumbent Opus 5 (cheaper *and* newer), so make it the anthropic `mentor` default. **Recommended (open):** also adopt it as the automatic-work ceiling model in place of `claude-opus-4-8`, since it is cheaper per token than today's ceiling — pending a bounded quota-burn measurement. |
| Decision (thread 2) | Jev is a **non-agentic "System 1" structured-decision classifier**, not a generative LLM. It **cannot** be onboarded as a worker kind or a tier-inventory row — the mystic/friar template does not apply. Consider it instead as a **classification primitive** at specific decision points, via a bounded pilot. **Muster stays liaison-session-only with human dispose**; Jev at most runs a *pre-classification pass that feeds* the interactive muster. Everything about TypeSafe access, data-egress policy, and which decision point to pilot is open. |

The two threads share only their origin (new model access); they are cleanly separable and could split into sibling designs later. They are kept together here because the maintainer posed them as one and because thread 2's conclusion (Jev is *not* tier-shaped) is best understood against thread 1's tier vocabulary.

---

## Thread 1 — Opus 5.5 in the fleet tier vocabulary

### Evidence (grounded, not "possibly")

Anthropic first-party API pricing, transcribed from the bundled `claude-api` skill's model catalog (cached 2026-06-24, refreshed for the Opus 5.5 launch row):

| Model | Id | Input $/MTok | Output $/MTok | Cache read | Fleet tier today |
| --- | --- | --- | --- | --- | --- |
| Claude Opus 5.5 | `claude-opus-5-5` | **$4.00** | **$20.00** | $0.20 | *(unclassified — new)* |
| Claude Opus 5 | `claude-opus-5` | $5.00 | $25.00 | — | `mentor` |
| Claude Opus 4.8 | `claude-opus-4-8` | $5.00 | $25.00 | — | `minion` (the automatic ceiling) |
| Claude Fable 5 | `claude-fable-5` | $10.00 | $50.00 | — | `mentat` (manual-only) |

Capability: Opus 5.5 is the **successor to Opus 5 in the Opus line**, same 1M context / 128K output / tokenizer / feature set, at a **lower price**. Its default reasoning effort is **`medium`** (one level below Opus 5's `high`); thinking is always-on and cannot be disabled (effort is the only depth control). Fast mode is $8/$40. So on the two axes the fleet cares about:

- **Capability (the tier / thoughtfulness axis):** Opus 5.5 ≥ Opus 5 (it is its successor), comfortably above Opus 4.8.
- **Cost (the rate-card axis):** Opus 5.5 ($4/$20) is **strictly cheaper than both** the incumbent `mentor` model (Opus 5, $5/$25) and the incumbent automatic-ceiling model (Opus 4.8, $5/$25).

This is a **Pareto improvement** over both incumbents: newer *and* cheaper. That is the load-bearing fact for every decision below.

### Existing tier or a new one? — existing `mentor`, no new tier

The four tiers (mentat > mentor > minion > myrmidon) are an **ordinal thoughtfulness/capability band**, not a price band — [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) is explicit that cost lives in the **rate card**, not the tier vocabulary (a Fireworks GLM 5.2 and Opus 5 both sit at `mentor` despite wildly different prices). Introducing a new tier "between mentor and mentat" to express "a cheaper Opus" would **conflate the cost axis into the capability axis** and break that separation — every consumer that reads the tier (`tier_model_for_provider`, the claim predicate, the auction, the reroute floor) would have to learn a band that means nothing about thoughtfulness.

Opus 5.5 is the **successor to Opus 5**, which sits at `mentor`. Its capability band is `mentor` (or arguably `mentat`, but Fable 5 remains the most-capable, manual-only mentat model and there is no reason to promote an automatic-eligible Opus into the manual-only band). **Register Opus 5.5 at `mentor`.** No new tier.

### Strictly better than the incumbent at that tier? — yes; make it the mentor default

At `mentor`, Opus 5.5 Pareto-dominates Opus 5 (cheaper on both input and output; newer). `tier_model_for_provider` (`scripts/jobs/common.sh`) resolves `(provider, tier)` by **first match** over the inventory TSV, so making Opus 5.5 the anthropic `mentor` default is a one-line ordering change: place the `anthropic  claude-opus-5-5  mentor` row **above** the existing `claude-opus-5` row. Opus 5 stays a registered, still-selectable inventory row (a maintainer can still pin it); it simply stops being the default the tier resolves to.

### Does a cheaper Opus 5.5 change the automatic-work cost ceiling? — yes, favourably

Today the **anthropic automatic-work cost ceiling** (`scripts/jobs/handlers/monk-claude.sh` §205–219, maintainer directive 2026-08-01) downshifts an **automatic** `mentor` job claimed by an anthropic worker to `serve_tier=minion`, which resolves to `claude-opus-4-8`. Manual `mentor` jobs are still served at `mentor`. The reaper mirrors this: an anthropic-served automatic mentor failure is evidence about the *minion* model, so it suppresses the reroute rather than burning mentor ([`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) § Never burn an unserved tier; `scripts/jobs/reaper.sh` §1301).

A subtlety the maintainer's prompt anticipates: **Opus 5 and Opus 4.8 are the same $5/$25 price**, so the current downshift never saved per-token dollars — its value was (a) capping automatic work below the newest mentor-designated model and (b) Opus 4.8's thinking-off-by-default keeping token *volume* lower than Opus 5's thinking-on-by-default. Opus 5.5 changes both inputs:

- It is **cheaper per token than the ceiling model itself** ($4/$20 vs Opus 4.8's $5/$25). Serving automatic mentor work at Opus 5.5 would be **cheaper *and* more capable** than today's ceiling.
- Its thinking is always-on (like Opus 5) *but* its default effort is **`medium`** (below Opus 5's `high`), which bounds token volume — the exact concern that justified preferring Opus 4.8.

Options, in ascending boldness:

- **A — conservative (register only).** Register Opus 5.5 at `mentor`; leave the downshift pointing at Opus 4.8. Manual mentor jobs get Opus 5.5; automatic mentor jobs stay on Opus 4.8. Captures the manual-path win, defers the automatic-spend decision. Zero behavioural change to automatic work.
- **B — raise the ceiling (recommended, open).** Drop the anthropic `serve_tier=minion` downshift so an automatic `mentor` job is served at `mentor` = Opus 5.5. Because Opus 5.5 is cheaper than the current ceiling model, automatic Claude work becomes both cheaper-per-token and more capable; the downshift (and its reaper-suppression special case) can be retired. This is the elegant end state.
- **C — retarget the ceiling.** Keep a downshift but resolve it to `claude-opus-5-5` explicitly rather than the `minion` tier. Marginal over B, more code, and it leaves the confusing "served at minion" log line in place. Not recommended.

**Recommendation: B, gated on a bounded measurement.** The flat-subscription reality makes per-token price *notional* — the fleet runs on flat Max-plan subscriptions and the binding constraint is **weekly quota**, not per-token billing (repeated 2026 quota outages and self-throttles are on record in the fleet memory). So the decision hinges on **quota token-burn**, not the sticker price. Opus 5.5's lower default effort points toward *less* burn than Opus 5-at-high, but always-on thinking could exceed Opus 4.8-with-adaptive-off on some jobs. This is favourable-but-unproven: run a bounded canary comparing per-completed-job token spend of Opus 5.5-at-medium vs Opus 4.8 on representative automatic work before flipping the ceiling fleet-wide. Land A now (the strict win), promote to B on the measurement. (See Open questions.)

### Exact changes ("Adding or changing a model")

Per [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) § Adding or changing a model. These are the changes a follow-up **build** job implements — this design specifies them; it does not itself edit the routing code (that lands through the build, reviewed):

1. `scripts/jobs/model-tier-inventory.tsv` — add `anthropic\tclaude-opus-5-5\tmentor`, **ordered before** `claude-opus-5` so first-match makes it the mentor default. (No `pull_bytes`; it is hosted.)
2. `scripts/jobs/model-routing-defaults.tsv` — add `claude-opus-5-5` to the anthropic patterns row (the space-separated id list); anthropic keeps its empty fleet-default column (headerless default decided in code).
3. `scripts/jobs/common.sh` — add `claude-opus-5-5` to the inline `_model_routing_table` fallback anthropic list (line ~7801) so a checkout missing the tracked TSV still classifies it; optionally add an `opus55) → claude-opus-5-5` short alias to `resolve_model_tier` (line ~7891) for hand pins.
4. **If option B:** in `scripts/jobs/handlers/monk-claude.sh` remove the `serve_tier=minion` anthropic-mentor downshift (§213–219) and, in `scripts/jobs/reaper.sh`, retire the ceiling-suppress special case (§1301–1314); update `scripts/jobs/test/gardener-claude-tier-serving-test.sh` and `reroute-role-floor-test.sh` accordingly.
5. Regression coverage — extend `scripts/jobs/test/gardener-claude-tier-serving-test.sh` to assert `(anthropic, mentor)` resolves to `claude-opus-5-5`; add an inventory-classification assertion.
6. Docs — update [`designs/provider-model-catalog.md`](provider-model-catalog.md) (the Claude model table + the Dispatch-vocabulary prose) and [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) (the tier table's `mentor` row and, under option B, the § anthropic automatic-work cost ceiling section).

---

## Thread 2 — TypeSafe Jev for classification-shaped work

### Evidence — Jev is not a generative LLM

TypeSafe AI's **Jev** (current `jev-1.13`) is a **"System 1" structured-decision model**: **non-autoregressive**, it does **not generate text token by token**. You give it a *state* (text to evaluate) plus a set of **typed questions**, and it returns **bounded, typed answers with probabilities / confidence scores** — a decision, not prose. It is purpose-built for **routing, classification, and scoring at decision points inside an application**. Pricing: **$0.042/M input tokens, $0.00/M output tokens** (~$0.0004 per average decision); the vendor claims ~200× faster (~100 ms/call) and ~400× cheaper than a frontier LLM on classify/route tasks. Reachable via TypeSafe's own API (`docs.typesafe.ai`) and via OpenRouter (`typesafe/jev-1.13`). (Sources in Grounding.)

### Why the mystic / friar / fireworker onboarding template does *not* apply

The prompt suggested Jev is "closer in shape to how mystic/cleric/fireworker/friar were onboarded." On inspection **it is not**, and this is the pivotal finding. Every existing worker kind — monk, cleric, mystic, fireworker, friar, openrouter — is an **agentic-CLI harness driver**: it runs `claude -p` or `codex` to *do* a job (design, build, fix, review), claims a job off the board, and runs an agent loop. A model in `model-tier-inventory.tsv` is, by construction, **a model that can drive that loop at some capability tier**.

Jev can do **none** of that. It emits no prose, no tool calls, no code, no agent loop — only a typed decision. Therefore:

- Jev **cannot be a worker kind**, cannot claim a job, cannot be assigned a `tier`, and has **no row in the closed tier inventory**. The "Adding or changing a model" checklist is inapplicable to it.
- It is **not** a reputation *arm* in the `(role, model)` sense of the bid-market — it produces no acceptances, does not compete with monks/clerics for jobs.

Jev is a **different category of thing**: a cheap, fast, injection-resistant classification *primitive* that deterministic garden code could **call at a decision point**, the way it already calls a grep or a deterministic sensor — not a worker that *is* dispatched.

### Where Jev could actually fit

The garden's classification-shaped decision points, ranked by fit:

- **Muster pre-classification** (best fit; see next section). Tag each unread inbox item with its recurring class (approval-gated / decision-gated / doom-and-halt / informational) + a confidence, and flag likely-dead items — feeding, not replacing, the interactive muster.
- **Triager fuzzy-directive mapping.** The triager is *deliberately deterministic* (a fixed verb→job table, "prefer a fixed mapping over open-ended reasoning" — [`roles/triager/AGENT.md`](../roles/triager/AGENT.md)). Jev fits only the residual: a maintainer comment whose intent is *not* one of the fixed verbs, mapped to a typed job-kind + confidence, with a low-confidence result falling back to "no deterministic match" (unchanged behaviour). This is a small surface — the verb table already covers the common cases.
- **Panel-kind discrimination** (design-only vs source-touching) and **web-frontend variant selection** — both are typed classification decisions currently made by deterministic sensors plus a "lawyer-analogous" classifier; Jev-shaped, but they already have working deterministic paths, so the marginal value is smaller.

A notable **security property**: because Jev returns only a bounded typed choice, it is **structurally more injection-resistant** than feeding untrusted text to a generative LLM — a hostile PR comment cannot steer it into emitting arbitrary text or a tool call; the worst case is a mis-classification within the fixed answer set. This does **not** dissolve the monitoring-safety constraint (untrusted text still enters an external service — a **data-egress** question, below) but it is a genuine mitigation for the *injection* half of that constraint.

### Muster architecture — do not silently reinterpret

Per [CLAUDE.md](../CLAUDE.md) § Orchestrator vocabulary and [`roles/liaison/AGENT.md`](../roles/liaison/AGENT.md) § Muster, **muster is liaison-session-only, interactive vocabulary** — a conversation the liaison drives with the maintainer over three passes (compact → classify → dispose), explicitly **never a board job and never watcher-recognized**, "because triage is a conversation, not a board entry." Reading "use Jev for muster" as *a new autonomous Jev-driven muster job that disposes inbox items* would **break that architecture** and violate the CLAUDE.md constraint. This design refuses that reading.

The architecturally-compatible interpretation — and the one recommended, pending maintainer confirmation — is a **pre-classification pass that feeds the interactive muster**:

- A cheap Jev pass runs over the **unread** inbox and annotates each item with a **typed class + confidence** and a **likely-dead flag** (e.g., "blocker referenced a PR that has since merged"). It writes annotations only; it **disposes nothing**.
- The liaison still runs the three-pass muster **with the maintainer**, now with the pile pre-sorted and the obvious corpses pre-flagged — pass 1 (compact) and pass 2 (classify) get a running start; **pass 3 (dispose) stays entirely human**, one item at a time, exactly as today.

The human-in-the-loop dispose boundary is preserved; Jev only accelerates the two mechanical passes. Whether the maintainer wants even this — versus keeping muster fully hand-driven, or something else — is an **open question**, not a decision this design makes.

```mermaid
flowchart LR
  inbox["Unread maintainer inbox"] --> jev["Jev pre-classification pass<br/>(typed class + confidence, dead-flag)"]
  jev --> compact["Liaison muster pass 1-2<br/>(compact, classify — accelerated)"]
  compact --> dispose["Pass 3: dispose<br/>(human, one at a time — unchanged)"]
  dispose --> maintainer["Maintainer decides"]
```

### If adopted — the onboarding shape (a primitive, not a worker kind)

- **A `jev_decide` primitive**, not a worker kind: a small script (e.g. `scripts/jobs/jev-decide.sh`) that wraps the TypeSafe decision API (or the OpenRouter `typesafe/jev-1.13` route), taking a *state* + typed questions and returning the typed decision + confidence as structured output. Deterministic callers (a muster pre-pass, the triager residual) invoke it; it never appears in `worker_kinds()`, the tier inventory, or the reputation ledger.
- **Credential plumbing** mirrors the metered-external-arm pattern (`OLLAMA_CLOUD_API_KEY` → tmpfs handoff, image-baked allowlist): a new `TYPESAFE_API_KEY`, value never committed, ships **inert** until a host exports it, callers **fail closed / fall through to the existing deterministic path** when it is absent (never block a job on a missing classification key).
- **Cost accounting**: priced per-decision (~$0.0004), it is a **cheap-primitive cost line**, not a bid-market arm. If metered at all, a single flat rate-card line suffices.
- **Data-egress / monitoring-safety review** (the gating concern): a muster pre-pass would send **maintainer-inbox content**, and a triager residual would send **PR-comment text**, to TypeSafe's servers. Does TypeSafe offer zero-data-retention / no-training-on-inputs (the bar `openrouter`/`ollama-cloud` had to clear)? The OpenRouter route additionally interposes OpenRouter's own policy. This widening needs the same **maintainer authorization recorded in a journal `message` entry** that every monitoring-surface widening needs (CLAUDE.md § Monitoring safety constraint). Jev's bounded-output injection-resistance helps the *injection* half but not the *egress* half.

---

## Alternatives considered

- **A new tier for "cheap Opus" (thread 1).** Rejected: conflates the cost axis into the capability axis and forces every tier-reading consumer to learn a band with no thoughtfulness meaning. Cost belongs in the rate card. Considered and rejected. Reason: the tier vocabulary is deliberately a thoughtfulness ladder.
- **Onboard Jev as a worker kind at a tier (thread 2).** Rejected: Jev is non-agentic and cannot drive a harness or claim a job; a tier row would be a category error. Considered and rejected. Reason: the inventory is a map of harness-driving models.
- **An autonomous Jev "muster" board job (thread 2).** Rejected: violates the liaison-session-only, human-dispose architecture that CLAUDE.md fixes for muster. Considered and rejected. Reason: triage disposition is a maintainer conversation.

## Open questions

- **Opus 5.5 automatic ceiling (A vs B).** Land A (register at mentor, manual-path win) immediately, or go straight to B (retire the anthropic downshift, serve automatic mentor at Opus 5.5)? B is favoured on a per-token basis but the binding constraint is weekly quota, not price — should a bounded token-burn canary (Opus 5.5-at-`medium` vs Opus 4.8 on representative automatic work) gate the flip? What effort default should automatic Opus 5.5 work run at?
- **Keep Opus 5 registered, or retire it?** Recommendation is to keep it selectable but demote it from the mentor default. Confirm.
- **TypeSafe access mechanics.** Direct TypeSafe API (`docs.typesafe.ai`, a `TYPESAFE_API_KEY`) or the OpenRouter `typesafe/jev-1.13` route? Does the garden already hold, or need to obtain, a TypeSafe credential? (Access mechanics are otherwise unverified in this design.)
- **Data-egress / retention policy.** Does TypeSafe (and, if used, OpenRouter) offer zero-retention / no-training on inputs sufficient to send maintainer-inbox and PR-comment text? This is the gating authorization, recorded in a journal `message` entry per the monitoring-safety constraint.
- **The muster architecture question (the maintainer's to answer).** Is a Jev pre-classification pass that **feeds** the interactive muster (human still disposes) what is wanted — or should muster stay fully hand-driven, or is something else intended? Do **not** read "Jev for muster" as an autonomous disposing job.
- **Which decision point to pilot first, and is it worth it?** The muster pre-pass has the clearest value; the triager residual is small because the verb table is already deterministic. Given the integration + egress-review cost, is a pilot warranted now, or parked until a concrete pain point appears?
- **Pricing freshness.** The Opus 5.5 row is transcribed from the `claude-api` skill catalog at its launch; the Jev figures from vendor/press sources (below). Re-verify both against the live vendor pages before a build lands (the catalogs are living).

## Grounding / references

- Opus 5.5 pricing/behaviour: the bundled `claude-api` skill model catalog (Claude Opus 5.5 `claude-opus-5-5`, $4/$20, cache read $0.20, default effort `medium`, thinking always-on, fast mode $8/$40).
- Tier vocabulary and the "Adding or changing a model" checklist: [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md); the resolver `tier_model_for_provider` and the inline routing fallback in `scripts/jobs/common.sh`; the automatic-work ceiling in `scripts/jobs/handlers/monk-claude.sh` and its reaper mirror in `scripts/jobs/reaper.sh`.
- Provider-onboarding precedent (metered external arm, ships inert, one-kind-per-provider): [`designs/claude-ollama-cloud-worker-kind.md`](claude-ollama-cloud-worker-kind.md), [`designs/openrouter-provider.md`](openrouter-provider.md), [`designs/provider-model-catalog.md`](provider-model-catalog.md).
- Muster and monitoring safety: [`roles/liaison/AGENT.md`](../roles/liaison/AGENT.md) § Muster; [`roles/triager/AGENT.md`](../roles/triager/AGENT.md); [CLAUDE.md](../CLAUDE.md) § Orchestrator vocabulary and § Monitoring safety constraint.
- Jev (TypeSafe AI) external sources: [Tom's Hardware](https://www.tomshardware.com/tech-industry/artificial-intelligence/typesafe-ais-jev-offers-an-alternative-to-llms-that-claims-to-be-193x-faster-and-445x-cheaper-system-one-type-model-is-bespoke-for-probabilistic-decision-making), [TypeSafe docs](https://docs.typesafe.ai/models), [OpenRouter `typesafe/jev-1.13`](https://openrouter.ai/typesafe/jev-1.13), [LangChain: building a harness with Jev](https://www.langchain.com/blog/building-a-harness-with-jev).
