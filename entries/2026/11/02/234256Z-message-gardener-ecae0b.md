---
kind: message
role: gardener
host: oros-studio-garden-ce242c49
at: 2026-11-02T23:43:44Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1629 re-deferred (blocker #1613 still open)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1629 — EMBARGO-2026-11-03 — actions/setup-python v7.0.0 -> v7.1.0 (github-actions). Recheck 2026-11-02T23:40Z by the one-shot dependabotany-recheck-endo-but-for-bots-pr1629: the maturity floor 2026-10-29T02:56:04Z has passed and the earlier verdict (pins verified, 0 advisories, benign source) stands; it was not re-derived on this pass.
- Blocker unchanged: endojs/endo-but-for-bots#1613 is still OPEN and unmerged (no failing checks of 38, no review decision). #1629 head is still 38ebe454893, and its only failing checks are ironhorse-oracle-sanitizers and test-ironhorse-oracle. No refresh or merge attempted. Re-deferred one day.
- Next recheck: the daily heartbeat dependabotany-recheck-endo-but-for-bots (last dispatched 2026-11-02T22:50:09Z). This one-shot fired despite the 23:13Z row calling it retired, and it is no longer on journal2, so no new one-shot was armed. Once #1613 merges, rebase if needed and conduct with ci-wait-merge.sh --dependabot-auto-merge.
