All verified and consistent. The job is complete.

## Completion report — minion.town Phase 6: web login gate

**What I did:** Stood up oauth2-proxy (standalone ARM64 binary v7.15.3, not a Caddy plugin) as an OIDC client against the Cognito pool, gating **only** the default route via Caddy `forward_auth`. Deployed live to the box (SSM-only) and verified end-to-end.

**Landed on `main` (commit `08a04f4`, direct push, no PR):**
- `deploy/aws/systemd/oauth2-proxy.service` — loopback `:4180`, `MemoryMax=128M`, hardened, `EnvironmentFile` for deploy-rendered secrets.
- `deploy/aws/oauth2-proxy/oauth2-proxy.cfg` — OIDC provider (issuer `us-west-1_mDaTgjr1m`, client `1ado9v94gl9lpufejiekpehnli`, redirect `https://minion.town/oauth2/callback`), `reverse_proxy=true`, `skip_provider_button=true`, `authenticated_emails_file` allowlist.
- `deploy/aws/oauth2-proxy/allowed-emails.txt` — seeded with `breakglass@minion.town`.
- `deploy/aws/scripts/gen-allowed-emails.sh` — re-runnable; regenerates the allowlist from `config/policy.json` (Phase 4) when it lands, seeds break-glass until then.
- `deploy/aws/scripts/deploy-oauth2-proxy.sh` — resolves the release, generates+stores the cookie secret, fetches client+cookie secrets from Secrets Manager and delivers them via **presigned S3** (secrets never in SSM command text / CloudTrail; the box role has SSM-core only), installs binary+user+unit+config, enables & starts the service.
- `deploy/aws/caddy/conf.d/minion-town.caddy` — added `/oauth2/*` → `:4180` and wrapped **only** the default route in `forward_auth /oauth2/auth` (401 → redirect to sign-in carrying `rd`). `/mcp*`, `/.well-known/*`, `/static/*` stay outside the gate.
- `DEPLOYMENT.md` — Phase 6 row → DONE (only that row); added `minion/web-gate-cookie-secret` to § Secrets.

**Cognito:** the web-gate client already carried callback `https://minion.town/oauth2/callback` (verified intact both before and immediately before deploy — no clobber by concurrent phases); no rewrite needed. New secret `minion/web-gate-cookie-secret` created (32-byte base64url).

**Live on the box:** `oauth2-proxy.service` **active + enabled**, 6.8M RSS. Caddy config validated (`Valid configuration`) and reloaded.

**Verifications (all evidenced, from the public internet):**
- **(a)** `GET https://minion.town/` → `302 /oauth2/sign_in?rd=/` → `302` into the Cognito hosted UI (`.../login?client_id=1ado9v94gl9lpufejiekpehnli&redirect_uri=…%2Foauth2%2Fcallback&scope=openid+email+profile&response_type=code`) → 200. Correct client_id and callback confirmed.
- **(b)** `/mcp` unchanged: no token → `401` + `WWW-Authenticate: Bearer … resource_metadata=…/.well-known/oauth-protected-resource/mcp`; with a `client_credentials` Bearer from `minion/test-cc-client` → `initialize` **200** and `tools/list` **200** (`minion_status`, `list_minions`, `summon_minion`). The gate never touches the API.
- **(c)** `/static/` → **200** ungated; `/.well-known/oauth-protected-resource/mcp` → **200**.
- **(d)** Full browser login round-trip with break-glass user (`minion/breakglass-user`) scripted through the gate: `/oauth2/start` → Cognito login → callback (session cookie set) → authenticated `GET /` → **200**; no-cookie control → **302**. Confirms the allowlist admits the break-glass email end-to-end.

**Follow-ups:** When Phase 4 lands `config/policy.json`, run `deploy/aws/scripts/gen-allowed-emails.sh`, commit the regenerated `allowed-emails.txt`, and re-run `deploy-oauth2-proxy.sh` to push the widened allowlist. No rework otherwise; inbox was empty.
