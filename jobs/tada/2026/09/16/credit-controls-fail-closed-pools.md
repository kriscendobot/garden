The deliverable is complete, tested, and pushed to `main2`. Here is my completion report.

---

## Completion report: `credit-controls-fail-closed-pools` (CHILD 1 of 4)

### What I did
Changed the claim-gate budget admission to **fail CLOSED** on a pool with no trustworthy ceiling, with a deliberate escape hatch and a loud halt.

**`scripts/jobs/usage-meter.sh`**
- Added `pool_provenance_uncalibrated()` — reuses budget-level.sh's exact uncalibrated set (`''|-|none|placeholder|uncalibrated|seed|tbd|todo`), so leveling and admission now agree on "not a trustworthy setpoint."
- Added `pool_admission_refusal()` — for a **configured** pool, returns REFUSE (+ a one-line operator remedy naming `set-budget-pool.sh`) when the pool is `unmetered` (no ceiling at all) **or** its cap provenance is uncalibrated. An **absent** pool row is deliberately *not* refused (that's the separate "gating not configured" posture → `off` → fail open).
- Rewrote `pool_admits()` to short-circuit to a new `refuse` verdict (rc 1) before the meter check; `off`/`unknown` still fail open (blind sensor / no config aren't misconfigured ceilings).

**`scripts/jobs/claim-job.sh`** — the claim gate now distinguishes `refuse` from `backoff`: on refuse it declines the tick (exit 3), keeps the job, and **pages the maintainer once** (`alert_maintainer` dedups) with the exact `set-budget-pool.sh` remedy, so a mis-set pool is a loud page, not a mysterious silent wedge.

**`scripts/jobs/set-budget-pool.sh`** — updated the header contract, which previously documented the *opposite* (deliberately provenance-blind claim gate); it now states the escape hatch is exactly this setter (promote a calibrated cap).

**`scripts/jobs/test/live-budget-admission-test.sh`** — added 8 regression assertions pinning: unmetered→refuse (the temp-key marker), placeholder cap→refuse (replicating the live 385M/595M pools), bare provenance-absent row→refuse, calibrated cap admits (escape hatch) and still backs off at high water, absent row stays fail-open, the refusal carries an actionable remedy, and a claim-gate integration test (declines + keeps job + pages remedy). Also gave the shared `CFG` row a calibrated provenance so the pre-existing "unreadable meter fails open" test keeps testing that path rather than tripping the new refusal.

### Verification
- `live-budget-admission-test.sh`: **38 passed, 0 failed** (30 pre-existing + 8 new).
- `quota-calibration-test` (8), `proportional-worker-leveling-test` (4), `handler-budget-test` (12), `scheduler-admission-test` (21), `foreman-brake-test` (20), `gardener-claude-tier-serving-test` (13), `qwen-mentor-trial-test` (26): all green.
- 4 other tests fail, but I confirmed they fail **identically on pristine HEAD** (kimi-credit-exhaustion, host-requirements-gating, auction-reputation, proxy-park-body-hygiene) — pre-existing, and none configure budget-pools, so untouched by this change.
- `bash -n` clean; shellcheck shows only pre-existing info notes on lines I didn't touch.

### The live signal — would it have refused those two pools?
**Yes, both.** `anthropic:endolin-garden2-5bcdff64` (cap=385000000) and `anthropic:endolin-garden-ece02cb4` (cap=595000000) are both UNCALIBRATED (`placeholder` provenance), so both now REFUSE at the claim gate. The regression test replicates exactly cap=385M and cap=595M placeholder rows and asserts `refuse`.

### Operational cost, reckoned with
Failing closed on the currently-configured fleet means **both live endolin hosts (this one included) will halt all claims on deploy** until a calibrated cap is set — that is the intended blast-radius bound. I made the halt loud (a deduplicated maintainer page carrying the precise `set-budget-pool.sh <pool> <cap> <calibrated-from>` command) rather than a silent wedge. The remedy is one command; an absent pool row remains a fail-open path, so removing a bad row is also a valid unblock.

### Follow-ups
- After deploy, the maintainer must promote a calibrated cap for the two endolin pools (or the fleet stays halted, loudly). This is the deliberate design, not a defect.
- Children 2–4 of `credit-controls-20260916` remain (the orchestrate watcher promotes the next serial child now that this reached `tada`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/credit-controls-fail-closed-pools.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5214385 cached reads)
- Output: 44751 tokens
- Cost: $5.152167499999999
- Wall-clock: 718s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
