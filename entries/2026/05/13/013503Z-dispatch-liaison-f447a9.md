---
ts: 2026-05-13T01:35:03Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/012400Z-result-steward-da0309.md
---

# Dispatch: land the kriscendobot authorization for endojs/ocapn-test-suite

Dispatch root: `dispatches/liaison--ocapn-test-suite-authorization--20260513-013453--f447a9/`. One of three concurrent dispatches firing this turn.

Task: in `journal/README.md`, add a row to the bulletin's *Pre-staged authorizations* section recording the maintainer's grant from `endojs/endo-but-for-bots#109#issuecomment-4436075344` (verbatim text mirrored in `entries/2026/05/13/012400Z-result-steward-da0309.md`):

- Identity: `kriscendobot`.
- Action: push branches and commits to `endojs/ocapn-test-suite`.
- Constraint: use the hash pinned from `endojs/endo-but-for-bots#109` as the baseline; do **not** open a PR upstream (the OCapN-org repo is not in scope).
- Source: `endojs/endo-but-for-bots#109#issuecomment-4436075344`, 2026-05-13T00:54:05Z, maintainer kriskowal.

The row stays in *Pre-staged authorizations* until the corresponding work lands (a future dispatch picks up the authorization and pushes the agreed branch). Determine the pinned hash from PR #109 via `gh pr view 109 -R endojs/endo-but-for-bots --json files,baseRefOid,headRefOid,body` and note it in the bulletin row so future agents do not have to re-derive it.

Do **not** bare-clone the fork or open any worktree this dispatch; infrastructure setup happens when the first work task arrives. The maintainer asked for the authorization to land, nothing more.

Report expected on return: the journal commit SHA, the bulletin row text, the pinned hash discovered.
