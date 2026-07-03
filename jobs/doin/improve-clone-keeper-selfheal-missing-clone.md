`scripts/jobs/clone-keeper.sh` `keep_clone()` (line 78-81) logs `WARN: tracked clone worktrees/endojs-endo.git is missing or not a git repo ... skipping` and returns 0 when a tracked bare clone is absent. A missing bare clone is exactly the infrastructure failure clone-keeper exists to prevent — every ephemeral worktree and CI read created off `endojs-endo.git` fails while the only signal is a WARN buried in `journalctl`. The tracked-clone spec (`GARDEN_TRACKED_CLONES`, `<dir>|<remote>|<branch>`, line 47) carries only a remote *name*, not a URL, so the script cannot currently re-clone. Extend the spec to carry a clone URL (`<dir>|<remote>|<branch>|<url>`) and have `keep_clone()` re-clone a missing tracked bare clone (bounded, like `bounded_fetch`) instead of skipping; failing that, escalate a persistently-missing tracked clone to the gardener inbox (kind:error) rather than silently WARN-skipping it, or drop the stale entry from the tracked list if `endojs-endo.git` is no longer in the active set.

---
claim:
  host: endolinbot2
  gardener: 8
  claimed_at: 2026-07-03T06:22:42Z
