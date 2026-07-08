Routing confirmed: `/billing/webhook` GET → 404 (reaches the app ungated), `/billing/config` & `/billing/balance` → 302 to login (gated). Everything is deployed, verified, committed, and pushed.

---

## Completion report

**Job:** deploy Stripe credit purchases on minion.town (`designs/stripe-credits.md` § 10 AWS binding, TEST mode). Pushed to `kriscendobot/minion.town@main` as `3b668d8` (direct push, no PR).

**Precondition (checked first):** `minion/stripe` exists in Secrets Manager with genuine TEST keys (`sk_test_`/`pk_test_`/`whsec_`). Proceeded.

### What I did (all six deliverables)
1. **Events table + IAM** — new `deploy-billing-store.sh` created `minion-town-billing-events` (partition `session_id`, on-demand, deletion-protected) and added inline policy `minion-billing-store` to `garden-ec2-ssm`: `PutItem` on the events table + `UpdateItem` on `minion-town-accounts` **scoped by `dynamodb:Attributes` to {iss, sub, credits}** (plus a `ReturnValues` guard).
2. **Router wired** — `src/http.ts` mounts `makeBillingRouter` **before** `express.json()`; optional by config; DynamoDB ledger (`makeDynamoCreditLedger`) + account-store `provision` as `ensureAccount`; issuer = the pool issuer. Typecheck clean, 27 billing + 7 auth tests green, build + mock demo pass.
3. **Secrets/env** — new `deploy-billing-secrets.sh` generated `minion/billing-gate-token` and rendered two 0600 EnvironmentFiles via presigned-S3 (never through SSM text): `/etc/minion-mcp/billing.env` (Stripe values + gate secret + `CREDIT_UNIT_CENTS=1` + `BILLING_PUBLIC_BASE_URL=https://minion.town` + events table) and `/etc/caddy/billing.env` (gate token, loaded via a `caddy.service.d` drop-in). Unit gained `EnvironmentFile=-/etc/minion-mcp/billing.env`.
4. **Caddy** — ungated `handle /billing/webhook` → :3000; gated `handle /billing/*` with `copy_headers … X-Auth-Request-Sub` + `header_up X-Billing-Gate-Token {$BILLING_GATE_TOKEN}`; alpha-config `injectResponseHeaders` grows the `sub` claim.
5. **Buy control** — progressive balance + preset/custom panel on the landing page, matching the SIWE/login aesthetic; hidden unless `/billing/config` resolves.
6. **Verified end-to-end** (see below) and documented in `DEPLOYMENT.md` (Phase 10 row, both secrets, a § Stripe credit purchases section, golden-path item 8).

**Deployed live** in order: store → app → secrets → oauth2-proxy → caddy → www. App logs `💳 billing mounted (Stripe TEST mode; 1¢/credit)`.

### Verification (real execution, not inference)
- **Webhook credits exactly once** — a production-`whsec_`-signed `checkout.session.completed` POSTed to the **public** `https://minion.town/billing/webhook` → 200; DynamoDB `minion-town-accounts` row = **500 credits**, `minion-town-billing-events` marker row present. A **duplicate** redelivery → 200 and balance stayed **500** (not 1000). `role`/`status` untouched.
- **Forged signature** → **400** at the live public endpoint.
- **IAM ceiling** — the exact instance role (`assumed-role/garden-ec2-ssm/i-0380cd68b90020fad`, via IMDS/boto3): `SET role` → **AccessDenied**, `SET status` → **AccessDenied**, `ADD credits` → **SUCCESS**.
- **Real test Checkout Session** created by the deployed app (`cs_test_a1Pcq…`, hosted URL, 500 credits); a loopback checkout **without** the gate token → **403**.
- **Route matchers** — public curl: webhook ungated (app-404 on GET, no login redirect), `/billing/config` & `/billing/balance` gated (302 → sign_in).
- Synthetic test rows deleted from both production tables afterward.

### Not browser-verified (flagged honestly)
Two UI steps sit **behind the login gate** (needs a human IdP sign-in) and were **not** given a rendered-DOM browser run: (a) the landing-page buy panel rendering, and (b) an in-browser card-`4242` completion of the hosted Checkout page. Both are **deployed**; the JS/HTML were statically validated, and the security-critical equivalent (a signature-verified `checkout.session.completed` → DynamoDB credit) was verified directly against the live stack. A maintainer can do the one-time browser purchase anytime — the panel is live.

### Follow-ups
- Optional human confirmation of the in-browser purchase + panel render (above).
- `minion/stripe`'s dashboard webhook endpoint must point at `https://minion.town/billing/webhook` for genuine Stripe deliveries (assumed present per the precondition; not independently re-checked in the dashboard).
- Cost lever unchanged: Cognito MAU alarm still advisable (pre-existing note).
