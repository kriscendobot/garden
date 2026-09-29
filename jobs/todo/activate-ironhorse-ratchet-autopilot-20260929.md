---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Finish activation of the authorized Ironhorse ratchet autopilot (continued)

Successor to activate-ironhorse-ratchet-autopilot-20260928 (itself successor to build-ironhorse-ratchet-autopilot). This job owns ALL remaining activation/runtime validation work. Authorization: journal2 entries/2026/09/28/201230Z-message-gardener-aa49da.md. Do not widen that authority. Read context/operations/ironhorse-ratchet.md and ironhorse-ratchet-evidence.md first.

State at handoff (2026-09-29T00:10Z):
- Implementation on main2 at c3aae0b2c0c + 509c6c9d9da. The GitHub `checks` CI blocker is CLEARED: d659b3ffd61 restored maintainer-inbox information hiding; checks green from 4767705b28d onward.
- Delegation record config/delegations/ironhorse-test262-ratchet is active (authorization_sha256 92cc11db…); no .revoked tombstone. Ratchet state: crank 3, floor refresh-20260904 (sha256 322ca2ba…), branch point 47f6965d…, no actions.
- Deployed leader root is still e036bb8e065 (predates the ratchet gates). The leader rolling deploy is running normally but keeps restarting as main2 advances: canary endolin-garden2 PASSED 894f2675 at ~23:25Z, oros-studio then deferred/stuck behind a long monk job, then main2 advanced to af1817773cd8 and the roll restarted from garden2 (deferring behind a long monk). Observe with `journalctl --user -u garden-rolling-deploy` and `cat /home/kris/garden/.git/HEAD` (never run git in the root). Do not force a canary/CI bypass.
- Schedule ironhorse-ratchet (cadence 2h, prefix ironhorse-ratchet-watch, occupancy skip) is snoozed to first fire 2026-09-29T08:55:00Z. No ironhorse-ratchet-watch-* tick has ever been emitted (checked todo/doin/tada/plan). If the root still lacks c3aae0b2c0c as that instant approaches, re-run `scripts/jobs/snooze-schedule.sh ironhorse-ratchet <future-UTC>` from a checkout of this code. Never change the 2h cadence or occupancy.

Remaining:
1. Wait (foreground, bounded) until the leader root HEAD is a descendant of c3aae0b2c0c (check with `git merge-base --is-ancestor c3aae0b2c0c $(cat /home/kris/garden/.git/HEAD)` in YOUR worktree) and confirm /home/kris/garden/scripts/jobs/{scheduler.sh,claim-job.sh} and the native monk/cleric handlers contain the ratchet gates; confirm followers serving workers are also current.
2. If an old scheduler emitted any noncanonical ironhorse-ratchet-watch-* tick, reconcile only those inert jobs via job-board helpers. Never counterfeit a watcher doin claim or attestation.
3. Snooze to a near-future instant to admit the first real tick; observe a canonical `tier: mentat` / `dispatch: ratchet-delegated` claim, actual mentat runtime model/handler evidence, and that the driver records exactly one step (or a correctly evidenced criterion failure / halt) with no overlapping children. Status: `scripts/jobs/ironhorse-ratchet.sh status`.
4. Subject https://github.com/endojs/endo-but-for-bots/pull/1359 (targets llm-47f6965, incompatible historical floor, 901 informational historical losses, no instrumented coverage) MUST NOT merge or acquire an attestation; a correctly halted watcher is the required safe outcome. Parked ironhorse-test262-ratchet-round3-floor-resolution-20260928 owns PR-side resolution; coordinate before mutations. Never lower the enforced floor.
Report deployed/runtime evidence to the maintainer; never claim mentat operation from the schedule definition alone. End only with live activation verified or another named durable handoff owning all remaining work.
