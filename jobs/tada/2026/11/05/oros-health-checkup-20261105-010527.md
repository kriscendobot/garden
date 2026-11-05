## 2026-11-05T01:43Z - oros-health-checkup-20261105-010527

The check-up exited early because oros has an active roll release, as the job spec requires. It changed nothing on the host and landed one record in `projects/garden/host-health/oros-studio-garden-ce242c49.md`.

- **Verdict:** healthy, with falling disk space on the garden mount as a caveat.
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / local
- **Trigger:** schedule/oros-health-checkup
- **Evidence:**
  - **Units:** `fleet/health` at 01:36:20Z shows 0 of 291 failed and `roll_status` deferred. No units are failed locally.
  - **Roll:** there is no local draining marker. `deploy/roll/<host>` names `a4d206f4d3f` (the `origin/main2` tip), and `36a2080657e` is deployed.
  - **Deferral:** `deploy/deferred` names long job monk 2, at 2201s elapsed at 01:42Z.
  - **Budget:** claude-oros at 21% (sample from 01:32Z).
  - **Disposition, last 6h:** 27 claims, 23 completions, 0 terminal failures, 0 transient kills, 3 in flight.
  - **Resources:** load 2.15, 12G memory available, `/` 7%, `/tmp` 18% by `df`, garden mount 94% used with 32G free and 4% of inodes used.
  - **Contention probe:** `outage_skips=0`, latch off.
  - **Sysop:** the newest record is `20261104T235002Z-66539f`, a drain, accepted and applied.
- **Cause:** none. This is the normal long-job deferral on an active roll release.
- **Actions:** no sysop operations and no code changes. The stray `pkill` of a `du` process in the carried-forward report needed no action; `/tmp` is 1.4G by `df`, as that report said.
- **Final state:** heartbeat current, 3 monks active, undrained, claims and completions advancing. `a4d206f4d3f` is still pending.
- **Maintainer:** none
- **Next mechanic:**
  - Confirm the deployed SHA reaches `a4d206f4d3f` once monk 2 finishes.
  - Check the pack-growth observations that the 01:34Z watch record asked for.

**Not checked (early exit):**
- Root `.git` pack counts, lock-holder liveness and `rc=124` were not read. This leaves the 01:34Z watch's pack-growth recheck open. The last pack count was 65 at 23:24Z.
- The disk recheck that watch also asked for is only partly done, because I did not trace the cause.

**Disk trend, not in the landed record:**
- The garden mount had about 35G free (36074 MiB) at 23:24Z and has 32G now, roughly 3G lost in about 2.3 hours. The shared disk had about 51G left at an earlier reading in the legacy log.
- The cause is still untraced, because a `du` of `scratch` did not finish in 75s at 23:24Z. As that log already asks, someone at the Mac should find what is using the shared disk.

**Record corrections:**
- The landing took two pushes, because the first placed my record below the 01:34Z watch record. The second put it first, as the file requires, and reworded the next-mechanic line.
- The record's "no failed units" and "undrained" are from local reads. `journal/fleet/health` in the live worktree was stale, at 00:11Z, so I read fresher values from the self-deploy clone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261105-010527.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (719883 cached reads)
- Output: 8570 tokens
- Cost: $0.8282806000000003
- Wall-clock: 218s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
