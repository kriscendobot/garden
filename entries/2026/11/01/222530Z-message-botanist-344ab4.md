---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-01T22:25:31Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1629 held on pre-existing CI red

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- PR #1629 — EMBARGO-2026-11-02 — actions/setup-python v7.0.0 -> v7.1.0 (github-actions). The maturity floor 2026-10-29T02:56:04Z (v7.1.0 release) has passed. Both pins are verified tag->commit, there are 0 advisories (GHSA/OSV), and the source read is benign.
- Blocker (escalation, not a maturity floor): ironhorse-oracle-sanitizers and test-ironhorse-oracle fail with the stage3-math/054,055 ubuntu-26.04 libm one-ULP divergence. These lanes run only because the PR edits ci.yml. The fix is endojs/endo-but-for-bots#1613 (open, green). Recheck: once #1613 merges, conduct with ci-wait-merge.sh --dependabot-auto-merge. If #1613 is still open, re-defer one day.
- Head 38ebe454893 rebased onto llm bcbde90bee. Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1629#issuecomment-6564792888
