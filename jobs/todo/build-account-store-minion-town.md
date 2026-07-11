---
role: builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-11T09:11:00Z -->

# Build: account store + auto-provisioning for minion.town (Phase A — ships dark, no live change)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws`, region us-west-1. **Secrets only in Secrets Manager.**

Implement Phase A of `designs/account-creation-open-signup.md` (§ 2, § 4, § 9). The design and a tested local toy of the grant algebra + store interface already landed (`src/auth/accounts.ts`, `test/accounts.test.ts`); this job takes them live-but-dark:

1. DynamoDB table `minion-town-accounts` (PK `iss`, SK `sub`, on-demand, deletion protection) via an idempotent `deploy/aws/scripts/deploy-accounts-table.sh`; IAM split per design § 2: the app instance role gets GetItem+PutItem only; UpdateItem/Scan stay with admin credentials.
2. DynamoDB adapter `src/auth/stores/dynamodb.ts` implementing the `AccountStore` interface (lazy `@aws-sdk/client-dynamodb` import, selected by `ACCOUNT_STORE=dynamodb` + `ACCOUNTS_TABLE`); conditional-put provision per the interface contract; a 60 s TTL resolution cache.
3. Wire `resolveEffectiveScopes` into `authorize()` in `src/server.ts` behind `ACCOUNT_AUTOPROVISION` (default **off** — byte-for-byte today's behavior; the flip belongs to Phase B). Caller identity (iss, sub, email, idp) from the verified access token; provision user principals only (the `idp` claim guard, design § 4).
4. `GET /account` endpoint on the Node app (returns email/provider/role/status/scopes; requires the internal shared-secret header, design § 4) — implemented but NOT yet routed by Caddy.
5. Admin script `deploy/aws/scripts/set-account-role.sh` (role/status via UpdateItem).
6. Tests (extend the toy's suite; adapter contract tests), typecheck, DEPLOYMENT.md: new phase row + the § 2 portability-rule amendment (lazy config-gated adapters under `src/auth/stores/`).

**No live behavior change in this job.** Verification: npm test + typecheck green; deployed service still authorizes exactly as before (flag off); table exists and the admin script round-trips a role change.

**Maintainer decision this promotion implies:** store = DynamoDB; `config/policy.json` stays as the static overlay (design § 2, open question 2).
