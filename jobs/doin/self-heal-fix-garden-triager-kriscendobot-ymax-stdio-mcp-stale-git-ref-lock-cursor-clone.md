In `scripts/jobs/common.sh`, journal/cursor git operations die with `cannot lock ref 'HEAD': Unable to create '<clone>/.git/refs/heads/journal2.lock': File exists` when a prior git process was killed mid-`update_ref` (e.g. the `timeout`/SIGKILL rc=137 fetch path, an OOM kill, or a container stop) and left an orphaned git lockfile behind. Confirmed live failure: `garden-triager@kriscendobot-ymax-stdio-mcp` exits 1 because `cursor-set.sh` → `sync_clone`/`commit_and_push` on `$GARDEN_STATE/cursors/journal` cannot advance HEAD; a stale zero-byte `.git/refs/heads/journal2.lock` (Jul 25 00:12) blocks it, and git never clears it, so every systemd restart re-fails.

Fix: add a small helper `_sweep_stale_git_locks <dir>` and call it inside `sync_clone` immediately AFTER `clone_lock "$dir"` (and in `ensure_clone` after its lock/existing-clone branch), guarded on `<dir>/.git` existing. The `clone_lock` flock guarantees exclusive fleet access to the clone, so any git lockfile present at that point is definitively orphaned and safe to `rm -f`. Sweep the standard set under `<dir>/.git`: `index.lock`, `HEAD.lock`, `config.lock`, `packed-refs.lock`, `ORIG_HEAD.lock`, and `refs/**/*.lock` (e.g. `find "<dir>/.git/refs" -name '*.lock' -delete` plus the top-level ones). Log a single line when it actually removes any (so the symptom stays visible), no-op otherwise. Immediate unblock for the currently-wedged host: `rm -f /home/kris/garden2/.garden-state/cursors/journal/.git/refs/heads/journal2.lock` (verify no live `git` process holds the clone first via the existing clone lock). Add/extend a test under the job-system tests asserting that a planted stale `refs/heads/journal2.lock` is swept and `sync_clone`/`cursor-set.sh` then succeeds, matching the existing `common.sh` guard-test style.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  worker_kind: cleric
  claimed_at: 2026-07-25T03:03:22Z
