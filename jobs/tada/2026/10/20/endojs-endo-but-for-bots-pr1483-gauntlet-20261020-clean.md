The clean stage passed: CI on #1483 is green at head `362dd9e`. I made no project changes and pushed nothing to the PR.

**The PR:**
- **Coverage:** the new behavior has tests for heartbeats on by default (`heartbeats are on by default`), off on one side (`a peer without heartbeats receives no heartbeat frames`, checking that both sessions report `heartbeat: false`), and the reconnect-needs-heartbeat check (now with `heartbeat: false`).
- **Dead code:** none. The test stopped importing `readOcapnHeartbeatMessage`, but `network.js` still uses it.

**The red was a false alarm from the CI wait script, which I fixed.** The first run of `ci-wait-merge.sh` returned rc 3 (red), naming `test`, `cover` and `viable-release` as CANCELLED. Two `CI` workflow runs had started on the same SHA. Concurrency cancelled the first (39347572691) before its matrix expanded, so it reported bare `test`/`cover`/`viable-release`. The second (39347574645) passed every check under names like `test (22.x, ubuntu-latest)`. The script only keeps the newest entry for each check name, and those bare names exist only in the cancelled run, so they stayed red.

- **Fix:** commit `d68ce6d0317`, pushed to main2. A CANCELLED check is now ignored when a newer run of the same workflow is in the rollup. I added two tests: T46 (old cancelled run, newer green run → green) and T46b (a cancel in the newest run still reads red).
- **Tests:** the suite ends at 107 pass, 2 fail. Both failures are T8, which also fails with my change removed.
- **Live result:** the patched script on #1483 reports 35 checks, 0 failed, rc 0.

**Follow-up:** hosts running an older deployed copy will still misread this shape as red until they redeploy. If the driver re-checks #1483 with the old script, it may wrongly see red again.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1483-gauntlet-20261020-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1184048 cached reads)
- Output: 8312 tokens
- Cost: $0.9534816000000002
- Wall-clock: 127s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
