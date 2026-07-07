---
gate: orchestrated
orchestrated_by: minion-town-oauth-stage2
priority: normal
roadmap: minion.town/mcp-oauth
role: builder
posted_by: orchestrator
posted_at: 2026-07-07T05:33:38Z
---

# minion.town Phase 6: web login gate (oauth2-proxy behind Caddy forward_auth)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, **direct push to `main`, no PR**. **Read `DEPLOYMENT.md` at the repo root FIRST** (AWS inventory, Cognito ids, secret names, Caddy discipline). Phase 2 is done: Caddy serves minion.town from `conf.d/minion-town.caddy` with `/static`, `/mcp*`, `/.well-known/oauth-protected-resource*`, and a default route; the MCP server runs as systemd `minion-mcp`. AWS CLI `~/.local/bin/aws`, region us-west-1; box `i-0380cd68b90020fad` is **SSM only**; keep additions light. **Secrets only in Secrets Manager.**

Isolated checkout:

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-phase6-web-gate kriscendobot/minion.town main

## Work

1. **oauth2-proxy, standalone binary** (NOT a Caddy plugin — it must stay portable to other providers/front-ends), ARM64 release, installed on the box with a systemd unit (`deploy/aws/systemd/oauth2-proxy.service` in the repo, loopback port e.g. 4180, `MemoryMax` modest). Provider: OIDC against issuer `https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m`, client = the web-gate confidential client `1ado9v94gl9lpufejiekpehnli` (secret from Secrets Manager `minion/web-gate-client`; fetch at deploy time via SSM — never commit). Redirect URL `https://minion.town/oauth2/callback` — **add that callback to the web-gate client in Cognito** (`update-user-pool-client` replaces the whole client config: read-modify-write preserving every field, read back to confirm; Phases 3/5 may be concurrently adding IdPs to the same client — on clobber, redo). Generate a cookie secret; store it as `minion/web-gate-cookie-secret`.
2. **allowed-emails**: derive `allowed-emails.txt` from the emails in `config/policy.json` (Phase 4 owns that file and may land it concurrently — if it doesn't exist yet, seed the allowlist with `breakglass@minion.town` and note in DEPLOYMENT.md that the list regenerates from policy.json; put the derivation in a small script under `deploy/aws/scripts/` so it's re-runnable).
3. **Caddy**: edit `deploy/aws/caddy/conf.d/minion-town.caddy` — you own this file in this wave (Phase 5 only adds a separate `github-idp.caddy`; Phase 4 doesn't touch Caddy). Route `/oauth2/*` → `127.0.0.1:4180`, and wrap ONLY the default route in `forward_auth 127.0.0.1:4180` (uri `/oauth2/auth`, with the standard redirect-to-sign-in on 401). **`/mcp*`, `/.well-known/*`, and `/static/*` stay outside the gate.** Pull `main` immediately before editing; deploy per DEPLOYMENT.md § Caddy discipline (base64 → SSM tee → `caddy validate` → reload).
4. **Verify live:** (a) `curl -I https://minion.town/` → redirect chain into the Cognito hosted UI login; (b) `/mcp` unchanged: no token → 401 + `WWW-Authenticate`, and a Bearer token from the Phase 2 test client (`minion/test-cc-client`) → tool call 200; (c) `/static/` still serves ungated; (d) a full browser login round-trip with the break-glass user (`minion/breakglass-user`) if scriptable — otherwise verify the redirect carries the right client_id and callback and say so in the report.

## Definition of done

Unit + Caddy config + allowlist script on `main`; oauth2-proxy running (enabled) on the box; gate live with all verifications evidenced in your report; DEPLOYMENT.md Phase 6 row (only that row) updated, new secret names added to § Secrets.
