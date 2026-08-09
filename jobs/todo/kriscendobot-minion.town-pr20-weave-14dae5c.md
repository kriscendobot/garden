---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town (worktree base `worktrees/kriscendobot-minion.town.git`).
Trigger: `main` advanced to 14dae5c by the merge of PR #31 (`feat(endo): add B4 guest facet tools`, head `feat/endo-guest-mcp-tools-b4`, merged 2026-08-09T18:26:07Z).
Task: weave PR https://github.com/kriscendobot/minion.town/pull/20 (`feat: retire toy MCP tools for daemon guests`, head `feat/endo-daemon-guest-mcp-b5`). It is still based on the now-merged `feat/endo-guest-mcp-tools-b4` branch and GitHub reports it CONFLICTING / DIRTY.
Do: retarget its base to `main`, rebase/restack the B5 commits onto merged `main` (14dae5c), resolve conflicts against the landed B4 content (`src/endo/guest-tools.ts`, `src/auth/accounts.ts`, `src/auth/policy.ts`, `src/http.ts`, `src/server.ts`, `config/policy.json`, and the `test/endo-guest-*.test.ts` suite all moved in B4), keep the net diff honest, run local verification, and force-push the restacked branch. Report the resulting mergeability state on the PR.
