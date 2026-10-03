## Completion report: improve-quota-recovery-transient-classification

**What I did:** A gauntlet stage that failed only because of a provider quota back-off was being parked as `failure_classification: unknown`. The quota back-off had already reached its reset time. `gauntlet.sh` then halted instead of retrying. The reaper already treated this case as transient when deciding whether to hold the doom notice, so the two disagreed. I fixed that and added a test.

**What changed** (commit `c0db68e4392`, pushed to `main2`):
- **`scripts/jobs/reaper.sh`:** a `requeue-exhausted` doom with `quota_recovery=1` now writes `failure_classification: transient`. It uses the same evidence `doom_transient` uses at line 1189. The new branch comes after the terminal-failure (`deterministic`) check, so a job with explicit deterministic evidence is still classified deterministic.
- **`scripts/jobs/test/reaper-gauntlet-handoff-test.sh`:** `place_stale` can now stamp a quota back-off marker whose reset time has passed. New subtest 6 checks that such a gauntlet stage is parked as `requeue-exhausted` + `transient` and that its notice is held back rather than sent to the maintainer straight away.

**Verification:**
- The handoff test passes 6/6 with the fix.
- Against the old `reaper.sh`, subtest 6 fails because the stage is recorded `unknown`, so the test does catch this bug.
- `reaper-doom-park-test` (12/12), `retry-narrowing-test` (16/16) and `provider-quota-backoff-test` (7/7) all pass.

**Follow-ups:** None needed. The fix takes effect on each host at its next deploy. Stages already parked as `unknown` from this cause, including the 2026-10-03T03:17:37Z halt, stay as they are and need promoting or re-running by hand.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-quota-recovery-transient-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (592028 cached reads)
- Output: 4740 tokens
- Cost: $0.7395016
- Wall-clock: 93s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
