The retired `garden-deploy-sync.service` crash-looped (`Failed with result 'exit-code'`, journalctl 20:26 & 20:28 on endolinbot) and was only removed by a reactive agent-claimed self-heal job (`self-heal-fix-garden-deploy-sync-deploy-reconcile-retired-units`, completed 20:31). Retired-unit cleanup in `scripts/jobs/install-units.sh` is a hand-maintained `RETIRED_UNITS=(...)` array (lines 52–61), so every retirement requires remembering to append the unit name, and stale-enabled units on already-deployed hosts crash-loop until a human/agent notices. Replace the by-name list with a deterministic self-reconciling prune: enumerate installed `garden-*` unit files in `~/.config/systemd/user/` (skipping `@`-template instances and `EXCLUDED_UNITS`) that have NO corresponding source file under `scripts/systemd/`, and `stop --now`/`disable`/`rm` each, then `daemon-reload`. Deleting a unit from `scripts/systemd/` then becomes sufficient to retire it; no list to maintain. Keep `RETIRED_UNITS` only as an explicit belt-and-suspenders for names that should never come back.

---
claim:
  host: endolinbot
  gardener: 28
  claimed_at: 2026-06-27T20:52:07Z
