Oros (oros-studio-garden-ce242c49) is still unhealthy and nothing has changed since the 12:40Z cycle. This cycle I only observed: no sysop operation, reset, restore, drain change, worker-count change, restart or code change. I added this cycle's record at the top of `projects/garden/host-health/oros-studio-garden-ce242c49.md` on journal2.

**What I found:**
- **Paired local run did not complete.** The checkup schedule last dispatched at 12:35:24Z, and that checkup (`oros-health-checkup-20261109-123524`) is still in `jobs/todo/`. It is one of 23 queued Oros checkups, and none has been claimed or finished.
- **Login expired.** The notice from 2026-11-07 (Claude OAuth session expired) is still unread, with no recovery notice. All four monks are parked because their credentials are rejected.
- **One unit failing.** Fleet health is unchanged at 02:57:49Z: Oros is deployed at `16ea23b4137b` (the current `origin/main2`) and held under the roll's drain. 1 of 296 units is failing: `garden-secret-broker.service`.
- **Sysop log unchanged.** The newest sysop record is still `20261109T034402Z-e76e60`, the roll-owned drain.
- **Present but idle.** The claude-oros budget heartbeat at 15:32:29Z is current (ok, 26%), but spend has not moved.

**Cause:**
1. The expired OAuth session stops every monk from claiming work.
2. The broker unit keeps failing the post-deploy unit check. Its cause is unknown until its log is exported.

The drain belongs to the rolling deploy. Restore or restart cannot fix rejected credentials, and a reset would not fix the broker failure that keeps coming back. So no action I'm allowed to take would help.

**What the maintainer needs to do:**
- On Oros, as the garden user, run `claude` then `/login`.
- Attest the read-only log export: `send-host-op.sh oros-studio-garden-ce242c49 op=unit-log name=garden-secret-broker.service lines=80 authorized_by=<login>`.
- Consider pausing the `oros-health-checkup` and `oros-health-watch` schedules until the login is fixed. No monk can claim the checkups, so they keep piling up (23 now).

**Next mechanic:** check first for the login recovery notice and the broker log. Then look for a fresh fleet-health record with 0 failed units, an Oros claim and completion, a passing canary, a `roll-completed` record, and the roll workflow lifting its drain.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-watch-20261109-155023.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (544634 cached reads)
- Output: 4291 tokens
- Cost: $0.6929708
- Wall-clock: 699s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
