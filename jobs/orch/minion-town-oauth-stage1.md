---
order: serial
children: minion-town-deployment-doc minion-town-phase2-mcp-server minion-town-oauth-fanout
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-07-07T05:33:54Z
---

# minion.town OAuth deployment — stage 1 (serial): doc → MCP server → fan-out

Set up by job `orchestrate-minion-town-oauth-deploy`. Drives the minion.town OAuth build (repo github.com/kriscendobot/minion.town, PRIVATE) to a live conclusion in two stages:

1. **This serial stage:** `minion-town-deployment-doc` (commit DEPLOYMENT.md, the in-repo architecture/phase source of truth every later child reads; close superseded PR #2) → `minion-town-phase2-mcp-server` (MCP server live on EC2 behind Caddy, Cognito-verified) → `minion-town-oauth-fanout` (records the stage-2 orchestration).
2. **Stage 2** (`minion-town-oauth-stage2`, parallel, on-child-failure=continue): phases 3 (Google IdP), 4 (authz policy + identity Lambda), 5 (GitHub OIDC thunk), 6 (web login gate). Its four children are ALREADY parked with gate=orchestrated owned by `minion-town-oauth-stage2`; only the fan-out child's `post-orchestration.sh` call arms them.

**If this stage halts** (Phase 2 fails), the four stage-2 children stay parked and invisible to every promoter. To resume after fixing Phase 2, run the fan-out recording by hand: `scripts/jobs/post-orchestration.sh --parallel --on-child-failure continue minion-town-oauth-stage2 minion-town-phase3-google-idp minion-town-phase4-authz-policy minion-town-phase5-github-oidc-thunk minion-town-phase6-web-gate`.

Phases 3 and 5 gate on maintainer inputs (Secrets Manager `minion/google-idp-client` and `minion/github-oauth-app`); the maintainer was asked at set-up time, and those children self-park a `--go-ahead` remainder job rather than failing if the input hasn't arrived.
