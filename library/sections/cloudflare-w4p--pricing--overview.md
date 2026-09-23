---
title: "Workers for Platforms pricing: subscription, usage allotments, overages, and worked example"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/pricing/
source_content_sha256: 7399e74ea95348622967231297c238618daa47130f8a7022f92b38826dab8377
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-02
ingested: 2026-07-02
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`). The cost-control cross-ref is cloudflare-w4p--custom-limits--overview."
---

Abstract: The **pricing model** for Workers for Platforms: a **$25/month** Paid-plan subscription plus metered usage. Monthly allotments (with overages): **20 million requests** included, then +$0.30 per additional million; **60 million CPU-milliseconds** included, then +$0.02 per additional million (with a max of 30 seconds of CPU time per invocation and 15 minutes per Cron Trigger / Queue Consumer invocation); and **1000 scripts** included, then +$0.02 per additional script. **Duration is not charged or limited.** Two billing subtleties: only **inbound** requests are billed (subrequests are free), and the whole dispatch → user → outbound Worker chain counts as **one request** for request billing while CPU time is charged across all three. A worked example (100M requests, 10 ms average CPU/request, 1200 scripts) totals **$71.80/month** ($25 subscription + $24 requests + $18.80 CPU + $4 scripts). Custom limits are the recommended guard against runaway bills / denial-of-wallet.

## Pricing

The Workers for Platforms Paid plan is **$25 monthly** (purchased through the Cloudflare dashboard). It comes with the following usage allotments and overage pricing.

|  | Requests | Duration | CPU time | Scripts |
| --- | --- | --- | --- | --- |
| | 20 million requests included per month; +$0.30 per additional million | No charge or limit for duration | 60 million CPU milliseconds included per month; +$0.02 per additional million CPU ms. Max of 30 s CPU time per invocation; max of 15 min CPU time per Cron Trigger or Queue Consumer invocation | 1000 scripts; +$0.02 per additional script |

Notes on the table:

- **Requests** counts *inbound* requests to your Worker. Cloudflare does not bill for subrequests you make from your Worker.
- Workers for Platforms charges for only **1 request** across the chain of dispatch Worker → user Worker → outbound Worker. **CPU time**, however, is charged across all Workers in that chain.

## Example pricing

A project serving **100 million requests/month**, averaging **10 ms of CPU time per request**, using **1200 scripts**:

|                  | Monthly cost | Formula |
| ---------------- | ------------ | ------- |
| **Subscription** | $25.00       | |
| **Requests**     | $24.00       | (100,000,000 − 20,000,000 included) / 1,000,000 × $0.30 |
| **CPU time**     | $18.80       | ((10 ms × 100,000,000) − 60,000,000 included) / 1,000,000 × $0.02 |
| **Scripts**      | $4.00        | (1200 − 1000 included) × $0.02 |
| **Total**        | **$71.80**   | |

## Custom limits

Set [custom limits](cloudflare-w4p--custom-limits--overview.md) for user Workers to control your Cloudflare bill and prevent accidental runaway bills or denial-of-wallet attacks. Configure the maximum CPU time per invocation by defining custom limits in your dispatch Worker.

Source: [Pricing](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/reference/pricing/) retrieved 2026-07-02, content hash `7399e74e`.
