Everything is complete and verified. Writing the completion report.

---

## Completion report — `minion-town-phase2-mcp-server`

**minion.town Phase 2: MCP server live on EC2 behind Caddy, Cognito-verified.** Delivered end-to-end; pushed to `kriscendobot/minion.town@main` as commit `cacb646`.

### Part A — portable app-layer fixes (`src/`, no AWS SDK imports)
- **Scope separator:** adopted Cognito's slash form (`mcp/tools`, `mcp/minions:read`, `mcp/minions:write`) as the canonical vocabulary everywhere — `scopes.ts`, `config.ts` default, `.env.example`, `Dockerfile`, `dev/client.ts`, tests, `README.md`, `designs/mcp-oauth.md` (open question #3 marked resolved), and the reference `infra/` env. Zero per-environment translation.
- **Verifier:** replaced `aud == resourceUrl` with a `client_id` allowlist (`OAUTH_ALLOWED_CLIENT_IDS`, added to `config.ts`) + `token_use === "access"` when present; kept JWKS signature, `iss`, and `exp`. Header comment documents the RFC 8707 deviation.
- **Bonus correctness bug found & fixed:** `new URL("/.well-known/…", issuer)` stripped Cognito's pool-id path (`…/us-west-1_mDaTgjr1m`), so **every** JWKS/discovery fetch hit a 400 URL — this initially broke live token verification. Added `issuerRelative()` to preserve the issuer path; fixed the JWKS default and both discovery candidates. Also added a `HOST` config so the app binds loopback behind the proxy.
- **Tests:** updated to the slash + client_id model, added `test/config.test.ts` locking the issuer-path fix. `npm test` → **10/10 pass**, `npm run typecheck` clean.

### Part B — `deploy/aws/` (new, source of truth)
- `systemd/minion-mcp.service` — dedicated `minion-mcp` system user, `/opt/minion-town`, loopback `:3000`, `MemoryMax=256M`, `Restart=on-failure`, hardened; env-driven config (issuer, resource URL, allowed client ids, quoted multi-scope value — a quoting bug that truncated the scope list was caught and fixed during live verification).
- `caddy/Caddyfile` (thin root, `import conf.d/*`) + `caddy/conf.d/minion-town.caddy` — converted the box's monolithic Caddyfile (fetched live via SSM first), preserving the `/static/*`→S3 proxy and placeholder, adding `/mcp*` and `/.well-known/oauth-protected-resource*` → `127.0.0.1:3000`.
- `scripts/` — idempotent SSM-only deploy: `deploy-caddy.sh` (base64→tee→`caddy validate`→reload) and `deploy-app.sh` (local build → **private** `minion-town-artifacts-292378781985` bucket, all public access blocked → presigned-URL SSM download → Node 22 arm64 + user + unit + restart). No instance-role change needed (presigned URLs). Plus a `README.md`.

### Live state on the box (`i-0380cd68b90020fad`)
- `minion-mcp` **enabled + active (running)**; Node v22.23.1 arm64 installed at `/usr/local`; Caddy config valid and reloaded.
- Cognito test client `52ivub038n2dnvnk134s6vkqp1` (`minion-mcp-test-cc`, `client_credentials`, `mcp/*`) created; secret stored in Secrets Manager **`minion/test-cc-client`**; its id added to the allowlist on the box.

### Part C — verifications (live, https://minion.town)
```
V1  GET /.well-known/oauth-protected-resource/mcp → HTTP 200
    {"resource":"https://minion.town/mcp","authorization_servers":
     ["https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m"],
     "scopes_supported":["mcp/tools","mcp/minions:read","mcp/minions:write"],...}

V2  POST /mcp (no token) → HTTP/2 401
    www-authenticate: Bearer error="invalid_token",
      error_description="Missing Authorization header", scope="mcp/tools",
      resource_metadata="https://minion.town/.well-known/oauth-protected-resource/mcp"

V3  client_credentials token (client_id=52ivub038n2dnvnk134s6vkqp1, token_use=access, mcp/* scopes)
    → MCP initialize OK (session c2196597-…) → minion_status: isError=false
      :: 🏙️  minion.town has 0 minion(s).
```

### DEPLOYMENT.md
Phase 2 row → **DONE (2026-07-07)**; `minion/test-cc-client` recorded in § Secrets. No secrets in the repo.

### Follow-ups (non-blocking)
- The bare `GET /.well-known/oauth-protected-resource` (no `/mcp` suffix) returns 404 — expected; the SDK serves and advertises only the resource-path-suffixed PRM, which is what clients discover via `WWW-Authenticate`.
- The reference `Dockerfile`'s `CMD ["node","dist/index.js"]` has the same `dist/src/` layout mismatch I worked around for the systemd artifact; the Docker/App Runner path is superseded per DEPLOYMENT.md, so I left it untouched.
- The test `client_credentials` client is permanently trusted in the box allowlist to keep verification repeatable; drop it from `OAUTH_ALLOWED_CLIENT_IDS` if that machine identity is no longer wanted.
