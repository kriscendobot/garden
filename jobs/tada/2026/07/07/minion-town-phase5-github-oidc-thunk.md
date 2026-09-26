All done. The gate remains unmet, so per the job's explicit gate procedure I've deployed Parts A+B, parked Part C, updated the DEPLOYMENT.md row, and reminded the maintainer — completing cleanly without failing the orchestration.

---

## Completion report — minion.town Phase 5: GitHub OIDC thunk

**Outcome:** Parts A + B fully built, deployed, and verified live. Part C (Cognito wiring) is **parked pending the maintainer's GitHub OAuth App** — the gated secret `minion/github-oauth-app` never appeared. Nothing failed; the orchestration can proceed.

### Part A — the reusable thunk contract (done)
- `deploy/thunks/CONTRACT.md`: provider-portable 5-endpoint OIDC thunk contract (`/.well-known/openid-configuration`, `/.well-known/jwks.json`, `/authorize`, `/token`, `/userinfo`) with invariants (configured-issuer, kid-consistency, stable `sub`, secrets-never-in-source, stateless). Says nothing about Lambda — SIWE is "just another thunk."
- `deploy/aws/lambda/github-oidc-thunk/`: first implementation — a **zero-dependency** ARM64 Node Lambda adapted from `TimothyJones/github-cognito-openid-wrapper` (BSD 3-Clause `LICENSE` preserved). `axios`→global `fetch`; `jsonwebtoken`+`json-web-key`→`node:crypto` (RS256 sign + JWK export). GitHub client secret read from Secrets Manager at runtime; id_token signing key from `minion/github-idp-signing-key`, injected as an env var — never committed. Smoke-tested all five endpoints locally, incl. id_token verifying against the JWKS with matching `kid`.

### Part B — plumbing (done, live)
- **Lambda** `minion-github-idp-thunk` deployed via new `deploy/aws/scripts/deploy-thunk.sh`; execution role scoped to logs + `GetSecretValue` on `minion/github-oauth-app` only.
- **Ingress deviation (documented):** the job specified a Lambda **Function URL**, but this AWS account **blocks public (AuthType NONE) Function URLs** — proven with a throwaway probe (public Function URL → 403; AWS_IAM+SigV4 to the same URL → 200; account is not in an Org). Pivoted to an **API Gateway HTTP API** (`$default`→Lambda proxy), which uses the identical payload-format-2.0 event, so the handler is unchanged and Caddy fronts it identically.
- **Route53:** A record `github-idp.minion.town → 13.56.17.18` (zone `Z05121952LNOCCNVIXFAO`).
- **Caddy:** new `deploy/aws/caddy/conf.d/github-idp.caddy` (owns only this file; Phase 6's `minion-town.caddy` left untouched — rebased onto latest `main` before deploying so its forward_auth was preserved). Deployed via SSM; `caddy validate` passed.
- **Verified live over HTTPS:** `https://github-idp.minion.town/.well-known/openid-configuration` → **200** (issuer `https://github-idp.minion.town`), `/.well-known/jwks.json` → 200, `/authorize` → 302 to `github.com/login/oauth/authorize`.

### Part C — parked (gate unmet)
- Secret `minion/github-oauth-app` absent throughout; inbox empty. Reminded the maintainer twice (callback URL `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse` + exact `create-secret` command). A 90-min poller ran until the session was reaped; rather than risk another reap cycle I parked per the gate procedure.
- **Wrote the reproducible Part C recipe on `main`:** `deploy/aws/scripts/deploy-cognito-github-idp.sh` — creates the generic-OIDC IdP `GitHub` on pool `us-west-1_mDaTgjr1m` and adds `GitHub` to both clients' `SupportedIdentityProviders` via a read→union→write→read-back-verify retry loop that re-converges rather than clobbering Phase 3's concurrent Google addition (validated the describe→strip→build-input transform against both live clients, read-only).
- **Parked** `minion-town-phase5-completion` (`--go-ahead --role builder`) with Part C verbatim + gate note + pointer to the ready-made script. The maintainer promotes it after creating the OAuth App; the thunk reads creds at runtime so **no thunk redeploy is needed**.
- **DEPLOYMENT.md Phase 5 row** updated (only that row): "thunk deployed (discovery 200); Cognito IdP parked pending GitHub OAuth App," secrets list updated with `minion/github-idp-signing-key`.

### Commits on `kriscendobot/minion.town@main`
- `868eb2a` Part A+B (contract, thunk, deploy-thunk.sh, github-idp.caddy, DEPLOYMENT.md)
- `284b0c2` Part C script (deploy-cognito-github-idp.sh)

### Follow-ups
1. **Maintainer:** create the GitHub OAuth App, set `minion/github-oauth-app`, promote `minion-town-phase5-completion`.
2. **Optional:** if a Function URL (vs API Gateway) is wanted, the account-level public-Function-URL block must be lifted; the Lambda handler already supports either ingress unchanged.
