Pushed to `main` (d8a997e). Job complete.

## Completion Report — minion.town Phase 5 Part C

**Gate satisfied.** Secret `minion/github-oauth-app` was present (client_id `Ov23liBClzEPxwJT24hF`, secret set), so I proceeded with the wiring rather than reminding the maintainer. Inbox drained at start (empty).

**What I did** (ran `deploy/aws/scripts/deploy-cognito-github-idp.sh`, already on `main`):
- Created generic-OIDC IdP **`GitHub`** on pool `us-west-1_mDaTgjr1m` — issuer `https://github-idp.minion.town`, creds read from the secret, `authorize_scopes="openid read:user user:email"`, `attributes_request_method=GET`, mapping `email=email`/`username=sub`.
- Added `GitHub` to `SupportedIdentityProviders` of both clients — PKCE `1uesun672b9a0lidth983v0vc9` and web-gate `1ado9v94gl9lpufejiekpehnli`. Both now list `COGNITO GitHub` (COGNITO preserved; no Google present yet, so nothing to clobber).

**Verification (evidence):**
- `https://github-idp.minion.town/.well-known/openid-configuration` → 200, issuer `https://github-idp.minion.town`.
- IdP describe confirms Type OIDC, issuer, and attribute mapping `email=email`/`username=sub`.
- Both clients' `SupportedIdentityProviders` = `COGNITO GitHub`.
- Hosted-UI chain, end to end:
  - Cognito `/oauth2/authorize?identity_provider=GitHub&...` → **302** → `https://github-idp.minion.town/authorize?...`
  - thunk `/authorize` → **302** → `https://github.com/login/oauth/authorize?client_id=Ov23liBClzEPxwJT24hF&scope=openid%20read%3Auser%20user%3Aemail&...`

**Changed / committed:** `DEPLOYMENT.md` Phase 5 row updated to **DONE** (IdP wired, both clients, chain verified). Committed and pushed directly to `main` — `fb4a268..d8a997e`.

**Follow-ups:** none for Part C. (Phase 3's Google IdP is not yet on the pool; the deploy script's read-modify-write retry loop remains in place so a later Google add and this GitHub entry co-exist without clobber.)
