## 2026-11-05T04:51Z - oros-health-checkup-20261105-042023

- **Verdict:** healthy
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / local
- **Trigger:** schedule/oros-health-checkup
- **Evidence:**
  - **Units:** `fleet/health` at 04:36:39Z shows 0 of 291 failed and 0 advisory, with `roll_status` deferred. No units are failed locally and there is no local draining marker.
  - **Deploy:** deployed is f4dcb3c044e, which matches `leader-sha`. The release was 7b151b7149f at inspection and is now d4f21341dcc, the `origin/main2` tip.
  - **Deferral:** the blocker is monk 2 on `endojs-endo-but-for-bots-pr1648-gauntlet-fix-2`, claimed 03:19Z, at 5490s by 04:51Z.
  - **Budget:** claude-oros status ok, 23% (sample 04:32Z).
  - **Disposition, 6h:** 50 claims, 41 completions, 4 terminal, 1 transient, 3 in flight.
  - **Resources:** load 3.03, 12G memory available. Swap is full, but si/so was 0 over a 3s vmstat. `/tmp` is at 18%, uptime 34 days.
  - **Disk:** virtiofs 94% used, 31G free, 4% inodes.
  - **Journal and repo:** the visible tail of the contention probe (the last 40 lines) shows `outage_skips=0`, latch off, checker heartbeat 131s. Root `.git` has 127 packs, 596M, no `gc.log`.
  - **Sysop:** the newest record, 20261105T021102Z-61948f, is a drain accepted and applied; no drain marker remains.
- **Cause:** no host failure established; this is the normal long-job deferral on an active roll release.
  - All 4 terminal-failure hints are on two jobs: `kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait` (3, at 03:43, 04:06 and 04:31Z, reclaimed on monk 1 at 04:40Z) and `kriscendobot-minion.town-pr237-gauntlet-20261105` (1, at 03:10Z).
  - I did not trace these handler failures. The wait job's brief expects unsignaled exits while its gauntlet is active, which may account for its three.
- **Actions:** none on the host. I exited early for the active roll release, per the recurrence rule, so `rc=124` and lock-holder liveness were not checked. I landed this record on `journal2` at `projects/garden/host-health/oros-studio-garden-ce242c49.md`, then amended it with the advanced roll target from the controller companion's message.
- **Final state:** heartbeat current, 3 monks active, deployed f4dcb3c044e with d4f21341dcc released, undrained, claims and completions advancing. Rolls are still landing despite the deferrals (36a2080657e to f4dcb3c044e since 01:43Z).
- **Maintainer:** none
- **Next mechanic:**
  - Confirm the deployed SHA reaches the release once monk 2 finishes.
  - Check whether the pr199 gauntlet-wait cycle is delaying rolls.
  - Recheck root pack growth: 65 at 23:24Z, 127 now, not repacked.
  - Watch virtiofs free space: 36G at 23:24Z, 32G at 01:43Z, 31G now.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261105-042023.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (693865 cached reads)
- Output: 10062 tokens
- Cost: $0.898165
- Wall-clock: 492s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
