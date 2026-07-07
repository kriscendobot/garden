---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-07-07T06:44:26Z
---

---
role: builder
---

# minion.town Phase 3 (completion): Google federation into Cognito

**Gate:** this remainder is parked pending maintainer input — the Google OAuth
client stored as Secrets Manager secret **`minion/google-idp-client`** (JSON
`{"client_id":"...","client_secret":"..."}`, us-west-1). Promote this job only
after that secret exists. If the maintainer delivered the creds by inbox reply
instead, write them into `minion/google-idp-client` yourself first, then proceed.

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, direct push
to `main`, no PR. **Read `DEPLOYMENT.md` at the repo root FIRST** (AWS inventory,
Cognito ids, secret names). AWS CLI `~/.local/bin/aws`, region us-west-1.
**Secrets only in Secrets Manager.**

## Work (once the secret exists)

1. Create the Google identity provider on pool `us-west-1_mDaTgjr1m`: `aws cognito-idp create-identity-provider --provider-name Google --provider-type Google --provider-details client_id=...,client_secret=...,authorize_scopes="openid email profile" --attribute-mapping email=email,username=sub`.
2. Add `Google` to `SupportedIdentityProviders` of BOTH clients — PKCE `1uesun672b9a0lidth983v0vc9` and web-gate `1ado9v94gl9lpufejiekpehnli`. **`update-user-pool-client` replaces the whole client config, and Phase 5 may be concurrently adding its own IdP:** read the current client config immediately before each update, preserve every field, and after updating read it back to confirm both your IdP and any other listed IdPs survived; if the read-back shows yours missing (a concurrent write clobbered it), redo the read-modify-write.
3. Verify: `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/authorize?identity_provider=Google&client_id=1uesun672b9a0lidth983v0vc9&response_type=code&scope=openid&redirect_uri=https://minion.town/callback` redirects to `accounts.google.com`.

## Definition of done

IdP live on the pool, both clients list it, the authorize redirect verification
(curl -I evidence) is in your report, and DEPLOYMENT.md's Phase 3 row (only that
row) is updated on `main` (flip it from `parked pending maintainer input` to
DONE).
