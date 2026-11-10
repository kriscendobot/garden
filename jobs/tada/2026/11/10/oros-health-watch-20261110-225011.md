## 2026-11-10T22:55Z - oros-health-watch-20261110-225011

Oros is still held for the maintainer, as it was at 19:40Z. The monks' Claude login has expired, a rolling-deploy drain stays on after `1c72004901d7` failed its canary check, and `garden-secret-broker.service` fails again after each deploy. I sent no operations; I only observed and recorded.

- **Verdict:** operator-held. Nothing has changed since 19:40Z.
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (the leader marker names endolin-garden-ece02cb4) / controller.
- **Trigger:** schedule/oros-health-watch.
- **Evidence:**
  - **Local check-up not done:** this cycle's local run did not complete. The newest check-up, `oros-health-checkup-20261110-193511`, is unclaimed in `jobs/todo/`. There are 33 Oros check-ups queued and none in `doin/`.
  - **Fleet health:** the newest record is still from 18:28:44Z. It shows `1c72004901d7` (the same as `origin/main2`) and 1 failed unit out of 297, `garden-secret-broker.service`.
  - **Sysop:** the newest record is still `20261110T191102Z-bc69d2`, which is the drain the rolling deploy turned on after the failed canary. No later operation was sent and no `unit-log` was ever pulled.
  - **Deploy state:** `deploy/roll` for Oros is `1c72004901d7`, and `deploy/leader-sha` is `f2788117645d`.
  - **Login notice:** the `worker-agent-bin-monk` notice (expired OAuth) is still unread, with no recovery.
  - **Heartbeat:** the claude-oros heartbeat at 22:31:38Z is `ok`, but spend has been 0 in every sample since 20:01Z.
  - **New since 19:40Z:** at 20:48Z the journal-lock-contention notice for Oros's repo-watcher journal was updated to its third occurrence (p95 0.027s, 1 giveup, 0 steals). It is minor and limits itself.
- **Cause:** two separate problems, both unchanged:
  - Claude rejects the expired OAuth session, so all monks are parked and nothing on Oros claims work.
  - `garden-secret-broker.service` fails after a deploy. Its cause is unknown until an attested log pull.
- **Actions:** observed only. I sent no sysop operation, reset, restore, drain change, worker-count change or restart, and made no code change.
  - The drain belongs to the rolling deploy, so only that workflow lifts it.
  - Resetting the failed broker unit would erase the only evidence of its cause.
  - A restore or restart cannot fix the expired login.
- **Final state:** Oros is present at `1c72004901d7` with 1 failed unit and drained by the rolling deploy. It claims and completes nothing. The leader stays at `f2788117645d`.
- **Maintainer:** the same three requests as before:
  - (a) On Oros, as the garden user, run `claude` then `/login`.
  - (b) Approve the read-only log pull: `send-host-op.sh oros-studio-garden-ce242c49 op=unit-log name=garden-secret-broker.service lines=80 authorized_by=<login>`.
  - (c) Decide whether to re-run the `1c72004901d7` roll or hold it.
  - Also pause the `oros-health-checkup` and `oros-health-watch` schedules until (a) is done. Each cycle adds another check-up nobody can claim, and 33 are queued now.
- **Next mechanic:**
  - First check for a `unit-log` record and a recovery notice for the expired login.
  - Then look for 0 failed units, an Oros claim and completion, a passing canary, and the roll lifting its own drain.
  - Do not reset the broker unit or lift the drain by hand.

**What changed:** I added this entry, newest first, to `projects/garden/host-health/oros-studio-garden-ce242c49.md` on `journal2` through `land-journal-edit.sh`. There were no `main2` commits.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-watch-20261110-225011.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (614690 cached reads)
- Output: 4715 tokens
- Cost: $0.7215580000000001
- Wall-clock: 133s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
