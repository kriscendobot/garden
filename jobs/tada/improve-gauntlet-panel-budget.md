Pushed to `main2`. Job complete.

## Completion report

**What the job asked:** Give staged panel jobs a bounded CI-sized `handler-timeout` with a dedicated configurable default below the claim-TTL ceiling, so the driver budgets the long-running panel stage explicitly instead of dooming it after one deterministic wall hit.

**What I found:** In `scripts/jobs/gauntlet.sh`, `compose_stage_body` stamped a `handler-timeout:` header only on the `clean|fix` (CI-blocking) stages. The `panel` stage fell through to the plain gardener default (`GARDEN_HANDLER_TIMEOUT` = 2400s). Since a single scripted juror-fan-out round routinely exceeds 2400s (the re-panel deadline overrun), the panel base was killed at rc=124 and burned its requeue budget on a wall it was always going to hit.

**What changed:**
- `scripts/jobs/gauntlet.sh`:
  - Added a dedicated, configurable default `GARDEN_GAUNTLET_PANEL_HANDLER_TIMEOUT` (7200s), documented as a CI-sized budget that tunes independently of the clean/fix budget and stays comfortably under the claim-TTL ceiling (≈14339s at shipped defaults, so the gardener honors it verbatim without clamp/escalate).
  - Extended the `compose_stage_body` timeout case so `panel` now stamps that budget; `clean|fix` keep `GARDEN_GAUNTLET_STAGE_HANDLER_TIMEOUT`; only the short `undraft` stage takes the plain default.
- `scripts/jobs/test/gauntlet-test.sh`:
  - New `todo_body`/`handler_timeout` helpers and three assertions in the happy path: clean carries 7200, panel carries its dedicated 7200 (above the 2400 default), undraft carries none. Exports `GARDEN_GAUNTLET_PANEL_HANDLER_TIMEOUT=7200` for determinism.

**Verification:** `bash -n` clean; full `gauntlet-test.sh` suite passes 31/31, including the three new handler-timeout checks.

**Follow-ups:** None required. The 7200s default matches the shepherd/clean-fix CI budget; if panel rounds ever need a different envelope than CI stages, the new knob can be tuned in isolation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-panel-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1400732 cached reads)
- Output: 9928 tokens
- Cost: $1.5273890000000003
- Wall-clock: 176s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
