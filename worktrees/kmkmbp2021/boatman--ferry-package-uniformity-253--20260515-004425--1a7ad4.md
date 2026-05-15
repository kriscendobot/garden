---
hostname: kmkmbp2021
worktree: boatman--ferry-package-uniformity-253--20260515-004425--1a7ad4
path: /Users/kris/garden/dispatches/boatman--ferry-package-uniformity-253--20260515-004425--1a7ad4
repo: endojs/endo
branch: chore/security-md-uniformity
role: boatman
status: collected
created_at: 2026-05-15T00:44:25Z
last_heartbeat: 2026-05-15T00:51:14Z
task: "Re-ferry endojs/endo-but-for-bots#253 (broadened package-uniformity check) over endojs/endo#3258, replacing the SECURITY.md-only series and updating title+body"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: source
    title: "chore: general package uniformity checker (broadens endojs/endo#3258 scope)"
  - repo: endojs/endo
    pr: 3258
    role: target
    title: "chore: enforce general package uniformity across workspace"
---

Per-dispatch worktree triple for the re-ferry of #253 over #3258. The bot-side fixer (dispatched per the maintainer's "recreate based on master, expand its scope" directive) broadened the SECURITY.md-only check into a general package-uniformity checker; the upstream PR's two original commits were replaced with the new 6-commit series. The user explicitly asked for title and description update.

Outcome: #3258 force-pushed from `f4e6e8e6b` to `e98151eda` (6 commits, all `Kris Kowal <kris@cixar.com>`). Title rewritten; body redone per `pr-formation`. Source-side cross-link posted. Full reports at `../../entries/2026/05/15/005247Z-result-liaison-1a7ad4.md` and `../../entries/2026/05/15/005114Z-result-boatman-eaabd7.md`.

Torn down via `skills/dispatch-worktree/dispatch-teardown.sh`.
