---
role: fixer
requires: host=endolin-garden-ece02cb4
handler-timeout: 5400
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# URGENT: every cleric job dies at codex startup (minion.town MCP config conflict)

Since clerics came back online (2026-10-03 ~05:00Z, cleric-fleet-ceiling 2, both on
endolin-garden-ece02cb4), EVERY cleric claim failed within ~10s with "non-transient
handler failure". ~12 jobs hit it (garden-book-supervisor-20261003,
resume-halted-gauntlets-20261003, garden-upkeep-watchers-provenance-20261003,
ebfb-pr1380/1409-panel-summary-20261003, build-confined-application-makers-p2-split-20261003,
book-codex-illustrations, kriscendobot-garden-book-pr{1,2,3}-conduct/review,
minion-town-claude-cli-provider-conduct-20261003, fu-endojs-endo-but-for-bots-pr1348-shell-command-grammar-2).
Capture (journal inboxes/endolin-garden-ece02cb4/captures/2ac3e77439766b2844f696d0b84ba26bc4792c57):

    [cleric/2] job '...' attaching minion.town MCP (stdio bridge)
    Error loading config.toml: url is not supported for stdio
    in `mcp_servers.minion-town`

The liaison has STOPPED clerics fleet-wide with the placeholder pool
(`config/budget-pools`: codex-endolin ... placeholder). minion-mcp-lib.sh /
cleric-codex.sh have not changed since 09-30; the likely cause is a persisted
`[mcp_servers.minion-town] url = ...` entry in this host's codex config
(~/.codex/config.toml or $CODEX_HOME), colliding with the inline `-c` stdio override.

Do:
1. Confirm the root cause on this host and remove the conflicting persisted entry
   (keep a backup; do not touch auth).
2. Make the handler robust so a persisted entry can never brick every cleric again
   (for example: detect a conflicting persisted minion-town entry and skip or
   rename the inline server, failing OPEN as the standing order intends), with a
   test in scripts/jobs/test/minion-mcp-test.sh. Check the opencode/kimi handlers
   for the same hazard. Land on main2.
3. Verify with one real `codex exec` smoke run using the handler's args.
4. Undo the stop: `scripts/jobs/set-budget-pool.sh codex-endolin 100 codex-cli-rate-limit --kind percent`.
5. Revive each job above EXCEPT the kriscendobot-garden-book-pr*-conduct/review jobs (the garden-book supervisor owns merges and reviews there; leave those parked) that the failure doomed or parked (`promote-plan.sh --maintainer <base>`
   for go-ahead-parked ones; re-post any that vanished), and report the list.
