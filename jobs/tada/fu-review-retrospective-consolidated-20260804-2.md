Investigated PRs #684, #806, #836, and #881 and traced the failure to producer coupling: auto-gauntlet runs only after `role: builder` completion, which excludes other PR creators and can occur hours after PR creation.

Added `designs/auto-gauntlet-pr-reconciler.md`, proposing:

- Per-PR lifecycle records keyed by repository and PR number.
- Registration during `ensure-pr.sh`.
- A leader-only reconciler for all bot-authored, bot-pushable PRs.
- Explicit probe exemptions.
- Approval/conductor gates requiring gauntlet evidence.
- Safe migration using a rollout watermark.

Verified with `git diff --check`, shell parsing of referenced scripts, path checks, clean worktree status, and matching local/remote `main2` SHA.

Committed and pushed `413f6814e7` to `main2`.

Follow-up: implementation remains a separate build.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-review-retrospective-consolidated-20260804-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 403s

<!-- garden-usage-end -->
