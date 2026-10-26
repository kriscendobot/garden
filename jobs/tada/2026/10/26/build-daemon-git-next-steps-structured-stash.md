Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1571, stacked on PR #1570’s frozen base.

Implemented structured `Git.stashList()` and `Git.stashShow()` results, porcelain `*Text` siblings, guards, types, help/code-mode generation, changesets, and tests across `@endo/exo-git`, `@endo/git`, `@endo/agent-tools`, and `@endo/daemon`.

Verification: 12-stage `pre-push-gates` passed; targeted stash and daemon tests, exo-git tests/types, and the full git suite passed. Per `regression-evidence`, breaking the stash comparison made the new test fail. Full daemon and agent-tools suites retain known host Git identity failures unrelated to this change.

`frozen-base-branch`, `pr-formation`, `changeset-discipline`, and `pre-pr-checklist` shaped the branch, PR, release notes, and verification. `library-lookup` found no relevant prior guidance. Follow-up: `build-daemon-git-next-steps-read-only-type-narrowing` owns the remaining Phase 7 typing slice.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-next-steps-structured-stash.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1497s

<!-- garden-usage-end -->
