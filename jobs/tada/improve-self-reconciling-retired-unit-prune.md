The worktree is cleaned up and the work is pushed. Writing the completion report.

---

## Completion report — `improve-self-reconciling-retired-unit-prune`

**What I did**

Replaced the hand-maintained `RETIRED_UNITS=(...)` array in `scripts/jobs/install-units.sh` with a deterministic, self-reconciling prune. Worked in an isolated worktree off `origin/main2` (per gardener norms), pushed as commit `49f4c47e3`, and tore the worktree down.

**What changed**

- **New `prune_retired()`** — enumerates the installed `garden-*.{service,timer}` files in `$DEST` (`~/.config/systemd/user/`), skips `@`-template files/instances and `EXCLUDED_UNITS`, and for any unit whose source no longer exists under `scripts/systemd/` runs `disable --now` (stop + un-enable) + `rm` of the rendered file, then a single `daemon-reload`. Deleting a unit from `scripts/systemd/` is now sufficient to retire it.
- **Wired into two paths**: `render()` (so `deploy-restart.sh`'s re-render-on-unit-change prunes automatically) and `enable_services()` (replacing the old RETIRED_UNITS-only loop).
- **`RETIRED_UNITS` kept as belt-and-suspenders only** — names that should stay dead even if a stray source reappears (pruned unconditionally). It is now **empty by default**: the historical retirees (`garden-bulletin.timer`, `garden-deploy-sync.{timer,service}`) already ship no source, so `prune_retired` removes them with no name listed. This directly closes the 2026-06-27 `garden-deploy-sync` crash-loop class: a stale-enabled retiree on an already-deployed host is now cleaned up on the next install/enable instead of crash-looping until an agent appends its name.

**Tests** — `scripts/jobs/test/enable-services-test.sh` now sandboxes `$DEST` via `XDG_CONFIG_HOME` (critical: `prune_retired` `rm`s real files, so an un-sandboxed run would delete the host's units) and adds a rewritten RETIRE section asserting: three orphans pruned (file removed + disabled) with **no name listed**; sourced (`garden-foreman.timer`), template (`garden-gardener@.service`), and excluded-but-sourced (`garden-mention-watcher.service`) units all survive. **24/24 pass.** I also manually verified the `install`/`render` prune path end-to-end against the mock systemctl + sandboxed DEST.

**Verification** — `bash -n` clean; full test suite green; end-to-end `install` run pruned a pre-seeded orphan while rendering and substituting real units correctly. Pushed cleanly to `main2` (`557e0d763..49f4c47e3`).

**Follow-ups** — None required. The change takes effect on this host at the next deliberate deploy (when `deploy-restart.sh` re-renders) or next `enable-services` run; no manual intervention needed for already-stale units thereafter. The pre-existing untracked `bundle-ymax0.json` / `wt-507/` at the garden root are unrelated and left untouched.
