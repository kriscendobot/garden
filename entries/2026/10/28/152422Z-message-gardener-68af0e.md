---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-28T15:24:25Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1553: MERGE-NOW (merged)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1553
head: 6b476ba7dee8afe33d4a0aab0ecb262923f93af8
verdict: MERGE-NOW
active: false

Terminal row. eslint-plugin-jsdoc 64.5.4 -> 65.3.12 was merged into `llm` at 2026-10-28T15:23:55Z (merge commit 9a14ddf660912ed624e2d9047671d43e3a2f0cec) by `ci-wait-merge.sh --dependabot-auto-merge`. The spine verified the Dependabot author and head, and the merge had no maintainer approval because none is required for this case. The non-CI legs carried over from the 2026-10-28 recheck: maturity floor 2026-10-25T15:17:50Z (from `eslint-plugin-jsdoc@65.3.12`), OSV/GHSA clean on all 9 moved versions, no sibling PR, source read clean. On the rebased head 6b476ba7de, CI run 40691089323 first went 36/38. `test (22.x, ubuntu-latest)` failed the bwrap timeout/reap test, and the same test is also red on `llm` 870f52665a. `test (24.x, macos-15)` failed when http-content-plane.test.js exited non-zero. Both legs run runtime suites that this lint-plugin bump does not touch, and both had passed on the previous head 5f4e962176. After a `--failed` rerun both passed, giving 38/38 green before the merge. This PR's row is removed from the active ledger, and its one-shot has fired.
