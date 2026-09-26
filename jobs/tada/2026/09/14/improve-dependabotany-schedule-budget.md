Pushed cleanly to main2. The work is complete.

## Completion report

**What the job asked:** Make `dependabotany-recheck-*` schedules default to a 7200-second handler timeout, alongside their existing preflight default, because the PR #1268 recheck deterministically hit the generic 2400s wall despite needing botanist review + CI shepherding + merge handling.

**What I changed** (committed `12fcaa50c4`, pushed to `main2`):

- **`scripts/jobs/set-schedule.sh`** — extended the `dependabotany-recheck-*` family case block to attach `handler_timeout="7200"` when neither an explicit (`GARDEN_SCHEDULE_HANDLER_TIMEOUT`) nor a preserved value exists, exactly mirroring the existing `preflight` default. The default flows through the existing `validate_handler_timeout` guard (7200 ≤ 14339s claim-budget max) and the preserve-on-edit logic, so an explicit value still wins and the budget survives later cadence edits. Updated the header comment block.
- **`scripts/jobs/test/run-test.sh`** — added two assertions to the existing family-default subtest: the recheck schedule carries `handler-timeout: 7200` (and preserves it across a second edit), and an ordinary schedule stays unbudgeted (default is confined to the family).
- **`skills/schedule/SKILL.md`** and **`roles/botanist/AGENT.md`** — documented the new family default alongside the preflight one, noting *why* (a scheduled recheck does not resolve to the `role: botanist` 7200s handler budget already in `common.sh`, so the budget must be stamped on the schedule itself).

**Verification:** ran an isolated harness replicating the test's journal fixture — confirmed the dependabotany schedule gets `handler-timeout: 7200`, preserves it and its preflight across a cadence edit (daily→hourly), and that an ordinary schedule receives neither. Syntax-checked both scripts. (The full `run-test.sh` suite is too slow to complete in a single turn here, so I isolated the relevant subtest.)

**Follow-ups:** none. The alignment with the existing `GARDEN_BOTANIST_HANDLER_TIMEOUT:=7200` role default is intentional; if that role figure ever changes, this schedule default should track it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-schedule-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1230383 cached reads)
- Output: 10281 tokens
- Cost: $1.4213225
- Wall-clock: 1218s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
