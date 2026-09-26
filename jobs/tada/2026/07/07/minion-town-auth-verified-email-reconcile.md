All tasks are complete, verified live, and pushed. Here is my completion report.

---

## Completion report: minion.town verified-email enforcement + auth-config reconcile

**Repo:** `kriscendobot/minion.town` — committed and pushed directly to `main` (`45e65e6`), then deployed live to EC2 `i-0380cd68b90020fad`.

### What I did

**1. Thunk enforces verified-only (core change).** Rewrote email selection in the GitHub OIDC thunk (`deploy/aws/lambda/github-oidc-thunk`): it now asserts a **GitHub-verified** email only — primary verified, else any verified — and **refuses** (throws → `/userinfo` fails) when the account has no verified email, so a login can never carry an unverified address. `email_verified` is now always `true` by construction. I extracted the pure selector into a new dependency-free `src/email.js` (so it's unit-testable outside the AWS-SDK runtime) and added `src/openid.self-test.js` (6 cases, all pass). Redeployed via `deploy-thunk.sh`; **confirmed the enforcement code is present in the live Lambda bundle**.

**2. Maintainer identity → source of truth.** Moved `kriskowal@kriskowal.com` (federated `GitHub_60294`, Cognito sub `895979ee-…`, full admin) into `config/policy.json`, regenerated `allowed-emails.txt` via `gen-allowed-emails.sh` → now contains **both** `breakglass@minion.town` + `kriskowal@kriskowal.com`.

**3. Gate flag folded into the repo.** Added `insecure_oidc_allow_unverified_email = true` to the committed `oauth2-proxy.cfg` with a rationale comment (Cognito drops `email_verified` for federated users → verification enforced upstream at the thunk). The existing `deploy-oauth2-proxy.sh` renders the committed cfg to the box, so it now survives a redeploy.

**4. Cognito mapping cleanup.** Reconciled the committed `deploy-cognito-github-idp.sh` attribute mapping to match the live pool (`email_verified=email_verified`) with a documented note that it's a no-op Cognito ignores for federated users, plus the "`--attribute-mapping` preserves provider-details" caveat. (No Google IdP script exists in the repo — Phase 3 was applied live-only; the note in DEPLOYMENT.md covers both IdPs.)

**5. DEPLOYMENT.md** — new "Email verification — enforced at the thunk" section documenting the Cognito federated-user limitation, the verified-at-the-thunk posture, and the maintainer-email finding; Phase 5/6 rows updated.

### Maintainer-email verification finding (the lock-out safety check)
`kriskowal@kriskowal.com` is a **verified primary** GitHub email → enforcement keeps the maintainer in, so I shipped it. Basis: the existing federated Cognito user already carries that address, which the *old* thunk only ever produced by selecting GitHub's **primary** email, and GitHub requires a primary email to be verified. Break-glass (`breakglass@minion.town`, native admin, unaffected by thunk enforcement) remains the fallback. Messaged the maintainer with the finding + an optional "confirm your next login" request.

### Verified live
- No drift: box `oauth2-proxy.cfg` sha == repo sha; box allowlist == repo (both emails).
- `https://minion.town/` (no session) → **302** → `/oauth2/sign_in` (not 403/500).
- `/mcp` no token → **401** with correct `WWW-Authenticate` (gate doesn't touch the API).
- PRM `/.well-known/oauth-protected-resource/mcp` → **200**; thunk discovery → **200**.
- Both self-tests pass.

### Follow-ups (non-blocking)
- The "unverified account is refused" path is proven by the self-test + live-bundle inspection, not a live unverified login (I can't provision one). The maintainer's optional fresh-login confirmation would close the loop end-to-end.
- No committed Google IdP provisioning script exists (Phase 3 live-only); worth landing one for parity if Google federation needs to be reproducible.
