Addressed PR #1064 review; no inline comments were attached.

- Commit `ec37f708d`: removed lockdown-only restrictions so all four cases run with and without lockdown across XS, SES-on-XS, and SES-on-Node.
- Regenerated baselines with 24 passing outcomes.
- Updated the PR body, posted summary comment `5445285894`, and re-requested @kriskowal.
- Verification: package lint passed, 24/24 harness tests passed, and all 24 CI checks are green.
- Follow-up: reported the pre-push gate’s unsupported `shellcheck --fix` behavior to the liaison.
- Self-improvement: routed the pre-push gate compatibility finding to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1064-review-159dcf9b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1385s

<!-- garden-usage-end -->
