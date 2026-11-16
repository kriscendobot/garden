The job is already fully complete. The prior attempt committed `ef1323e1e30` and it is already on `origin/main2` (HEAD == origin/main2), so there is nothing left to push.

## Completion report

**Job:** `improve-edge-latch-cleric-freeze` — stop `scripts/jobs/budget-level.sh` from re-logging an identical cleric-allocation-frozen warning every leveling tick when a host sits above its physical cap.

**State found:** A prior attempt had already committed and pushed the exact fix as `ef1323e1e30` ("fix: edge-latch cleric preflight freezes"). HEAD equals `origin/main2`, so the work is durably landed — nothing to re-do or re-push.

**What the committed change does:**
- Both cleric-freeze arms (the fail-fast `finish` path, prev. line ~494, and the `else` fallback, prev. line ~505) now route through `report_freeze budget-level-cleric-preflight "$bad" "cleric allocation frozen: $bad"` instead of a bare `log "WARN:"`.
- A matching `report_unfreeze budget-level-cleric-preflight …` recovery notice fires once on the success path.
- This mirrors the monk preflight path (`budget-level-monk-preflight`, lines 373–374) exactly: `report_freeze`/`report_unfreeze` delegate to `alert_maintainer_edge`/`alert_maintainer_edge_clear`, which edge-latch on freeze onset / reason-change and emit a single recovery — so one onset alert and one recovery replace the per-tick supervisor noise.
- A stable fingerprint key (`budget-level-cleric-preflight`) ensures steady-state repeats are suppressed.

**Verification (this attempt):**
- `bash -n scripts/jobs/budget-level.sh` → clean.
- `scripts/jobs/test/proportional-worker-leveling-test.sh` → **11 passed, 0 failed**, including the newly added regression `cleric preflight freeze warns once, recovers once, and suppresses steady repeats`.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-edge-latch-cleric-freeze.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 18 tokens (496023 cached reads)
- Output: 3553 tokens
- Cost: $0.8780865 (2 engagement(s) unpriced)
- Wall-clock: 785s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
