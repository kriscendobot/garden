Fixed and landed commit `cae895c91d3` on `main2`.

- Reaper now sources `auction.sh`, providing `auction_bid_dir` and existing reputation helpers.
- Expanded the superseded-schedule test to verify bid-directory cleanup and preservation for non-superseded jobs.
- Audited reaper helper calls; found no other missing sources.
- Verification: all five reaper tests passed; `bash -n` and `git diff --check` passed.
- Follow-up: unrelated worker-kind/reducer failures remain in `auction-reputation-test.sh`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-reaper-auction-bid-dir-20261014.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 247s

<!-- garden-usage-end -->
