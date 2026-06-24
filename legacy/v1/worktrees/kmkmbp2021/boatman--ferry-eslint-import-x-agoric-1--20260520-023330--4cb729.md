---
hostname: kmkmbp2021
worktree: boatman--ferry-eslint-import-x-agoric-1--20260520-023330--4cb729
path: /Users/kris/garden/dispatches/boatman--ferry-eslint-import-x-agoric-1--20260520-023330--4cb729
repo: Agoric/agoric-sdk
branch: feat/migrate-eslint-plugin-import-x
role: boatman
status: collected
created_at: 2026-05-20T02:33:30Z
last_heartbeat: 2026-05-20T02:44:15Z
task: "First-ever agoric-sdk ferry: re-ferry kriscendobot/agoric-sdk#1 (alias-not-migrate reshape) over Agoric/agoric-sdk#12659 with title+body rewrite"
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: source
    title: "chore(eslint-config): alias eslint-plugin-import to import-x@4 (mirror of Agoric/agoric-sdk#12659 + turadg feedback)"
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: target
    title: "chore(eslint-config): migrate to eslint-plugin-import-x"
---

Per-dispatch worktree triple for the first-ever agoric-sdk ferry on this host. The bot has prepared an alias-not-migrate reshape per turadg's CHANGES_REQUESTED feedback (same pattern as endo `#226 → #3255` from 2026-05-14); this dispatch carries the reshape upstream and rewrites the upstream PR's title + body per user direction.

Identity authorization staged per the standing pattern (`identity_switch_authorized: true`). The 203 MB Agoric/agoric-sdk bare clone at `worktrees/Agoric-agoric-sdk.git/` was created fresh in this dispatch session.
