Clean tree, HEAD == origin/main2. All work is landed. Here is my completion report.

---

## Completion report — job `cybernetics-rec123-budget-loop`

Implemented recommendations 1, 2, and 3 of `designs/cybernetics-audit.md` § 7 as **three ordered commits** on `main2` (all pushed; `origin/main2` = `3cfbeb5ac4`), so no concurrent editor fights over `usage-meter.sh` / `budget-level.sh`.

**Commit 1 `0b86ab72e2` — rec 1 [wrong sensor]: make blindness hold, not maximize.**
`usage-meter.sh` printed a confident `0` whenever it saw no in-window activity, and a blind `0` drove `budget-level` to headroom 1 (four workers) — maximum workers on no signal (§ 2.2). Both blind-zero paths now distinguish "no signal" from "measured zero" via a positive liveness marker:
- `_meter_session_total`: an empty mtime-pruned listing returns the genuine `0` **only** if at least one session `.jsonl` exists under the logdir (proving Claude wrote there); otherwise unknown (rc 1) → the caller fails open and skips.
- `meter_journal_host_tokens`: an empty `usage/` ledger now returns unknown instead of a confident `0`; a populated ledger with no rows for the host still folds to a genuine `0`.

Verified all other callers (`deadline-nudge.sh`, `quota-panel.sh`, publisher) handle the unknown rc gracefully.

**Commit 2 `60ceb2feeb` — rec 3 [correct but couples badly]: give budget-level restraint.** Four bounded corrections, no new loop: (a) per-tick step clamp (`STEP`, default 1 — narrows the gap one count/tick); (b) confirm-before-move dwell copied from `backend_effective_count` (raise after `UP_CONFIRM`=2 same-direction ticks, throttle promptly at `DOWN_CONFIRM`=1; a boundary flip resets the streak, host-local state, no journal write); (c) skip leveling entirely while `fleet_draining`; (d) read/steer the per-host active Anthropic kind via `anthropic_active_kind` (monk on a cut-over host) instead of the hardcoded `gardeners:` awk.

**Commit 3 `3cfbeb5ac4` — rec 2 [wrong sensor]: don't actuate on setpoints the config disclaims.** `config/budget-pools` rows gained provenance columns (calibrated-from, date); `budget-level.sh` treats an uncalibrated/placeholder-marked cap as config-absent (levels nothing, alerts once with a stable dedup key). `budget-pools-placeholder.tsv` now carries and self-discloses the columns. Added the already-designed **`weekly-capacity-calibration.sh`** (`recurring-budget-calibration.md`, `live-budget-admission.md` OQ1): a deterministic scheduler-preflight that folds the closed week's `usage/` ledger, upserts a weekly-capacity record keyed on (host, anchor), takes max-over-trailing-N per account, and rewrites the summed token bucket — idempotent per anchor. It **measures and records only**; it never writes `config/budget-pools` (auto-promotion stays a maintainer decision, the audit's own § 2.3 lesson).

**Out of scope, respected:** did not loosen the cap-consistency guard (§ 4.3); did not build the campaign-bucket draw-down side (`orchestrate --from-bucket`).

**Verification** (per `local-verify` / `pre-push-gates` spirit for garden-infra: this lands bare on `main2`, no project PR):
- `bash -n` + `shellcheck -x` clean on all three scripts (only pre-existing info notes remain).
- `live-budget-admission-test.sh`: 29/29 (rewrote the leveling section for the new controller — step clamp 4→3, monk active-kind steering, two-tick dwell, drain suspension, uncalibrated-skip + alert-once; plus new blind/idle/empty-ledger assertions).
- New `weekly-capacity-calibration-test.sh`: 10/10 (fold windowing, upsert, max-over-N, summed bucket, optional index, idempotency, leader-only).
- `meter-journal-cutoff` 2/2, `quota-panel` 9/0, both `budget-snapshot` tests pass, and `tests/checks/run.sh` 10/10 suites.

**Follow-ups (messaged to the maintainer via the liaison):**
1. **Live behavior change:** after deploy, the existing provenance-less `config/budget-pools` rows read as uncalibrated → `budget-level` stops leveling + alerts once per pool (intended rec-2 behavior). Append a `calibrated-from date` to each live row to resume leveling.
2. **`weekly-capacity-calibration.sh` is not armed** — wire it as the scheduler preflight (`GARDEN_SCHEDULE_PREFLIGHT=…`) when ready.
3. Auto-promoting a measured cap into `config/budget-pools` remains an open maintainer decision (owned by the two designs).

Recs 5 and 10 of the same audit were already landed by sibling jobs (`ce57d564b7`, `5a5d705275`).

Self-improvement: nothing this time — the reusable principle (distinguish no-signal from measured-zero with a positive liveness marker; don't wire a disclaimed setpoint to a full-authority actuator) is already captured in `cybernetics-audit.md` §§ 2.2/2.3 and now in the code's own comments; no role/skill was missing or wrong.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec123-budget-loop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 167 tokens (19315685 cached reads)
- Output: 124287 tokens
- Cost: $15.580402500000003
- Wall-clock: 1687s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
