Rebased PR #173 onto frozen base `50aa690` and force-pushed with lease (`6b2e551` → `7f1a6a3`), refreshing its stale workflow snapshot without changing the design diff.

CI is green on the new head: test, amd64 harness, and arm64 harness all passed in https://github.com/kriscendobot/minion.town/actions/runs/37833565251. The self-hosted runner switch-back schedule already exists.

Follow-up: exact-head panel coverage must use `7f1a6a3` before undrafting.

Self-improvement: sent the liaison evidence that rerun attempts can retain an obsolete workflow snapshot after `CI_RUNS_ON` changes; the runner-switch skill should require a fresh workflow run in this case.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2347s

<!-- garden-usage-end -->
