Implemented and pushed `229b5c94444` to `main2`.

- Isolated missing/invalid monk physical-cap faults per pool/host; valid pools continue apportionment and leveling.
- Added edge-latched per-host freeze/recovery reporting.
- Added missing- and invalid-cap regression coverage.

Verified: proportional leveling test (8/8) and worker-leveling host-gate test (4/4) pass.

Follow-up: operator must still backfill the Oros host’s monk cap.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-level-single-host-cap-freeze.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 376s

<!-- garden-usage-end -->
