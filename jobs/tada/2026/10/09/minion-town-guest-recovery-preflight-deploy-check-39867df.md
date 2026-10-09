---
orchestration-failed: true
---
Checked the first non-`[skip deploy]` `deploy.yml` run on `main` at `39867df`: https://github.com/kriscendobot/minion.town/actions/runs/37868510874

Outcome: red. No workflow step ran; GitHub rejected the job before runner allocation because of failed account payments or an insufficient spending limit. The deploy never reached the new preflight.

Independent production checks over SSM passed without exposing secret material:

- Exact `systemd-run --wait --pipe` recovery-key length check: passed
- `minion-mcp`: active
- `NRestarts`: stable at `0` over 10 seconds
- Loopback `/healthz`: HTTP 200

No secret was created, rotated, or exposed. Follow-up: resolve the GitHub Actions billing/spending-limit gate and rerun the deploy.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-recovery-preflight-deploy-check-39867df.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 106s

<!-- garden-usage-end -->
