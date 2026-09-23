Job complete. Report follows.

---

## Completion report: `build-account-store-minion-town` (Phase A)

**Finding first:** When I claimed this parked job, the repo had already raced ahead. Commit `576a118` + `0e7f574` (and the DEPLOYMENT.md Phase 9 row) had **collapsed Phase A and Phase B into one live rollout** ("no dark-launch flag; there are no existing users"). So 5 of the 6 deliverables were already implemented **and live**:

1. ✅ **Table + deploy script + IAM split** — `deploy/aws/scripts/deploy-accounts-store.sh` (idempotent; app role gets GetItem+PutItem only, UpdateItem/Scan withheld).
2. ✅ **DynamoDB adapter** — `src/auth/stores/dynamodb.ts` (lazy SDK import, conditional-put provision, `ConsistentRead`) + the 60 s TTL cache in `accounts.ts`.
3. ✅ **`resolveEffectiveScopes` wired into `authorize()`** in `src/server.ts`, behind `ACCOUNT_AUTOPROVISION` (config default off; the live systemd unit sets it on).
5. ✅ **Admin script** — `deploy/aws/scripts/set-account-role.sh` (role/status via UpdateItem, guarded).
6. ✅ **Tests + typecheck + DEPLOYMENT.md** rows and the § 2 portability-rule amendment (already present under § Provider portability boundary).

**The one genuine gap — deliverable #4 (`GET /account`) — was missing.** I built it:

- **`src/auth/account-endpoint.ts`** — `makeAccountRouter`: `GET /account` returning `{ email, provider, role, status, scopes }`. Identity from `X-Auth-Request-Sub/-Email/-Provider` proxy headers (not a Bearer token → mounted outside the `/mcp` Bearer surface), gated by an internal shared-secret header `X-Account-Gate-Token` (timing-safe compare; empty = disabled for local dev), mirroring the billing router's forged-loopback defense.
- **`src/auth/accounts.ts`** — new pure `resolveAccountView`: same (static ∪ active-role) ∩ supported-scopes algebra plus role/status surfacing; statically-listed identities display as `admin`; auto-provisions when enabled.
- **`src/config.ts`** — `accountGateSharedSecret` from `ACCOUNT_GATE_SHARED_SECRET`.
- **`src/http.ts`** — mounts the router (after `express.json()`, outside Bearer auth).
- **`test/account-endpoint.test.ts`** — 11 tests: resolver (guest/admin-overlay/resident/suspended/no-provision/header-vs-record) + router over real HTTP (403 missing/wrong gate token, 401 no subject, 200 view, empty-secret bypass).
- **DEPLOYMENT.md** — added the `/account` bullet under § Open self-signup, documenting it ships dark (Caddy does not yet route it; the route + provider-header injection + secret land with Phase C).

**Ships dark, as specified:** the endpoint is built and mounted but unrouted by Caddy and needs no `ACCOUNT_GATE_SHARED_SECRET`/`minion/account-endpoint-token` yet, so there is no live behavior change.

**Verification:** `npm run typecheck` clean (exit 0); **79 app tests pass**. The only failing suites are the two `deploy/thunks/siwe` tests, which fail to load because `viem` lives in that subpackage's own `package.json` and isn't installed at the repo root — a pre-existing harness gap, untouched by this change.

**Commit** `7c541c1` pushed to `origin/main` (private repo, direct push, no PR per the repo's flow).

**Follow-ups for Phase B/C (not this job):** Caddy `/account` route inside `forward_auth`; oauth2-proxy alpha-config `injectResponseHeaders` for the provider claim; provision `minion/account-endpoint-token` in Secrets Manager and render `ACCOUNT_GATE_SHARED_SECRET` into the app env + `X-Account-Gate-Token` into the Caddy route; the Phase C landing role-panel that consumes `/account`.
