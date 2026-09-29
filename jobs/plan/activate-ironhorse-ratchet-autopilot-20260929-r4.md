---
gate: blocked
blocked_on: ironhorse-ratchet-r4-timer-20260929
priority: normal
posted_by: builder
posted_at: 2026-09-29T04:33:10Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Finish activation of the authorized Ironhorse ratchet autopilot (continued, round 4)

Successor to activate-ironhorse-ratchet-autopilot-20260929-r3 (chain: build-ironhorse-ratchet-autopilot → activate-ironhorse-ratchet-autopilot-20260928 → activate-ironhorse-ratchet-autopilot-20260929 → -r3). This job owns ALL remaining activation/runtime validation work. Authorization: journal2 entries/2026/09/28/201230Z-message-gardener-aa49da.md. Do not widen that authority. Read context/operations/ironhorse-ratchet.md and ironhorse-ratchet-evidence.md first.

State at r3 handoff (2026-09-29T04:35Z):
- Ratchet implementation on main2 at c3aae0b2c0c + 509c6c9d9da. Delegation config/delegations/ironhorse-test262-ratchet active (no .revoked). Ratchet status: crank 3, floor refresh-20260904, actions {}, queue [].
- Deployed leader root (endolin-garden-ece02cb4) STILL e036bb8e065 (it predates the ratchet gates). The roll target moved from 65f0c2e4414d to 18df481c04b5 at ~03:53Z. Canary endolin-garden2 deployed at 65f0c2e but was DEFERRING for 18df481c ("long-job monk 2", ceiling 10800s from ~04:05Z ≈ 07:05Z). Canary oros-studio-garden-ce242c49 is STUCK at e036bb8e: released ~02:53Z, never advanced, and failed retry 1. Its fleet/health was silent 23:46Z→03:33Z, then showed roll-drained. Its workers still claim jobs on old code. The maintainer was messaged at 03:24Z (msg-activate-ironhorse-ratchet-autopilot-20260929-r3-35b22755c4d2); no reply by 04:35Z. Observe with `journalctl --user -u garden-rolling-deploy` and `cat /home/kris/garden/.git/HEAD` (never run git in the root). Do not force a canary/CI bypass, and never originate a sysop `deploy` op (it needs maintainer attestation).
- Schedule ironhorse-ratchet (cadence 2h, prefix ironhorse-ratchet-watch, occupancy skip) has last_dispatched 12:00Z, so it first fires 2026-09-29T14:00:00Z. No ironhorse-ratchet-watch-* tick emitted as of 04:35Z. If the leader root still lacks c3aae0b2c0c by ~13:30Z, re-run `scripts/jobs/snooze-schedule.sh ironhorse-ratchet <future-UTC>` from your worktree (main2). Never change the 2h cadence or occupancy.

Remaining:
1. Wait (foreground, bounded) until the leader root HEAD is a descendant of c3aae0b2c0c (`git merge-base --is-ancestor c3aae0b2c0c $(cat /home/kris/garden/.git/HEAD)` in YOUR worktree). Confirm /home/kris/garden/scripts/jobs/{scheduler.sh,claim-job.sh} and the native monk/cleric handlers contain the ratchet gates, and that followers serving workers (fleet/deployed/*) are also current.
2. If an old scheduler emitted any noncanonical ironhorse-ratchet-watch-* tick, reconcile only those inert jobs via job-board helpers. Never counterfeit a watcher doin claim or attestation.
3. Once deployed, snooze to a near-future instant to admit the first real tick. Observe a canonical `tier: mentat` / `dispatch: ratchet-delegated` claim, actual mentat runtime model/handler evidence, and the driver recording exactly one step (or a correctly evidenced criterion failure / halt) with no overlapping children.
4. https://github.com/endojs/endo-but-for-bots/pull/1359 MUST NOT merge or acquire an attestation; a correctly halted watcher is the required safe outcome. Parked ironhorse-test262-ratchet-round3-floor-resolution-20260928 owns PR-side resolution; coordinate before mutations. Never lower the enforced floor.
If the roll is still wedged on oros-studio, re-message the maintainer (message-user.sh) with current evidence rather than bypassing. Report deployed/runtime evidence to the maintainer; never claim mentat operation from the schedule definition alone. End only with live activation verified or another named durable handoff owning all remaining work (e.g. a further set-schedule-once successor timed before the next ratchet fire).
