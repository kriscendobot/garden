Implemented and pushed Phase 7 in draft PR endojs/endo-but-for-bots#1544, stacked on #1504 at `ee79556d4d8`.

Added sandbox-gated Claude session provisioning and a daemon-backed MCP Git acceptance loop covering edit, build, status, diff, commit, push, and historical filesystem inspection. Reconciled shell timeout behavior and environment-shell posture reporting.

Validation passed: 181 Claude tests, targeted daemon/environment tests, shell suites, type/lint checks, and all nine pre-push gates. CI remains in flight; two completed Ubuntu 26.04 lanes expose runner-level `tred` packaging and `/bin/sh ulimit -u` incompatibilities.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-endo-claude-acceptance-loop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 7046s

<!-- garden-usage-end -->
