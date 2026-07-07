---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T06:07:40Z -->

# minion.town Phase 5: GitHub OIDC thunk (portable wrapper + Lambda + Cognito OIDC IdP; maintainer-input gated)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, **direct push to `main`, no PR**. `gh` is authenticated as `kriscendobot` (admin). **Read `DEPLOYMENT.md` at the repo root FIRST** (architecture, provider-portability boundary, AWS inventory, Caddy discipline). AWS CLI `~/.local/bin/aws`, region us-west-1; box `i-0380cd68b90020fad` is **SSM only**. **Secrets only in Secrets Manager.**

Isolated checkout:

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-phase5-github-oidc-thunk kriscendobot/minion.town main

GitHub is OAuth2-but-not-OIDC, so Cognito needs a shim: an OIDC provider facade in front of GitHub. Fork/vendor `github-cognito-openid-wrapper` (TimothyJones) as the basis.

## Part A — the reusable thunk contract (NOT gated; do this regardless)

Define the **5-endpoint OIDC thunk contract** so a future SIWE (or any other) identity source is "just another thunk": `/.well-known/openid-configuration`, `/.well-known/jwks.json`, `/authorize`, `/token`, `/userinfo`. Write it as `deploy/thunks/CONTRACT.md` (provider-portable: the contract says nothing about Lambda), with the GitHub thunk as the first implementation under `deploy/aws/lambda/github-oidc-thunk/` (vendored + adapted wrapper source, ARM64 Node Lambda, config from env; the GitHub client secret read from Secrets Manager `minion/github-oauth-app` at runtime or injected as a Lambda env var from the secret at deploy time — never committed).

## Part B — plumbing (NOT gated)

1. Lambda + **Function URL** for the thunk (execution role: logs + `secretsmanager:GetSecretValue` on `minion/github-oauth-app` only).
2. Route53 (zone `Z05121952LNOCCNVIXFAO`): A record `github-idp.minion.town` → `13.56.17.18`.
3. Caddy: NEW file `deploy/aws/caddy/conf.d/github-idp.caddy` — a `github-idp.minion.town` site block reverse_proxying to the Lambda Function URL (set the upstream Host header to the Function URL host). Deploy per DEPLOYMENT.md § Caddy discipline (pull `main` first; you own ONLY this file — Phase 6 concurrently edits `minion-town.caddy`; never write that file).

## The gate — maintainer input

The thunk needs a **GitHub OAuth App (client id + secret)** created by the maintainer. Its authorization callback URL is, per the wrapper's README (verify there): `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`. Expected as Secrets Manager secret **`minion/github-oauth-app`** (JSON `{"client_id":"...","client_secret":"..."}`, us-west-1); the maintainer was asked when this orchestration was set up.

- Check the secret and your inbox (`/home/kris/garden2/scripts/jobs/inbox-read.sh minion-town-phase5-github-oidc-thunk`). If absent, do Parts A+B first, then remind the maintainer via `/home/kris/garden2/scripts/jobs/message-user.sh minion-town-phase5-github-oidc-thunk` (include the callback URL and create-secret command) and poll secret+inbox every ~5 minutes up to ~90 minutes (write inbox-delivered creds into the secret yourself). If still absent: park the remainder as `/home/kris/garden2/scripts/jobs/post-plan.sh --go-ahead --role builder minion-town-phase5-completion <body-file>` (body = § Part C below verbatim + the gate note), message the maintainer, mark the DEPLOYMENT.md Phase 5 row `thunk deployed; Cognito IdP parked pending GitHub OAuth App`, and complete with that outcome. **Do not fail the orchestration over the missing input.**

## Part C — Cognito wiring + verify (gated on the secret)

1. Configure the thunk with the GitHub client id/secret; verify `https://github-idp.minion.town/.well-known/openid-configuration` → 200 with the right issuer.
2. Cognito generic-OIDC IdP on pool `us-west-1_mDaTgjr1m`: `create-identity-provider --provider-name GitHub --provider-type OIDC --provider-details` with `oidc_issuer=https://github-idp.minion.town`, client id/secret = the GitHub OAuth App's, `authorize_scopes="openid read:user user:email"`, `attributes_request_method=GET`; map `email=email`, `username=sub`.
3. Add `GitHub` to `SupportedIdentityProviders` of BOTH clients (PKCE `1uesun672b9a0lidth983v0vc9`, web-gate `1ado9v94gl9lpufejiekpehnli`). **`update-user-pool-client` replaces the whole config and Phase 3 may be concurrently adding Google:** read current config immediately before each update, preserve every field, read back after to confirm all IdPs survived, redo on clobber.
4. Verify: hosted-UI `/oauth2/authorize?identity_provider=GitHub&client_id=1uesun672b9a0lidth983v0vc9&response_type=code&scope=openid&redirect_uri=https://minion.town/callback` chains a redirect toward `github.com/login`.

## Definition of done

Contract doc + thunk source + Caddy file on `main`; Lambda + DNS + Caddy live (discovery endpoint 200); Cognito IdP wired and verified (or the remainder parked per the gate procedure); DEPLOYMENT.md Phase 5 row (only that row) updated; evidence in your report.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 14
  claimed_at: 2026-07-07T06:07:46Z
