---
role: orchestrator
model: fable
---

# Orchestrate: drive the minion.town OAuth deployment to a live, verified conclusion

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, direct push to `main`, no PR. gh is authenticated as `kriscendobot` (ADMIN).
**Mandate:** finish the minion.town OAuth build on the maintainer's behalf. **Phase 1 is DONE** (state below). Execute Phases 2–6, **maximizing concurrency by dispatching child sub-jobs back to the board** via the [orchestration](../../skills/orchestration/SKILL.md) skill: decompose → park children (`post-plan.sh --orchestrated --orchestrated-by <this-base> <child>`) → record (`post-orchestration.sh --parallel|--serial …`) → the deterministic engine drives them. Run independent children in **parallel**; serialize only true dependencies.

## Governing architecture — READ FIRST (this reframes the prior plan)

**minion.town is a deployment + configuration layer, NOT a code home.**
- The **garden** code lives in its own open repo; the **Endo MCP server** code belongs in its own Endo open repo (endojs). minion.town captures only **configuration + deployment**: Dockerfiles/systemd units, Caddy config, Cognito provisioning, Lambda thunks, the first-party authz policy, deploy/verify scripts.
- **Keep coupling LOOSE / provider-portable.** These same components will later be deployed (at least for demonstration) to **CloudFlare, Netlify, and other providers**. Structure the repo so the **AWS binding (Cognito, Lambda, Caddy-on-EC2, SSM) is a separable target** under a clear `deploy/aws/` (or similar) boundary, and the portable app runs elsewhere with only config changes. No AWS-lock in the app layer.
- The MCP server code currently sits in this repo's `src/`. Treat that as the seam to eventually **extract to the Endo repo**; do **not** block the working deployment on the extraction, but keep the code/config boundary clean and record the extraction as an explicit follow-on.
- **First child job:** commit a `DEPLOYMENT.md` to this repo capturing this architecture, the provider-portability boundary, and the phase plan/state below — a self-contained in-repo source of truth every subsequent child reads (children work in the minion.town worktree and cannot see the garden's plan/log files).

## Current state — Phase 1 DONE (do not redo)

AWS acct 292378781985, region **us-west-1**, IAM user garden-fleet (admin). AWS CLI at `~/.local/bin/aws` (install user-local if missing on your host — note `/tmp` is `noexec`, extract under `$HOME`; creds are hard-linked in `~/.aws`). Box access is **SSM only** (no SSH): `aws ssm start-session --target i-0380cd68b90020fad --region us-west-1`.

Infra (built this session):
- EC2 t4g.medium `i-0380cd68b90020fad` (Ubuntu 24.04 ARM64), Elastic IP `13.56.17.18`. **This box also runs the garden fleet — keep additions light.**
- Caddy fronts minion.town with automatic Let's Encrypt TLS; `/etc/caddy/Caddyfile` deployed via `aws ssm send-command` (base64→`tee`→`caddy validate`→`systemctl reload caddy`). Routes today: `/static/*` → S3 `minion-town-static` (public website); default `/` → placeholder.
- Route53 zone `Z05121952LNOCCNVIXFAO` (minion.town); apex+www A → EIP.

Cognito broker (Phase 1):
- User pool `us-west-1_mDaTgjr1m` (Essentials, self-signup off, deletion-protected). Issuer `https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m`.
- Resource server `mcp` → scopes `mcp/tools`, `mcp/minions:read`, `mcp/minions:write`. Hosted UI `minion-town.auth.us-west-1.amazoncognito.com` (ACTIVE).
- MCP public client (PKCE) `1uesun672b9a0lidth983v0vc9` (callbacks `http://localhost:8080/callback`, `https://minion.town/callback`).
- Web-gate confidential client `1ado9v94gl9lpufejiekpehnli` (secret in Secrets Manager `minion/web-gate-client`).
- Break-glass admin `breakglass@minion.town` (creds in Secrets Manager `minion/breakglass-user`).

**Audience correction (Cognito limitation — confirmed in AWS docs):** Cognito cannot set an arbitrary access-token `aud` (it "must match the app client ID"). So the MCP verifier must validate **`client_id` ∈ {`1uesun672b9a0lidth983v0vc9`} + `iss` + `mcp/*` scopes** instead of `aud == resourceURL`. Adjust `src/auth/verifier.ts` / `src/config.ts`. Strict RFC 8707 audience=resourceURL is not achievable on vanilla Cognito; document the deviation.

## Remaining phases (decompose; parallelize independents)

- **Phase 2 — MCP server on EC2** (depends on Phase 1 ✓; unblocks 4 & 6). Repo: fix scope separator `mcp:`→`mcp/` in `src/auth/scopes.ts`; verifier → client_id validation. Box (SSM): Node 22 + systemd `minion-mcp` at `/opt/minion-town` (`OAUTH_ISSUER`=pool issuer, `MCP_RESOURCE_URL=https://minion.town/mcp`, slash scopes, `PORT=3000` loopback, `MemoryMax=256M`); Caddy: add `/mcp*` and `/.well-known/oauth-protected-resource*` → `127.0.0.1:3000` (keep `/static`, default). Single instance only (in-memory sessions). Verify: PRM 200; no-token `/mcp` → 401+`WWW-Authenticate`; a break-glass Cognito token → `minion_status` 200.
- **Phase 3 — Google federation** (independent of 5; gated on maintainer input). Cognito Google IdP; add to both clients; map email/sub. **MAINTAINER INPUT NEEDED:** a Google OAuth 2.0 Web client (id+secret), redirect = Cognito hosted-UI `…/oauth2/idpresponse`. Secret → Secrets Manager.
- **Phase 4 — first-party authz + identity Lambda** (depends on 2). `config/policy.json` + `src/auth/policy.ts`; server computes allowed tools = intersection(policy scopes, token scopes) keyed on `iss`+`sub`. Build the **pre-token-generation V2 Lambda** to enrich the access token with human identity (email / upstream provider) for the policy (NOT for aud). Deploy policy to box. Verify: read-only identity denied `summon_minion` (`insufficient_scope`).
- **Phase 5 — GitHub OIDC thunk** (independent of 3 & 6; gated on maintainer input). Fork `github-cognito-openid-wrapper` into a portable thunk; define the reusable **5-endpoint OIDC thunk contract** (so SIWE etc. are "just another thunk"); Lambda Function URL; Route53 A `github-idp.minion.town` → EIP; Caddy subdomain proxy; Cognito generic-OIDC IdP `issuerUrl=https://github-idp.minion.town`. **MAINTAINER INPUT NEEDED:** a GitHub OAuth App (id+secret). Secret → Secrets Manager.
- **Phase 6 — web login gate** (depends on 2; independent of 5). oauth2-proxy (portable standalone binary, NOT a Caddy plugin) behind Caddy `forward_auth` on the default route, OIDC=web-gate client; `allowed-emails.txt` from policy. Verify: unauthenticated `/` → Cognito login → back; `/mcp` still Bearer-accessible.
- **Deferrable (no rework):** static RFC 8414 doc (only if a client can't fall back to OIDC discovery); DCR/CIMD `/register`; SIWE thunk; custom auth domain `auth.minion.town` (ACM cert in us-east-1).

**Concurrency shape:** Phase 2 first. Then fan out {Phase 4}, {Phase 6}, {Phase 5} in parallel; {Phase 3} anytime. Phases 3 & 5 gate on maintainer inputs — **post those asks to the maintainer early (message bus) and don't stall the rest**.

## Guardrails
- **Secrets ONLY in Secrets Manager** — never commit credentials to the repo. Keep the repo PRIVATE.
- Keep the box light (shared with the garden fleet); single MCP instance.
- Record progress in the in-repo `DEPLOYMENT.md` and a final completion report.
- **Reconcile the two parked jobs:** `synth-and-deploy-minion-town-aws` (assumed App Runner — superseded by this EC2/Caddy path) and `cognito-mcp-metadata-bridge` (folded into Phases 4/5). Close/annotate them so they don't run stale.
- Surface any maintainer-input gaps crisply via the message bus; don't stall silently.
- **Golden path at conclusion:** PKCE client → federated login → token (client_id-validated, `mcp/*` scopes) → `list_minions` 200; read-only token → `summon_minion` denied `insufficient_scope`; browser `/` → Cognito login → signed in; `/mcp` with a Bearer token still works.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  claimed_at: 2026-07-07T05:23:06Z
