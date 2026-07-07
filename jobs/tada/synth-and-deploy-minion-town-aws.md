# synth-and-deploy-minion-town-aws — closed as superseded (never run)

Closed 2026-07-07 by `orchestrate-minion-town-oauth-deploy` on the maintainer's
standing mandate. This go-ahead-gated plan assumed the CDK **App Runner** path
(`infra/`, draft PR kriscendobot/minion.town#2). That path is superseded: the
live deployment is **EC2 (`i-0380cd68b90020fad`) + Caddy + Cognito** in
us-west-1, Phase 1 of which is already done, and the remaining phases run under
orchestrations `minion-town-oauth-stage1` (DEPLOYMENT.md → MCP server → fan-out)
and `minion-town-oauth-stage2` (Google IdP / authz policy / GitHub OIDC thunk /
web gate). The sibling `cognito-mcp-metadata-bridge` completed earlier (tada);
its pre-token-generation Lambda idea carries into Phase 4, its aud-stamping
goal is dead (the verifier validates `client_id` instead — Cognito cannot set a
resource-URL `aud`). Architecture source of truth: `DEPLOYMENT.md` in
kriscendobot/minion.town.
