Implemented and pushed commit `59f8a4ded3` to `main2`.

- Added a 720-second tick deadline, 32-session resumable batch limit, finish reserve, and per-operation timeouts.
- Bounded transcript enumeration, decompression, redaction/gzip, journal reads, and remote Git operations.
- Preserved unprocessed spool and ledger state after batch limits, timeouts, or unverified pushes.
- Added regression coverage for multi-tick backlog draining and wedged remote pushes.
- Verification: `transcript-capture-test.sh` passed all 29 tests; shell syntax and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-transcript-capture-bounded-tick.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 774s

<!-- garden-usage-end -->
