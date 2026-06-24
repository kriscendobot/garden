---
ts: 2026-06-09T14:39:15Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/09/143457Z-dispatch-liaison-98efa8.md
---

Boatman re-ferried the rebuilt bots#75 onto endojs/endo#3232 as-is (dispatch `98efa8`); maintainer-directed despite 37-line content divergence on the gibson042-approved PR.

#3232 new head `5cb2ae89a` (was `cc336d40a`), force-with-lease, 10 commits (down from 12). All Kris Kowal author+committer; trailer gate EMPTY (no Claude trailer this time). HEAD tree == rebuilt bots#75 tip tree `2c2d3018c` (content matches the rebuild, not the old #3232). Clean recompute (source base == master 4a04d078b; yarn.lock applied without regen). MERGEABLE. Cross-link 4637494705 -> `...head 5cb2ae89a`. CI pending.

**gibson042 APPROVED persists** (endo master unprotected; force-push did not dismiss). Per the maintainer's explicit "re-ferry as-is" decision, the standing approval now covers ~37 lines of content gibson042 did not review (fast-check test logic changes + pure-rand-v8 adapter docs), and NO re-review request was routed. This is a maintainer-accepted state, recorded for traceability: a future reader of #3232 should know the approval predates the current test/doc content. If gibson042's re-review is later wanted, it routes as a kriscendobot comment via the steward.
