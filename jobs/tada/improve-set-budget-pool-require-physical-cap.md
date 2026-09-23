The commit landed on `origin/main2` and the inbox is empty. The work is complete.

## Completion report

**Problem.** `budget-level.sh` apportions one monk fleet ceiling across every enabled *calibrated* Anthropic weekly-tokens pool and requires each such pool's host to carry a physical-cap row in `config/worker-leveling` (proportional-worker-leveling.md § 1.4). A freshly calibrated pool whose host lacks that row (`oros-studio-garden-ce242c49`) trips the fleet-wide gate at `budget-level.sh:82` and sets `mv=0`, **freezing all monk allocation every leveler tick** until a human intervenes.

**Fix — caught at the write boundary in `scripts/jobs/set-budget-pool.sh`:**
- Added a gate (`require_leveling`) that fires only when enabling a **calibrated Anthropic weekly-tokens** pool (`provider=anthropic`, `--kind weekly-tokens`, provenance outside the uncalibrated set, via the shared `pool_provenance_uncalibrated`).
- Added a `_leveling_reconcile` function and two options, `--monk-cap N` / `--cleric-cap M`. When leveling is configured (the file exists), it **validates** an existing host physical-cap row, **upserts** it from `--monk-cap` (insert or override), or **rejects (exit 2)** when the row is absent and no cap is supplied.
- The worker-leveling row and the pool row commit in the **same atomic journal commit** (staged together before one `commit_and_push`; the transform re-derives idempotently across CAS retries). A hard reject aborts before either file is touched.
- The upsert is refused if it would still freeze the fleet (physical capacity below `monk-fleet-ceiling`, or host count above the one-per-host floor) — both deliberate `set-worker-leveling.sh` policy calls. The fleet ceilings (`F`/`K_max`) are never modified.
- Uncalibrated/placeholder, unmetered, and non-Anthropic pools, and an unconfigured leveler, impose no requirement (no freeze is possible), preserving existing behavior.

**Changes.**
- `scripts/jobs/set-budget-pool.sh` — gate, options, `_leveling_reconcile`, driver honoring the non-retryable reject code (rc 3 → exit 2), and an expanded header documenting the coupling.
- `scripts/jobs/test/set-budget-pool-physical-cap-test.sh` — new hermetic suite (10 assertions): reject on missing row, atomic upsert, validate-only, override, capacity/one-per-host feasibility rejects, unconfigured-leveler pass and reject, uncalibrated/non-Anthropic/unmetered exemptions.
- `designs/manual-quota-calibration.md` — operator-facing note of the new setter contract.

**Verification.** New suite 10/10; pre-existing `quota-calibration-test` (8/8) and `proportional-worker-leveling-test` (6/6) and `live-budget-admission-test` (38/38) still pass; `bash -n` and shellcheck clean (only pre-existing info notes). Pushed as `dd3e002519` on `origin/main2`.

**Follow-ups.** None required. Note the new test follows the standalone `*-test.sh` convention of its peers and, like them, is not in the curated `GARDEN_DEPLOY_TEST_SUITES` smoke subset — if a maintainer wants it in the deploy gate, it can be added to that list in `deploy-garden.sh:104`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-set-budget-pool-require-physical-cap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5400333 cached reads)
- Output: 45601 tokens
- Cost: $5.2869615
- Wall-clock: 647s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
