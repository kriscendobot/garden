---
order: serial
children: kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait kriscendobot-minion.town-pr199-land-20261104-merge kriscendobot-minion.town-pr199-land-20261104-deploy-verify minion-town-coupon-flip-and-mint-20261104 minion-town-maintainer-guest-reset-20261104
on-child-failure: halt
state: pending
resume_from: minion-town-first-users-orchestration-20261104
created_by: producer
created_at: 2026-11-05T01:29:39Z
---

Split of `kriscendobot-minion.town-pr199-land-20261104` after one handler overrun: the wall was spent waiting on a gauntlet that runs under its own stage jobs. Children: wait for the gauntlet outcome (stop and report must-fix on failure), merge, verify the deploy and promote the phase-1 successor. Then the unrun remainder of the halted `minion-town-first-users-orchestration-20261104` (flip and mint, maintainer guest reset) is adopted, in its authorized order. Adopting it keeps it parked until #199 has really merged and deployed; otherwise the handoff report would read as a recovered success and auto-resume that halt before the merge.
