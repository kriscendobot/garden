Rebased PR #282’s 26 commits onto `llm` at `6257535532` and safely force-pushed head `e73a77e92a`. Resolved `designs/README.md` by preserving current design rows plus the PR’s updated endor design date. Range-diff preserved the fixture-parity and host-hook commits.

Verification:
- `cargo test -p endo --lib`: 328 passed
- `cargo test -p endo --bin endor`: 3 passed
- `git diff --check origin/llm..HEAD`: passed
- GitHub reports `MERGEABLE`; remote head matches `e73a77e92a`
- CI currently has 5 successes, including `test-ironhorse` and `fuzz-ironhorse`; 20 checks remain in progress and 2 queued

Posted the completion summary on PR #282. Follow-up: the Ironhorse press should rerun its staged gauntlet after CI settles. No merge performed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr282-weave-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 455s

<!-- garden-usage-end -->
