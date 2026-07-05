# Bot-driven email on a dedicated domain

| Created | 2026-07-03 |
| Author  | gardener (researcher + designer) |
| Status  | Proposed |

This is the **counter-plan** to the FastMail masking study
([`fastmail-masked-email-bot-personas.md`](fastmail-masked-email-bot-personas.md)).
Where that plan multiplexes one FastMail account behind masked addresses, this one runs
bot-driven email on a **dedicated domain the bot fully controls** (the domain is
`minion.town`, already bot-controlled per the minion.town infra work). The agent mints
arbitrary per-persona addresses — via catch-all, so any `persona+tag@minion.town` "just
works" with no per-address API call — for the same purposes: service subscriptions,
2FA / account-recovery receipt, email verification, and a base identity for OAuth to
online services.

**Scope: investigation only.** No DNS, mailserver, or cloud provisioning happens in this
job. Any standup is an authorization-gated follow-on, and any AWS work would run against
the maintainer's account per the minion.town deploy plan.

## Why a dedicated domain might beat masking

- **Full control of the address space.** With a catch-all, *any* local part is a live
  address the instant a service asks for one — no round-trip to a masked-alias API to mint
  `signup-github@minion.town` before use. Per-persona tagging (`persona+service@`) is free.
- **No third-party masked domain.** Some picky 2FA / recovery senders reject or downrank
  known masking/relay domains (Fastmail's `*.fastmail.com` masked hosts, DuckDuckGo,
  SimpleLogin, etc.). A plain vanity domain looks like an ordinary company domain.
- **Reputation is ours to manage.** We own SPF/DKIM/DMARC and (where relevant) the sending
  IP, rather than sharing a provider's masked-domain reputation.

The trade — examined in the Caveats — is that a **fresh** self-controlled domain starts
with *no* reputation, which is its own deliverability risk, and one domain fanning out to
many personas concentrates identity blast-radius.

## The workload shape that drives the recommendation

The bot's email need is **receive-mostly**. The dominant flows are *inbound*: a 2FA code,
an account-verification link, a recovery message. Outbound is rare and low-stakes (the
occasional "confirm" reply, or a "reset my password" trigger that is itself a click, not an
email we compose). This asymmetry is the single most important fact in the comparison,
because:

- **Inbound deliverability is easy.** Receiving mail imposes essentially no reputation
  burden on us — the *sender* (GitHub, a bank, a SaaS) owns their reputation; we just need
  a correctly-pointed MX and a reader.
- **Outbound deliverability is hard.** Landing self-originated mail in an inbox is the
  entire IP-warmup / DKIM-alignment / not-getting-blacklisted problem. A receive-mostly bot
  can largely *sidestep* that problem by not sending — or by sending the rare message
  through a managed sender that already has warm IPs.

So the axis that separates the options is not "who has the best mailserver" but "who gives
us reliable **inbound** + a clean **programmatic read path** at the lowest cost and ops
burden, while leaving a cheap door open for the rare outbound."

## The comparison

Axes, per the plan: **inbound receive**, **how the agent reads it**, **per-persona /
catch-all addressing**, **outbound send**, **deliverability**, **cost**, **ops burden**.

### 1. AWS SES (+ Route 53, S3, Lambda/SNS)

- **Inbound receive.** SES email-receiving with a receipt-rule set. A catch-all is a single
  rule matching the bare domain (`minion.town`) with no recipient condition. **Region
  caveat:** SES *receiving* is only offered in a subset of regions (a handful of US/EU/AP
  endpoints), and every resource in the receipt pipeline except S3 (the SNS topic, KMS key,
  Lambda) must live in the **same region** as the SES receiving endpoint. Pick the receiving
  region deliberately and pin the rest of the stack to it.
- **How the agent reads it.** Receipt rule → **deliver-to-S3** (raw MIME to a bucket) and/or
  **invoke-Lambda** / **publish-to-SNS**. The agent reads by listing/getting the S3 objects
  (pull) or by having Lambda parse the MIME and drop a structured record the agent polls
  (e.g. into DynamoDB or a queue). This is the most "cloud-native, glue-it-yourself" read
  path — flexible, but you write the parser.
- **Addressing.** Catch-all trivially (one recipient-less rule); `persona+tag@` and distinct
  local parts all land in the same bucket/Lambda, tagged by the `To:` header.
