---
created: 2026-09-01
updated: 2026-09-01
author: gardener
---

# Design: the `friar` worker kind — Claude Code against Ollama Cloud

| Field | Value |
| --- | --- |
| Status | **Implemented, ships inert (pool zero, unarmed).** The registry row, the provider-parameterized handler, the tier/routing rows, the secrets bridge, eligibility, rate card, and quota classification are all landed on `main2`. The friar claims nothing until a host declares `friars: N` AND the image is rebuilt to carry the new `OLLAMA_CLOUD_API_KEY` env var AND that key is exported on the host. |
| Directive | kriskowal, 2026-09-01: add an Anthropic-taxonomy worker kind that runs Claude Code against Ollama Cloud (ollama.com), authenticated with a maintainer-supplied Ollama API key, alongside the existing `monk` (real Anthropic API), `cleric` (OpenAI/Codex), and `hermit` (local Ollama/Codex). The maintainer has obtained an Ollama Cloud key (held locally, never committed) and greenlit implementation, not just a design. |
| Decision | Add a single `friar` worker kind, **provider `ollama-cloud`**, that **reuses the monk `claude` handler verbatim** (`handlers/monk-claude.sh`), which is now provider-parameterized: seeing `provider=ollama-cloud` it points the same `claude -p` at Ollama Cloud's Anthropic-compatible endpoint by exporting `ANTHROPIC_BASE_URL=https://ollama.com`, `ANTHROPIC_AUTH_TOKEN=$OLLAMA_CLOUD_API_KEY`, and clearing `ANTHROPIC_API_KEY`. Ship at pool zero, explicit-model-only, no automatic/unpinned route — sized like `mystic`/`fireworker`, a paid metered arm routed to a human on funding exhaustion. |

This is the Anthropic-CLI analogue of the `hermit` move (`context/operations/local-inference-amd/worker-backend.md` § "adding a third backend"): where `hermit` reuses `cleric-codex.sh` with `provider=local`, the `friar` reuses `monk-claude.sh` with `provider=ollama-cloud`. One handler, two providers, no new spine file.

## Why a distinct provider, not `anthropic` and not `local`

The friar runs the `claude` CLI (like a monk) and talks to an Ollama endpoint (like a hermit), but it is neither:

- **Not `anthropic`.** The real Anthropic API is a **flat subscription** amortized at ~$0.000069/s in the rate card — Ollama Cloud is a **separate paid, metered** surface billed against the maintainer's Ollama key. Pooling their reputation/rate-card arms would mis-price both, and the anthropic-only *automatic-work cost ceiling* (mentor→minion downshift in the handler) is an Anthropic pricing policy that must not govern the friar's separately-priced tiers.
- **Not `local`.** The hermit's on-box Ollama is **free** compute that never emits a cap signature; `designs/quota-throttle.md` excludes `local` from throttling precisely because it can never be capped. Ollama Cloud **will** emit real rate-limit/quota errors against a metered key, so `ollama-cloud` needs its own throttle classification (below) and must **not** inherit the local exclusion.

So `ollama-cloud` is a first-class provider with its own registry `provider` field, its own tier-inventory/routing rows, its own rate-card arm, and its own quota classification — while sharing the monk handler's code.

## What changed (the full surface)

**Handler (`handlers/monk-claude.sh`) — provider-parameterized, the one behavioral change.**
It now resolves `KIND=$GARDEN_WORKER_KIND` (default `monk`) and `provider=worker_kind_field <kind> provider` at the top, exactly as `cleric-codex.sh` does. The model-resolution block resolves against `$provider` instead of a hardcoded `anthropic`, and the mentor→minion cost-ceiling downshift is gated on `[ "$provider" = anthropic ]`. Immediately before the `claude -p` invocation, a `provider_auth_env` array is built: **empty for `anthropic`** (so the monk/gardener invocation is byte-for-byte unchanged), and for `ollama-cloud` it carries `ANTHROPIC_BASE_URL=https://ollama.com`, `ANTHROPIC_AUTH_TOKEN=$OLLAMA_CLOUD_API_KEY`, `ANTHROPIC_API_KEY=` — passed via `env NAME=VAL` scoped to the child, never exported into the handler. A missing key is an environmental defect (`die_environmental` → requeue), not a job failure.

**Registry (`common.sh`).** New `friar` row in `worker_kind_field` (handler `handlers/monk-claude.sh`, `agent_bin claude`, provider `ollama-cloud`, unit `garden-friar@`, count_key/state_ns `friars`, label `garden-friar`); `friar` appended to `worker_kinds()`; `friar` added to `canonical_worker_kind`, `role_default_model` (empty — explicit-model-only), `role_default_effort`. `ollama-cloud` added to `job_provider_constraint`, `resolve_model_tier` (a new branch classifying concrete cloud tags, rejecting `claude-*` ids), `worker_backend_probe` (a read-only preflight: `claude` on PATH + `OLLAMA_CLOUD_API_KEY` present), and the inline `_model_routing_table` fallback.

**Model/tier (`model-tier-inventory.tsv`, `model-routing-defaults.tsv`).** One provisional onboard row: `ollama-cloud  qwen3.5:cloud  minion`, and a no-fleet-default routing row `ollama-cloud  qwen3.5:cloud`. Per-instance model changes go to `config/model-routing` on `journal2`, never these tracked seeds.

