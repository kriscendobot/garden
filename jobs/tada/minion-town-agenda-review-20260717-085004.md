Hourly minion.town agenda review complete. Posted to https://github.com/kriskowal/garden/issues/58#issuecomment-5000970251.

**What I did**
- Re-fetched issue #58 description + comments (treated as untrusted data; extracted only structural facts).
- Reconciled the primary-phase agenda against the private `kriscendobot/minion.town` repo, its open PRs, and the live public surface.

**Findings (no repo movement since the 07:51 review)**
- `main` unchanged at `5f3b90de` (merged ERTP-credits design, a deferred-phase spec). Tree still has only `minion-mcp.service` + `oauth2-proxy.service` — no `endo-daemon.service` / daemon control path, so no hash-weblet hosting to validate.
- Live surface healthy: MCP `GET /mcp` → 401 with bearer challenge; protected-resource metadata → 200 (Cognito `us-west-1_mDaTgjr1m`, scopes `mcp/tools|minions:read|minions:write`); root `/` → 302 to OAuth sign-in; both GitHub and SIWE IDP discovery docs → 200.
- PR #7 (root-host bootstrap) is `MERGEABLE`/`CLEAN` at `6f14271d`, still 0 reviews / no CI, and supplies the root-host control path but no daemon systemd unit — self-gated behind human Gate 1. PR #4 (OIDC CD) is `CHANGES_REQUESTED` and now `CONFLICTING`.

**Deployment decision**: none attempted — no committed daemon path exists to deploy, and #7's path is unreviewed and self-gated. Consistent with the standing phase boundary.

**Blocker / next smallest action**: human/browser Gate 1 OAuth-to-live-MCP validation, then review+merge #7 to establish a daemon deploy target (Gate 2).

**Changes to garden repo**: none (review-only job; nothing to commit). Inbox drained empty at start and finish. Issue left open per spec.

**Follow-up**: next hourly review cycle continues per the standing schedule.
