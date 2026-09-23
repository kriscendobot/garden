Rebased PR #1013 onto `llm@1956e545d`, resolving both README conflicts while preserving upstream and PR intent. Force-pushed `33984f7da` with an exact lease; draft state remains intact and the PR is now mergeable.

Verification:
- Pre-push 8-stage gate passed.
- Formatting, lint fixes, typist checks, `diff --check`, and range-diff review passed.
- Full-suite validation was attempted but blocked by checkout-path Unix socket limits after repairing a Node ABI mismatch; documented in the PR summary.
- Five check-runs attached; zizmor passed, with remaining CI queued/running at last check.

Posted the required summary: https://github.com/endojs/endo-but-for-bots/pull/1013#issuecomment-5503377305

No merge or close performed. Routed a durable garden follow-up recommending ABI-aware dependency caches and shorter test socket paths.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-weave-20260902-sweep.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2598s

<!-- garden-usage-end -->
