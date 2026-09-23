All work complete and pushed to main2. Here is my completion report.

---

## Completion report: `design-claude-ollama-cloud-worker-kind`

Added the **`friar`** worker kind (provider **`ollama-cloud`**) — Claude Code (`claude`) driven against Ollama Cloud's Anthropic-compatible endpoint — as both a design and a **landed, working implementation** on `main2` (commit `ceeb7306a0`). It ships **inert** (pool zero, unarmed) until a host declares `friars: N`, the image is rebuilt for the new env var, and the maintainer's key is exported.

### What changed
- **Handler** (`monk-claude.sh`): now provider-parameterized like `cleric-codex.sh`. For `provider=ollama-cloud` it injects `ANTHROPIC_BASE_URL=https://ollama.com`, `ANTHROPIC_AUTH_TOKEN=$OLLAMA_CLOUD_API_KEY`, and clears `ANTHROPIC_API_KEY` (scoped to the child via `env NAME=VAL`) around the same `claude -p` call; model resolution is provider-scoped and the anthropic-only mentor→minion cost ceiling is gated on `anthropic`. The monk/gardener path stays byte-identical (empty auth array).
- **Registry/wiring** (`common.sh`): `friar` row + `worker_kinds`/`canonical_worker_kind`/`role_default_model`/`role_default_effort`; `ollama-cloud` in `job_provider_constraint`, `resolve_model_tier` (new branch rejecting `claude-*` ids), `worker_backend_probe` (claude + key preflight), inline routing fallback.
- **Model/tier**: provisional `ollama-cloud → qwen3.5:cloud @ minion` in both TSVs (verified present on the live ollama.com catalog 2026-09-01; `:cloud` tag confirmed), no fleet/role default.
- **Eligibility** (`claim-job.sh`): explicit-model-only fence like mystic (pin/canary required, no builder/designer, opt-in carve-out).
- **Secrets**: `OLLAMA_CLOUD_API_KEY` in `seed-api-key-handoff.sh` allowlist + `garden` `-e` forwarding/docs.
- **Cost/quota**: provisional rate-card arm; `quota-throttle.md` names `ollama-cloud` in the manually-funded-arm class (explicitly **not** the local exclusion); reputation sentinel; `friar→claude` provenance.
- **Docs**: new design doc (with Open questions), `context/operations/ollama-cloud.md` runbook, and model-selection/operations/live-budget enumerations.
- **Tests**: friar registry/eligibility/unit/scale/tier coverage added; `api-key-handoff`, `worker-health-gate`, `monk-worker-kind-compat` updated (two used `friar` as their unknown-kind sentinel → switched to `phantom`).

### Verification
`worker-spine-kinds` (286/0 — includes both `friar` and the peer's concurrently-landed `opencode-anthropic`), `worker-health-gate` (29/0), `api-key-handoff` (7/0), `model-routing` (32/0), `tier-vocabulary-routing`, `monk-worker-kind-compat` (25/0), `scaler-desired-count`, `flat-provider-censor`, `foreman-provider-order`, `provider-quota-backoff`, `gardener-claude-tier-serving`, `worker-startup-cgroup-reap` — all green. Handler and touched scripts pass `bash -n`/shellcheck (only harmless SC1091).

**Rebase note:** a sibling job landed `opencode-anthropic` on `main2` mid-flight; I hand-resolved the resulting registry/eligibility/test conflicts to keep **both** new kinds. Investigated one `mentor-provider-order-test` subtest that flips to fail — it is a fixture artifact, not a code bug: the handler's `already_fixed_pending_deploy` guard correctly sees my *uncommitted* edit to the tracked `garden` file as a pending change; it clears once merged (now done). A separate `Dockerfile` subtest fails even on pristine main2 in this worktree (a pre-existing peer divergence), unrelated to this work.

### Follow-ups (maintainer decisions, all in the design doc's Open questions)
Final kind/provider names; which Cloud model(s) and tier to onboard first (a capability probe; more tags addable as journal data with no code change); pool sizing and host(s); whether arming a paid external pool should require attestation like the sysop `local-model` op; and confirming the real key's charset fits the base64url handoff validation. Live smoke-tests to run before trusting the fleet on it: end-to-end Bearer auth against ollama.com, Claude Code's `count-tokens` behavior on the unsupported endpoint, and usage-accounting degradation. The `reputation/rate-card.md` provider row is per-instance `journal2` state (tracked seed added to `rate-card-defaults.md`); the maintainer adds the journal row when arming.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-claude-ollama-cloud-worker-kind.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 363 tokens (37451879 cached reads)
- Output: 121669 tokens
- Cost: $27.56645850000001
- Wall-clock: 2290s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
