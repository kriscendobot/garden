---
handed-off: activate-ironhorse-ratchet-autopilot-20260929-r4
deliverable-complete: false
---
The Ironhorse ratchet autopilot is **not live**. The rolling deploy is still wedged, so I handed off all remaining work to a round-4 job timed to run before the ratchet's first tick at 14:00Z. I did not bypass anything.

**Deploy state (03:23Z–04:33Z)**
- **Leader root:** still at e036bb8e, which predates the ratchet gates (c3aae0b2c0c). It deploys last, so none of steps 1–3 could run.
- **Target keeps moving:** main2 advanced again at ~03:53Z (18df481c04b5, "restore automatic producer handoff"), which restarted the roll.
- **Canary endolin-garden2:** deployed and passed validation at 65f0c2e. For the new target it keeps deferring because its monks keep picking up long jobs. The deferral ceiling is 3h, so it could run until about 07:05Z.
- **Canary oros-studio-garden-ce242c49:** stuck at e036bb8e since it was released at ~02:53Z, and it failed its first retry.
  - It is not offline: its heartbeat is fresh and it claimed `kriscendobot-minion.town-pr120-gauntlet-fix-5` at 02:59Z.
  - Its deploy health record was silent from 23:46Z to 03:33Z and now shows `roll-drained`.
  - So its self-deploy is broken while its workers keep taking jobs on old code. The fix needs someone on that host, or a sysop `deploy` op that only the maintainer can authorize.

**What I did**
- **Messaged the maintainer twice** about the oros-studio wedge and the full deploy state (03:24Z and 04:33Z). No reply yet.
- **Posted the successor, durably, in two parts:**
  - `activate-ironhorse-ratchet-autopilot-20260929-r4` is parked in plan/ with `gate: blocked` and `blocked_on: ironhorse-ratchet-r4-timer-20260929`. Its body carries the full state and the remaining steps 1–4.
  - A one-time schedule posts that timer job at 2026-09-29T11:30:00Z. The timer does no work; when it completes, the unblock watcher releases r4.
  - I used the timer because the deployed completion code doesn't count a schedule as a handoff successor, and parking r4 alone would have left it stuck.
- **Left alone:** the `ironhorse-ratchet` schedule is still snoozed to its first fire at 14:00Z (2h cadence and occupancy unchanged), and no ratchet-watch job has been emitted. I didn't touch PR 1359, the floor, or the delegation, and wrote no attestation.

**Follow-ups**
- Someone needs to fix oros-studio's self-deploy by hand. Otherwise the roll will stop after its retries run out and page the maintainer.
- If the deploy is still pending when r4 runs, it must re-snooze `ironhorse-ratchet` before 14:00Z. Its body says so.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/activate-ironhorse-ratchet-autopilot-20260929-r3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2491092 cached reads)
- Output: 15970 tokens
- Cost: $1.4126984
- Wall-clock: 4214s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
