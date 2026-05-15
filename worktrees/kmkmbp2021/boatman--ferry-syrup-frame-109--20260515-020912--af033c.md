---
hostname: kmkmbp2021
worktree: boatman--ferry-syrup-frame-109--20260515-020912--af033c
path: /Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109--20260515-020912--af033c
repo: endojs/endo
branch: feat/syrups-package
role: boatman
status: collected
created_at: 2026-05-15T02:09:12Z
last_heartbeat: 2026-05-15T02:13:17Z
task: "Re-ferry endojs/endo-but-for-bots#109 over endojs/endo#3256: source has been rebased onto current master and split from one squash into two logical commits; recompute from master and force-push"
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

Per-dispatch worktree triple for the re-ferry of #109 over #3256. The bot side was rebased to current upstream master and the work split from one squash commit (`acddddba`) into two logical commits (`24560074` package addition + `069c24d6` consumer opt-in).

Outcome: #3256 force-pushed from `acddddba` to `b5c3168655` (two commits, both `Kris Kowal <kris@cixar.com>`). Title kept as-is; body untouched. Cherry-pick auto-merged cleanly. **kumavis APPROVED persisted across force-push** (branch not protected, no auto-dismiss). Full reports at `../../entries/2026/05/15/021448Z-result-liaison-af033c.md` and `../../entries/2026/05/15/021317Z-result-boatman-394d39.md`.

Torn down via `skills/dispatch-worktree/dispatch-teardown.sh`.
