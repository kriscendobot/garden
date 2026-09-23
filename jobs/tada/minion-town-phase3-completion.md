Everything is live and stable. Job complete.

## Completion report: minion.town Phase 3 — Google federation into Cognito

**Gate:** satisfied — secret `minion/google-idp-client` existed (us-west-1) with valid `client_id`/`client_secret`. No maintainer inbox action needed.

**Work done (against pool `us-west-1_mDaTgjr1m`, region us-west-1):**

1. **Created Google IdP** — `create-identity-provider --provider-name Google --provider-type Google` with `authorize_scopes="openid email profile"` and `--attribute-mapping email=email,username=sub`, creds read from the secret.
2. **Added `Google` to both clients** via read-modify-write. Read each client's full config immediately before update, preserved every writable field (callbacks, OAuth flows/scopes, token validity, auth flows, etc.), appended `Google` to `SupportedIdentityProviders`, then read back to confirm survival.
   - PKCE `1uesun672b9a0lidth983v0vc9` → `COGNITO, GitHub, Google`
   - web-gate `1ado9v94gl9lpufejiekpehnli` → `COGNITO, GitHub, Google`
   - **Phase 5's `GitHub` IdP preserved** on both (concurrency guard honored). Final re-read after push re-confirmed all three providers on both clients.
3. **Verified authorize redirect** — `curl -I` on the hosted-UI authorize URL with `identity_provider=Google` returned:
   ```
   HTTP/2 302
   location: https://accounts.google.com/o/oauth2/v2/auth?client_id=752852928535-2lfr729ajanbmfv984el3q9h8qj2l9k9.apps.googleusercontent.com&redirect_uri=...%2Foauth2%2Fidpresponse&scope=openid+email+profile&response_type=code&...
   ```
4. **DEPLOYMENT.md** — flipped only the Phase 3 row from `parked pending maintainer input` to **DONE (2026-07-07)** with the wiring details. Committed and pushed to `main` (`d8a997e..50ec61b`) as `endolinbot`, direct push, no PR.

**Notes / follow-ups:**
- First update attempt failed harmlessly (a heredoc-vs-pipe stdin bug, then a wrong hardcoded aws path) — caught before any AWS write; confirmed clients unchanged, then redid cleanly via a script file. No partial writes occurred.
- Redirect-URI check: Google console must have `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse` as an authorized redirect for the OAuth client — that's on the maintainer's Google Cloud side and outside this job's scope; the Cognito-side wiring is complete and correct.
