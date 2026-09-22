Rebased and refreshed PR #1097 onto frozen base `llm-db664fa` (`db664fa119`), force-pushing head `4003abd2a1`.

- Retained the relevant transcript stabilization in `481de8826a`.
- Updated the changeset to canonical `sha256`, `size`, `bytes`, `byteRange`, and `textRange` names in `4003abd2a1`.
- Dropped superseded implementation commits already landed independently on `llm`.
- Replied to the inline review and posted the required top-level completion summary.
- Verification: targeted platform test passed three times (7 tests); formatting, platform types, scoped local verification, and all six pre-push probes passed. ESLint reported zero errors and one pre-existing warning.
- CI currently has 11 passing and 23 pending checks; reviewer re-request remains pending CI completion.
- Full-repository local verification was interrupted by concurrent worktree teardown and also encountered existing workflow/zizmor failures; this was disclosed on the PR.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-review-05395c57.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 126 tokens (4388493 cached reads)
- Output: 62413 tokens
- Cost: $5.5296345 (1 engagement(s) unpriced)
- Wall-clock: 2992s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
