I fixed the rolling deploy so a leader self-deploy killed by a signal is retried on the next tick instead of being marked rejected. The change is pushed to `main2` as commit `0b0324fd984`.

**What changed**
- **`scripts/jobs/rolling-deploy.sh`:** a new helper, `leader_deploy_rc_is_transient`, treats `GARDEN_OFFLINE_RC`, 143 (SIGTERM) and 130 (SIGINT) as temporary failures. `leader_deploy_failed` now uses it. For those exit codes it logs "temporarily unavailable … retrying next tick" and writes no rejected-candidate marker. Any other non-zero exit is still marked rejected and still logs a warning, as before. This covers the 2026-10-07 15:56:04 incident: the origin fetch was interrupted by SIGTERM, the deploy exited 143, and that blocked every retry for sha `0c64481407d9`.
- **`scripts/jobs/test/rolling-deploy-test.sh`:** a new test runs a fake deploy that exits 143, then one that exits 130, each over two conductor ticks. It checks that the unchanged sha is tried twice, that no rejected marker is written, and that the retry message is logged. I also updated the test file's header list of scenarios.

**Tests:** the full `rolling-deploy-test.sh` run gives PASS=115, FAIL=0. With the script change reverted, all six new checks fail and the rest pass, so the test does catch the bug.

**Follow-up:** host `endolin-garden2-5bcdff64` (the host I ran on) may still hold the rejected marker for `0c64481407d9` from the incident; I didn't check. If it does, it should be cleared, either with `GARDEN_ROLL_CLEAR_REJECTED=0c64481407d9` or by deleting `$STATE/rejected/0c64481407d9`. A newer upgrade-ready sha has its own marker key, so it isn't blocked either way.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rolling-deploy-sigterm-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (699322 cached reads)
- Output: 6402 tokens
- Cost: $0.6912883999999999
- Wall-clock: 220s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
