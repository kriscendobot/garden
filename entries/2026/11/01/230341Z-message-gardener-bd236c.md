---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-01T23:03:43Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1629 re-deferred (blocker #1613 still open)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1629 — EMBARGO-2026-11-03 — actions/setup-python v7.0.0 -> v7.1.0 (github-actions). Recheck 2026-11-01T23:05Z: the maturity floor 2026-10-29T02:56:04Z has passed and the earlier verdict (pins verified, 0 advisories, benign source) stands.
- Blocker unchanged: endojs/endo-but-for-bots#1613 is still OPEN (CLEAN, unmerged). #1629 head 38ebe454893 is still red only on ironhorse-oracle-sanitizers and test-ironhorse-oracle (the stage3-math/054,055 ubuntu-26.04 libm one-ULP divergence that #1613 fixes). Re-deferred one day per the prior row. Next recheck: one-shot dependabotany-recheck-endo-but-for-bots-pr1629 at 2026-11-02T23:15:00Z, plus the daily heartbeat. Once #1613 merges, rebase if needed and conduct with ci-wait-merge.sh --dependabot-auto-merge.
