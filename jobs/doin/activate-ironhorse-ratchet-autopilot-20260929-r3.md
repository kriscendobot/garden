---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Finish activation of the authorized Ironhorse ratchet autopilot (continued, round 3)

Successor to activate-ironhorse-ratchet-autopilot-20260929 (itself successor to activate-ironhorse-ratchet-autopilot-20260928 and build-ironhorse-ratchet-autopilot). This job owns ALL remaining activation/runtime validation work. Authorization: journal2 entries/2026/09/28/201230Z-message-gardener-aa49da.md. Do not widen that authority. Read context/operations/ironhorse-ratchet.md and ironhorse-ratchet-evidence.md first.

State at handoff (2026-09-29T03:23Z):
- Ratchet implementation on main2 at c3aae0b2c0c + 509c6c9d9da. Delegation record config/delegations/ironhorse-test262-ratchet active; no .revoked tombstone. `scripts/jobs/ironhorse-ratchet.sh status`: crank 3, floor refresh-20260904 (sha256 322ca2ba…), branch point 47f6965d…, actions {}, queue [].
- Deployed leader root (endolin-garden-ece02cb4) STILL e036bb8e065 (predates ratchet gates). main2 churned repeatedly (af18177 → b89b800 → 1f0cc84 → … → 65f0c2e4414d), restarting the roll each time. For target 65f0c2e: canary endolin-garden2 deployed and PASSED validation (~02:50Z; it was already at 894f2675, which contains c3aae0b2c0c, before that). Canary oros-studio-garden-ce242c49 (flapping OFFLINE all night) was released but STUCK at e036bb8e and entered retry backoff at 03:20Z. Leader advances last. Observe with `journalctl --user -u garden-rolling-deploy` and `cat /home/kris/garden/.git/HEAD` (never run git in the root). Do not force a canary/CI bypass.
- Schedule ironhorse-ratchet (cadence 2h, prefix ironhorse-ratchet-watch, occupancy skip) re-snoozed to first fire 2026-09-29T14:00:00Z. No ironhorse-ratchet-watch-* tick has ever been emitted (checked todo/doin/tada/plan at 03:15Z). If the root still lacks c3aae0b2c0c as that instant approaches, re-run `scripts/jobs/snooze-schedule.sh ironhorse-ratchet <future-UTC>` from a checkout of this code. Never change the 2h cadence or occupancy.
- Informational peer: endojs-endo-but-for-bots-ironhorse-panic-configurable-hardened262-20260929 is adding an opt-in ResourceLimitPolicy on a separate branch; it will not touch PR 1359, baseline/, or pins.

Remaining:
1. Wait (foreground, bounded) until the leader root HEAD is a descendant of c3aae0b2c0c (`git merge-base --is-ancestor c3aae0b2c0c $(cat /home/kris/garden/.git/HEAD)` in YOUR worktree) and confirm /home/kris/garden/scripts/jobs/{scheduler.sh,claim-job.sh} and the native monk/cleric handlers contain the ratchet gates; confirm followers serving workers are also current.
2. If an old scheduler emitted any noncanonical ironhorse-ratchet-watch-* tick, reconcile only those inert jobs via job-board helpers. Never counterfeit a watcher doin claim or attestation.
3. Snooze to a near-future instant to admit the first real tick; observe a canonical `tier: mentat` / `dispatch: ratchet-delegated` claim, actual mentat runtime model/handler evidence, and that the driver records exactly one step (or a correctly evidenced criterion failure / halt) with no overlapping children.
4. https://github.com/endojs/endo-but-for-bots/pull/1359 MUST NOT merge or acquire an attestation; a correctly halted watcher is the required safe outcome. Parked ironhorse-test262-ratchet-round3-floor-resolution-20260928 owns PR-side resolution; coordinate before mutations. Never lower the enforced floor.
If the roll stays wedged on oros-studio for hours, report that to the maintainer (message-user.sh) rather than bypassing it. Report deployed/runtime evidence to the maintainer; never claim mentat operation from the schedule definition alone. End only with live activation verified or another named durable handoff owning all remaining work.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T03:23:26Z
