---
role: builder
tier: mentor
handler-timeout: 14339
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-29T12:46:08Z cleared=none -->

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

<!-- garden-annotation: key=maintainer-directive-5884119530 by=gardener at=2026-09-29T06:11:44Z -->

**Maintainer directive (kriskowal, issue #51 comment id 5884119530, 2026-09-29T05:15Z):** resume the arc only through a budgeted press interval that ONLY the foreman can wake; each engagement parks a plan to continue, promoted by the foreman only if budget permits. Consequently deadmail-issue-comment-5884119530 SNOOZED the ironhorse-ratchet schedule to 2027-01-01T00:00Z. Do NOT snooze it back to a near-future instant or otherwise admit a scheduler tick (step 3 of this job is superseded). Deploy-verification (step 1) remains useful. Foreman-woken admission is owned by build-ironhorse-foreman-woken-press — coordinate with it via inbox-send.sh before any schedule/delegation change.

<!-- garden-annotation: key=foreman-press-handoff-9bf25f4362f by=builder at=2026-09-29T08:40:19Z -->

**Foreman-press activation handoff (garden main2 `9bf25f4362f`):** the implementation and source tests are complete. This existing activation successor now owns every remaining runtime step that cannot be done by the still-running builder on the old leader.

1. Wait until the deployed leader HEAD is a descendant of `9bf25f4362f`. Verify the deployed `scheduler.sh` permanently ignores `ironhorse-ratchet.md`; `policy.py` accepts only `ironhorse-test262-press-<UTC stamp>`; claim and monk/cleric handler gates admit the canonical press; and `foreman.sh` runs the `not_before` + rolling arc-budget gate.
2. Retire the snoozed legacy row with `scripts/jobs/remove-schedule.sh ironhorse-ratchet`. Never unsnooze or recreate it.
3. Check the maintainer reply on https://github.com/kriscendobot/garden/issues/51#issuecomment-5886712927 (and the job inbox carried forward if any). If the maintainer names a cap/window/interval, install exactly those values with `scripts/jobs/set-arc-budget.sh ironhorse-test262-ratchet <cap> <window-seconds> <press-interval-seconds>`. Do not invent a cap. If no answer has landed, leave the budget config absent.
4. Park the first engagement with `scripts/jobs/seed-ironhorse-press.sh`. This is safe before a cap exists: the foreman fails closed with `arc-budget-untrusted` and leaves the canonical plan parked. Confirm exactly one `ironhorse-test262-press-*` exists in plan/todo/doin, carries the issue spine from comment 5884119530, and was not scheduler-produced.
5. Report deployed/runtime evidence on https://github.com/kriscendobot/garden/issues/51. Do not close the issue. Do not resolve the separate 901-path historical-floor question.

Source verification already completed: `ironhorse-press-budget-test.sh` 11/11, `ratchet-watcher-test.py` 13/13, `annotate-plan-test.sh` 47/47, `foreman-decision-log-test.sh` 7/7, `foreman-deferred-sigpipe-test.sh` 5/5, and `promote-plan-shepherd-budget-test.sh` 9/9.

<!-- garden-terminal-handler-failure -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T12:56:23Z
