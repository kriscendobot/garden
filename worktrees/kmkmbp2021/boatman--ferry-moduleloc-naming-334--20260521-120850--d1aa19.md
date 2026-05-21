---
hostname: kmkmbp2021
worktree: boatman--ferry-moduleloc-naming-334--20260521-120850--d1aa19
path: /Users/kris/garden/dispatches/boatman--ferry-moduleloc-naming-334--20260521-120850--d1aa19
repo: endojs/endo
branch: kriskowal-naming-module-location-specifier
role: boatman
status: collected
created_at: 2026-05-21T12:08:50Z
last_heartbeat: 2026-05-21T12:12:59Z
task: "Re-ferry endo-but-for-bots#334 over endojs/endo#2887: recompute-from-master force-push-with-lease; 2 commits replace upstream's single approved commit"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 334
    role: source
    title: "fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes"
  - repo: endojs/endo
    pr: 2887
    role: target
    title: "fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes"
---

Per-dispatch worktree triple. 2 source commits (substance + docs follow-up) recompute onto current master `bf951df3`. Source commit 1 reshape drops a now-moot `src/node-modules.js` hunk; the recompute carries that reshape upstream.

Attribution default: `Kris Kowal <kriskowal@kriskowal.com>`. Both source commits rewritten to that (commit 1 was `kris@agoric.com`, commit 2 was `endolinbot`).

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`).
