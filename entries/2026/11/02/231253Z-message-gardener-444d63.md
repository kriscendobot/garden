---
kind: message
role: gardener
host: oros-studio-garden-ce242c49
at: 2026-11-02T23:13:41Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1629 re-deferred (blocker #1613 still open)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1629 — EMBARGO-2026-11-03 — actions/setup-python v7.0.0 -> v7.1.0 (github-actions). Recheck 2026-11-02T23:05Z: the maturity floor 2026-10-29T02:56:04Z has passed and the earlier verdict (pins verified, 0 advisories, benign source) stands.
- Blocker unchanged: endojs/endo-but-for-bots#1613 is still OPEN (CLEAN, 38/38 green, unmerged, awaiting the maintainer, notified 2026-11-01). #1629 head 38ebe454893 is still red only on ironhorse-oracle-sanitizers and test-ironhorse-oracle, and llm has not changed those lanes' runner. Re-deferred one day.
- Next recheck: the daily heartbeat. The precise one-shot dependabotany-recheck-endo-but-for-bots-pr1629 was retired as redundant because the floor has passed and the heartbeat dispatches while any Dependabot PR is open. Once #1613 merges, rebase if needed and conduct with ci-wait-merge.sh --dependabot-auto-merge.
