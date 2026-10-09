---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: deploy-garden.sh crashes after swapping in its own replacement and strands the host drained with timers frozen

Repo: kriscendobot/garden, branch main2 (direct push, no PR).

## What happened (host oros-studio-garden-ce242c49, 2026-10-02)
A self-deploy ran `deploy-garden.sh` from e036bb8 to 2e8aedf. It engaged the drain, froze all 139 garden timers (the release boundary), advanced the root tree with the per-file atomic rename, and recorded the deployed sha (05:38:53Z). It then started the unit reconcile (`install-units.sh install` and `enable-services`; three daemon-reloads). At 05:39:24Z bash died with:

    /Users/dom/garden/scripts/jobs/deploy-garden.sh: error reading input file: No such file or directory

Everything after that was skipped: thaw_timers, `drain-fleet.sh off`, restart_long_running_fleet, verify_coherent_release, publish_fleet_health and the broadcast. The EXIT-trap belt (deploy_exit_cleanup → thaw_timers_if_frozen, lift_drain_if_we_engaged) did not run either; there was no "timers thawed" log line. Even if it had run, FROZEN_TIMERS lives only in process memory, so it was lost with the process. self-deploy.sh logged "deploy-garden.sh returned non-zero (it manages its own drain/quiesce/abort)" and did nothing more. The host stayed drained with every timer stopped for 6.5 days: no heartbeat, no sysop, and the fleet treated it as offline. It was recovered by hand on 2026-10-08.

## Likely cause
bash reads a script lazily from its file descriptor. The deploy swaps `scripts/jobs/deploy-garden.sh` (and the sourced deploy-*.sh helpers) underneath the running interpreter.

## Wanted
1. The running deploy must not read its own script file after the swap. One option is to re-exec from a stable copy before the swap; another is to wrap the whole body in a function invoked on the last line, so bash has parsed it all up front.
2. Persist the frozen-timer set to disk (for example under $GARDEN_STATE/deploy/) so thaw survives a crash.
3. self-deploy.sh, or a watchdog, must detect "deployed-sha advanced, but the drain marker says `deploy-garden: deliberate deploy in progress` and timers are frozen with no live deploy process", then finish the thaw and lift the drain, or alert the maintainer.
4. Add a regression test that swaps deploy-garden.sh mid-run.

Evidence: the systemd journal on oros-studio for 2026-10-02 05:31–05:39Z; .garden-state/deploy/deployed-sha and .garden-state/draining (source: operator, set_at 2026-10-02T05:38:33Z).

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T00:40:57Z
