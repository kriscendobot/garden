minion.town is now open. The dynamic account store was built enabled and the web gate opened live in one rollout, with the consequential gate-flip performed only after the store and baseline enforcement were proven working on the box.

## What I did

**Account store + guest auto-provisioning (commit `576a118`)**
- Renamed the baseline role `visitor` → `guest` everywhere (`BASELINE_ROLE=guest`, grants `mcp/tools` only). Kept `resident` (read) as a latent admin-only tier; no store role maps to write — write/admin remain mintable only via the git-audited `config/policy.json` overlay.
- New lazy DynamoDB adapter `src/auth/stores/dynamodb.ts` (GetItem + conditional PutItem `attribute_not_exists`), dynamically imported only when `ACCOUNT_STORE=dynamodb` — so `src/` stays provider-portable.
- Wired `resolveEffectiveScopes` into `src/server.ts`: effective = (static overlay ∪ dynamic account role) ∩ token. `verifier.ts` now surfaces `email`/`idp`; an unknown **verified user principal** (idp claim present) auto-provisions as `guest` at request time; machine `client_credentials` principals never provision. Added a 60 s per-process `withTtlCache` so steady-state traffic costs no reads. Added a `credits` seam to the record for future Stripe metering.
- `deploy-accounts-store.sh` (table `minion-town-accounts`, iss+sub, on-demand, deletion-protected + the IAM split: app instance role gets `GetItem`+`PutItem` only) and `set-account-role.sh` (the admin `UpdateItem`/`Scan` surface, separate creds). systemd unit set to `ACCOUNT_STORE=dynamodb`, `ACCOUNT_AUTOPROVISION=on`.
- Tests updated to the open-signup model + new coverage (guest baseline, `withTtlCache`, e2e guest-path); DEPLOYMENT.md § Open self-signup, portability-rule amendment, Phase 9 row.

**Gate flip (commit `0e7f574`)** — `oauth2-proxy.cfg`: dropped `authenticated_emails_file`, set `email_domains = ["*"]`. Preserved: upstream verified-identity enforcement, break-glass, and the ungated `/mcp` Bearer surface. Allowlist + `gen-allowed-emails.sh` kept as the one-line rollback.

## Verified live (real execution, in this order — store before the flip)
- **Adapter against real DynamoDB**: provision→`guest`, conditional-put idempotent (no overwrite), get/miss correct.
- **App e2e suite**: 41/41 pass (real app + mock AS: fresh user principal → guest → status only, list/summon denied; machine principal denied; admin full). *(2 unrelated suites — the SIWE thunk's own tests — fail only because that sub-package's deps aren't installed at repo root; I touched nothing under `deploy/thunks`.)*
- **Live guest path on the box**: minted a real Cognito user-principal token (fresh native user NOT in `policy.json`, `idp=cognito`, `mcp/*` scopes) → `POST https://minion.town/mcp`: `minion_status` OK ("0 minion(s)"), `list_minions`/`summon_minion` denied `insufficient_scope` with effective `[mcp/tools]`. The account row was auto-provisioned `role=guest` **by the box's own instance role** (GetItem+PutItem).
- **Admin overlay live**: break-glass admin token (in `policy.json`) → `summon`/`list` succeed (full scopes via the static union).
- **Gate opened**: full oauth2-proxy web login as the fresh **non-allowlisted** user (start → Cognito → callback set a session → `GET /` = HTTP 200 landing `<title>minion.town</title>` with a Log out control). Before the flip this email was not in `allowed-emails.txt` and would have been rejected.
- **No config drift**: deployed `oauth2-proxy.cfg` shows only `email_domains = ["*"]` active (allowlist line commented); unit carries the account-store env. Both services active, healthz 200.

## Cleanup / notes
- Deleted the Cognito test user and all verification-induced account rows; the accounts table is empty (0 rows). Restarted `minion-mcp` to clear the in-memory test minion (comes back healthy).
- Both parked design jobs (`build-account-store` + `open-signup-gate-flip`) are superseded by this single rollout, as instructed.

## Follow-ups (out of scope here, per maintainer)
- **Styled privilege surfaces** (design job #3, deferred): the `/account` browser endpoint, landing role panel, `error.html`, insufficient-privilege page, and `ELEVATION_CONTACT`. Because `/account` was deferred, a browser-only guest who never calls `/mcp` isn't provisioned until their first authorized MCP request (lazy by design).
- **Stripe credits/metering**: the account record has the `credits` seam ready; no Stripe built here.
- **Billing alarms**: a CloudWatch alarm on Cognito pool MAU (and DynamoDB spend) is recommended now that signup is open — not created in this job.
