## Completion report

**Job:** Research/design counter-plan to FastMail masking — bot-driven email on a dedicated domain (`minion.town`) the bot fully controls, comparing AWS, Hetzner, and managed options.

**What I did**
- Ran targeted web research (verified 2026-07-03) on all provider axes: AWS SES inbound receiving/regions/pricing/sandbox semantics, Cloudflare Email Routing catch-all + Email Workers, ForwardEmail/ImprovMX/Migadu pricing & IMAP, Postmark inbound-parse gating, and Hetzner self-hosted deliverability/IP-reputation reality.
- Wrote the deliverable: `designs/bot-email-dedicated-domain.md` (Status: Proposed).
- Added its row to the `designs/README.md` index.
- Committed with explicit pathspecs and pushed to `main2` via a rebase CAS loop (`90ec62613..efe606ffe`).

**What the doc delivers (per the plan's required shape)**
- **Side-by-side comparison** of AWS SES vs Hetzner vs Cloudflare Email Routing vs ImprovMX/ForwardEmail/Migadu vs Postmark/Mailgun on all seven axes (inbound receive, agent read path, catch-all addressing, outbound, deliverability, cost, ops burden), with a summary table.
- **Framing that drives the answer:** the workload is receive-mostly, so inbound deliverability is cheap and outbound is the hard part — which separates the options.
- **Recommendation:** Cloudflare Email Routing (free catch-all inbound + Email Workers) as the receive engine, with a managed sender (SES reusing the minion.town AWS account, or Postmark/Mailgun) *deferred* until a real outbound need appears. Runner-up if a real IMAP mailbox is wanted: Migadu (~$19/yr) or ForwardEmail-with-IMAP. Hetzner explicitly not recommended (ops burden + blast-radius). Also notes the plans are complementary — a Cloudflare-fronts-Fastmail hybrid.
- **Concrete provisioning outline** for the recommendation: DNS records (MX/SPF/DMARC/DKIM), catch-all rule, the two agent read-path options, the `persona+service@` address scheme, and deferred outbound wiring.
- **Both REQUIRED caveats:** ToS/abuse risk (bulk account creation prohibited by many services; fresh-domain low reputation) and identity blast-radius (one domain → many personas; DNS/account/server compromise exposes all).

**Verification:** the design doc is a research/prose deliverable with no runtime surface; correctness rests on the cited, verified sources listed in the doc. Push confirmed by the observed ref update above. Investigation-only per the job constraints — no DNS/mailserver/cloud provisioning performed.

**Follow-ups:** Any actual standup is an authorization-gated follow-on (AWS work would run against the maintainer's account). The sibling FastMail plan (`investigate-fastmail-masked-email-api-for-bot-personas`) remains open; the maintainer may pick one or wire the hybrid described in the doc.
