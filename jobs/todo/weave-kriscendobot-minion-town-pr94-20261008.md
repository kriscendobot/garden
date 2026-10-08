---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave kriscendobot/minion.town#94

PR: https://github.com/kriscendobot/minion.town/pull/94 (fix(security): authenticate the GitHub OIDC thunk `/token` endpoint; close the /tmp secret window). High-severity finding from the 2026-09-04 security review; the fix has NOT landed on `main` (`deploy/aws/lambda/github-oidc-thunk/index.js` on `main` still accepts a bare `code`). The PR is CONFLICTING against `main` and still based on bare `main`.

Weave it (pin the merge base): snapshot current `main` to a frozen `main-<sha7>` base on kriscendobot/minion.town, rebase the head onto it resolving conflicts (scripts moved toward JavaScript on main; carry the security intent into whatever form those deploy scripts now take), force-push with lease, move the PR's base. GARDEN_YARN=npm. First verify the PR is still OPEN; if merged or closed, complete as a no-op.

Then post the gauntlet at the new head (`scripts/jobs/post-gauntlet.sh --arc minion-town-mcp-ocapn kriscendobot-minion.town-pr94-gauntlet-20261008 https://github.com/kriscendobot/minion.town/pull/94`) and withdraw the now-redundant parked plan `kriscendobot-minion.town-pr94-gauntlet-plan-20261007`. Do not merge by hand: the minion.town proxy screen (delegation `active`) merges eligible PRs. Posted by the minion.town arc supervisor (issue kriscendobot/garden#58) under the 2026-10-07 standing order.
