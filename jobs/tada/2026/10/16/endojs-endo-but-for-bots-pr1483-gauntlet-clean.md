PR #1483 already passed the clean stage, so I made no changes and pushed nothing.

- **CI:** every check has finished on the current head, with none failing or still running. `lint`, `test` (22.x and 24.x on ubuntu and macos-15), `cover` (22.x and 24.x), `viable-release`, `sandbox-drivers`, `familiar-bundle`, `build-xsnap` and `zizmor` passed, and the others were skipped because the change doesn't touch their paths. I didn't run `ci-wait-merge.sh` because there was nothing left to wait for.
- **Coverage:** I read the diff (6 files). The new heartbeat tests cover all the paths it adds:
  - heartbeats on by default, with both sides reporting `heartbeat: true`;
  - one side set to `heartbeat: false`, where neither side runs heartbeats and A neither pings nor drops the session after sitting idle past its timeout;
  - `heartbeat: false` together with `reconnect: true` is rejected;
  - the new `sessionHeartbeat` check that heartbeats run only when the peer also advertises them.
- **Dead code:** the change leaves nothing unused. The only thing it dropped was the `readOcapnHeartbeatMessage` import in the test file, and the PR already removes that itself.
- **PR state:** #1483 is still an open draft, and later gauntlet stages handle the review and un-drafting.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1483-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (174344 cached reads)
- Output: 1510 tokens
- Cost: $0.42615679999999995
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
