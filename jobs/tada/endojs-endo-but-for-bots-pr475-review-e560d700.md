Reviewed PR #475 feedback review 4998388584; its top-level body was empty. The sole inline comment was `packages/immutable-arraybuffer/src/lib.js:1390`, asking whether the reverse-map write was redundant and whether TypedArray emulation shared the issue.

No additional changes were needed: commit `4dbe5ffff6c472a6c866c371fa14759523adbc0f` installs both buffer-map directions together at immutable-buffer creation and removes the redundant writes from both TypedArray and DataView constructors. Reply `3834914888` acknowledged the urgent question; reply `3834924079` explains the invariant gap and cites the fix. Top-level summary comment `5377533017` records the outcome and verification.

Observed PR head `4dbe5ffff` with all 27 GitHub checks passing, clean merge state, and review re-requested from erights. No files or commits were created by this attempt.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-review-e560d700.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 73s

<!-- garden-usage-end -->
