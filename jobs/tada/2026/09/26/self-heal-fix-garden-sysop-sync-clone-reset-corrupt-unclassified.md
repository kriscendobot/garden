Implemented and pushed commit `42a937a700d` to `main2`.

- `sync_clone` now captures reset stderr, prioritizes corruption classification, re-clones once, re-fetches/resets, and logs `REPAIRED:`.
- Vanished clones are recreated before re-fetching, avoiding futile retry loops.
- Added regressions for mixed corruption/offline reset output and reset-deleted clones.
- Verified: `fetch-timeout-test.sh` 24/24; full `run-test.sh` 386/386.
- Follow-up: standalone `receipt-watcher-test.sh` has one unrelated stale rc expectation (expects 1; current clone-outage behavior returns 75).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-sysop-sync-clone-reset-corrupt-unclassified.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 442s

<!-- garden-usage-end -->
