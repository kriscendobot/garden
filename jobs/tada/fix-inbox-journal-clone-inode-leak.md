# fix-inbox-journal-clone-inode-leak — DONE

Implemented interactively in a liaison session at the maintainer's direction
rather than waiting for the drain to lift, so this job was never claimed by a
gardener. Landed on `main2` as **830a4b299b** and DEPLOYED to
`endolin-garden2-5bcdff64`.

## What landed

**Part 1 — the common path.** New `state_cleanup()` in `common.sh`, confined to
`$GARDEN_STATE` and refusing `$GARDEN_STATE` itself, called from
`complete-job.sh` after the completion push succeeds. Fail-open by construction:
a cleanup error can never strand a finished job in `doin/`.

**Part 2 — `state-clone-keeper.sh` + `garden-state-clone-keeper.{service,timer}`,
hourly at :22, on EVERY host** (not leader-gated; each host can only see its own
`$GARDEN_STATE`). Scope was widened per the staged bus message to all five state
kinds, not just `inbox/`. Four cumulative guards — per-kind liveness (board
membership for doers, `systemctl is-active` for unit-keyed ids), a 6h idle floor,
no live process rooted in it, no fresh `journal.lock` — plus a 200/tick cap whose
remainder is LOGGED, never silently truncated.

## One hazard found during implementation, not in the job body

If `systemctl --user` were ever unreachable, every unit-keyed id would answer
"not active" and the sweeper would delete LIVE workers' clones after the idle
floor — the same shape as an unreadable board. The keeper now probes systemd
once and drops the unit-keyed kinds for that tick, while still reclaiming
board-keyed `inbox/` (much the largest kind), so a systemd-less host still gets
the bulk of the benefit.

Separately: the `if ! load_live_doers` bail-out is UNREACHABLE on the offline
path — `sync_clone` exits the process rather than returning. The protection is
real but comes from ordering, not that branch. The code says so at the guard
rather than claiming credit it does not deserve.

## Evidence (real execution)

Tests: `tests/checks/test_state_clone_keeper.sh`, 17 assertions, all passing;
added to the CI shellcheck list so the gate cannot rot. Discriminating power
verified by MUTATION — all six guards deliberately broken and the suite re-run,
each caught. Two mutations that are correctly no-ops (removing either
unmodelled-kind guard alone; deleting the unreachable offline branch) are
recorded in the test header as deliberate defence-in-depth, not gaps. An earlier
draft of the suite had two VACUOUS assertions that passed against broken code;
both were fixed before this landed.

Full `tests/checks` suite: 8 of 9 suites pass. The one failure
(`test_maintainer_inbox_information_hiding.sh`) is PRE-EXISTING and byte-identical
on pristine `origin/main2` — `roles/scholar/AGENT.md` references the maintainer
inbox without being on the gate's allowlist. Unrelated to this change and
deliberately left alone: whether scholar should be allowlisted is a policy call.
It is the same failure `scripts/checks/run-all.sh` reports.

Deploy: `deploy-garden.sh` candidate gate passed; root advanced
d430427ab3 -> 830a4b299b; 115 timers thawed onto the new release, 0 failed;
`garden-state-clone-keeper.timer` auto-enabled by the existing
present-units-derive-the-enable-set policy (no installer change needed).

Deployed keeper run through its real systemd unit (`Result=success`, rc=0):

    05:11:01  reclaimed 200 clone(s) ( monitors=135 gardeners=65 ); kept 61
    05:11:01  CAP: 54 further clone(s) left for the next tick (MAX_SWEEP=200)
    05:11:34  reclaimed 54 clone(s) ( gardeners=36 clerics=18 ); kept 63
    05:11:40  reclaimed 0 clone(s); kept 63          <- converged, clean no-op

Free inodes on `/dev/nvme0n1p2`: **2,717,596 (1.11%) at the worst point ->
152,377,629 (62%)**. The 2851 leaked `inbox/` clones (69,052,121 inodes) were
reclaimed by hand earlier in the same session under the same predicates; the
deployed keeper then took the 254 remaining across the other four kinds.

## Residual

`endolin-garden-ece02cb4` has NOT been deployed and still carries its own
refilled leak; its filesystem is shared with this host. Deploying it requires
`op=deploy` with maintainer `authorized_by:` attestation (destructive tier).
Cross-host findings are in `projects/garden/inode-starvation-notepad.md`.
