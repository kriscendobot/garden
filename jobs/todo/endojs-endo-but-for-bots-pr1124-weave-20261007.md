---
arc: minion-town-mcp-ocapn
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave (pin the merge base) on endojs/endo-but-for-bots#1124, the OCapN formula nonce locator mechanism on branch build/ocapn-nonce-locator-mechanism. That means snapshotting the current `llm` tip as a frozen `llm-<sha>` base, rebasing the conflicted head onto it with conflict resolution, force-pushing, and retargeting the PR base. Once the PR is re-based, the halted gauntlet can run again and unblock the federation release gate in endo-minion-town-guest-locator-federation.
