---
gate: orchestrated
orchestrated_by: ironhorse-ci-failures-20261116
priority: normal
posted_by: producer
posted_at: 2026-11-16T06:56:18Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI step 4: the remaining reds and the final report

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16): address failing CI on the ironhorse pull requests, serially. Run the CI-equivalent checks locally before pushing (CI failure = automation defect). Push only to kriscendobot-authored heads; never push to another author's PR (kumavis) - diagnose and report only. Do not merge anything; nothing merges until the ratchet improves the base. Do not weave unless a PR is blocked without it. Classify each red as (a) the known oracle-lane red (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055 asinh/acosh, ubuntu-26.04 glibc rounding; fix is #1613), (b) a cross-PR flake (rerun the failed leg), or (c) a real defect in the PR, and fix (c). Report per PR: before/after check state, cause, commit pushed.

Task: #1535 (kriscendobot; red: cover, test on 22.x and 24.x ubuntu, sandbox-drivers, oracle sanitizers) - fix it. #1548 and #1473 are kumavis's PRs: diagnose their reds (browser-tests, cover, test, sandbox-drivers; test-xs) and report the cause and a suggested fix; do not push. Then write the closing report for the whole sequence: a table of every open ironhorse PR with its CI state now, and which reds remain and why (expected: only the oracle lanes, until #1613 reaches their base).

