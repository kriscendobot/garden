once: 2026-09-29T17:15:00Z
job_basename_prefix: activate-ironhorse-ratchet-autopilot-20260929-r5
---
---
role: builder
handler-timeout: 5400
---
# Finish activation of the Ironhorse foreman-woken press (continued, round 5)

Successor to activate-ironhorse-ratchet-autopilot-20260929-r4 (chain: build-ironhorse-ratchet-autopilot → activate-…-20260928 → activate-…-20260929 → -r3 → -r4). This job owns ALL remaining activation/runtime-validation work. Authorization: journal2 entries/2026/09/28/201230Z-message-gardener-aa49da.md plus maintainer directive kriskowal https://github.com/kriscendobot/garden/issues/51#issuecomment-5884119530 (resume ONLY via a budgeted press the foreman alone can wake). Do not widen that authority. Read context/operations/ironhorse-ratchet.md first.

## State at r4 handoff (2026-09-29T16:15Z)
- The roll to garden main2 `36def9fd9e8` PASSED its canary (endolin-garden2 deployed 36def9fd9e8; probe canary-probe-endolin-garden2-5bcdff64-36def9fd9e81-r1 reached tada 15:59:54Z). The leader endolin-garden-ece02cb4 was still on e036bb8e065 only because its deploy-garden.sh DEFERRED behind its single monk — the r4 job itself (monk 1, long job). r4 ended so the leader can deploy.
- r4 landed two roll fixes on main2: `25123fdae03` (claim-job.sh claims canary probes before ordinary work) and `36def9fd9e8` (rolling-deploy.sh: an unclaimed probe on a fully busy canary is waiting, not failed).
- Legacy schedule `ironhorse-ratchet` is RETIRED (remove-schedule.sh, 13:03Z). No ironhorse-ratchet-watch-* tick was ever emitted, so nothing to reconcile. Never recreate or unsnooze it.
- No maintainer cap/window/interval has been given on kriscendobot/garden#51 (checked 13:03Z), so config/arc-budgets/ironhorse-test262-ratchet is ABSENT. Do not invent one.
- No ironhorse-test262-press-* exists yet in plan/todo/doin/tada.
- oros-studio-garden-ce242c49 is OFFLINE (heartbeat stale since ~09:47Z, stuck at e036bb8e). The roll skips it. The maintainer was told at 13:03Z. Do not bypass.

## Do (in order)
1. Check the deployed leader: `git merge-base --is-ancestor 9bf25f4362f $(cat /home/kris/garden/.git/HEAD)` in YOUR worktree (never run git in the root). **If NOT yet deployed, do NOT wait in the foreground.** On a one-monk leader YOU become the long job that defers the leader deploy (this is exactly what stalled r4). Instead, re-post this same body via `scripts/jobs/set-schedule-once.sh activate-ironhorse-ratchet-autopilot-20260929-r6 <now+60min> activate-ironhorse-ratchet-autopilot-20260929-r6 <body-file>` with the state updated. Emit the honest-handoff signal naming r6, then exit promptly. Before re-scheduling, check `journalctl --user -u garden-rolling-deploy` and `journalctl --user | grep deploy-garden` for the reason.
2. Once deployed, read the deployed files (read-only) and verify: `scheduler.sh` permanently ignores `ironhorse-ratchet.md`; `ratchet/policy.py` accepts only `ironhorse-test262-press-<UTC stamp>`; the claim-job.sh and monk/cleric handler gates admit the canonical press; and `foreman.sh` runs the `not_before` plus rolling arc-budget gate (plan_deferred_status in common.sh). Check followers in fleet/deployed/* too (garden2 should be ≥ 36def9fd9e8).
3. Re-check https://github.com/kriscendobot/garden/issues/51 for a maintainer reply naming cap/window/interval. If there is one, install exactly those values with `scripts/jobs/set-arc-budget.sh ironhorse-test262-ratchet <cap> <window-seconds> <press-interval-seconds>`.
4. Park the first engagement with `scripts/jobs/seed-ironhorse-press.sh`, but ONLY once the leader (the foreman host) is on ≥ 9bf25f4362f. An older foreman would promote it ungated. Confirm exactly one `ironhorse-test262-press-*` exists in plan/todo/doin, carries the issue spine from comment 5884119530, and was not scheduler-produced. With no budget config, the foreman should log `arc-budget-untrusted` in .garden-state/foreman/decisions.log and leave it parked. Show that as runtime evidence.
5. Report the deployed and runtime evidence on https://github.com/kriscendobot/garden/issues/51. Do not close the issue. Do not resolve the separate 901-path historical-floor question.

https://github.com/endojs/endo-but-for-bots/pull/1359 MUST NOT merge or acquire an attestation. Never lower the enforced floor. Never originate a sysop `deploy` op. Never force a canary or CI bypass. Coordinate with build-ironhorse-foreman-woken-press (inbox-send.sh) before any schedule or delegation change beyond the above.
