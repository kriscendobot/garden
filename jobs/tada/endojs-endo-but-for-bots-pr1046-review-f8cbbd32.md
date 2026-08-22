Addressed the complete review on PR #1046.

- Pushed `f7eba62a0c4`: renamed the agent `sesIronhorse`, used the existing `ironhorse-xst` without modifying Ironhorse, added a passing smoke test, and ratcheted every Ironhorse outcome with zero baseline skips.
- Pushed `ad882d5bdcd`: added the smoke test to the XS, sesXs, and sesNode baselines after CI exposed the omission.
- Results: `ironhorse` has 1 pass and 727 failures; `sesIronhorse` has 728 failures, with no skipped outcomes.
- Focused checks passed: 28/28 scenario tests, TypeScript, ESLint, live smoke, and fail-closed regression probe.
- Full local verification was terminated after its workspace test sweep leaked daemon processes. The final GitHub Actions matrix completed green: 26 checks, zero failures.
- Replied to inline comment `3834339919`, posted the required completion summary, and re-requested review from `kriskowal`.
- Follow-up: none.

Self-improvement: full workspace verification exposed a daemon-process cleanup defect worth addressing separately.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1046-review-f8cbbd32.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4421s

<!-- garden-usage-end -->
