---
gate: go-ahead
priority: normal
role: builder
posted_by: design-account-creation-open-signup-minion-town
posted_at: 2026-07-08T00:47:02Z
---

# Build: open-signup gate flip for minion.town (Phase B — THE consequential change: minion.town opens to all authenticated users)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws`, region us-west-1. **Secrets only in Secrets Manager.** Requires Phase A (`build-account-store-minion-town`) deployed first.

Implement Phase B of `designs/account-creation-open-signup.md` (§ 5, § 9) — **security-sensitive; this is the flip the design job deliberately did not make**:

1. `deploy/aws/oauth2-proxy/oauth2-proxy.cfg`: drop `authenticated_emails_file`, add `email_domains = [ "*" ]`, with the design's § 5 rollback comment. Keep `gen-allowed-emails.sh` + `allowed-emails.txt` current as the rollback artifact.
2. Caddy: route `GET /account` to the app inside the gated default route (behind forward_auth); oauth2-proxy alpha config: `injectResponseHeaders` for the `sub` + provider claims; Caddy `copy_headers` them; attach the internal shared-secret header (new secret `minion/account-endpoint-token`) — required because the box is multi-tenant (design § 4, § 8).
3. Flip `ACCOUNT_AUTOPROVISION=on` in the minion-mcp systemd unit env.
4. CloudWatch alarms: Cognito pool user count + DynamoDB on-demand spend (design § 8 cost levers).
5. DEPLOYMENT.md phase row + § Email verification cross-reference update.

Verification (real-execution evidence required): end-to-end with a **fresh, never-allowlisted** GitHub or Google account — sign in → landing page (no 403) → `/account` shows role `visitor` → MCP token calls `minion_status` OK and gets `insufficient_scope` on `list_minions`/`summon_minion`; break-glass login still full-admin; `/mcp` Bearer surface unaffected; the § 5 rollback (restore the cfg line) exercised once on the box and then re-flipped, or explicitly reported not exercised.

**Maintainer decisions this promotion implies:** confirm opening minion.town to every verified authenticated identity; confirm baseline role = `visitor` = `mcp/tools` only (design § 3, open question 1).
