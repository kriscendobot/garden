---
title: "Observability: namespace-wide logs via Logpush and Tail Workers"
source_kind: web
source_url: https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/observability/
source_content_sha256: 94ab78174b444e18ff6a3573f4ba3cbf38dee4b52b57057828461d4140355848
source_authors: [Cloudflare Docs]
source_date: 2026-04-21
retrieved: 2026-07-01
ingested: 2026-07-01
ingested_by: scholar
topics: [multi-tenant-platform]
status: current
notes: "Living vendor docs (developers.cloudflare.com). Idempotency anchor is source_content_sha256 over the page's `.md` rendering (append `index.md`)."
---

Abstract: Two ways to collect logs across all the user Workers in a dispatch namespace. **Workers Trace Events Logpush** gets raw execution logs; enabling it on the *dispatch Worker* captures logs for both the dispatch Worker and every user Worker in the namespace (and automatically for new Workers added later), forwarded to a Logpush job you can filter on the `Outcome` or `Script Name` field. **Tail Workers** are the real-time / programmable alternative: a Tail Worker receives execution info about producer Workers (HTTP statuses, `console.log()` data, uncaught exceptions); adding one to the dispatch Worker likewise covers the whole namespace. Choose Tail Workers over Logpush when you want granular formatting control before delivery, diagnostics-channel events, or real-time delivery. Either mechanism can be scoped to a single user Worker instead of the namespace by attaching it to that user Worker directly.

## Logs

Learn how to access logs with Workers for Platforms.

### Workers Trace Events Logpush

Workers Trace Events Logpush is used to get raw Workers execution logs. Logpush can be enabled for an entire dispatch namespace or a single user Worker. To capture logs for all of the user Workers in a dispatch namespace:

1. Create a [Logpush job](https://developers.cloudflare.com/workers/observability/logs/logpush/#create-a-logpush-job).
2. Enable [logging](https://developers.cloudflare.com/workers/observability/logs/logpush/#enable-logging-on-your-worker) on your dispatch Worker.

Enabling logging on your dispatch Worker collects logs for both the dispatch Worker and for any user Workers in the dispatch namespace. Logs are automatically collected for all new Workers added to a dispatch namespace. To enable logging for an individual user Worker rather than an entire dispatch namespace, skip step 1 and complete step 2 on your user Worker.

All logs are forwarded to the Logpush job that you have set up for your account. Logpush filters can be used on the `Outcome` or `Script Name` field to include or exclude specific values or send logs to different destinations.

### Tail Workers

A [Tail Worker](https://developers.cloudflare.com/workers/observability/logs/tail-workers/) receives information about the execution of other Workers (known as producer Workers), such as HTTP statuses, data passed to `console.log()`, or uncaught exceptions.

Use Tail Workers instead of Logpush if you want granular control over formatting before logs are sent to their destination, to receive diagnostics-channel events, or if you want logs delivered in real-time.

Adding a Tail Worker to your dispatch Worker collects logs for both the dispatch Worker and for any user Workers in the dispatch namespace. Logs are automatically collected for all new Workers added to a dispatch namespace. To enable logging for an individual user Worker rather than an entire dispatch namespace, add the Tail Worker configuration directly to the user Worker.

Source: [Observability](https://developers.cloudflare.com/cloudflare-for-platforms/workers-for-platforms/configuration/observability/) retrieved 2026-07-01, content hash `94ab7817`.
