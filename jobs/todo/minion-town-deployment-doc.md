---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T05:34:16Z -->

# minion.town: commit DEPLOYMENT.md (architecture + phase plan source of truth) and close superseded PR #2

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, **direct push to `main`, no PR**. `gh` is authenticated as `kriscendobot` (admin).

Get your isolated checkout with:

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-deployment-doc kriscendobot/minion.town main

then `cd` to the printed path.

## Task 1 — commit `DEPLOYMENT.md` at the repo root

A full draft follows below. Before committing, **verify it against repo reality** (file paths under `src/`, `infra/`, package scripts) and correct anything the draft got wrong. Do not weaken the architecture statements; they are maintainer directives. Push directly to `main` (rebase-and-retry on a rejected push).

## Task 2 — close superseded draft PR #2

PR https://github.com/kriscendobot/minion.town/pull/2 ("cognito-mcp-metadata-bridge", CDK/App Runner era) is superseded by the EC2/Caddy deployment this DEPLOYMENT.md describes. Leave a comment saying exactly that (point at DEPLOYMENT.md; note that its pre-token-generation-Lambda idea survives in Phase 4, while its aud-stamping goal is dead — the verifier now validates `client_id` instead), then close the PR **without merging**. Keep the branch.

## Definition of done

`DEPLOYMENT.md` is on `origin/main` and PR #2 is closed with the comment. Your completion report names the commit SHA.

---

## DEPLOYMENT.md draft (verify, correct, commit)

