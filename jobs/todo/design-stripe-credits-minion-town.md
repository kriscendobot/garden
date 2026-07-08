---
role: designer
---

# Design + toy: Stripe credit purchase for minion.town (test / simulation mode)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws`, region us-west-1. Box access SSM only (`i-0380cd68b90020fad`). **Secrets only in Secrets Manager.**

## Mandate

Design + a runnable, tested toy for **authenticated users purchasing credits** via Stripe, in **test/simulation mode**. Every authenticated user (guest and up) can buy credits; credits accrue to their account (`minion-town-accounts` already carries a `credits` seam). Deliver a design doc + a runnable toy proving the purchase→credit loop end-to-end against Stripe test mode (or a faithful mock), plus a parked `--go-ahead` deploy follow-on gated on the maintainer's Stripe test keys. **Scope is OBTAINING credits, not spending/metering them** — shape the debit seam, don't build it.

## Maintainer parameters (2026-07-08)
- **Rate:** configurable; **start at 1 credit = 1 cent** (`CREDIT_UNIT_CENTS=1`; 100 credits = $1). The rate must be a single config value (variable by design).
- **Test mode only:** build against Stripe **test keys** — no live keys, no real charges. The maintainer **has a Stripe account**; frame their setup steps from that position (obtain test keys; create a test webhook) and **no farther** (do NOT explain account creation or business onboarding).

## Design these

1. **Credit model:** integer `credits` per account (DynamoDB `minion-town-accounts`, key iss+sub). `credits += amount_paid_cents / CREDIT_UNIT_CENTS`, applied with an atomic `ADD` update. Guests included.
2. **Purchase flow (Stripe Checkout):** an authenticated `POST /billing/checkout` creates a Stripe **Checkout Session** (`mode=payment`) for a chosen amount (preset packs + optional custom), success/cancel URLs back to minion.town; the session **metadata carries the user's `iss`+`sub`** so the webhook credits the right account (never a client-supplied balance/identity). Returns the Checkout URL; browser redirects to Stripe's hosted page (test cards, e.g. `4242…`).
3. **Webhook `POST /billing/webhook`:** UNGATED at Caddy (Stripe can't pass the login gate) but **secured by Stripe signature verification** (`whsec`), not the gate. On `checkout.session.completed`: verify signature → read `iss`+`sub` + amount from the session → credit the account **idempotently** (dedupe on the Stripe event / session id — persist processed ids; webhooks retry and must never double-credit).
4. **Surfaces:** the landing / `/account` view shows the current balance + a "Buy credits" control; a success page on return. Minimal aesthetic, matching the login + SIWE pages.
5. **Where it runs:** the app (`minion-mcp` on the box) gains a small billing module + the two routes; Caddy routes `/billing/*` to the app — **webhook ungated (signature-verified), checkout behind the login gate**. Stripe SDK server-side only; publishable key client-side.
6. **Secrets (maintainer-provided, test):** `minion/stripe` = `{secret_key: sk_test_…, publishable_key: pk_test_…, webhook_secret: whsec_…}` in Secrets Manager. Give the **exact dashboard steps** for an existing account: switch to test mode → copy the test secret + publishable keys → create a webhook endpoint at `https://minion.town/billing/webhook` subscribed to `checkout.session.completed` → copy its signing secret. No farther.

## Threat model (must address)
- **Webhook signature verification is THE security boundary** — without it, anyone POSTing could mint credits for free.
- **Idempotency** — dedupe events so retries/duplicates never double-credit.
- **Identity binding** — credits go to the `iss`+`sub` in the *server-created* session metadata; the credited amount comes from Stripe, never the client.
- **Test/live key separation** — never live keys in this build; guard config mixups.
- Refunds/disputes/chargebacks — name the handling seam (out of scope to build).

## Deliverables
- `designs/stripe-credits.md` — the above with recommendations, threat model, and the exact (existing-account) maintainer setup steps.
- A **runnable, tested toy** (mirror the mcp-oauth / SIWE toy pattern): create-checkout + a signature-verified webhook handler + the atomic credit + idempotency, proven with tests (valid webhook credits once; duplicate event no-ops; bad signature rejected; identity taken from metadata; rate math at 1¢). Runnable against Stripe test mode with test keys, or a faithful mock if keys are absent — state which.
- A parked `--go-ahead` deploy follow-on `deploy-stripe-credits-minion-town` (AWS/box binding: routes, `minion/stripe` secret, DynamoDB credit path, Caddy `/billing/*`) naming the Stripe-test-keys precondition.
- Ground in the **current** Stripe API (verify against the SDK, not memory). Secrets only in Secrets Manager; keep the billing module's config-driven and coupling loose.
