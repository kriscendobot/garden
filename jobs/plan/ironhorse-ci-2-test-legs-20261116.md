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
# Ironhorse CI step 2: macOS and ubuntu test-leg failures

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16): address failing CI on the ironhorse pull requests, serially. Run the CI-equivalent checks locally before pushing (CI failure = automation defect). Push only to kriscendobot-authored heads; never push to another author's PR (kumavis) - diagnose and report only. Do not merge anything; nothing merges until the ratchet improves the base. Do not weave unless a PR is blocked without it. Classify each red as (a) the known oracle-lane red (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055 asinh/acosh, ubuntu-26.04 glibc rounding; fix is #1613), (b) a cross-PR flake (rerun the failed leg), or (c) a real defect in the PR, and fix (c). Report per PR: before/after check state, cause, commit pushed.

Task: PRs whose red includes a test, cover or macOS leg beyond the oracle lanes: #1623 (cover 24.x ubuntu, test 24.x macos-15), #1618 (test 22.x ubuntu, test 24.x macos-15), #1616 (test 24.x macos-15), #1615 (test 22.x ubuntu), #1614 (cover 22.x ubuntu), #1612 (sandbox-drivers, test 24.x macos-15), #1605 (test 24.x macos-15), #1585 (test 22.x macos-15). Known flakes in this repo: Node 24 undici ClientDestroyedError, claude-sandbox restore-context macOS, @endo/cli component exit-leak: rerun the failed leg once before changing code. Fix real defects on the PR heads; leave the oracle-lane red alone.

