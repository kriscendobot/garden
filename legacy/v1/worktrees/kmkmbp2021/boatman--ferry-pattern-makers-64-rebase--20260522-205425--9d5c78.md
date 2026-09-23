---
hostname: kmkmbp2021
worktree: boatman--ferry-pattern-makers-64-rebase--20260522-205425--9d5c78
path: /Users/kris/garden/dispatches/boatman--ferry-pattern-makers-64-rebase--20260522-205425--9d5c78
repo: endojs/endo
branch: kriskowal-harden-exports-pattern-makers-2632
role: boatman
status: collected
created_at: 2026-05-22T20:54:25Z
last_heartbeat: 2026-05-22T20:58:17Z
task: "Re-ferry #64 over endojs/endo#3277: source rebased (new SHAs same content); upstream CONFLICTING with master; recompute-from-master force-push-with-lease, 3->1 squash"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 64
    role: source
    title: "feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)"
  - repo: endojs/endo
    pr: 3277
    role: target
    title: "feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)"
---

Per-dispatch worktree triple. 3 source commits squash to 1; force-push-with-lease over `7d853dc8`. Apply the `--amend -F <cleaned-msg>` pattern (per the #352 lesson) to strip any Claude `Co-Authored-By:` body trailers along with the attribution rewrite. Use correct erights comment ID `#issuecomment-2477602697` (the prior #64 ferry caught my wrong `#2479055797` cite).

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`).