- **Outbound send.** SES sending is first-class — but gated by the **sending sandbox**
  (verified-recipients-only, 200/day) until you file for **production access**, which
  requires SPF/DMARC/DKIM in place and bounce/complaint SNS wired up. **Important
  asymmetry: SES *receiving* is not gated by the sending sandbox** — inbound works while the
  account is still sandboxed. So a receive-only SES deployment needs no production-access
  request at all.
- **Deliverability.** Route 53 MX + DKIM (SES-managed easy DKIM) + SPF + DMARC. For the rare
  outbound, SES rides AWS's shared warm IP pool (or a dedicated IP as a paid add-on) — far
  better than a cold self-hosted IP.
- **Cost.** Receiving: **$0.10 per 1,000 incoming 256 KB chunks** (uniform across regions),
  plus trivial S3 storage + Lambda invocations. Route 53 hosted zone ~$0.50/mo. For a bot's
  volume this is **cents per month**.
- **Ops burden.** Low-to-moderate. No servers to patch; but you own the receipt-rule set,
  the Lambda parser, IAM, and region-pinning. **Ties into existing minion.town AWS infra**
  (Cognito / App Runner / Route 53) — reuse that account and the existing hosted zone rather
  than standing up anything new. This reuse is the main reason SES is attractive here.

### 2. Hetzner (self-hosted mailserver)

- **Inbound receive.** A small Hetzner VPS running **mailcow** or **docker-mailserver**
  (Postfix + Dovecot + Rspamd). Catch-all is a native mailserver feature. Port 25 is
  **open by default** on Hetzner (unlike many clouds), and rDNS/PTR is settable in the
  Hetzner console — both prerequisites for a real mailserver.
- **How the agent reads it.** **IMAP** (or JMAP if the stack offers it) straight against the
  mailbox. This is the most "normal email" read path — the agent is just an IMAP client.
- **Addressing.** Full control: catch-all, plus-tagging, arbitrary aliases, all local.
- **Outbound send.** Fully capable — and this is exactly where the cost hides. Self-hosted
  **outbound** deliverability is the hard problem: cold-IP reputation, warmup, blacklists.
- **Deliverability.** The self-hosted deliverability tax. Research is blunt about it: roughly
  **half of Hetzner's IP pool carries prior reputation baggage**, and a recycled IP can land
  mail in spam for **weeks to months** even with correct SPF/DKIM/DMARC/rDNS, until enough
  clean volume accrues. For **inbound-only**, this tax is *largely avoided* — receiving mail
  doesn't depend on our IP's sending reputation — but the *server* and its patching remain.
- **Cost.** Cheapest **flat** monthly cost (a small Hetzner VPS is a few €/month, flat
  regardless of message count).
- **Ops burden.** **Highest.** You own the OS, Docker stack, TLS certs, Rspamd tuning,
  security patching, backups, PTR, and — if you ever send — IP warmup and blacklist
  monitoring. For an agent fleet whose value is *not* running a mailserver, this is a
  standing liability and an attack surface. Even inbound-only, a compromised mailserver
  exposes every persona's mail (see Caveats, blast-radius).

### 3. Cloudflare Email Routing (+ Email Workers)  — the receive-mostly front-runner

- **Inbound receive.** Free **catch-all inbound** forwarding on any domain on Cloudflare
  DNS. Enable the catch-all rule and every `*@minion.town` is live. No per-address or
  per-user fee.
- **How the agent reads it.** Two paths: (a) **forward** to a destination inbox the agent
  already reads (e.g. a single mailbox / the Fastmail account from the sibling plan — the two
  plans compose), or (b) **Email Workers**: run code on *each* inbound message (the
  `email()` handler) to parse the MIME, extract the 2FA code / verification link, and drop it
  somewhere the agent polls (KV, a queue, an HTTP callback). Email Workers is the clean
  "programmatic read without running a server" path.
- **Addressing.** Catch-all is native and free; per-persona routing rules or a Worker that
  switches on `To:` both work.
- **Outbound send.** Email Routing is **inbound/forwarding only**. Programmatic *sending* to
  arbitrary recipients needs a Worker on the **Workers Paid** plan (or, more practically,
  pair with a managed sender — SES/Mailgun/Postmark — for the rare outbound). So Cloudflare
  is a receive engine, not a send engine.
