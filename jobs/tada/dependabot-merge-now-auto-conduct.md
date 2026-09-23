Implemented and pushed commit `225e364eb0` to `main2`.

Added explicit `--dependabot-auto-merge`, gated by live Dependabot authorship and bot-owned repository scope. Failures retain the normal approval gate. CI green, CHANGES_REQUESTED veto, live-base rewrite, shared-stack refusal, branch retention, post-merge verification, and botanist diligence remain enforced. Human-authored and non-owned upstream PRs remain approval-gated.

Updated botanist/conductor/watcher documentation and added `designs/dependabot-auto-merge.md`.

Tests passed:

- `ci-wait-merge-test.sh`: 41/41
- `dependabot-watcher-test.sh`: 43/43
- `pr-maintainer-approval-gh-test.sh`: 12/12
- Full `run-test.sh`: 368/368

Follow-up: the separate sweep job can conduct the existing terminal MERGE-NOW PRs.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabot-merge-now-auto-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 757s

<!-- garden-usage-end -->
