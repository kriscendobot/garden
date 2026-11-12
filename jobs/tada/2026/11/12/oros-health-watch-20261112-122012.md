Oros is still held for the same two reasons as the last five cycles, and both need a person on the machine. I sent no repair operation. The Claude login on Oros has expired, so its four workers claim nothing. A rolling deploy left the host drained after a unit failed.

## 2026-11-12T12:25Z - oros-health-watch-20261112-122012

- **Verdict:** operator-held. Nothing has changed since 09:25Z.
- **Target / role / mode:** oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / controller
- **Trigger:** schedule/oros-health-watch
- **Evidence** (journal tip `9654a987c`, 12:21:46Z):
  - This cycle's local check, `oros-health-checkup-20261112-122012`, did not run. It and the previous one (`…-092012`) are both unclaimed in `todo/`.
  - 47 Oros checkups are waiting (46 in `todo/`, 1 in `plan/`), the oldest from 2026-10-13. None is in progress.
  - The newest local host-health record is still from 2026-11-05T07:33Z.
  - `fleet/health` is unchanged since 2026-11-11T18:57:33Z: deployed `18fc7b17375`, which is also current `origin/main2`. The host is `roll-drained`, and 1 of 297 units has failed (`garden-secret-broker.service`).
  - The newest sysop record is still `20261111T192902Z-971319` (`drain on [rolling-deploy]`, applied). The roll still targets `18fc7b17375`, and the leader is still at `f2788117645d`.
  - The claude-oros budget heartbeat is fresh (12:16:53Z, `ok`, spend 0), so the host is present.
  - The `worker-agent-bin-monk` expired-login notice is still unread, with no recovery since 2026-11-07T02:26Z.
- **Cause:** unchanged.
  1. The expired Claude login sidelines every Oros worker, so local checks and the deploy's test jobs go unclaimed.
  2. `garden-secret-broker.service` fails the deploy's unit-health check. Its cause is still unknown because controller mode can't read the unit log.
- **Actions:** observed only; no sysop operation sent.
  - The drain belongs to the rolling deploy, so only the deploy may lift it.
  - I did not send `reset-failed`: it would only hide the broker failure that the deploy check reads.
  - Restarting the unit or exporting its log needs maintainer sign-off, and a restart would not fix the login.
- **Final state:** Oros is present at `18fc7b17375` and drained by the deploy. It has 1 failed unit, four configured workers, and no claims or completions. The leader stays at `f2788117645d`.
- **Maintainer:** unchanged.
  1. On Oros, as the garden user, run `claude` then `/login`.
  2. Run `journalctl --user -u garden-secret-broker -n 80` and `systemctl --user status garden-secret-broker`, then fix the cause.
  3. Re-trigger or hold the `18fc7b17375` roll.
  4. Until step 1 is done, pause both Oros health schedules and clear out the 47 stale checkups.
- **Next mechanic:** first check for a `worker-agent-bin` recovery notice or any Oros claim. Then look for a fresh `fleet/health` record with zero failed units. Then look for a passing `18fc7b17375` deploy check and the roll lifting its own drain. Do not lift the drain by hand.

**Changed:** I added this record to the top of `projects/garden/host-health/oros-studio-garden-ce242c49.md` on `journal2` with `land-journal-edit.sh`, which pushed cleanly. Nothing changed on `main2`.

**Follow-up:** the health watch keeps rerunning every 3h and finds the same thing each time; no checkup has run on Oros since 2026-11-05. Pausing both Oros health schedules until someone logs in on Oros would stop that.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-watch-20261112-122012.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1274022 cached reads)
- Output: 7505 tokens
- Cost: $0.9670484
- Wall-clock: 227s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