- **Deliverability.** Inbound: excellent, nothing to manage. Cloudflare manages the MX and
  the forwarding hop (with SRS so forwarded mail keeps SPF alignment). We add SPF/DMARC on
  the domain. No IP reputation for us to own on the receive side.
- **Cost.** **Free** for catch-all inbound + forwarding. Email Workers ride the standard
  Workers free tier (with CPU/memory limits — a heavy handler may need Workers Paid, ~$5/mo).
- **Ops burden.** **Lowest.** No server, no patching, no IP warmup. Configuration is a few
  DNS records + (optionally) one Worker. This is the cheapest reliable inbound.

### 4. ImprovMX / ForwardEmail.net (catch-all forwarders)

- **Inbound receive.** Both are catch-all **forwarders**: mail to `*@minion.town` forwards
  to a destination the agent reads. Free tiers exist (ImprovMX free tier; ForwardEmail free
  forwarding).
- **How the agent reads it.** Primarily **forward-then-read** at the destination. **Forward
  Email additionally offers IMAP storage** (mailboxes you read directly) and API access on
  its paid tiers — so ForwardEmail can be *both* the catch-all and the readable store, no
  separate mailbox needed.
- **Addressing.** Catch-all native on both; unlimited aliases.
- **Outbound send.** ForwardEmail supports outbound (SMTP) on paid tiers; ImprovMX has a
  send add-on. Neither is a warm-IP transactional sender at the level of SES/Postmark.
- **Deliverability.** Inbound/forwarding: good. As with any forwarder, the forwarding hop
  needs SRS to preserve SPF (both handle this).
- **Cost.** ForwardEmail **~$36/yr** unlimited domains (Enhanced Protection ~$3/mo adds 10 GB
  IMAP + API); ImprovMX free tier, paid from a few $/mo. Migadu-adjacent pricing tier.
- **Ops burden.** Very low — managed. Slightly more than Cloudflare only because it's a
  third-party service rather than sitting inside the DNS we already run.

### 5. Migadu (managed mailboxes, flat price)

- **Inbound receive.** Managed **mailbox** host (not just a forwarder) with native catch-all
  and unlimited aliases across unlimited domains, priced by *volume* not per-mailbox.
- **How the agent reads it.** **IMAP/JMAP** against real mailboxes — the "normal email" read
  path, like Hetzner, but with **zero server ops**.
- **Addressing.** Catch-all + unlimited aliases, all under one flat plan.
- **Outbound send.** Full SMTP send included (Migadu manages the sending reputation), subject
  to their fair-use volume tiers.
- **Deliverability.** Managed — Migadu owns the IPs and reputation for both directions.
- **Cost.** **~$19/yr** (Micro) for low volume, flat. Excellent value if we want a *real
  mailbox* (IMAP) without running one.
- **Ops burden.** Low. The main watch-item is Migadu's **fair-use** send/receive limits and
  its explicit anti-abuse stance (relevant to the Caveats).

### 6. Mailgun / Postmark (transactional APIs with inbound parse)

- **Inbound receive.** Both offer **inbound parse**: MX points at them, they POST parsed
  JSON (headers, text, links, attachments) to a webhook.
- **How the agent reads it.** **Webhook** (push) — the cleanest structured read of all: no
  MIME parsing, they hand you fields. The agent needs an HTTP endpoint (or a Worker) to
  receive the POST, or polls their message API.
- **Addressing.** Catch-all/route rules supported.
- **Outbound send.** This is their core competency — warm-IP transactional sending with
  strong deliverability. If outbound ever becomes non-trivial, these are the right sender.
- **Deliverability.** Best-in-class outbound; inbound parse is reliable.
- **Cost.** **Postmark: inbound parse is gated to paid Pro/Platform tiers (~$15/mo+); the
  free 100-email plan excludes inbound.** Mailgun has a small free/low tier with inbound
  routes. For a receive-mostly bot, paying transactional-sender prices for inbound-only is
  poor value — these earn their keep only if we also send meaningfully.
- **Ops burden.** Low (managed), but you host the webhook receiver.

## Side-by-side

