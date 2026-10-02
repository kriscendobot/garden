## Completion report: fix-oros-heartbeat-canary-drain-20261001

I found causes for all three symptoms and pushed two script fixes to `main2` (`25e98fcd`, `2e8aedf5`). Oros is **not** fit to serve as a deploy canary yet. It is still running `e036bb8e`, its own deploy test gate times out under load, and neither fix is deployed there.

Logs came from `sudo journalctl -D /var/log/journal/<id>`, because `journalctl --user` has no permission on this host.

### 1. Budget heartbeat stopped — the cause was lost journal pushes, not a dead timer
- **What happened:** the scaler publishes the heartbeat. It runs a session-log scan that takes about 40s on this loaded host (I timed 16s for the total and 25s for the percentage). That scan sits between the journal sync and the push, and the fleet's journal tip almost always moves in that window. The push is a compare-and-swap, so it lost.
- **Evidence:** `WARN: could not publish live budget snapshot (pool=claude-oros, commit_and_push rc=1, push-class=cas)` at 17:49, 18:03 and 18:20. Then `recovered after 21 failed scaler tick(s) over 6500s (outage since 18:20:05Z)` at 20:08. The scan also ran on every one-minute tick *before* the cheap "is a snapshot due?" check, so ticks took minutes.
- **Ruled out:** `cfc49a7a` (the stagger change) was never deployed on oros, which runs `e036bb8e`. The timer was healthy. The scaler's clone was not corrupt (458M, fetches fine).
- **Current state:** publication resumed but is still intermittent. Origin has snapshots at 23:59, 00:34 and 01:52Z, with gaps up to 78 minutes against a 30-minute max-age.
- **Fix (`25e98fcd`, `usage-meter.sh`):**
  - Check whether a snapshot is due before scanning, so a tick with nothing due costs no scan.
  - Measure first, then re-sync right before the first push if the measurement was slow (new `GARDEN_BUDGET_PUBLISH_RESYNC_SECS`, default 5).
  - Retries after a lost push reuse the same reading instead of re-scanning, so each push races a fresh tip.
  - New test `budget-snapshot-measure-first-test.sh`: fails on base, passes with the fix.

### 2. Canary keeps failing — oros never deployed either target
- **Gate timeouts:** for both `c810e1e6` (12:28–12:45Z) and `697976e7` (16:13–16:29Z), oros's own pre-deploy test gate rejected the candidate. Suites timed out (rc=124): `retry-narrowing-test`, `triager-pacing-test`, `terminal-handler-failure-reap-test`. That ended in `ABORTED: candidate test gate failed; root tree remains unchanged`. This is the known "deploy gate times out under host load" problem, not a bad candidate.
- **Leader's view:** the leader declared the canary failed at 16:17Z, about 6 minutes after release, while oros was still inside its gate. So the probe never reached a deployed host.
- **Killed attempt:** the 16:30 attempt passed the gate at 16:35 and was waiting for 2 busy gardeners when the container got SIGRTMIN+3 at 16:38:45. The Docker VM rebooted at 17:15:26 (kernel boot lines), which killed the deploy.
- **Shared cause with #1:** oros published no health record after 12:25, and the "host-offline" notices come from the stale budget heartbeat. Both trace to load on this host.

### 3. Claims under a drain — a garden script lifted it
At 17:18:46Z, `self-deploy.sh` logged *"leaderless fallback: cleared a stale ROLL-INDUCED drain"*, then in the same second *"target 697976e7 is AHEAD of last-known-good 878c5d52; HOLDING"*. No operator was involved, and `deploy-garden.sh` was not involved either. The leader endolin is alive but holding the roll, and self-deploy's grace timeout treats a long wait as "leaderless". Its backstop lifted the drain before checking whether a deploy could actually proceed, so the drain was dropped and nothing was deployed. That is why oros monks claimed at 19:10, 19:32 and 19:53.
- **Fix (`2e8aedf5`, `self-deploy.sh`):** the drain is lifted only after the canary check and the retry backoff have passed, immediately before deploying.
- **Test:** new case d2 in `rolling-deploy-test.sh`: fails on base, passes with the fix (106/0).

### What I changed on-host
Nothing. I did not touch drains, worker leveling or derotation markers. Nothing else needed restarting: the timers are healthy and the scaler's clone is fine.

### Tests
- New test plus `budget-snapshot-publish-retry`, `outage-reclone`, `percent-label`, `warning-dedup` and `rolling-deploy`: all pass.
- `live-budget-admission-test` fails identically on unmodified `main2`, so that failure was already there.
- `budget-snapshot-publish-retry-test` takes about 1050s on this host with or without my change.

### Needs the maintainer or a person at the oros machine
1. **The 16:38:45 container stop and 17:15 VM reboot** were outside the garden: a Docker Desktop restart, the Mac sleeping, or an update. Worth asking whoever is at the machine.
2. **Host load is the common root of all three.** The deploy gate times out and publication is slow. Before oros can pass as a canary, it needs fewer monks while it deploys, or a longer per-suite timeout for the deploy gate on this host. The inbox clone also timed out at 45s again during this job (the known clone livelock).
3. **Nothing reaches oros until it deploys.** Both fixes stay inactive there until oros gets past its gate, which is blocked by item 2. The roll is held at `878c5d52`, so a person may need to deploy oros by hand during a quiet period.
4. **Fitness as canary: no, not yet.** Once oros has deployed a sha that includes `25e98fcd` and its heartbeat publishes every 15 minutes, the derotation self-restores and it can be retried as canary.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-oros-heartbeat-canary-drain-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (7870976 cached reads)
- Output: 40270 tokens
- Cost: $3.6450832000000006
- Wall-clock: 4652s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
