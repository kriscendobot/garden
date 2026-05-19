---
ts: 2026-05-19T03:29:13Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: target
---

# Dispatch: shepherd on #288 — fix lint:prettier + re-request review

Shepherd dispatched to drive #288 CI to green after the fixer dispatch
`7e0c14` (result `59c029`). Lint job on workflow run `26074178297`
failed at the `yarn lint:prettier` step; the rest of CI is mid-flight.

Dispatch root: `/home/kris/dispatches/shepherd--8add0d` on `feat/cbors-package`, head
`6196d0f5b`.

Per-action authorization carried: push to `feat/cbors-package`,
`gh api .../requested_reviewers` re-request after CI converges,
optional brief PR comment if the prettier diff is non-obvious. All
covered by the standing broad authorization on endojs/endo-but-for-bots.
