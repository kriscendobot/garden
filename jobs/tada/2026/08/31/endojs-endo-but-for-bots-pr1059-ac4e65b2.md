Completed PR #1059 SQLite coverage follow-up.

- Added mid-transaction SQL abort/rollback and cold-cache retry coverage.
- Added valid-database corruption matrices across validation, eager resume, and lazy faults.
- Integrated concurrent resume-oracle and close/reopen carry-matrix coverage for `FUNC`, `GENR`, `IBFN`, `PRIV`, `DISP`, iterator identities, and Intl rebound ordering.
- Pushed head `c0c30fcde8` and posted completion summary: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5474286945
- Verified: full `ironhorse-snapshot` and `ironhorse-store-sqlite` test suites pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1059-ac4e65b2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1194s

<!-- garden-usage-end -->
