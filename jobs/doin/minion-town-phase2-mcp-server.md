---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T05:40:03Z -->

# minion.town Phase 2: MCP server live on EC2 behind Caddy, Cognito-verified

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, **direct push to `main`, no PR**. `gh` is authenticated as `kriscendobot` (admin). **Read `DEPLOYMENT.md` at the repo root FIRST** — it is the source of truth for the architecture, the AWS inventory (account/region/instance/Cognito ids, secret names), the audience deviation, and the Caddy config discipline this job must follow.

Isolated checkout:

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-phase2-mcp-server kriscendobot/minion.town main

AWS CLI: `~/.local/bin/aws` (if missing on this host, install user-local under `$HOME` — `/tmp` is noexec; creds are hard-linked in `~/.aws`). Box access is **SSM only**: `aws ssm send-command` / `aws ssm start-session --target i-0380cd68b90020fad --region us-west-1`. The box also runs the garden fleet — **keep additions light; single MCP instance only** (in-memory sessions).

## Part A — code fixes (portable app layer, `src/`)

1. **Scope separator:** `src/auth/scopes.ts` uses `mcp:tools` / `mcp:minions:read` / `mcp:minions:write`. Cognito issues resource-server scopes with a **slash**: `mcp/tools`, `mcp/minions:read`, `mcp/minions:write`. Fix the constants (and every test/env-example/reference that carries the `mcp:` form, e.g. `MCP_SCOPES_SUPPORTED` in `.env.example`/Dockerfile if present).
2. **Verifier:** `src/auth/verifier.ts` currently enforces `aud == config.resourceUrl` via `jwtVerify`. Cognito cannot put the resource URL in `aud` (it must match the app client id), so replace audience validation with: verify `iss` (keep), then require the token's `client_id` claim ∈ a configured allowlist. Add the allowlist to `src/config.ts` (env `OAUTH_ALLOWED_CLIENT_IDS`, comma-separated). Also require `token_use === "access"` when the claim is present (Cognito stamps it). Keep JWKS signature + `exp` checks. Update the file's header comment to document the RFC 8707 deviation (DEPLOYMENT.md § audience deviation is the canonical text).
3. Update unit tests to match (`npm test` must pass) and keep the app layer free of AWS SDK imports.

## Part B — deployment target (`deploy/aws/`, new)

Create in the repo (source of truth, per DEPLOYMENT.md):

- `deploy/aws/systemd/minion-mcp.service` — runs the built server at `/opt/minion-town` as a dedicated system user, `Environment=`: `OAUTH_ISSUER=https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m`, `MCP_RESOURCE_URL=https://minion.town/mcp`, `OAUTH_ALLOWED_CLIENT_IDS=1uesun672b9a0lidth983v0vc9`, slash scopes, `PORT=3000` **bound to loopback**, `MemoryMax=256M`, `Restart=on-failure`.
- `deploy/aws/caddy/Caddyfile` + `deploy/aws/caddy/conf.d/minion-town.caddy` — convert the box's current monolithic `/etc/caddy/Caddyfile` to a root file that only `import`s `conf.d/*.caddy`; move the existing minion.town site (the `/static/*` → S3 `minion-town-static` proxy and the default placeholder) into `conf.d/minion-town.caddy`, and add routes `/mcp*` and `/.well-known/oauth-protected-resource*` → `reverse_proxy 127.0.0.1:3000`. Fetch the CURRENT live Caddyfile via SSM before converting — do not reconstruct it from memory.
- `deploy/aws/scripts/` — idempotent deploy scripts: one for Caddy config (base64 → SSM `tee` → `caddy validate` → `systemctl reload caddy`), one for the app (build locally or on the box; recommended: tarball → a **private** artifacts S3 bucket (create e.g. `minion-town-artifacts-292378781985`, block public access) → SSM command downloads + unpacks to `/opt/minion-town` + `systemctl restart minion-mcp`; `garden-fleet` is admin, so you may attach S3 read to the instance role if it lacks it). Node 22 ARM64 on the box (NodeSource or tarball; keep it light).

## Part C — verification (all live, against https://minion.town)

1. `GET /.well-known/oauth-protected-resource` → 200 JSON naming the Cognito AS.
2. `GET/POST /mcp` with no token → **401** + `WWW-Authenticate` header pointing at the PRM.
3. A real token exercising a tool: Cognito grants custom scopes only through its OAuth endpoints, so create a dedicated **test confidential client** on pool `us-west-1_mDaTgjr1m` with `client_credentials` grant and all three `mcp/*` scopes; store its secret as Secrets Manager `minion/test-cc-client` (us-west-1) and record the name in DEPLOYMENT.md § Secrets. Then: token from `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/token` (grant_type=client_credentials) → add its client id to `OAUTH_ALLOWED_CLIENT_IDS` on the box → MCP `initialize` + `minion_status` call → **200**. (The break-glass user in `minion/breakglass-user` exists, but password-auth tokens do not carry `mcp/*` scopes; the test client is the scriptable path.)

## Definition of done

Code fixes + `deploy/aws/` pushed to `main`; `minion-mcp` running (enabled) on the box; Caddy routing live; all three verifications pass and their evidence (curl output) is in your completion report. Update your row in DEPLOYMENT.md § Phase plan (only your row) to DONE with the date, and add any new secret names to § Secrets. **Secrets only in Secrets Manager — never in the repo.**

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  claimed_at: 2026-07-07T05:40:07Z
