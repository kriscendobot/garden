---
hostname: kmkmbp2021
worktree: boatman--ferry-eslint-import-x-226--20260514-175634--3114c6
path: /Users/kris/garden/dispatches/boatman--ferry-eslint-import-x-226--20260514-175634--3114c6
repo: endojs/endo
branch: kriskowal-eslint-plugin-import-x
role: boatman
status: active
created_at: 2026-05-14T17:56:34Z
last_heartbeat: 2026-05-14T17:58:15Z
task: "Re-ferry endojs/endo-but-for-bots#226 to endojs/endo#3255 with the reshaped alias approach (per turadg feedback carried by fixer at 06:28Z)"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 226
    role: source
    title: "feat(eslint-plugin): migrate to eslint-plugin-import-x"
  - repo: endojs/endo
    pr: 3255
    role: target
    title: "feat(eslint-plugin): migrate to eslint-plugin-import-x"
---

Per-dispatch worktree triple for the re-ferry of #226 → #3255. The source has been reshaped (since the first ferry on 2026-05-12) from a migrate-to-import-x diff to an alias-import-x diff per turadg's CHANGES_REQUESTED feedback on #3255. The fixer at `entries/2026/05/14/061347Z-dispatch-liaison-63f3ef.md` carried the feedback to #226; this dispatch carries the reshape upstream.

The target PR title and body are expected to change in this dispatch to match the new alias shape. The titles recorded here are the pre-dispatch state; the result entry will record the post-dispatch state. Identity authorization staged in the dispatch prompt per the standing pattern (`identity_switch_authorized: true`).
