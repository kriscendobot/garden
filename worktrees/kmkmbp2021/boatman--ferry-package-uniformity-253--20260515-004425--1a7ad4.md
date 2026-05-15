---
hostname: kmkmbp2021
worktree: boatman--ferry-package-uniformity-253--20260515-004425--1a7ad4
path: /Users/kris/garden/dispatches/boatman--ferry-package-uniformity-253--20260515-004425--1a7ad4
repo: endojs/endo
branch: chore/security-md-uniformity
role: boatman
status: active
created_at: 2026-05-15T00:44:25Z
last_heartbeat: 2026-05-15T00:44:39Z
task: "Re-ferry endojs/endo-but-for-bots#253 (broadened package-uniformity check) over endojs/endo#3258, replacing the SECURITY.md-only series and updating title+body"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: source
    title: "chore: general package uniformity checker (broadens endojs/endo#3258 scope)"
  - repo: endojs/endo
    pr: 3258
    role: target
    title: "ci: enforce uniform SECURITY.md across packages"
---

Per-dispatch worktree triple for the re-ferry of #253 over #3258. The bot-side fixer (dispatched per the maintainer's "recreate based on master, expand its scope" directive) broadened the SECURITY.md-only check into a general package-uniformity checker; the upstream PR's current 2 commits will be replaced with the new 6-commit series. User explicitly asked for title and description update.

Identity authorization staged in the dispatch prompt per the standing pattern (`identity_switch_authorized: true`).

The titles recorded here are the pre-dispatch state; the result entry will record the post-dispatch state.
