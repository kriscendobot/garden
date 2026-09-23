Pushed to `main2` on the first attempt. The build is complete and verified end-to-end.

## Completion report

**What I did:** Added a deterministic per-provider (Claude + Codex) quota/spend panel to the bulletin, showing **token spend, dollar spend, and % of quota** per provider. Landed on `main2` as commit `90854ecb5a` (direct push, no PR, per garden conventions).

**Assessment first (what actually existed vs. what was designed):**
- `usage-meter.sh` (Claude token meter + quota gate) — **built**, reused verbatim.
- `token-cost-ledger` / `cost.sh` / the designed one-line bulletin cost chip — **designed but NOT built** (only `reputation.sh` references the unbuilt `usage/<base>.jsonl`). The cleric build's `GARDEN_USAGE_OUT` codex capture also hasn't landed.
- So I built the panel on the sources that exist today, sourcing the rate card from `provider-model-catalog.md`.

**Sources wired:**
- **Claude tokens + quota %** — `meter_window_total` / `meter_quota_status` (the same numbers the foreman gates on).
- **Claude dollars** — priced from Claude Code session logs *per-model* via the catalog rate card (input + cache_creation@1.25× + cache_read@0.10× at input rate, output at output rate). Labeled **"(notional, rate-card)"** because the Max subscription bills no per-token $.
- **Codex tokens** — billable `last_token_usage` deltas (uncached input + output) from `~/.codex/sessions/**` `token_count` events; cached tokens shown separately.
- **Codex quota %** — Codex's **own self-reported** `rate_limits.primary.used_percent`, which is the honest signal for a plan-metered account (far better than a guessed ceiling).

**Codex dollar/quota basis resolution (the catalog caveat):** On a ChatGPT plan there is no per-token price, so the dollar cell renders an honest `n/a (ChatGPT <plan> plan — no per-token $; plan-metered)`, naming the plan type Codex itself reports. `GARDEN_CODEX_PRICED=1` switches to API-key rate-card dollars (`GARDEN_CODEX_INPUT_RATE`/`_OUTPUT_RATE`). Quota % prefers Codex's reported %, then a configured `GARDEN_CODEX_WEEKLY_QUOTA` (tokens) / `GARDEN_CODEX_DOLLAR_BUDGET`, else `no quota set`. **No misleading dollar figure is ever rendered.**

**Config knobs added:** `GARDEN_QUOTA_PANEL_WINDOW_SECS`, `GARDEN_CODEX_LOGDIR`, `GARDEN_CODEX_PRICED`, `GARDEN_CODEX_INPUT_RATE`, `GARDEN_CODEX_OUTPUT_RATE`, `GARDEN_CODEX_WEEKLY_QUOTA`, `GARDEN_CODEX_DOLLAR_BUDGET`, `GARDEN_QUOTA_LEDGER_DIR` (hook to prefer the ledger's authoritative dollars once it lands).

**Files:** new `scripts/jobs/quota-panel.sh` (sourced by `common.sh` after usage-meter); `bulletin.sh` renders `## Spend & quota` between Messages and Board, with the ticking rows excluded from the change-compare so they never churn a commit; new `scripts/jobs/test/quota-panel-test.sh`.

**Verification:** `quota-panel-test.sh` green (9/9 — exact dollar/token math, Codex billable + self-reported %, plan basis, fail-open, window scoping). Fixed a real harness bug where per-subtest subshells silently dropped the pass/fail tally. Ran a full throwaway bulletin tick end-to-end (exit 0) confirming the section renders into `README.md`; shellcheck clean; an existing common.sh-sourcing test still passes.

**Fail-open / leader-only:** every cell degrades gracefully; panel reflects the leader host's local logs (same single-host scope `usage-meter` documents).

**Follow-ups:**
1. When `token-cost-ledger` (`usage/*.jsonl` with the CLI's `total_cost_usd`) lands, make it the authoritative Claude/Codex dollar source and the fleet-wide multi-host sum (via `GARDEN_QUOTA_LEDGER_DIR` + the design's max rule); today's numbers are leader-host-local, matching the meter.
2. Reconcile with the designed one-line cost *chip* (surface 3 of `token-cost-ledger.md`): it's unbuilt, so no conflict now — the chip can later become a condensed view of, or be subsumed by, this richer per-provider panel rather than a parallel surface.
