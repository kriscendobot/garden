All DoD items verified. The build is complete. Let me write the completion report.

---

## Completion report — `build-token-cost-ledger`

**Finding on resume:** the core ledger build was already committed and **deployed** by a prior session (commit `11d0e8655f`, now an ancestor of `main2`) and is producing real data live. My session's job was to verify the full chain end-to-end and close the one uncovered lane. The remaining gap — the **moonshot/kimi** lane — is what I built and pushed.

### What was already working (verified, not rebuilt)
- **anthropic (`gardener-claude.sh`)** — *measured, tokens + dollars.* `--output-format json` envelope → `usage_capture_result` + `/usr/bin/time` rusage. Live rows carry real `total_cost_usd`.
- **openai/codex (`cleric-codex.sh`)** — *measured tokens, deliberately unpriced.* Parses codex's `token_count` event; codex reports no provider dollars, so rows carry tokens with no `total_cost_usd` (never a guessed rate).
- Storage/footer/reducer chain: `usage/<base>.jsonl`, the strip-and-regenerate `## Cost` footer, `complete-job.sh`'s reputation event, and `reputation-reduce.sh` (which now does `att++` for **every** event, censored or not) — all live.

### What I built this session
- **`meter_kimi_home_usage`** (`kimi-provider-common.sh`): the kimi lane's lane-specific capture. Kimi writes neither `~/.claude` session logs nor a usage-bearing stdout stream (I probed the live CLI to confirm), so the design's layer-1/layer-2 paths can't reach it. It *does* record each turn's usage to a `usage.record`/`usageScope:turn` line in a per-session `wire.jsonl` under `KIMI_CODE_HOME`; the helper sums the four classes (`inputOther`/`output`/`inputCacheCreation`/`inputCacheRead`), returning genuine-0 vs unknown correctly.
- **`mystic-kimi.sh`**: snapshots usage before/after the one invocation and writes the delta to `$GARDEN_USAGE_FILE` (`source:"result"`, `model:"kimi-k3"`, tokens only, no dollars — same shape as codex). Written after the run, outside the credential-stripped kimi env, fully fail-open — the agent can neither author nor destroy it. The pre/post delta is correct across a persisted `--continue` resume home.
- **Test**: extended `mystic-kimi-harness-test.sh` — the fake kimi now emits a `usage.record` wire log, and three new assertions drive it **through the real gardener spine** and confirm the completed engagement's ledger row carries the measured tokens (unpriced), and the tokens reach the tada `## Cost` footer. **33/33 pass.**

### Definition-of-done evidence
- **Rows written by code on every outcome:** 113 `usage/*.jsonl` files on `journal2`.
- **Fresh event with real `agentic_dollars`:** `endojs-endo-but-for-bots-pr656-shepherd` → `agentic_dollars: 5.504056` (`source: live`).
- **Arm with `attempts > 0` (first in garden history):** `gardener/anthropic/claude-opus-4-8/high/design-m@main2.md` → `attempts: 1, accepts: 1, mean_dollars: 2.301883`. **19 arms** now non-zero.
- **Per-lane status:** anthropic = measured (tokens + dollars); openai/codex = measured (tokens, unpriced — no provider dollars); moonshot/kimi = **now measured** (tokens, unpriced) via this change.
- **`usage-meter.sh` unchanged:** the ledger commit's diff to it is a pure append (`124 added, 0 deleted`, single hunk at line 265); `meter_quota_status` was last touched by the original gate commit `8562eb991d`. Behavioral check: no quota → `off`, quota-set-but-no-source → `unknown` (fail-open intact).
- **Pushed to `main2`:** `b0acba2103` (HEAD == origin/main2), direct push per own-repo convention.
- Regression: `token-cost-ledger-test.sh` 5/5, grep-gates 7 suites clean, `bash -n` clean on all touched files.

### Coordination / follow-ups
- **`fix-censored-events-frozen-reputation-arm`** — left open, as instructed. Kimi/codex rows are tokenful-but-dollarless, so their reputation events still read `agentic_dollars: censored`; they now correctly count toward `attempts` in the current reducer, but that job remains the owner of censored-event handling.
- **`wallclock-cost-proxy-for-censored-arms`** — the ledger is now the primary path for all three lanes; the wallclock proxy remains the fallback only for outcomes where capture fails.
- **Deploy:** the anthropic/openai capture is already live on the deployed fleet (real rows prove it); the new **kimi** capture is on `main2` and will go live on the next deliberate `deploy-garden.sh`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-token-cost-ledger.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 105 tokens (5758750 cached reads)
- Output: 45602 tokens
- Cost: $5.42026
- Wall-clock: 820s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
