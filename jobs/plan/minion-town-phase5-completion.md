---
gate: go-ahead
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-07T06:45:23Z
---

---
role: builder
---

# minion.town Phase 5 completion: wire GitHub OIDC thunk into Cognito (Part C)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR.
AWS CLI `~/.local/bin/aws` (install with `bash scripts/aws/install-aws-cli.sh` from
the garden repo if absent; credentials are hard-linked into `$HOME/.aws`), region
us-west-1. Isolated checkout:

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-phase5-completion kriscendobot/minion.town main

## State carried in from Phase 5 (Parts A + B are DONE and LIVE)

- Contract `deploy/thunks/CONTRACT.md`; thunk source `deploy/aws/lambda/github-oidc-thunk/`
  (zero-dep ARM64 Node Lambda `minion-github-idp-thunk`) — all on `main`.
- Ingress: **API Gateway HTTP API `minion-github-idp-thunk`** in front of the Lambda
  (this account BLOCKS public Lambda Function URLs — a throwaway public Function URL
  403s while AWS_IAM+SigV4 succeeds; the HTTP API uses the identical payload format
  2.0 event, handler unchanged). Caddy `deploy/aws/caddy/conf.d/github-idp.caddy`
  fronts it. Route53 A `github-idp.minion.town → 13.56.17.18` is set.
- Verified live: `https://github-idp.minion.town/.well-known/openid-configuration`
  → 200 (issuer `https://github-idp.minion.town`), `/.well-known/jwks.json` → 200,
  `/authorize` → 302 to github.com.
- The GitHub client secret is read at RUNTIME from Secrets Manager
  `minion/github-oauth-app`; the id_token signing key is in
  `minion/github-idp-signing-key` (created) and injected as a Lambda env var.

## The gate (why this job is parked)

Part C needs the maintainer's **GitHub OAuth App** (client id + secret). Create the
OAuth App at github.com/settings/developers → New OAuth App:
  - Homepage URL:           `https://minion.town`
  - Authorization callback: `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`
Then store the credentials:

    aws secretsmanager create-secret --name minion/github-oauth-app --region us-west-1 \
      --secret-string '{"client_id":"YOUR_CLIENT_ID","client_secret":"YOUR_CLIENT_SECRET"}'

**First action of this job:** check the secret exists
(`aws secretsmanager get-secret-value --secret-id minion/github-oauth-app --region us-west-1`)
and drain the inbox (`/home/kris/garden2/scripts/jobs/inbox-read.sh minion-town-phase5-completion`).
If the secret is STILL absent, remind the maintainer
(`/home/kris/garden2/scripts/jobs/message-user.sh minion-town-phase5-completion`) with the
callback URL + create-secret command above, and complete without failing (this job
stays promotable / can be re-run). Do NOT fail. If a reply carries the creds, write
them into the secret yourself.

## Part C — Cognito wiring + verify (run once the secret exists)

A reproducible, idempotent script is already on `main`:
**`deploy/aws/scripts/deploy-cognito-github-idp.sh`** — it does steps 2 and 3 below
(read-modify-write with a read-back-verify retry loop that re-converges rather than
clobbering a concurrent Phase 3 Google addition). Just run it:

    bash deploy/aws/scripts/deploy-cognito-github-idp.sh

Then verify (step 4). The literal steps, for reference:

1. Confirm `https://github-idp.minion.town/.well-known/openid-configuration` → 200
   with issuer `https://github-idp.minion.town` (already true; the thunk reads the
   GitHub creds from the secret at runtime — no thunk redeploy needed).
2. Cognito generic-OIDC IdP on pool `us-west-1_mDaTgjr1m`:
   `create-identity-provider --provider-name GitHub --provider-type OIDC
   --provider-details` with `oidc_issuer=https://github-idp.minion.town`, client
   id/secret = the GitHub OAuth App's, `authorize_scopes="openid read:user user:email"`,
   `attributes_request_method=GET`; map `email=email`, `username=sub`.
3. Add `GitHub` to `SupportedIdentityProviders` of BOTH clients (PKCE
   `1uesun672b9a0lidth983v0vc9`, web-gate `1ado9v94gl9lpufejiekpehnli`).
   `update-user-pool-client` REPLACES the whole config and Phase 3 may be
   concurrently adding Google: read current config immediately before each update,
   preserve every field, read back after to confirm all IdPs survived, redo on
   clobber. (The script does exactly this.)
4. Verify: hosted-UI
   `/oauth2/authorize?identity_provider=GitHub&client_id=1uesun672b9a0lidth983v0vc9&response_type=code&scope=openid&redirect_uri=https://minion.town/callback`
   chains a redirect toward `github.com/login`.

## Definition of done

Cognito `GitHub` OIDC IdP created on the pool; both clients list `GitHub` in
SupportedIdentityProviders (all other IdPs preserved); hosted-UI verification
chains toward github.com; DEPLOYMENT.md Phase 5 row updated to reflect the IdP is
wired (only that row). Evidence in the report.
