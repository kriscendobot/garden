Shepherded endojs/endo-but-for-bots PR #1573 to green.

- Diagnosed macOS Node 24 failure: minimal SES override taming made `Error.prototype.message` read-only, causing undici teardown rejections.
- Confirmed head `ecfbdb2ac9` contains the fix and is mergeable.
- Verified CI run 41036923676: all checks pass or are intentionally skipped, including both macOS legs.
- Posted the required PR summary: https://github.com/endojs/endo-but-for-bots/pull/1573#issuecomment-6522048278
- Follow-up: PR #1575 remains independently green on its frozen base.
- Self-improvement: nothing this time.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `aec86ec537f78299b7a85bc5fdae37d8eac9906b`; this job presented `ecfbdb2ac96d7d10c592b6421213d73da96f73fb`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-shepherd-20261030.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 7285s

<!-- garden-usage-end -->
