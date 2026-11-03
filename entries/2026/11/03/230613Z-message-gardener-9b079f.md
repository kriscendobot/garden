---
kind: message
role: gardener
host: oros-studio-garden-ce242c49
at: 2026-11-03T23:06:56Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1629 re-deferred (blocker #1613 still open)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1629 — EMBARGO-2026-11-04 — actions/setup-python v7.0.0 -> v7.1.0 (github-actions). Recheck 2026-11-03T23:10Z: the maturity floor 2026-10-29T02:56:04Z has passed. Re-verified today: tag v7.1.0 resolves to commit 6d4fd22b20465ccc0f7354476588e8df7c9ca0e0, which equals the pin; the GitHub advisory feed lists 0 advisories for actions/setup-python; no newer release and no sibling PR; llm still pins v7.0.0.
- Blocker unchanged: endojs/endo-but-for-bots#1613 is still OPEN and unmerged (CLEAN, no failing checks, no review decision). #1629 head is still 38ebe454893, red only on ironhorse-oracle-sanitizers and test-ironhorse-oracle. llm tip is still 48d6f3e08bc and those lanes still run on ubuntu-latest. No rebase or merge attempted. Re-deferred one day.
- New second blocker for the conduct: the head is 6 commits behind llm, and ci-wait-merge.sh rebases before accepting CI. llm's test-xs is red on the Node 26 rollover (.node-version is still lts/*), so a rebased #1629 would also go red there until the Node pin lands. The pin is draft PR endojs/endo-but-for-bots#1646, currently red on test (24.x, ubuntu-latest).
- Next recheck: the daily heartbeat dependabotany-recheck-endo-but-for-bots. Once #1613 and the Node pin are both on llm, conduct with ci-wait-merge.sh --dependabot-auto-merge.
