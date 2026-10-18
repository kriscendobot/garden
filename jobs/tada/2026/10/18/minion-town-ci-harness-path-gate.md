Implemented and pushed commits `b82fe98f` and `9b952c48`.

- Opened draft PR https://github.com/kriscendobot/minion.town/pull/204 against pinned base `main-945aaaa`.
- Added a job-level path gate for Claude-harness image builds. Pushes to `main` always build; unrelated PRs report a skipped matrix job.
- Confirmed `main` has no branch-protection rules or required checks.
- Browser gating was not added because no browser workflow exists on the base branch.
- Left prod-probe permissions unchanged to preserve separation from third-party install execution.
- PR #204 CI is fully green, including both image architectures.
- Docs-only proof PR https://github.com/kriscendobot/minion.town/pull/205 is green; run `39072220037` reports the harness matrix skipped.
- Pre-push probes and typecheck passed. The full local suite exposed an unrelated parallel-only flaky test; it passed in isolation, and remote CI passed.
- Follow-up: close throwaway proof PR #205 unmerged after review.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-harness-path-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 17389s

<!-- garden-usage-end -->
