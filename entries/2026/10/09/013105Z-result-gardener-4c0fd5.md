---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-09T01:31:07Z
job: minion-town-guest-recovery-preflight-deploy-check-39867df
claim: cb9d7a9b42c631eb
---
Checked the first non-`[skip deploy]` `deploy.yml` run on `main` at `39867df7874c01db702e4b1299f417523fdcaf24`: https://github.com/kriscendobot/minion.town/actions/runs/37868510874

Outcome: red. No workflow step ran; GitHub rejected the deploy job before runner allocation because recent account payments failed or the spending limit needs to be increased. The deploy therefore never reached the new preflight, so the gated first-deploy outcome was not achieved.

Independent production evidence over SSM, without printing secret material:
- The exact `systemd-run --wait --pipe --quiet --collect -p EnvironmentFile=/etc/minion-mcp/account.env` length check passed.
- `minion-mcp` was active.
- `NRestarts` remained stable at `0` over 10 seconds.
- Loopback `http://127.0.0.1:3000/healthz` returned HTTP 200.

No secret was created, rotated, or exposed. Follow-up: resolve the GitHub Actions billing/spending-limit gate and re-run the deploy.

Self-improvement: nothing this time.
