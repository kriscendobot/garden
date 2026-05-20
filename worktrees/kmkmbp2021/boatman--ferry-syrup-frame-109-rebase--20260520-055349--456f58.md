---
hostname: kmkmbp2021
worktree: boatman--ferry-syrup-frame-109-rebase--20260520-055349--456f58
path: /Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109-rebase--20260520-055349--456f58
repo: endojs/endo
branch: feat/syrups-package
role: boatman
status: collected
created_at: 2026-05-20T05:53:49Z
last_heartbeat: 2026-05-20T05:58:43Z
task: "Recompute-from-master re-ferry of #109: source rebased & squashed from 9 to 4 commits; force-push (with lease) onto endo#3256 replacing the prior 9-commit shape"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
    title: "feat(syrup-frame): syrup-frame package and opt-in framing for OCapN TCP-for-testing"
  - repo: endojs/endo
    pr: 3256
    role: target
    title: "feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing"
---

Per-dispatch worktree triple. Source rebased & squashed; recompute-from-master force-push.

Attribution default: `Kris Kowal <kriskowal@kriskowal.com>` (the post-2026-05-20T05:09Z global-config-change default). Pre-flight ancestor check baked into procedure per the recent #3241 force-update incident.

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`). Naming note: the source's commit 2 subject says "syrup" (singular) but the upstream PR's title says "syrups" (plural). The boatman is asked to read commit 2's diff and report whether the code paths use singular or plural, so the liaison can flag the title/body mismatch in the result without editing without user direction.
