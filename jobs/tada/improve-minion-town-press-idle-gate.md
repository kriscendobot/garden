Hardened `minion-town-press-preflight.sh` to classify repeated unmarked reports as idle when they explicitly describe unchanged maintainer review waits. Explicit status markers remain authoritative, and ambiguous unmarked reports still fail open.

Added regression coverage for the observed reports, ambiguous prose, explicit `advanced` overrides, and hermetic resume behavior. `minion-town-press-preflight-test.sh`: 18 passed, 0 failed.

Pushed commit `d90227d834` to `main2`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-minion-town-press-idle-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 276s

<!-- garden-usage-end -->
