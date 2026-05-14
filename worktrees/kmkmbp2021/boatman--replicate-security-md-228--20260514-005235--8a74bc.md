---
hostname: kmkmbp2021
worktree: boatman--replicate-security-md-228--20260514-005235--8a74bc
path: /Users/kris/garden/dispatches/boatman--replicate-security-md-228--20260514-005235--8a74bc
repo: endojs/endo-but-for-bots
branch: chore/security-md-uniformity
role: boatman
status: active
created_at: 2026-05-14T00:52:35Z
last_heartbeat: 2026-05-14T00:52:35Z
task: "Replicate endojs/endo-but-for-bots#228 (uniform SECURITY.md + CI check) on endojs/endo:master"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
    title: "ci: enforce uniform SECURITY.md across packages"
  - repo: endojs/endo
    pr: null
    role: target
---

Per-dispatch worktree triple for the boatman handoff dispatched at journal commit `c83daf7`. Source is `chore/security-md-uniformity` on `endojs/endo-but-for-bots` at head `5dc745be` (state MERGED into bot's `llm` base). Target is `endojs/endo:master`. Identity authorization staged. Dispatched concurrently with the #223 and #75 boatmen.

The boatman has substantial editorial work here: filter the diff to packages that exist on `endojs/endo:master`, drop the bot-only "newly-added" package list from the body. See dispatch entry for details.

Will be torn down via `skills/dispatch-worktree/dispatch-teardown.sh` after the boatman returns.