| Provider | Inbound | Agent read path | Catch-all | Outbound | Deliverability (our burden) | Cost (bot volume) | Ops burden |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Cloudflare Email Routing** | Forward + Email Workers | Forward-to-inbox **or** Worker (code per message) | Native, free | No (pair a sender) | Inbound: none | **Free** (Worker maybe ~$5/mo) | **Lowest** |
| **AWS SES** | Receipt rules → S3/Lambda/SNS | S3 pull / Lambda parse (DIY) | One recipient-less rule | Yes (sandbox until prod-access; **receiving not gated**) | We own DKIM/SPF/DMARC; AWS IPs for send | Cents/mo (~$0.10/1k in) | Low–moderate; **reuses minion.town AWS** |
| **ForwardEmail** | Forward + **IMAP store** | Forward-read **or** IMAP/API | Native | Paid tiers | Inbound: minimal (SRS) | ~$36/yr | Very low |
| **Migadu** | Managed mailbox | **IMAP/JMAP** | Native | Yes (managed) | Managed both ways | ~$19/yr flat | Low |
| **ImprovMX** | Forward | Forward-read | Native | Add-on | Inbound: minimal | Free–few $/mo | Very low |
| **Postmark / Mailgun** | **Inbound parse webhook** | Webhook (structured JSON) | Route rules | **Best-in-class** | Best outbound | Postmark inbound = paid (~$15/mo+); Mailgun low tier | Low (host a webhook) |
| **Hetzner self-hosted** | Postfix/Dovecot/Rspamd | **IMAP/JMAP** | Native | Yes (hard: IP warmup) | **We own everything, incl. IP reputation** | Few €/mo flat | **Highest** |

## Recommendation

**Primary: Cloudflare Email Routing** as the inbound engine for `minion.town`, because the
workload is receive-mostly and Cloudflare gives **reliable free catch-all inbound with two
clean programmatic read paths** (forward-to-a-mailbox, or an Email Worker that extracts the
2FA code / verification link and hands it to the agent) at the **lowest cost and lowest ops
burden**, and `minion.town`'s DNS is a natural fit for Cloudflare. It sidesteps the entire
self-hosted deliverability tax by not owning a sending IP.

**For the rare outbound**, do **not** stand up a sender preemptively. When a genuine
send-a-message need appears, add **AWS SES** (reusing the existing minion.town AWS account —
its inbound is even usable while sandboxed, and its outbound rides warm AWS IPs after a
one-time production-access request) or a transactional sender (Postmark/Mailgun). Cloudflare
+ a managed sender cleanly separates "receive everything cheaply" from "send the rare thing
reliably."

**Strong runner-up if a real IMAP mailbox is wanted:** **Migadu** (~$19/yr) or
**ForwardEmail with IMAP** (~$36/yr) — either gives the agent an ordinary IMAP/JMAP store
(the read path some agent tooling may prefer over a Worker/webhook) with **zero server ops**,
and both can send. Choose one of these over Cloudflare only if "the agent speaks IMAP" is a
hard requirement.

**Explicitly not recommended: Hetzner self-hosting.** It wins on flat cost and total control
but loses decisively on ops burden and blast-radius for a fleet whose value is not running a
mailserver — cold-IP warmup, patching, and a single compromisable box holding every
persona's mail. Its only edge (full outbound control) is exactly the capability a
receive-mostly bot least needs. Revisit only if a hard requirement forces fully self-owned
infrastructure.

**Postmark/Mailgun** are the right answer *only* if outbound volume becomes significant;
paying transactional-sender prices for inbound-only parse is poor value here.

## Provisioning outline for the recommendation (Cloudflare, receive-mostly)

Investigation-only; this is the shape a future authorization-gated standup would follow.

1. **DNS on `minion.town` (Cloudflare):**
   - `MX` → Cloudflare Email Routing's exchangers (auto-added when Email Routing is enabled).
   - `SPF` (`TXT`): `v=spf1 include:_spf.mx.cloudflare.net ~all` (add the managed sender's
     include only if/when outbound is added).
   - `DMARC` (`TXT` at `_dmarc`): start `p=none` with a `rua` report address, tighten to
     `quarantine`/`reject` once clean.
   - `DKIM`: none needed for pure inbound forwarding; add the sender's DKIM selector when
     outbound is added.