```markdown
# minion.town deployment

**This repo is a deployment + configuration layer, NOT a code home.** The garden
lives in its own repo; the Endo MCP server code belongs in its own Endo repo
(endojs) and currently sits here under `src/` only until it is extracted (an
explicit follow-on; do not let new work deepen the coupling). What this repo
permanently owns: Dockerfiles/systemd units, Caddy config, Cognito provisioning,
Lambda thunks, the first-party authorization policy, and deploy/verify scripts.

## Provider portability boundary

These components will later be deployed (at least for demonstration) to
CloudFlare, Netlify, and other providers. Therefore:

- Everything AWS-specific (Cognito, Lambda, Caddy-on-EC2, SSM, Route53, Secrets
  Manager) lives under **`deploy/aws/`**. It is a separable *target*.
- The app layer (`src/`, `config/policy.json`) stays provider-portable: it reads
  its issuer, resource URL, allowed client ids, and policy from config/env, and
  must run on another provider with only config changes. **No AWS SDK imports in
  `src/`.**
- Future targets get sibling directories (`deploy/cloudflare/`, `deploy/netlify/`).
- The `infra/` CDK tree (App Runner + Cognito + API Gateway bridge; draft PR #2)
  is **superseded** by the EC2/Caddy target below and is retained only as
  reference. Its pre-token-generation Lambda idea carries into Phase 4.

## AWS inventory (the live target)

- Account `292378781985`, region **us-west-1**. Fleet IAM user `garden-fleet`
  (admin). AWS CLI: `~/.local/bin/aws` on garden hosts.
- EC2 `i-0380cd68b90020fad` (t4g.medium, Ubuntu 24.04 ARM64), Elastic IP
  `13.56.17.18`. Access is **SSM only** (no SSH):
  `aws ssm start-session --target i-0380cd68b90020fad --region us-west-1`.
  **The box also runs the garden fleet — keep additions light. Single MCP
  instance only (in-memory sessions).**
- Caddy fronts `minion.town` (automatic Let's Encrypt TLS). Config discipline:
  § Caddy below.
- Route53 zone `Z05121952LNOCCNVIXFAO` (minion.town); apex + www A → the EIP.
- S3 `minion-town-static` (public website) behind the `/static/*` route.

### Cognito (the authorization broker)

- User pool `us-west-1_mDaTgjr1m` (Essentials tier, self-signup off,
  deletion-protected). Issuer
  `https://cognito-idp.us-west-1.amazonaws.com/us-west-1_mDaTgjr1m`.
- Resource server `mcp` → scopes `mcp/tools`, `mcp/minions:read`,
  `mcp/minions:write`. **Note the `/` separator** — Cognito writes custom scopes
  as `<resource-server-id>/<scope>`.
- Hosted UI domain `minion-town.auth.us-west-1.amazoncognito.com` (ACTIVE).
- MCP public client (PKCE) `1uesun672b9a0lidth983v0vc9`
  (callbacks `http://localhost:8080/callback`, `https://minion.town/callback`).
- Web-gate confidential client `1ado9v94gl9lpufejiekpehnli`
  (secret in Secrets Manager `minion/web-gate-client`).
- Break-glass admin `breakglass@minion.town`
  (creds in Secrets Manager `minion/breakglass-user`).

### The audience deviation (deliberate, documented)

Cognito cannot set an arbitrary access-token `aud` — it must match the app
client id. **Strict RFC 8707 audience=resourceURL is not achievable on vanilla
Cognito.** The MCP verifier therefore validates, instead of `aud == resourceURL`:

1. `iss` == the pool issuer,
2. `client_id` claim ∈ the configured allowlist (env
   `OAUTH_ALLOWED_CLIENT_IDS`), and
3. the `mcp/*` scopes required per tool.

A future provider that supports RFC 8707 (or a token-issuing proxy) can restore
strict audience binding by config.

### Secrets

**Secrets live ONLY in AWS Secrets Manager (us-west-1) — never in this repo.**
Names: `minion/web-gate-client`, `minion/breakglass-user`,
`minion/google-idp-client` (Phase 3 input), `minion/github-oauth-app` (Phase 5
input), plus any test-client or cookie secrets phases add (record them here).

## Caddy config discipline

`deploy/aws/caddy/` in this repo is the **source of truth** for
`/etc/caddy/Caddyfile` and `/etc/caddy/conf.d/*.caddy` on the box. The root
Caddyfile only imports `conf.d/*.caddy`. Each concern owns its own file so
concurrent phases never clobber each other:

- `conf.d/minion-town.caddy` — the minion.town site (static, /mcp,
  /.well-known, default route). Owned serially: Phase 2 creates it; Phase 6
  edits it (forward_auth).
- `conf.d/github-idp.caddy` — the github-idp.minion.town site (Phase 5).

Deploy recipe (no SSH; idempotent): base64 the file → `aws ssm send-command`
→ `tee` into place → `caddy validate --config /etc/caddy/Caddyfile` →
`systemctl reload caddy`. **Always start from the current committed repo copy
(pull `main` immediately before editing), never from a stale checkout.**

## Phase plan and state

| Phase | What | State |
| --- | --- | --- |
| 1 | Cognito broker, EC2 + Caddy + TLS, DNS, static site | **DONE** (2026-07-06) |
| 2 | MCP server on the box: `mcp/` scope fix, client_id verifier, systemd `minion-mcp`, Caddy `/mcp` + PRM routes | pending — job `minion-town-phase2-mcp-server` |
| 3 | Google federation (Cognito Google IdP; needs maintainer's Google OAuth client) | pending — job `minion-town-phase3-google-idp` |
| 4 | First-party authz policy (`config/policy.json`, iss+sub keyed) + pre-token-generation V2 identity Lambda | pending — job `minion-town-phase4-authz-policy` |
| 5 | GitHub OIDC thunk (portable 5-endpoint OIDC wrapper, Lambda Function URL, `github-idp.minion.town`, Cognito OIDC IdP; needs maintainer's GitHub OAuth App) | pending — job `minion-town-phase5-github-oidc-thunk` |
| 6 | Web login gate (oauth2-proxy standalone behind Caddy `forward_auth` on the default route) | pending — job `minion-town-phase6-web-gate` |

Each phase's job updates its own row (and only its row) on completion.

Orchestration: serial stage `minion-town-oauth-stage1` (this doc → Phase 2 →
fan-out) then parallel stage `minion-town-oauth-stage2` (Phases 3/4/5/6) on the
garden job board.

Deferred (deliberately, no rework implied): static RFC 8414 AS-metadata doc
(only if a client cannot fall back to OIDC discovery); DCR/CIMD `/register`;
SIWE thunk (the Phase 5 thunk contract is written so SIWE is "just another
thunk"); custom auth domain `auth.minion.town` (needs ACM cert in us-east-1).

## Verification golden path

1. PKCE client → federated login → token (client_id-validated, `mcp/*` scopes)
   → `list_minions` 200.
2. A read-only token → `summon_minion` denied with `insufficient_scope`.
3. Browser `/` → Cognito login → signed in.
4. `/mcp` with a Bearer token still works (the gate never blocks the API).
5. `https://minion.town/.well-known/oauth-protected-resource` → 200; no-token
   `/mcp` → 401 + `WWW-Authenticate` pointing at the PRM.
```
