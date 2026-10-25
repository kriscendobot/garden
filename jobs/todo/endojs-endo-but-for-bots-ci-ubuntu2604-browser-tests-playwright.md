---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# fix: endojs/endo-but-for-bots browser-tests red on Ubuntu 26.04 (Playwright)

Repo: endojs/endo-but-for-bots, base `llm`.

Since `ubuntu-latest` moved to Ubuntu 26.04 (runner-images migration, beginning
2026-10-19), the `browser-tests` job fails on EVERY head, including the `llm` tip
(d5ac41980a), at `node node_modules/playwright/cli.js install --with-deps`:
`Error: ERROR: Playwright does not support chromium on ubuntu26.04-x64`.
Example: https://github.com/endojs/endo-but-for-bots/actions/runs/40228801582/job/121276176951
(PR #1553 head ba26b7472a).

Repair it the way the sibling depcheck fix did (draft PR #1546, job
`endojs-endo-but-for-bots-ci-ubuntu2604-graphviz-tred`: pin the job to
`ubuntu-24.04` with a comment explaining why), or by moving to a Playwright release
that supports 26.04 if one exists and is mature, whichever is the smaller, safer change.
Check whether the same workflow has other `ubuntu-latest` Playwright jobs. Open a PR
against `llm` via ensure-pr.sh, drive its `browser-tests` to green, and let the gauntlet
run. This red currently blocks every Dependabot MERGE-NOW on the repo (e.g. #1553).