2. **Catch-all rule:** enable the Email Routing catch-all so every `*@minion.town` is live.
3. **The agent's read path — pick one:**
   - *Simple:* catch-all **forwards** to one destination mailbox the agent already reads
     (this composes with the sibling FastMail plan — Cloudflare fronts the address space,
     Fastmail is the store).
   - *Programmatic:* an **Email Worker** parses each message, extracts the code/link, and
     writes a structured record to Workers KV / a queue / an HTTP callback the agent polls.
     Prefer this if we want structured extraction and no shared mailbox.
4. **Address scheme:** `persona@minion.town` per persona, `persona+service@minion.town` for
   per-service tagging (survives catch-all; the `To:` header carries the tag for routing and
   audit). Reserve a few control addresses (`abuse@`, `postmaster@`, `dmarc@`) as real
   monitored routes — required for a well-behaved domain and to receive DMARC reports.
5. **Outbound (deferred):** wire SES/Postmark/Mailgun only when a real send need appears;
   at that point add the sender's SPF include + DKIM selector and (SES) request production
   access.

## Caveats — REQUIRED, and the same ones as the FastMail plan

- **ToS / abuse risk.** Automated or bulk account creation is **prohibited by many services'
  terms**; using a bot-controlled domain to mint many identities for signups can violate
  those ToS and get accounts (or the domain) banned. Separately, a **fresh self-controlled
  domain has no sending reputation** — recovery/2FA mail *to* us is fine, but any outbound we
  originate from a cold domain/IP is easily flagged or dropped, and aggressive automated
  signup patterns can get the whole domain blocklisted. Managed providers (Cloudflare,
  Migadu, ForwardEmail) also enforce **fair-use / anti-abuse** limits that automated fan-out
  can trip. This capability must be used within each target service's terms; it is not a
  license for bulk/abusive account creation.
- **Identity blast-radius.** One domain fanning out to many personas means **a single point
  of compromise exposes them all.** Whoever controls `minion.town`'s DNS (or the Cloudflare
  account, or — in the Hetzner case — the mailserver box) can read **every** persona's 2FA
  codes and recovery mail, and thus **seize every account** those personas hold. This is
  strictly *worse* concentration than separate providers per persona. Mitigations:
  least-privilege on the DNS/Cloudflare/AWS account, MFA on the registrar and Cloudflare,
  monitored control addresses, and treating the domain's credentials as fleet-critical
  secrets. The convenience of "one domain, infinite addresses" *is* the risk.

## Relationship to the FastMail masking plan

These plans are **complementary, not mutually exclusive**. The cheapest robust shape may be
a **hybrid**: Cloudflare Email Routing owns `minion.town`'s address space (free catch-all,
full control, no per-address API) and **forwards into** the FastMail mailbox the sibling plan
already reads — getting the dedicated-domain benefits (control, no masked-domain rejection)
without a second store or a self-hosted server. If the maintainer picks one, this counter-plan
recommends the dedicated domain via Cloudflare; if both, wire them as above.

## Sources

Verified 2026-07-03:

- AWS SES email-receiving concepts, regions, and receipt-rule actions — <https://docs.aws.amazon.com/ses/latest/dg/receiving-email-concepts.html>, <https://docs.aws.amazon.com/ses/latest/dg/regions.html>
- AWS SES pricing ($0.10 / 1,000 incoming chunks, uniform across regions) — <https://www.emailplatformreview.com/blog/amazon-ses-pricing-official-2026/>
- AWS SES sandbox vs production access (sending-gated; receiving not gated) — <https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html>
- Cloudflare Email Routing catch-all, Email Workers, free tier & limits — <https://developers.cloudflare.com/email-routing/limits/>, <https://developers.cloudflare.com/email-routing/email-workers/>
- ForwardEmail / ImprovMX / Migadu pricing, catch-all, IMAP — <https://forwardemail.net/en/blog/improvmx-vs-migadu-email-service-comparison>
- Postmark inbound parse gated to paid tiers — <https://postmarkapp.com/pricing>, <https://postmarkapp.com/developer/webhooks/inbound-webhook>
- Hetzner port 25 / PTR / mailcow deliverability & IP-reputation tax — <https://mailflowauthority.com/self-hosted-smtp/best-vps-email-server>, <https://netguardia.com/privacy/self-hosting/running-your-own-mail-server-in-2026-mailcow-mail-in-a-box-and-the-deliverability-problem/>
