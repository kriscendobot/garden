The CD deploy moved minion.town's Endo daemon to `1706e63247fb2c23b767f24fa1bd4b35d575089e`, and the box is healthy. The daemon did not crash-loop, so there is no rollback or pin revert, and I made no code changes.

**Precondition:** kriscendobot/minion.town#139 merged at 2026-09-29T21:59:36Z as `7e87a44e2bfaa88d790b53d81f3ef50c0a63a978`.

**Deploy run:** the push-triggered `deploy (continuous deployment)` run 36636831952 for `7e87a44` succeeded (21:59:42Z–22:03:30Z), so I didn't need to dispatch one. Its "Deploy Endo daemon" step:
- upgraded `f9cbcfc426f7 -> 1706e63247fb`;
- passed the preflight against a copy of the persisted state (every formula came back up and workers reported ready);
- restarted `endo-daemon`, which came up active at 22:01:00 UTC;
- logged "pinned commit on box: 1706e63247fb…" and "endo-daemon deployed (pin 1706e63247fb)".

**Checks on the box:** I ran these over SSM with `ssm_run` (instance i-0380cd68b90020fad, us-west-1). I did not run `endo list`; the only socket probe was a raw Unix-socket connect.
- `/opt/endo/ENDO_COMMIT` is `1706e63247fb2c23b767f24fa1bd4b35d575089e`.
- I sampled four times, a minute apart (22:40:58–22:43:58Z):
  - **endo-daemon:** active every time, with `NRestarts=0`, the same MainPID 1885103 and active since 22:01:00. That is about 43 minutes up with no restarts.
  - **minion-mcp:** active every time, with `NRestarts=0`, active since 22:02:23.
- All seven endo-daemon-owned endo processes are in the `endo-daemon.service` cgroup: `run-daemon`, `manager-node.js` pid 1885125 and five `worker-node.js`. None run outside the unit.
- The `127.0.0.1:8920` listener is pid 1885125, the manager inside the unit, not a stray daemon.
- `/run/endo-daemon/endo.sock` accepts connections.
- The endo-daemon journal for the last 30 minutes has no errors, fatals or EADDRINUSE. Its only match was one "CapTP Endo exception: Connection stream ended", which is an ordinary client disconnect.

**Follow-ups:** none from this job. The #139 fix held: the preflight probe did not start a stray daemon, unlike the earlier run 36531062447.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-endo-pin-post1015-deploy-verify-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (384185 cached reads)
- Output: 3083 tokens
- Cost: $0.5297689999999999
- Wall-clock: 231s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
