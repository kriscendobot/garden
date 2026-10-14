Fixed and pushed commit `82fc050e032` to `main2`.

- Root cause: every claimed job created a fresh per-doer journal checkout; on oros Docker/virtiofs, the canary’s inbox checkout consumed roughly 14 minutes.
- Changed gardener inbox reads to reuse the worker’s already-hot private journal clone. Completion now inherits that fresh tip, avoiding another cold catch-up. The 600-second deadline was not raised.
- Added regression coverage proving inbox delivery uses the worker clone and creates no per-doer checkout.
- Verified `journal-clone-seed-from-root-test.sh` (20/20) and `rolling-deploy-test.sh` (127/127). Diff and shell syntax checks passed.
- Follow-up: observe the first post-deployment oros canary to confirm host-level latency.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-oros-canary-probe-latency-20261014.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 335s

<!-- garden-usage-end -->
