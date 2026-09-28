---
title: Auth flows, OAuth2 endpoints, and introspection
source_kind: web
source_url: https://fakecloud.dev/docs/services/cognito/
source_content_sha256: b9f2586b6d0472e4ec77c89a61d40a88fd7f3f11bc467a7a5dc6c9f923081d83
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, oauth-credentials]
status: current
---

fakecloud's Cognito User Pools runs real auth flows (SRP6a, USER_AUTH, custom, refresh), issues real RS256 JWTs with PreTokenGeneration claim overrides merged before signing, serves `/oauth2/authorize|token|userInfo|revoke` plus JWKS and OIDC discovery per pool, invokes all 12 Lambda triggers, and exposes confirmation codes, tokens, and trigger invocations to tests.

"fakecloud implements 126 of 126 Cognito User Pools operations at 100% Smithy conformance." Selected features:

- **Authentication flows** — USER_PASSWORD_AUTH, USER_SRP_AUTH ("real SRP6a, works with Amplify / amazon-cognito-identity-js"), USER_AUTH (choice-based), REFRESH_TOKEN_AUTH, CUSTOM_AUTH, ADMIN_USER_PASSWORD_AUTH; `NEW_PASSWORD_REQUIRED` enforced for admin-created users.
- **Tokens** — "access, refresh, ID tokens with real JWT structure. The `PreTokenGeneration` trigger's `claimsOverrideDetails` ... is merged into the issued access and ID tokens before signing."
- **Signing keys** — `GetSigningCertificate` returns a real X.509 certificate wrapping the pool's RSA-2048 key, the same key served via JWKS.
- Identity providers (SAML, OIDC, social), resource servers with custom scopes, domains, MFA (SMS, TOTP), WebAuthn with real `packed` attestation parsing, compromised-credential blocking, multi-region replicas as records only.

**OAuth2 / OIDC endpoints:**

- `GET /oauth2/authorize` — `response_type=code` (PKCE `S256`/`plain`) and `token`; validates `client_id`, `redirect_uri` against `CallbackURLs`, and `scope` against `AllowedOAuthScopes`; accepts `username`/`password` query params in lieu of the Hosted UI form.
- `POST /oauth2/token` — `authorization_code`, `client_credentials`, `refresh_token`; Basic client auth; PKCE verified.
- `GET|POST /oauth2/userInfo`, `POST /oauth2/revoke`.
- `GET /<pool_id>/.well-known/jwks.json`, `GET /<pool_id>/.well-known/openid-configuration`.

**Introspection:** `/_fakecloud/cognito/confirmation-codes` (all, or per `{pool_id}/{username}`), `confirm-user`, `tokens`, `expire-tokens`, `auth-events`, `authorization-codes` (mint a code without driving `/authorize`), `compromised-passwords`, `webauthn-credentials`, `pretokengen/invocations` (request/response payloads with parsed `claims_added`, `claims_overridden`, `group_overrides`).

**Cross-service:** all 12 Lambda triggers; verification email through SES, SMS through SNS; CustomEmailSender / CustomSMSSender take precedence when configured. The page does not describe federating a sign-in out to an external OIDC IdP at runtime.

Source: [fakecloud docs/services/cognito](https://fakecloud.dev/docs/services/cognito/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
