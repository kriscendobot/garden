---
hostname: kmkmbp2021
worktree: boatman--ferry-numeric-separators-244--20260515-013456--9224ee
path: /Users/kris/garden/dispatches/boatman--ferry-numeric-separators-244--20260515-013456--9224ee
repo: endojs/endo
branch: master
role: boatman
status: collected
created_at: 2026-05-15T01:34:56Z
last_heartbeat: 2026-05-15T01:39:50Z
task: "First-time ferry of endojs/endo-but-for-bots#244 (numeric-separators-style rule + 44-file autofix) to a new DRAFT PR on endojs/endo"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: source
    title: "chore(eslint-plugin): require underscore-delimited groups in numeric literals"
  - repo: endojs/endo
    pr: 3263
    role: target
    title: "chore(eslint-plugin): require underscore-delimited groups in numeric literals"
---

Per-dispatch worktree triple for the first-time ferry of #244 (the master-branch mirror of #243, built specifically "for future ferry" at the earlier 2026-05-14T03:50Z builder dispatch). The user chose a DRAFT upstream PR.

Outcome: upstream PR `endojs/endo#3263` opened as DRAFT on branch `kriskowal-eslint-numeric-separators-style` at head `b583f9259`. Four commits, all `Kris Kowal <kris@cixar.com>`. Cherry-pick auto-merged the 44-file autofix cleanly against the 28-commit upstream gap. Full reports at `../../entries/2026/05/15/014119Z-result-liaison-9224ee.md` and `../../entries/2026/05/15/013950Z-result-boatman-b39a13.md`.

Torn down via `skills/dispatch-worktree/dispatch-teardown.sh`.
