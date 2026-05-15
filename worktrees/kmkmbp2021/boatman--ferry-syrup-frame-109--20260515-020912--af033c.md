---
hostname: kmkmbp2021
worktree: boatman--ferry-syrup-frame-109--20260515-020912--af033c
path: /Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109--20260515-020912--af033c
repo: endojs/endo
branch: feat/syrups-package
role: boatman
status: active
created_at: 2026-05-15T02:09:12Z
last_heartbeat: 2026-05-15T02:09:25Z
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

Per-dispatch worktree triple for the re-ferry of #109 over #3256. The bot side has been rebased to current upstream master and the work split from one squash commit (`acddddba`) into two logical commits (`24560074` package addition + `069c24d6` consumer opt-in). The upstream PR carries kumavis's APPROVED review; the branch is not protected, so the approval should persist across force-push as a record.

Identity authorization staged in the dispatch prompt per the standing pattern (`identity_switch_authorized: true`). The boatman picks whether to keep the upstream PR's combined title or shorten/split it; no user ask for title/body changes this round.
