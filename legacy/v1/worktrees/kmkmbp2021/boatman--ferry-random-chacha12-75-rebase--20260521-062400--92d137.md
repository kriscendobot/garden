---
hostname: kmkmbp2021
worktree: boatman--ferry-random-chacha12-75-rebase--20260521-062400--92d137
path: /Users/kris/garden/dispatches/boatman--ferry-random-chacha12-75-rebase--20260521-062400--92d137
repo: endojs/endo
branch: kriskowal-random-chacha20
role: boatman
status: collected
created_at: 2026-05-21T06:24:00Z
last_heartbeat: 2026-05-21T06:29:44Z
task: "Re-ferry #75 over endojs/endo#3232: source rebased to 11 fresh commits on current master; recompute-from-master force-push (with lease) to fix the CONFLICTING upstream"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
    title: "feat(random,chacha12): factor @endo/random from @endo/chacha12 [resync to actual/kriskowal-random-chacha20]"
  - repo: endojs/endo
    pr: 3232
    role: target
    title: "feat(chacha12): Consolidate PRNG for fuzzing"
---

Per-dispatch worktree triple. 11 commits to recompute-from-master onto current `bf951df3`. AGENTS.md thunk-module commit is intentional (matches upstream's existing thunk-module commit), included.

Attribution default: `Kris Kowal <kriskowal@kriskowal.com>`. Identity authorization staged per the standing pattern (`identity_switch_authorized: true`).
