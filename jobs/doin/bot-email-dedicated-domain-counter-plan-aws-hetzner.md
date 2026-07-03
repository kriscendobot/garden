<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-03T04:20:42Z -->

# PLAN (low priority, counter-plan to FastMail-masking): bot-driven email on a dedicated domain

Map: **research/design** → researcher then designer. Deliverable is a comparison + design
doc. Investigation only — no DNS/mailserver provisioning in this job.

This is the COUNTER-PLAN to `investigate-fastmail-masked-email-api-for-bot-personas`.
Instead of multiplexing one FastMail account via masked addresses, run bot-driven email on
a **dedicated domain the bot fully controls** (e.g. `bot-address@minion.town`), so the
agent can mint arbitrary per-persona addresses (catch-all or generated) for the same
purposes: service subscriptions, 2FA/account-recovery receipt, email verification, and a
base identity for OAuth to online services.

## Why a dedicated domain might beat masking
Full control of the address space (catch-all → any `persona+tag@minion.town` just works,
no per-address API call), no third-party masked-domain that picky 2FA/recovery senders may
reject, and the domain reputation is ours to manage. `minion.town` is already a
bot-controlled domain (per the minion.town infra work).

## Subplans — provider approaches to COMPARE (the user asked for AWS, Hetzner, and others)
For EACH, evaluate: inbound receive (the 2FA/verification mail), how the AGENT READS it
(API/webhook/IMAP/JMAP), per-persona/catch-all addressing, outbound send (if needed),
deliverability (SPF/DKIM/DMARC + IP reputation — critical so recovery/2FA mail isn't
dropped and we aren't flagged), cost, and ops burden.

1. **AWS.** SES inbound (receipt rules → S3/SNS/Lambda) for receiving + a Lambda/parser the
   agent reads; SES outbound for sending; Route53 MX + DKIM/SPF/DMARC. Catch-all via a
   receipt rule. Note SES inbound region availability and the sandbox/production-access
   step. Ties into the existing minion.town AWS infra (Cognito/App Runner/Route53) — reuse
   that account + hosted zone. Cost = per-message + S3/Lambda.
2. **Hetzner.** A small VPS running a self-hosted mailserver (mailcow, or docker-mailserver
   = Postfix+Dovecot+Rspamd) with catch-all; agent reads via IMAP/JMAP. Cheapest flat
   monthly cost, full control — but the highest ops burden: deliverability hardening, IP
   reputation/warmup, PTR/rDNS, ongoing patching. Assess whether inbound-only (we mostly
   RECEIVE 2FA/verification) reduces the reputation problem.
3. **Other managed options (call these out — likely the cheapest viable).**
   - **Cloudflare Email Routing** — free catch-all INBOUND forwarding + Email Workers for
     programmatic handling; pairs with a separate sender if outbound is needed. Strong
     candidate for receive-mostly.
   - **ImprovMX / ForwardEmail.net** — free/cheap catch-all forwarding to a destination
     the agent reads.
   - **Migadu / Mailgun / Postmark** — managed mailbox or transactional API with inbound
     parse webhooks.
   Compare these against AWS/Hetzner on the same axes; for a RECEIVE-mostly bot, a free
   catch-all forwarder + a programmatic read may dominate.

## Deliverable
- A side-by-side comparison of AWS vs Hetzner vs the managed options on the axes above, a
  recommended approach (likely receive-mostly → cheapest reliable inbound), and a concrete
  provisioning outline for the recommendation (DNS records, the agent's read path, the
  address scheme).
- The SAME caveats as the FastMail plan, REQUIRED: ToS/abuse risk (automated/bulk account
  creation is prohibited by many services; a fresh self-hosted domain can be low-reputation
  and get 2FA/recovery mail blocked), and identity blast-radius (one domain → many personas;
  domain or server compromise exposes all).

## Constraints
Investigation only — no DNS, mailserver, or cloud provisioning in this job; any standup is
an authorization-gated follow-on (and AWS work would run against the maintainer's account,
per the minion.town deploy plan).

---
claim:
  host: endolinbot2
  gardener: 6
  claimed_at: 2026-07-03T04:20:47Z
