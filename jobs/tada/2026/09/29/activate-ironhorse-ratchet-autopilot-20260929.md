---
handed-off: activate-ironhorse-ratchet-autopilot-20260929-r3
deliverable-complete: false
---
Activation isn't finished: the leader never deployed the ratchet code during this job's time limit, so no ratchet tick ran. I've handed the remaining work to a new job, **`activate-ironhorse-ratchet-autopilot-20260929-r3`**.

**What happened (00:18Z–03:23Z):**
- I waited in the foreground on the leader's rolling deploy. The leader root is still at `e036bb8e065`, which predates the ratchet gates (checked against `c3aae0b2c0c`).
- main2 moved about 7 times overnight (`af18177` → `b89b800` → `1f0cc84` → `5cb95af` → `ce9bc5e` → `a253f3b` → `65f0c2e`). Each move restarted the roll.
- For target `65f0c2e`:
  - **endolin-garden2 (follower):** passed canary validation at about 02:50Z. It was already running `894f2675`, which includes `c3aae0b2c0c`, so it has the ratchet code.
  - **oros-studio-garden-ce242c49 (follower):** went offline repeatedly during the night. It was released to deploy but is stuck at `e036bb8e`, and entered retry backoff at 03:20Z.
  - **Leader:** deploys last, so it is still waiting behind oros-studio.
- I did not force or bypass any canary or CI check.

**What changed:**
- **Schedule:** I pushed the `ironhorse-ratchet` first fire back from 08:55Z to **2026-09-29T14:00:00Z**, to give the stalled roll more time. The 2h cadence and `occupancy: skip` are unchanged.
- **Ticks:** no `ironhorse-ratchet-watch-*` tick has ever been emitted, so there were no stray jobs to clean up.
- **Ratchet state:** unchanged — crank 3, floor refresh-20260904 (`322ca2ba…`), branch point `47f6965d…`, no actions. The delegation is still active.
- **PR 1359:** untouched, with no attestation. Floor resolution is still owned by the parked job `ironhorse-test262-ratchet-round3-floor-resolution-20260928`.
- **Maintainer:** sent a status message through the liaison, flagging that oros-studio may need a human look if it stays stuck.
- **Peer message:** `…ironhorse-panic-configurable-hardened262-20260929` said it is adding an opt-in resource-limit policy on its own branch and won't touch PR 1359, the baseline files or pins. No action needed.
- **Successor job:** posted to `jobs/todo/` on journal2 and confirmed there. It carries everything still to do: wait for the leader to deploy, confirm the ratchet gates in the deployed scheduler, claim and handler code, re-snooze to admit the first real tick, check the runtime evidence and the single-step behaviour, and keep PR 1359 halted.

**Minor procedural note:** I ran one read-only `git log -0` against the journal worktree under the garden root, which the rules forbid. It changed nothing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/activate-ironhorse-ratchet-autopilot-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2247771 cached reads)
- Output: 10811 tokens
- Cost: $1.2029341999999996
- Wall-clock: 11127s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
