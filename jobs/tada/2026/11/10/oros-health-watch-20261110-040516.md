## 2026-11-10T04:10Z - oros-health-watch-20261110-040516

- **Verdict:** unhealthy. Oros is held on credentials, and the rolling deploy has drained it because its canary failed for good. Nothing has changed since the 01:15Z watch.
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / controller.
- **Trigger:** schedule/oros-health-watch.
- **Evidence:**
  - **Local run:** the paired local check did not complete. No local checkup was posted for this cycle; the 3-hourly checkup schedule last dispatched at 01:05:10Z. `oros-health-checkup-20261110-010510` is still unclaimed in `jobs/todo/`, along with 26 other Oros checkups (27 total).
  - **Canary probes:** all 18 Oros canary probes are still in `jobs/todo/`. That includes the three for the current release, `6a1e44eafd6a` (r1–r3).
  - **Sysop:** the newest record is still `20261109T231402Z-1f1774`, applied at 23:15:14Z. It is the rolling deploy's `drain on` after the failed canary.
  - **Fleet health:** unchanged since 21:59:03Z. Oros is at `6a1e44eafd6a` with 0 of 297 units failed.
  - **Credential notice:** the Claude "OAuth session expired" notice from 2026-11-07T02:26Z is still unread, and no recovery notice has followed it.
  - **Heartbeat:** the claude-oros budget heartbeat at 03:32:14Z is `ok`, but spend is flat at 59113428. Oros is present but doing no work.
  - **Deploy state:** there is no `roll-completed` record for `6a1e44eafd6a`, and the leader is still at `f2788117645d`.
- **Cause:** Claude rejects Oros's expired OAuth session, so all four of its worker processes are parked and none can claim jobs. The canary probe therefore cannot run, and the rolling deploy's drain stays in place.
- **Actions:** observed only. I sent no sysop operation, drain change, worker-count change, restore, restart or code change. The drain belongs to the rolling deploy after a failed canary, so the host-repair skill (§4) says it stays until the canary passes or you choose the old SHA. No unit is failed, and neither a restore nor a restart fixes a rejected credential.
- **Final state:** Oros is up at `6a1e44eafd6a` with 0 failed units, drained by the rolling deploy, and is claiming and completing nothing. The leader's own deploy is still held behind the failed Oros canary.
- **Maintainer:**
  - On oros-studio-garden-ce242c49, run `claude` then `/login` as the garden user. This is the only blocker; the workers resume by themselves once the credential file changes.
  - After that, the canary has to be re-validated, either by the rolling deploy or by your explicit `drain off`.
  - Please consider pausing the `oros-health-checkup` and `oros-health-watch` schedules until the login is done; Oros cannot claim the 27 queued checkups or the 18 queued canary probes.
- **Next mechanic:** first look for the credential recovery notice. Then look for a canary probe reaching `tada/`, a `roll-completed/6a1e44…` record, and the rolling deploy lifting its own drain. Do not lift the failed-canary drain by hand.

I landed this record at the top of `projects/garden/host-health/oros-studio-garden-ce242c49.md` on `journal2`. I made no code changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-watch-20261110-040516.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (592842 cached reads)
- Output: 4737 tokens
- Cost: $0.6846764000000001
- Wall-clock: 696s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
