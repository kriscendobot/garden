---
role: builder
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-08T05:45:57Z -->

---
role: builder
---

# Deploy Stripe credit purchases on minion.town (AWS/box binding, TEST mode)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws`, region us-west-1; box access SSM only (`i-0380cd68b90020fad`). Secrets only in Secrets Manager.

**PRECONDITION (why this is parked go-ahead):** the maintainer must first provide Stripe TEST keys per `designs/stripe-credits.md` § 7 — Secrets Manager secret `minion/stripe` = `{"secret_key":"sk_test_…","publishable_key":"pk_test_…","webhook_secret":"whsec_…"}` with a dashboard webhook endpoint at `https://minion.town/billing/webhook` subscribed to `checkout.session.completed` + `checkout.session.async_payment_succeeded`. Verify the secret exists before any live change; if absent, report the gap and stop. Test keys ONLY — the app refuses live keys by design.

The design + tested toy landed on `main` (commit 328e7e1: `src/billing/`, `test/billing.test.ts` 27 green, `npm run billing:demo`). This job is the § 10 AWS binding:

1. **Events table:** create `minion-town-billing-events` (partition key `session_id` (S), on-demand, deletion protection), mirroring `deploy-accounts-store.sh` as `deploy-billing-store.sh`.
2. **IAM:** extend the instance role with `dynamodb:PutItem` on the events table and `dynamodb:UpdateItem` on `minion-town-accounts` scoped by the `dynamodb:Attributes` condition to the `credits` attribute only (the account store admin ceiling must survive: the serving path must remain unable to touch role/status via UpdateItem).
3. **Wire the router:** mount `makeBillingRouter` in `src/http.ts` BEFORE `express.json()` (raw-body signature verification breaks otherwise), billing enabled only when `loadBillingConfig` returns config; `ensureAccount` = the account store provision; ledger = `makeDynamoCreditLedger`.
4. **Secrets/env:** generate `minion/billing-gate-token`; render an EnvironmentFile for `minion-mcp.service` from `minion/stripe` + the gate token (the oauth2-proxy presigned-S3 0600 pattern); set `CREDIT_UNIT_CENTS=1`, `BILLING_PUBLIC_BASE_URL=https://minion.town`.
5. **Caddy:** in `conf.d/minion-town.caddy`, `handle /billing/webhook` ungated → 127.0.0.1:3000; the rest of `/billing/*` inside the gated `forward_auth` route with `copy_headers` extended to `X-Auth-Request-Sub` (oauth2-proxy alpha-config `injectResponseHeaders` grows the sub claim) and the `X-Billing-Gate-Token` header attached from the gate-token secret.
6. **Buy control:** balance + preset/custom buy panel on the landing page per design § 5, matching the login/SIWE aesthetic; progressive (hidden when billing is unmounted).
7. **Verify end-to-end** (report evidence, not inference): a real test-mode purchase with card 4242… credits the signed-in account exactly once (DynamoDB row shows the balance; Stripe dashboard shows the delivery 200); a duplicate redelivery from the dashboard no-ops; a forged-signature POST answers 400; document rows/commands in DEPLOYMENT.md (new phase row + secrets list entries).

Design: `designs/stripe-credits.md` (threat model § 8 is the acceptance frame).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  claimed_at: 2026-07-08T05:46:03Z
