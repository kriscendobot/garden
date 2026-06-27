Add a deterministic deploy reconciler so landed script fixes actually reach the running fleet. Today the long-lived `garden-*` systemd units execute `/home/kris/scripts/...` from a checkout that drifts behind `origin/main2` (currently 4 commits behind), so the gardener claim-path self-heal fix in `origin/main2:bd65630d1` never took effect and 9 gardeners crash-looped on `claim failed (rc=128)` after the fix had already landed. Create `scripts/jobs/deploy-sync.sh` + a `garden-deploy-sync.timer`/`.service` pair under `scripts/systemd/` that, on a cadence (≈2–5 min): fetches `origin/main2`; only when the local checkout is clean and a strict fast-forward is possible (`git merge --ff-only`, skip-and-log if the tree is dirty or diverged — the working tree carries concurrent gardener edits per the isolated-worktree convention), advances `/home/kris`; and when `scripts/` actually changed, `systemctl --user restart` the affected garden units (reuse the unit list/patterns in `scripts/jobs/install-units.sh`) so workers re-exec onto the new code. Restart gardeners between claims, not mid-job (honor the existing killswitch/idle path). Without this, every reliability fix the fleet lands on itself is dead on arrival until a manual maintainer step.

---
claim:
  host: endolinbot
  gardener: 19
  claimed_at: 2026-06-27T07:06:40Z
