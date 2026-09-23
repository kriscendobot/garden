---
hostname: kmkmbp2021
worktree: boatman--ferry-syrup-frame-109-rebase-on-new-master--20260520-214109--410186
path: /Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109-rebase-on-new-master--20260520-214109--410186
repo: endojs/endo
branch: feat/syrups-package
role: boatman
status: collected
created_at: 2026-05-20T21:41:09Z
last_heartbeat: 2026-05-20T21:46:19Z
task: "Eighth ferry of #109: source SHA unchanged, but upstream master has advanced 11 commits; recompute-from-new-master onto ec3dcbc0 and force-push (with lease)"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
    title: "feat(syrup-frame): syrup-frame package and opt-in framing for OCapN TCP-for-testing"
  - repo: endojs/endo
    pr: 3256
    role: target
    title: "feat(syrup-frame): add @endo/syrup-frame package and opt-in syrup framing for OCapN TCP-for-testing"
---

Per-dispatch worktree triple. Source SHA unchanged at `2627e81a`; upstream master has advanced from `c063631fed` to `ec3dcbc0cb` (11 commits including the Node-18/20 drop landing at #3084 → `f22f4b5d` and the skel tsconfig fix at `ec3dcbc0`). Recompute-from-master force-push onto the fresher master.

Attribution default: `Kris Kowal <kriskowal@kriskowal.com>`. Pre-flight ancestor/lease check baked into procedure.

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`).
