from_host: endolin-garden-ece02cb4
from: gardener:upgrade-fleet-to-main2-uniform-20260918
reply_to: upgrade-fleet-to-main2-uniform-20260918
msg_key: msg-upgrade-fleet-to-main2-uniform-20260918-b70389c59e3d
notice_count: 1
first_seen: 2026-09-27T18:14:59Z
last_seen: 2026-09-27T18:15:02Z
sent_at: 2026-09-27T18:15:02Z
---
# Fleet-uniformity drive stuck on 2 of 3 hosts — needs operator action

Job `upgrade-fleet-to-main2-uniform-20260918`, pass 1. Pinned target this pass:
`7bd312a6379` (main2 has since advanced to `b9a0411e52f`). Fleet is NOT uniform.

## Per host

- **endolin-garden2-5bcdff64** — AT target `7bd312a6379`, 0 unit failures, reporting
  normally (host record 17:54Z). Deployed by the autonomous roll (canary PASSED
  17:56). ✅ nothing to do.

- **oros-studio-garden-ce242c49** — OFFLINE. Stuck at `586aee8196b`. Host record
  `hosts/oros-studio-garden-ce242c49` last `updated_at` 2026-09-27T16:49:55Z (~80 min
  stale); heartbeat stale ~65 min; health record stale ~11h. The leader's roll
  correctly SKIPS it as offline (>1800s). **Cannot be deployed remotely while it is
  not heartbeating** — a `send-host-op deploy` would queue but never execute. This is
  a host-level outage that needs an operator to bring oros back up. I did NOT send it
  a queued op. Please recover/restart the oros container/host.

- **endolin-garden-ece02cb4 (LEADER, the host I ran on)** — stuck at `47b41af5a14`,
  47 behind. In a **bootstrap trap**: the autonomous rolling-deploy is actively
  self-deploying-LAST but its candidate gate keeps INTERMITTENTLY rejecting the
  target on `triager-pacing-test.sh`. Root cause: commit `6fc21936148` made the
  triager emit a `cgroup reap skipped` WARN when its cgroup sweep runs outside a
  `garden-triager@*` cgroup; on the leader the gate runs under
  `rolling-deploy.service`'s cgroup, so that WARN leaks into the test's output and
  breaks its assertions. It is a flake (the SAME gate PASSED this suite at 17:56;
  passes 14/14 standalone), but the gate ran both retries ~2s apart in one load
  window and misclassified it as a "real regression." Today's fixes that would end
  this (`improve-rolling-deploy-rejected-candidate-backoff` b7e65392bd; the pacing
  test's cgroup fixtures; the deferring-canary fix) are all on main2 but the leader
  can't deploy them because its OLD gate flakes on exactly the leak they fix.
  Additional throttle: continuous main2 churn keeps resetting the leader's 600s
  settle timer, and long-running clerics (>=300s) trigger deploy deferrals.

## Requests

1. **oros**: operator recovery — bring the host/container back online; the roll will
   then re-adopt it as a canary.
2. **leader**: to break the bootstrap trap, an emergency override deploy from the
   leader host itself is warranted:
   `GARDEN_DEPLOY_TEST_OVERRIDE=1 scripts/jobs/deploy-garden.sh` (the target is proven
   healthy — endolin-garden2 runs it clean; the failing test is a harness-contamination
   flake, not a code regression). I did NOT do this from the job because deploying the
   leader restarts my own worker mid-job and would race the active rolling-deploy
   service — a two-driver wedge risk. It is your call.

## Already delegated

Posted fix job **`fix-triager-pacing-rolling-deploy-cgroup-leak`** (fixer) to make the
test hermetic against the WARN under the `rolling-deploy.service` cgroup, so the gate
stops flaking on the leader path once deployed.

I did NOT touch any drain (all hosts read `roll_status: deployed`; no stuck operator
drain found) and did NOT chase the newer `b9a0411` commits past the pinned target.
