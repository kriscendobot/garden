Added Unicode-set parser edge coverage and removed unused UTF-8 encoder helpers in commits 8273c26c5d and 92a09cd15c. Coverage rose from 77.60% to 79.05%; all 30 regexp tests and 5 Unicode-set integration tests passed. Changes were pushed and remain in current PR head 89fddc8940.

CI reached its 3600-second deadline with only lint still running, so the stage must be re-posted.

Self-improvement: coverage runs for this crate require `RUST_MIN_STACK=33554432`.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-unicode-sets-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3988s

<!-- garden-usage-end -->
