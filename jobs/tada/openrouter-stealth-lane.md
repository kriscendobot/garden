Inbox empty. The job is complete. 

## Completion report

Built **Child 2 of 3** of the OpenRouter arc: the `openrouter-promo` cloaked ("stealth") lane, per the maintainer's decision to admit rotating cloaked models *while cloaked* (design `openrouter-provider.md` option b). Committed as `b0934418c6`, pushed to `main2`.

**What it is.** A second OpenRouter worker kind, `openrouter-promo`, sharing the stable lane's handler, endpoint, key, and the **same fail-closed ZDR/deny-collection privacy proxy** (inherited unconditionally — the authorization is for undisclosed *provenance* only, never logging), but with its **own** kind, provider, unit, count/state namespace, and routing namespace (`openrouter-promo/<wire-id>`). Because the reputation arm is keyed on `(kind, provider, model, thoughtfulness)`, a cloaked model's short-lived, separately-re-reviewed history **never pools** with a named model's, and `openrouter/*` does not glob-match `openrouter-promo/*`, so neither lane can claim the other's pins (asserted in tests).

**The re-review cadence (the design's undesigned requirement), enforced in two layers:**
- **Read-side, daemon-free (primary):** enabled ids live in a **journal ledger** (`config/openrouter-promos`, `wire-id/tier/attested_at/attested_by`). A row whose attestation is older than 24h (`GARDEN_OPENROUTER_PROMO_CADENCE_SECS`) **stops classifying** — auto-disabled by construction, no timer needed. Journal-backed (not tracked inventory) so a daily-rotating id needs no deploy.
- **Deterministic janitor:** `openrouter-promo-recheck.sh` (LLM-free; wired as a daily schedule preflight, exits 2 = no agent dispatched) prunes expired rows and **404-drops** ids that rotated away, alerting per disable. Only a definitive 404 or stale attestation disables; transients never do.

**Tooling & rip-cord:** `openrouter-promo-attest.sh` (enable/re-attest = the periodic review), `set-openrouter-promos.sh` (pool count), `openrouter-promo-drop.sh` (per-id rip-cord). Documented rip-cord = `set-openrouter-promos.sh 0` + `openrouter-promo-drop.sh <id>`.

**Surface touched:** `common.sh` (registry, ledger helpers, all model-selection/eligibility/probe paths), the two Codex handler files, `claim-job.sh` (explicit-model-only fence), `reputation.sh`, `comment-provenance.sh`, `rate-card-defaults.md`, `post-job.sh` (canary allowlist — also fixed the *stable* lane's documented-but-rejected `--provider-canary openrouter`).

**Tests:** new hermetic `openrouter-promo-lifecycle-test.sh` (11/11 — attest→classify→recheck-auto-disable→drop); promo coverage added to the spine test (**249/249**) and harness test (**25/25**). Adjacent suites (health-gate, scaler, backend-autotune, model-routing, comment-provenance, api-key-handoff) all green.

**Ships inert:** empty ledger, pool zero, no id attested — the lane does nothing until a maintainer attests an id and raises the pool. Supplies and spends nothing.

**Notes / follow-ups:**
- Two failures in `auction-reputation-test.sh` are **pre-existing** (verified identical against pristine `HEAD` reputation.sh) — unrelated to this job.
- Registering the recheck schedule and actually attesting/enabling any id are the separate host-side, maintainer-directed steps the liaison handles (as with the stable lane's canary).
- Child 3 (`openrouter-reputation-unmask-migration`) can now migrate from a real `openrouter-promo` arm shape.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/openrouter-stealth-lane.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 217 tokens (24283850 cached reads)
- Output: 102143 tokens
- Cost: $17.408095999999993
- Wall-clock: 1706s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
