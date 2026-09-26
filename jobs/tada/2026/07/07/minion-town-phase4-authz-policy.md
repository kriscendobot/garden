Phase 4 complete. Report follows.

---

## minion.town Phase 4 — first-party authz policy + pre-token-gen identity Lambda

**Status: DONE.** All three parts built, deployed, and verified live. Pushed to `kriscendobot/minion.town` `main` as `6ec7638`.

### Part A — portable policy layer (`src/`)
- **`config/policy.json`** — identities keyed on `iss`+`sub` → granted scopes, with a `default` baseline-deny (empty). Entries: break-glass user (`sub` = pool user id `e9a9096e…`, full scopes), Phase-2 full-scope test client (`sub` = client id `52ivub…`, full), and the new Phase-4 read-only test client (`sub` = `3r6qe6…`, `mcp/tools`+`mcp/minions:read`). Client-credentials tokens carry no user, so clients are keyed by their client-id `sub` as the job required.
- **`src/auth/policy.ts`** — loads the policy (plain `fs`, no AWS SDK; path from `MCP_POLICY_PATH`/config). Computes **effective scopes = policy grant for iss+sub ∩ token scopes** — intersection only, so it can never widen a token; unknown identity → baseline deny.
- **`src/auth/verifier.ts`** now surfaces `iss`+`sub` on `AuthInfo.extra`; **`src/server.ts`** authorizes each tool against effective scopes and denies with the OAuth `insufficient_scope` shape.
- **Tests:** `test/policy.test.ts` (12 tests — intersection both directions, dedupe, iss+sub keying, baseline deny, load/validate). Full suite **22 passed**, `tsc` clean. E2E `auth.test.ts` kept green via a permissive fixture policy.

### Part B — pre-token-generation V2_0 identity Lambda (`deploy/aws/lambda/pre-token-gen/`)
- Plain Node CommonJS, **ARM64**, no framework. Enriches the **access token** with `email`, `email_verified`, and `idp` (upstream provider name, or `cognito` for native users) — identity, **not** `aud`. Reuses the superseded CDK `token-customizer.js`'s V2_0 event shape.
- Deployed idempotently via new **`deploy/aws/scripts/deploy-pre-token-gen.sh`**: created exec role `minion-pre-token-gen-role` (logs only), function `minion-pre-token-gen`, `lambda add-permission` for `cognito-idp`, then `update-user-pool` attaching `PreTokenGenerationConfig={V2_0, <arn>}` — **reading the current pool config first and preserving every setting** (verified: tier ESSENTIALS, deletion-protection ACTIVE, username/auto-verify attrs, tags, MFA, admin-create all intact).
- **Verified via test-invoke** (StatusCode 200, no FunctionError): Google-federated event → `{email, email_verified, idp:"Google"}`; native break-glass event → `{email, idp:"cognito"}`.

### Part C — deploy + live verification
- `deploy-app.sh` now ships `config/policy.json` in the artifact; systemd unit pins `MCP_POLICY_PATH=/opt/minion-town/config/policy.json` and adds the read-only client to `OAUTH_ALLOWED_CLIENT_IDS`. Redeployed via the Phase-2 script; `minion-mcp` active, `healthz: 200`.
- **Live deny/allow evidence** (real Cognito tokens → `https://minion.town/mcp`):
  - Read-only client (`3r6qe6…`): `minion_status` **OK**, `list_minions` **OK**, `summon_minion` **DENIED** — `insufficient_scope: tool "summon_minion" requires "mcp/minions:write"; effective scopes [mcp/minions:read, mcp/tools] (first-party policy ∩ token…)`.
  - Full-scope client (`52ivub…`): `summon_minion` **OK** — `✨ Summoned Kevin (minion-1)`.

### Docs / secrets
- DEPLOYMENT.md: Phase 4 row → **DONE (2026-07-07)** (my row only); added `minion/test-cc-readonly` to § Secrets. Resolved a rebase conflict in § Secrets by merging Phase 6's cookie-secret line with mine.

### Coordination / follow-ups
- Ran concurrently with Phase 6 (landed first). No overlap in code/pool-Lambda/Caddy; the only touch-point was DEPLOYMENT.md § Secrets (merged cleanly).
- Phase 6 already references `config/policy.json` for its web-gate email allowlist via `deploy/aws/scripts/gen-allowed-emails.sh` (which Phase 6 shipped). My policy provides `breakglass@minion.town`'s email; the two machine test clients have `email: null` — Phase 6's generator should skip nulls. No action needed from me, flagged for awareness.
- New AWS resources created: Cognito client `3r6qe6tsqpqir9hueh2v1uaadv`, secret `minion/test-cc-readonly`, IAM role `minion-pre-token-gen-role`, Lambda `minion-pre-token-gen`.
