Pushed to `main2`. The job is complete.

## Completion report

**Commit:** `3c696ea6c8` — `fix(triager): stop recording no-op fail-open pacing decisions` (pushed to `origin/main2`).

**What changed:**
- `scripts/jobs/triager.sh` — The fail-open branch of `triager_pace_schedule` (status != paced) now records a `triager-pacing:current-cadence` / `fail-open-skipped` decision only when the `(status, reason)` state **changes** for the slug, plus the same 6h `PACE_DECISION_HEARTBEAT_SECS` heartbeat that 74461976fd introduced — not on every tick. Per-slug state lives in a dedicated latch (`PACE_FAILOPEN_MARKER`, `failopen-<slug>`) rather than the paced `PACE_MARKER`, because the fail-open branch returns before any `next_wake` is computed and must not clobber the scheduling fields. The latched warning (`triager_pace_note_warning`) and all pacing behaviour are untouched; a state-dir-unwritable path skips the record (churn-safe) rather than writing every tick.
- `scripts/jobs/test/triager-pacing-test.sh` — two new cases: three fail-open ticks with an unchanged reason record exactly one decision; a reason change records a second.

**Before/after rate:** In a persistent `missing-role-cost-samples` state this was ~500 fail-open decision commits/day/slug (evidence: 28 in ~80 min across 11 slugs on the leader after it deployed 74461976fd). After: at most one record per `(status,reason)` change, plus one per 6h heartbeat.

**Sibling-emitter verdict (both NOT per-tick — no fix needed):**
- `budget-level.sh:161` — `apply_target` returns early when `cur==target` (steady state); the fail-open record fires only on an actual level-change apply whose operation failed. No steady-state churn.
- `claim-job.sh:227` — the `unknown` fail-open record fires only when the budget pool is *unreadable*; a readable pool (steady state) admits without recording, and claims are event-driven (a job to claim), not a fixed timer. No steady-state churn.

**Tests:** `triager-pacing-test.sh` 14/14 pass; verified the two new cases genuinely fail against the pre-fix `triager.sh` (records 3, then 4). `triager-test.sh` (151/0) and `triager-claude-handler-test.sh` (7/0) still green. Deploy will roll via the normal upgrade-ready path.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-triager-pacing-fail-open-churn.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1426216 cached reads)
- Output: 15272 tokens
- Cost: $1.8954980000000003
- Wall-clock: 237s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
