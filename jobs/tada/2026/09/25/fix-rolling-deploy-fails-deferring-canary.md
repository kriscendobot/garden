The leader now treats a follower that is deliberately deferring behind a long job as **waiting**, not failed. The fix is pushed to `main2` as `fa2e05905a0`. The rolling-deploy suite passes 89/0 and the deploy-garden suite 162/0. shellcheck is clean, and the deploy-release-boundary, root-repo-guard and sysop suites also pass.

**1. The follower publishes its deferral, and the leader waits.**
- When `deploy-garden.sh` defers, it now leaves a small record on the host (`$GARDEN_STATE/deploy/deferred`).
- `self-deploy.sh` turns that into a published status: `roll_status: deferred`, with `deferred_reason: long-job <kind> <id> <elapsed>s`, the target sha and a timestamp. While the deferral continues it republishes at most every 5 minutes.
- In `rolling-deploy.sh`, a deferral of the released target means waiting. There is no failure, no drain, no retry used and no stuck-canary page while the deferral is recent (within 15 minutes).
- The existing 1500s deploy deadline now counts from the later of the release or the last deferral. So once the long job ends, the real deploy gets a full deadline.
- **Hard ceiling:** a canary still deferring 3 hours after its release is a real failure and goes through the normal retry/halt path. 3 hours covers the longest role handler budget (2h), plus the 30-minute quiesce delay and some slack.
- A canary that publishes no deferral for its target still fails at the plain deadline, as before.

**2. Targeted drain: yes, but late.** On a busy host some job is nearly always older than the 300s long-job threshold. Without a drain the deploy could keep deferring until the 3-hour ceiling. So after 30 minutes of continuous deferral, the leader sends one "quiesce for deploy" drain (marked `source=rolling-deploy-quiesce`). New claims stop and the running long jobs finish as the host's last. This drain is logged as a quiesce, is not a failure, and uses no retry.
- The follower still runs its released deploy under this drain.
- `deploy-garden.sh` keeps deferring under it rather than waiting out its 600s drain budget and aborting, and lifts it when the deploy lands.
- If there is no live leader, the follower clears a stale quiesce drain the same way it clears a stale failure drain.
- An operator drain replaces the quiesce drain and still takes priority.

**3. Tests added:**
- A deferring canary well past 1500s stays released: no drain, no retry, no page.
- The quiesce drain is sent once, and is not the failure drain.
- The deadline extends from the last deferral, then the canary fails once no deploy follows.
- Still deferring at the ceiling means a failure.
- A deferral for a different sha, or no deferral status at all, fails at the plain deadline.
- Follower side: it publishes the deferral, doesn't re-push inside the 5-minute interval, republishes after it, and still deploys under a quiesce drain.
- `deploy-garden.sh`: the deferral record is written, and it defers under a quiesce drain while leaving that drain in place.

Docs are updated in `designs/follower-self-deploy.md` (new section "A deferring canary is waiting, not failed") and `context/operations/deploy.md`.

**Follow-ups:**
- The new behavior only applies once a host has deployed this commit. A follower on older code publishes no deferral, and the leader treats it as before. The next roll will still show the old fail-and-drain behavior if the leader rolls before a follower has this change.
- Known gap: if a follower is quiesced but `deploy-garden.sh` then finds nothing to deploy, the quiesce drain isn't lifted. The canary probe would then fail, and the existing retry path lifts the drain. That path is rare and I left it as is.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-rolling-deploy-fails-deferring-canary.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (3266493 cached reads)
- Output: 35654 tokens
- Cost: $2.4888665999999997
- Wall-clock: 424s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
