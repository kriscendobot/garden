**Verdict: degraded. The root cause is fixed on main2, but oros is now drained and needs the leader or a person to lift the drain.**

- **Drain:** oros has been drained since 21:00:08Z (source `rolling-deploy`, reason "canary FAILED validation (retries exhausted)"). The failure is almost certainly false. Oros self-deployed `f9b279f6` cleanly at 19:44–19:49Z, but the leader never saw it, because every post-deploy status push was lost (details below). The sysop was wedged by the same cause, so it applied the leader's 20:02Z drain-on op only at 21:00Z, after oros was already reported healthy. The job forbids touching drains, so I left it alone and messaged the maintainer. If the leader's conductor doesn't lift it, someone needs to send oros a `drain off`.

**Health snapshot:**
- **Load and memory:** load 1.9–3.4; 13 GiB of 15.6 GiB available.
- **Disk and inodes:** disk 50% used; inodes 1%.
- **Uptime:** 11 days, no recent reboot.
- **Units and workers:** 0 failed units; 8 monks running.
- **Deployed vs main2:** `f9b279f6`, which was the main2 tip until this run's fix (`0411ed9f`).
- **Budget heartbeat:** pushes every 12–20 min; 57.0M of 180M spent, status ok. Spend has barely moved since 13:30 (56.8M), which I didn't dig into.
- **State clones and locks:** clones are at 47–49 packs, under the threshold of 50. All held locks belong to live jobs; none are stale.
- **rc=124 timeouts:** 28 in the last 3h, down from 90 at the previous check. Mostly the sysop and self-deploy handlers, which is the bug below.

**Root cause:** on oros's file system, a no-op `git reset --hard` of the 68k-file journal takes 63–105s, and `git status` takes 29s. Every retry that went through that path pushed from a journal view about 100s old, so it lost to concurrent pushes every time.
- **Post-deploy status:** all 15 attempts to publish `deployed` lost between 19:49 and 20:10. Self-deploy then hit its 2400s timeout, and the leader kept reading `roll-drained @ 2e531a6`.
- **Sysop:** from 20:03 every tick hit its 600s timeout. It was stuck on one spooled record, the leader's 20:03 `drain off` ack, and never acked anything.

**What I changed:**
- **`0411ed9f` on main2:** a new `journal_graft_push` helper in `common.sh` writes host-owned files onto the latest journal without touching the working tree, the same approach `ec4cc369` used for the budget heartbeat. Fleet-health publishing and the sysop's `flush_pending` now use it, and the push/verify step is shared through a new `journal_push_head`.
- **Tests:** the new `fleet-health-publish-test.sh` fails on the old code and passes on the new. The rolling-deploy (120/120), sysop, land-journal-edit (32/32), budget-snapshot-replay and journal-auto-gc suites pass.
- **On-host fixes, using the new code:**
  - Republished oros's status as `deployed @ f9b279f6`; it landed first try in 33s.
  - Landed the stuck sysop record `20261012T195902Z-d97800`, after which the running sysop sent its ack and cleared it.
  - The next queued record (`f13a0d`, the drain-on) was already on the journal, so the sysop will ack it itself.
- **Health log:** note added to `journal2:projects/garden/oros-health-log.md`.

**Still open:**
- **The drain above** needs the leader's conductor or a person.
- **Until oros deploys `0411ed9f`,** the old sysop code can wedge again on its next op.
- **Other journal writers still use the slow path.** These are post-job, land-journal-edit and watchdog-notice. The new helper only suits files a single host owns, so they need a different fix.
- **The root repo is still shallow** (`.git/shallow` = `1fa90b4f`). Unshallowing it needs an operator decision.
- **This run took about 70 minutes,** over the 45-minute target.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261012-185007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 142 tokens (7199387 cached reads)
- Output: 42337 tokens
- Cost: $3.4768654
- Wall-clock: 3333s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
