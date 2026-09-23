Fixed PR #3 CI by pinning the Node 24 test leg to v24.18.1 while preserving its `24.x` check name. Node 24.19.0 caused the `RemoveEnvironmentCleanupHook` native-addon teardown crash.

Pushed project commit `6f12f2188`. All 26 checks passed on head SHA `6f12f2188`: https://github.com/kriscendobot/endo/actions/runs/33067505811

Verification: Prettier, full lint, garden probes, and remote CI passed. Local verification was stopped after 49 minutes while serial Genie tests remained active; CI subsequently completed the full matrix successfully.

Follow-up: remove the temporary pin after the Node 24 cleanup-hook backport ships.

Self-improvement: updated `roles/shepherd/AGENT.md` and pushed garden commit `276a3ea88e`; documented this failure signature and mitigation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-pr3-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5771s

<!-- garden-usage-end -->