**Secrets (`scripts/systemd/seed-api-key-handoff.sh`, `garden`).** `OLLAMA_CLOUD_API_KEY` added to the tmpfs handoff allowlist (same base64url-charset validation) and to the launcher's `-e` forwarding + usage doc. Both files are baked into the image (COPY / build-contract hash), so **recognizing the new variable name requires an image rebuild**; the key's *value* never enters the image or the repo — only the host-exported env var at container-start time.

**Eligibility (`claim-job.sh`).** `friar` added to the hosted-pool opt-in carve-out (never absorbs unpinned/compat traffic) and given a fence mirroring `mystic`: it claims **only** a job that names `provider: ollama-cloud` or pins a `model:` an ollama-cloud row owns, and it is barred from `builder`/`designer` roles. A foreign kind (monk/cleric/hermit) is left off an `ollama-cloud` pin by the existing backend-fit filter.

**Cost/quota (`rate-card-defaults.md`, `quota-throttle.md`, `reputation.sh`, `comment-provenance.sh`).** A provisional `ollama-cloud * * 0.005154` rate-card arm (conservative fleet-default ceiling so a never-measured arm cannot win on false cheapness). `ollama-cloud` named in the quota-throttle **manually-funded-arms** class (funding exhaustion → alert the maintainer, no auto-restore) with an explicit note that it is NOT the local exclusion. `ollama-cloud-unconfigured` reputation sentinel; `friar→claude` provenance harness mapping (also fixing monk, which previously fell through).

**Docs.** `skills/model-selection/SKILL.md`, `context/operations/{README,starting}.md`, a new `context/operations/ollama-cloud.md` runbook, and `designs/live-budget-admission.md` all enumerate the new arm.

## Verification / risks (smoke-test before trusting the fleet on it)

These are transcribed into the code as UNVERIFIED-until-a-live-run caveats, mirroring how the hermit/cleric handlers flag their un-run CLI surface:

- **Bearer vs x-api-key.** Ollama Cloud's `/v1/messages` wants `Authorization: Bearer` — supplied here as `ANTHROPIC_AUTH_TOKEN`, with `ANTHROPIC_API_KEY` cleared so the CLI cannot send `x-api-key` instead. **Confirm end-to-end against ollama.com**, not just that the CLI starts. The maintainer's independent `ollama launch claude` sanity check is a good first signal.
- **Unsupported endpoints.** Claude Code calls `count-tokens` (and possibly others) that Ollama Cloud may not implement; a hard-fail there would kill every friar job. Confirm the CLI degrades (warns/skips) rather than aborting — this is the known open risk on the live Ollama GitHub issue.
- **Usage/cost accounting.** `usage_capture_result` in the handler parses Claude's JSON envelope. Ollama's token counts are approximate and it has no prompt caching, so cache-read fields will be zero/absent and dollar figures will be missing → the arm degrades to the wallclock proxy (the rate-card row above). Confirm it degrades sensibly rather than recording garbage.

## Open questions (maintainer decisions — arming-time, not blocking the landed code)

The approach is pre-approved and the code ships inert, so these are tuning decisions for when the friar is armed, not a go/no-go design fork:

- **Final kind/provider names.** `friar` / `ollama-cloud` are implemented (the brief's suggested placeholder, matching the `common.sh` "third backend" example). Rename is cheap now, expensive once a host declares `friars:` and reputation arms accrue under those names.
- **Which Cloud model(s) first, at what tier.** Onboarded provisionally as `qwen3.5:cloud` at `minion` (a strong coding tag verified present on the ollama.com catalog 2026-09-01, classed to mirror the local qwen minion row). The exact tag(s) and tier want a capability probe; a second, heavier tag (e.g. a `glm-5.x:cloud` / `deepseek-v4-pro:cloud` / `kimi-k3:cloud` at a higher tier) can be added as data on `journal2` with no code change. Confirm the `:cloud` tag suffix is what ollama.com's Anthropic-compatible route accepts.
- **Pool sizing and host(s).** Ships at `friars: 0` everywhere. Recommended first arming: a small pool (1–2) on one host to accrue reputation before scaling.
- **Attestation to arm?** Like the sysop `local-model` op, the friar is a new **paid external surface** spending the maintainer's key. Should declaring `friars: N` (or a `send-host-op.sh set-workers friar N`) require maintainer attestation the way destructive sysop ops do? The current build does **not** gate it beyond the general journal-push boundary; the key's absence is the de-facto gate (no key → the handler requeues and the backend probe fails the pool closed). Decide whether a stronger explicit arming gate is wanted before the first non-zero pool.
- **Charset of the real key.** The handoff reuses the base64url validation (`[A-Za-z0-9_-]+`). If a real Ollama Cloud key contains a character outside that set (e.g. a `.`), the seed rejects it and the widening must be made deliberately — confirm against the actual key format.

## Grounding

- `context/operations/local-inference-amd/worker-backend.md` — the "adding a third backend" recipe this follows.
- `designs/quota-throttle.md` — the manually-funded-arm classification the friar joins.
- `designs/openrouter-provider.md`, `designs/cleric-worker-bid-auction-reputation.md` — the one-kind-per-provider, ships-inert precedent.
- `context/operations/ollama-cloud.md` — the operator arming runbook.
