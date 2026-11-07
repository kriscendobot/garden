## 2026-11-07T17:25Z - oros-health-watch-20261107-172009

Oros is still unhealthy and nothing has changed since 11:08Z: its Claude login has expired, so its workers can't take any jobs. I only observed; nothing on the host was changed.

- **Verdict:** unhealthy
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (leader is endolin-garden-ece02cb4) / controller
- **Trigger:** schedule/oros-health-watch
- **Evidence:**
  - **No local run this cycle.** There is no local checkup job for this cycle (`oros-health-checkup-20261107-172009`) on the board. The two earlier ones (`-105011`, `-140511`) are still waiting unclaimed in `jobs/todo/`.
  - **Login notice still open.** The 02:26:36Z notice `watchdog-worker-agent-bin-monk-oros-studio-garden-ce242c49` is still unread, with no recovery notice after it. It says the OAuth session expired and every monk stopped claiming work.
  - **Deploy canary failed on all three tries.** The roll lifted its drain for the third try (sysop record `20261107T112003Z-ed6f37`, 11:20:26Z), then put it back (`20261107T113503Z-85ecc2`, 11:35:41Z) when probe r3 didn't finish within 600s. The canary-failed notice was filed at 11:35:09Z. No sysop record has landed since.
  - **Deploy not complete.** All three canary probes for `f2788117645d` are still unclaimed, and the rollout hasn't recorded completion.
  - **The host itself looks fine.** Last fleet-health record (10:20:47Z): deployed `f2788117645d`, 0 of 296 units failed. The budget heartbeat at 17:01:29Z is current, status ok, 26% used.
- **Cause:** the host is up and its services are healthy, but its workers can't authenticate, so they stopped claiming. That is also why the canary probes never ran; it doesn't point to a bug in the new code.
- **Actions:** none. A restart won't fix an expired login, and the drain belongs to the rolling deploy, so I left it on.
- **Final state:** host up with a current heartbeat, held under the rolling-deploy drain after the failed canary, deployed `f2788117645d`. It isn't claiming or finishing any jobs.
- **Maintainer:**
  1. On oros-studio-garden-ce242c49, as the garden user, run `claude` then `/login` (or `claude auth login`). The workers pick up the new login on their own; no restart is needed.
  2. The drain from the failed canary then stays on until either a canary re-run passes or you explicitly choose to stay on the old version.
- **Next mechanic:**
  1. Check for the login recovery notice.
  2. Confirm a canary for `f2788117645d` finishes, the rollout records completion, and the deploy workflow lifts the drain.
  3. Confirm the checkups `-105011`/`-140511` get claimed or cleared and Oros finishes regular jobs again.
  4. The local disk, scratch-size and lock-holder checks are still owed.

I added this record, newest first, to `projects/garden/host-health/oros-studio-garden-ce242c49.md` on journal2 using `land-journal-edit.sh`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-watch-20261107-172009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (628156 cached reads)
- Output: 5203 tokens
- Cost: $0.7507872
- Wall-clock: 136s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
