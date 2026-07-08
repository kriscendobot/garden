# Completion report: design-account-creation-open-signup-minion-town

**What I did.** Designed and specced the open self-signup account-creation loop and the dynamic authorization store for minion.town, per the mandate. Spec only — no live gate change was made.

**What changed** (one commit, `593c99a`, pushed direct to `kriscendobot/minion.town` `main`):

- **`designs/account-creation-open-signup.md`** — the design doc covering all six mandated items: (1) DynamoDB store `minion-town-accounts` keyed `iss`+`sub`, with access patterns, an IAM read+provision/admin split, a narrow portable `AccountStore` reader interface, and the recommendation to **keep `config/policy.json` as a static overlay** (union of grants, intersection with the token unchanged) rather than seeding admins into the store — chosen for admin bootstrap/lockout resistance and git-audited admin grants; (2) **baseline role `visitor` = `mcp/tools` only** (town status count), justified tool-by-tool against `src/auth/scopes.ts` — the store's role ladder deliberately tops out at `resident` (read), so no store compromise can ever mint write or admin authority; (3) the account-creation loop placed in the **app policy layer at request time** (trade-off table vs the pre-token-gen Lambda and the thunks; conditional-put idempotency settles the first-request race; user-principals-only guard via the `idp` claim); (4) the exact oauth2-proxy change (drop `authenticated_emails_file`, add `email_domains = ["*"]`) with preserved properties (thunk-enforced verified identity, break-glass, ungated `/mcp`), a rollback artifact, and the security implications stated plainly; (5) styled role-aware surfaces (landing role panel from a new `/account` endpoint, `error.html`, an app-served insufficient-privilege page — one shared aesthetic); (6) the SIWE/Tier-2 composition (open signup dissolves the SIWE email-allowlist wrinkle; on-chain rules union in as a third grant source). Plus a threat model (open-signup abuse with the IdP as rate limiter, Cognito MAU and DynamoDB cost levers with alarms, admin lockout resistance, the multi-tenant-box header-forgery requirement).
- **`src/auth/accounts.ts` + `test/accounts.test.ts`** — the optional runnable toy, mirroring the mcp-oauth toy pattern: the `AccountStore` interface with the atomic provision-if-absent contract, the role→scopes map, and `resolveEffectiveScopes` implementing `(static ∪ dynamic) ∩ token`. Deliberately **not wired** into the serving path.

**Verification (real-execution evidence).** `npx vitest run test/accounts.test.ts`: 13/13 pass (idempotent provisioning, concurrent-race convergence, machine-client exclusion, the no-write-role invariant, suspension vs static-grant semantics). Full root suite: 35/35 tests pass; `npm run typecheck` clean. Note: the 2 "failed" test *files* in the root vitest sweep are the SIWE thunk's `node:test` suites, which vitest cannot collect — pre-existing, unrelated to this change; they pass 19/19 under their own runner (`cd deploy/thunks/siwe && npm test`). Live behavior: not changed and not claimed verified — nothing was deployed.

**Follow-ups parked on the board** (all `--go-ahead`, promote serially; each body names the maintainer decision its promotion implies):

1. `build-account-store-minion-town` (builder) — table + adapters + dark wiring behind `ACCOUNT_AUTOPROVISION=off`; decision: DynamoDB + policy.json-as-overlay.
2. `open-signup-gate-flip-minion-town` (builder) — **the consequential flip**; decisions: confirm going open, confirm baseline = `visitor`/`mcp/tools`-only.
3. `styled-privilege-surfaces-minion-town` (web-builder) — the § 6 surfaces; decision: the `ELEVATION_CONTACT` value.

Open questions for the maintainer are in design § 10 (baseline breadth, overlay vs migrate, adapter placement vs the no-AWS-SDK-in-`src/` rule, elevation contact, Tier-2 materialization).

Possible repo-hygiene follow-up (not posted): scope the root vitest config to exclude `deploy/thunks/**` so `npm test` reports fully green instead of mis-collecting the thunk's `node:test` files.

Self-improvement: nothing this time.
