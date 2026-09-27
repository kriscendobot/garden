Reproduced finding `ad5b483fc5e0973f` at the recorded SHA. Root cause was XS-oracle’s former 1 KiB result truncation; IronHorse correctly returned the full 1,549-byte value. Existing commits `7fae4aea2f` and `8fdef95f3c` already contain the causal fix.

Pushed commit `a5b76ab318` to the standing branch and adopted draft PR endojs/endo-but-for-bots#1298. It adds exact-input, submodule-free VM fixtures plus a live differential regression. Temporarily restoring the truncation reproduced the original failure, proving the regression is load-bearing.

Verification passed: exact pinned fuzz replay, Rust formatting, both targeted tests, all `ironhorse-fuzz` unit tests, and all 11 pre-push gates. Broader local checks only encountered unrelated host limitations. CI currently has no failures; the existing staged gauntlet `endojs-endo-but-for-bots-pr1298-gauntlet` owns completion, and its active fixer was notified of this commit. Documented the finding in PR comment `#issuecomment-5855529862`.

Self-improvement: queued a scholar review for missing Ironhorse-fuzz library coverage and alerted liaison to the gauntlet-policy conflict in the repair-job generator.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ad5b483fc5e0973f-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 3434s

<!-- garden-usage-end -->
