---
title: Binding and local test contract
source: packages/gatekeeper-email/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 9a2c8509089653eba0727a8d73124ea50361ef5c
source_date: 2026-05-18
source_authors: [Kenton Varda, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

A mailbox binding exposes only its address until a gadget explicitly connects an exported email hook; local delivery uses Wrangler's synthetic email endpoint because real SMTP is unavailable in development.

Mailbox names are lowercase and accept a constrained email-local-part alphabet, excluding leading, trailing, and consecutive dots. The resulting `EmailSession` provides `getAddress()`. Receiving requires a `WorkerEntrypoint` export implementing `receiveEmail()` and a `setBindingHook` connection from the binding to that export. Local tests POST raw message content to `/cdn-cgi/handler/email`; the recipient selects the Durable Object, and mail without a configured hook is rejected.

Source: [packages/gatekeeper-email/README.md](https://github.com/cloudflare/cloudflare-os/blob/9a2c8509089653eba0727a8d73124ea50361ef5c/packages/gatekeeper-email/README.md) at commit `9a2c8509`.
