---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-07T06:07:22Z -->

# minion.town Phase 3: Google federation into Cognito (maintainer-input gated)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — bot repo, direct push to `main`, no PR. **Read `DEPLOYMENT.md` at the repo root FIRST** (AWS inventory, Cognito ids, secret names). AWS CLI `~/.local/bin/aws`, region us-west-1. **Secrets only in Secrets Manager.**

Isolated checkout (you'll likely only touch DEPLOYMENT.md):

    /home/kris/garden2/scripts/jobs/ensure-project-worktree.sh minion-town-phase3-google-idp kriscendobot/minion.town main

## The gate — maintainer input

This phase needs a **Google OAuth 2.0 Web client (client id + secret)** created by the maintainer, with authorized redirect URI `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/idpresponse`. The maintainer was asked for it when this orchestration was set up, with instructions to store it as Secrets Manager secret **`minion/google-idp-client`** (JSON `{"client_id":"...","client_secret":"..."}`, us-west-1).

1. Check `aws secretsmanager get-secret-value --secret-id minion/google-idp-client --region us-west-1` and your job inbox (`/home/kris/garden2/scripts/jobs/inbox-read.sh minion-town-phase3-google-idp`).
2. If absent: send the maintainer a crisp reminder via `/home/kris/garden2/scripts/jobs/message-user.sh minion-town-phase3-google-idp` (include the redirect URI and the create-secret command), then poll BOTH the secret and your inbox every ~5 minutes for up to ~90 minutes. If the creds arrive by inbox reply instead of the secret, write them into `minion/google-idp-client` yourself, then proceed.
3. If still absent after the window: **do not fail the orchestration.** Park the remainder as a maintainer-gated plan job — `/home/kris/garden2/scripts/jobs/post-plan.sh --go-ahead --role builder minion-town-phase3-completion <body-file>` where the body is this job's § Work below verbatim plus a note that the gate is `minion/google-idp-client` — message the maintainer that Phase 3 is parked pending the Google client, note it in DEPLOYMENT.md's Phase 3 row (`parked pending maintainer input`), and complete with that outcome in your report.

## Work (once the secret exists)

1. Create the Google identity provider on pool `us-west-1_mDaTgjr1m`: `aws cognito-idp create-identity-provider --provider-name Google --provider-type Google --provider-details client_id=...,client_secret=...,authorize_scopes="openid email profile" --attribute-mapping email=email,username=sub`.
2. Add `Google` to `SupportedIdentityProviders` of BOTH clients — PKCE `1uesun672b9a0lidth983v0vc9` and web-gate `1ado9v94gl9lpufejiekpehnli`. **`update-user-pool-client` replaces the whole client config, and Phase 5 may be concurrently adding its own IdP:** read the current client config immediately before each update, preserve every field, and after updating read it back to confirm both your IdP and any other listed IdPs survived; if the read-back shows yours missing (a concurrent write clobbered it), redo the read-modify-write.
3. Verify: `https://minion-town.auth.us-west-1.amazoncognito.com/oauth2/authorize?identity_provider=Google&client_id=1uesun672b9a0lidth983v0vc9&response_type=code&scope=openid&redirect_uri=https://minion.town/callback` redirects to `accounts.google.com`.

## Definition of done

IdP live on the pool, both clients list it, the authorize redirect verification (curl -I evidence) is in your report, and DEPLOYMENT.md's Phase 3 row (only that row) is updated on `main`. If you took the parked-remainder path, the plan job exists and the maintainer was messaged.

<!-- garden-reaped: 3 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-07T06:33:15Z
