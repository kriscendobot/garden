## 2026-11-11T01:55Z - oros-health-watch-20261111-015011

- **Verdict:** operator-held, the same as at 19:40Z. The OAuth session is still expired, the roll-owned failed-canary drain on `1c72004901d7` is still in place, and `garden-secret-broker.service` is still failed.
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (the leader marker names endolin-garden-ece02cb4) / controller.
- **Trigger:** schedule/oros-health-watch.
- **Evidence:**
  - The paired local run did not complete. 34 Oros checkups are unclaimed in `jobs/todo/`; the newest is `oros-health-checkup-20261110-225011`. None are in `doin/` or `tada/`.
  - `fleet/health` has not changed since 2026-11-10T18:28:44Z: deployed `1c72004901d7` (the same as `origin/main2`), 1 of 297 units failed, the first being `garden-secret-broker.service`.
  - The newest sysop record is still `20261110T191102Z-bc69d2` (`drain on [rolling-deploy]`). No later operation and no `unit-log` record exist.
  - `deploy/roll/<oros>` is `1c72004901d7` and `deploy/leader-sha` is `f2788117645d`.
  - The canary-failed notice is still at #12 (19:11:07Z). The `worker-agent-bin-monk` notice (expired OAuth) is still unread, and no recovery has been reported.
  - The claude-oros heartbeat is fresh (01:32:00Z, `ok`) with spend 0. The host is up but doing no work.
- **Cause:** unchanged.
  1. Claude rejects the expired OAuth session, so the monks are credential-parked and Oros claims nothing.
  2. `garden-secret-broker.service` fails after deploy. Its cause is unknown because no attested log has been pulled.
- **Actions:** observed only. I sent no sysop operation and made no reset, restore, drain change, worker-count change, restart or code change.
  - The drain belongs to the roll.
  - Resetting the broker would erase the only evidence of its failure.
  - A restore or restart cannot fix credentials.
- **Final state:** Oros is up at `1c72004901d7` with 1 failed unit and a rolling-deploy drain. It claims and completes nothing. The leader stays at `f2788117645d`.
- **Maintainer (unchanged):**
  - (a) On Oros, as the garden user, run `claude` then `/login`.
  - (b) Attest `send-host-op.sh oros-studio-garden-ce242c49 op=unit-log name=garden-secret-broker.service lines=80 authorized_by=<login>`.
  - (c) Decide whether to re-trigger or hold the `1c72004901d7` roll.
  - Until (a) is done, please pause the `oros-health-checkup` and `oros-health-watch` schedules. There are now 34 unclaimed checkups, and more `doomed-oros-health-watch-*` notices land in the inbox.
- **Next mechanic:** first check for the `unit-log` record and the worker-agent-bin recovery notice. Then look for 0 failed units, an Oros claim and completion, a passing canary, and the roll lifting its own drain. Do not reset the broker or lift the drain by hand.

**What changed:** I added this record to the top of `projects/garden/host-health/oros-studio-garden-ce242c49.md` on journal2 using `land-journal-edit.sh`. No code changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-watch-20261111-015011.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (547505 cached reads)
- Output: 4332 tokens
- Cost: $0.709365
- Wall-clock: 132s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
