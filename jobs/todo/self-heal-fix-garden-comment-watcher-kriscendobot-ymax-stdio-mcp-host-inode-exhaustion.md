---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Host filesystem backing `/` (and the bind-mounted garden checkout) is at 100% inode usage (244,091,381/244,121,600 used, only 30,219 free) while only 79% space-used — this is why `garden-comment-watcher@kriscendobot-ymax-stdio-mcp` exited 255 with `error: could not lock config file .git/config: No space left on device`. This is filesystem-wide (not comment-watcher-specific) and will intermittently kill any service doing filesystem/git writes until remediated, then recur.

Two parts:
1. Investigate top inode consumers on this host — start with `worktrees/*/*/node_modules` under stale/completed per-job worktrees (candidates seen: `endojs-endo-but-for-bots/{gardener-fixer-442,port-pr57,pr472-shepherd,pr513-gauntlet,shepherd-461,pr438-fixer,pr96-finish}/node_modules`) — and propose a bounded, reviewed cleanup of worktrees whose jobs already reached `jobs/tada/`.
2. Add an inode-headroom check to `scripts/jobs/root-repo-guard.sh` (or a sibling host-disk-guard script/timer) that alerts the maintainer when host free-inode percentage drops below a threshold (e.g. <5%), mirroring the guard's existing classify-before-repair pattern (§ Invariant C) — so this is caught before it cascades into unrelated service failures, not after.
