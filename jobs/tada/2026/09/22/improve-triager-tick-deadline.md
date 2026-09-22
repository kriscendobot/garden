Done. Work complete and pushed.

## Completion report

**Job:** `improve-triager-tick-deadline` — add an internal bounded tick deadline + clean fail-open exit to `scripts/jobs/triager.sh` before systemd's 900s unit wall, so slow nested journal/fetch/pace work defers to the next tick rather than being SIGTERM-killed.

**What I did**
- Added `GARDEN_TRIAGE_TICK_DEADLINE` (default **780s**, ~120s headroom under the unit's `TimeoutStartSec=900`; `0`/negative disables). A firing records its start epoch in `TICK_START` (overridable via `GARDEN_TRIAGE_TICK_START`, with a `GARDEN_TRIAGE_TICK_NOW` clock override, for deterministic tests).
- Added a small, purely-local guard `triager_tick_defer_if_past_deadline <phase>`: once elapsed wall-clock ≥ deadline it logs a clean fail-open and `exit 0`. It does **no** journal/network IO of its own (recording a decision there would add the very round-trip we're avoiding) and fails open toward proceeding on any unparseable clock.
- Placed checkpoints at each phase boundary: before the steady-state repo fetch, before the activity-cursor read, before the failcount-cursor read, before starting the triage handler, and before the cost-aware pace projection (both the no-change and success branches).
- Because the cursor is never advanced past a deferred change, the next tick re-triages the identical, idempotent transition — nothing is lost (same guarantee the existing crash-then-re-triage cursor already gives).
- Documented the mechanism in the file header and at each knob.

**Tests**
- Added `triager-test.sh` case **O**: forces "already past deadline" deterministically by pinning `GARDEN_TRIAGE_TICK_START` far in the past with a tiny deadline. Asserts clean exit 0 (not SIGTERM/Failed), handler **not** started, cursor left unadvanced, the next in-budget tick triages the same change (idempotent defer), and `deadline=0` never defers.
- Full suite: **143 passed, 0 failed** (133 pre-existing + 10 new assertions). `bash -n` clean; `shellcheck -x` surfaces only pre-existing info-level notes, none from this change.

**Changed:** `scripts/jobs/triager.sh`, `scripts/jobs/test/triager-test.sh`. Committed and pushed to `main2` (`762390ec8e4`, push accepted on first attempt).

**Follow-ups (optional, out of scope):** the triage *handler* (`claude -p`) itself remains internally unbounded — the deadline gates whether it *starts* this tick, not its runtime. If a single handler run is ever the thing exceeding 900s, a separate wall-bound on the handler would be the next lever (kept out here to avoid turning a slow handler into a spurious breaker-tripping failure). The 780s default is tunable per-host via the new env knob if minion.town needs more/less headroom.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-tick-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3308381 cached reads)
- Output: 26833 tokens
- Cost: $3.4374315
- Wall-clock: 420s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
