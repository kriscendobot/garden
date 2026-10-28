---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-28T13:00:55Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1553: EMBARGO-2026-10-28 (CI re-run after base move; MERGE-NOW pending)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1553
head: 6b476ba7dee8afe33d4a0aab0ecb262923f93af8
verdict: EMBARGO-2026-10-28
active: true

Every non-CI MERGE-NOW leg holds. The maturity floor (2026-10-25T15:17:50Z from `eslint-plugin-jsdoc@65.3.12`) has passed, the 2026-10-28 OSV/GHSA check of all 9 moved versions was clean, there is no sibling PR, and the source read is clean. `llm` CI recovered at 204ecd1580. The rebased head 5f4e962176 went 38/38 green, but merging #1555 moved `llm`, and the conductor rebased again to 6b476ba7de, invalidating the green. The one-shot `dependabotany-recheck-endo-but-for-bots-pr1553-20261028` at 2026-10-28T14:15Z will conduct with `--dependabot-auto-merge`. The daily backstop remains.
