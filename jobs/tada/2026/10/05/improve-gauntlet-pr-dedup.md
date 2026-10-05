Implemented and pushed PR-keyed gauntlet deduplication to `main2`.

- `post-gauntlet.sh` now refuses a second live gauntlet for the same PR after every journal sync.
- Added driver-side coalescing for duplicates that win overlapping creation races.
- Added a deterministic divergent-base concurrent race regression test.
- Verified `post-gauntlet-dedup-test.sh`, `gauntlet-pr-dedupe-test.sh` (10 checks), `gauntlet-test.sh` (68 checks), stage-retry tests (16 checks), and viability tests (9 checks).
- Pushed through commit `4bad63cb790`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-pr-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 364s

<!-- garden-usage-end -->
