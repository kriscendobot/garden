---
hostname: kmkmbp2021
worktree: boatman--ferry-drop-node-20-280--20260518-233223--8c1a6e
path: /Users/kris/garden/dispatches/boatman--ferry-drop-node-20-280--20260518-233223--8c1a6e
repo: endojs/endo
branch: ta/node-matrix
role: boatman
status: collected
created_at: 2026-05-18T23:32:23Z
last_heartbeat: 2026-05-18T23:42:46Z
task: "First-time stacked-on-#3084 ferry: endojs/endo-but-for-bots#280 (Node 20 portion) opens as a new non-draft PR on endojs/endo with base ta/node-matrix"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 280
    role: source
    title: "chore(ci): drop Node.js 18 and 20 from the test matrix"
  - repo: endojs/endo
    pr: 3268
    role: target
    title: "chore(ci): drop Node.js 20 from the test matrix"
  - repo: endojs/endo
    pr: 3084
    role: merge-base
    title: "drop Node 18"
---

Per-dispatch worktree triple for the first-time stacked ferry of #280. **New procedure shape**: stacked on `endojs/endo#3084` (Turadg's `ta/node-matrix` branch) rather than master. Per user direction at 2026-05-18T23:30Z:
- Use #3084 as the merge base (not master).
- Body references #3084 only as context, not "supersedes".

Only the two endolinbot commits (1 and 3) are ferried; Turadg's commit (2) is excluded because it's already on the base.

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`).

This new procedure shape (stacked-on-open-upstream-PR) is not covered by the `skills/pr-handoff/SKILL.md` brief at `entries/2026/05/15/045644Z-message-liaison-73cdf1.md`; the gardener's next pass should add it as a fourth sub-procedure.
