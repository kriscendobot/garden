The work is complete. Here is my report.

---

## Completion report: `self-heal-fix-garden-deploy-sync-deploy-reconcile-retired-units`

**Root cause confirmed.** On endolinbot the retired `garden-deploy-sync.timer`/`.service` were still `enabled`+`active` and firing every ~3 min, exec'ing the deleted `deploy-sync.sh` → rc 127. The deploy that landed the retirement (fe2d9f296) advanced the root checkout and restarted the fleet but never reconciled the systemd unit set, and the rendered unit files lingered in `~/.config/systemd/user/`. The self-heal wrapper was even invoking the diagnosis responder on each fire (220 MB / 1.4 s CPU per tick) — pure waste.

**Code changes (committed `8792b3d2b`, pushed to `origin/main2`):**
1. **`deploy-garden.sh`** — added a post-merge reconcile step that runs `install-units.sh install` + `enable-services`, so a unit retirement (or a newly-added intended unit) landed by a deploy actually takes effect on every deployed host, not just in the tree.
2. **`install-units.sh` `enable_services()`** — after `disable --now` on each `RETIRED_UNITS` entry, it now `rm -f`s the rendered file from `$DEST` and `daemon-reload`s, so a retired unit's files can't linger and be re-triggered.
3. **`deploy-garden-test.sh`** — added a `UNIT RECONCILE` case asserting a stale `RETIRED_UNITS` unit is disabled *and* its rendered files removed during a deploy. Full suite: **40/40 pass** (was 35; +5 new assertions). `bash -n` clean on both scripts.

All development was done in an isolated worktree off `origin/main2` (never the root checkout), committed under the `endolinbot` identity, and torn down.

**Live remediation on endolinbot:** ran the deployed `enable-services` (disabled the timer), then stopped/reset-failed the instances, removed the two lingering rendered files, and `daemon-reload`ed.

**Verification:** `systemctl --user is-enabled garden-deploy-sync.timer` → `not-found`; `list-timers 'garden-deploy-sync*' --all` → `0 timers listed`. The rc-127 loop is stopped.

**Follow-up:** The fix is on `origin/main2` but not yet deployed to any host's root checkout (including endolinbot's, still at fe2d9f296). The next deliberate `deploy-garden.sh` will pick it up and will now self-reconcile units going forward — no manual cleanup needed for future retirements. No action required from the maintainer.
