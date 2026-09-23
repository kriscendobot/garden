---
title: Mailbox capability and delivery path
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

The email Gatekeeper turns an address local part into a durable, hook-backed capability: each mailbox maps to a Durable Object that remembers a gadget entrypoint and invokes it with parsed mail.

Unlike connector Gatekeepers, this package is the external-facing service. A Cloudflare Email Worker accepts a message, selects an `EmailAddress` Durable Object by the canonicalized recipient local part, loads the stored hook `Fetcher`, and calls the gadget's `receiveEmail()` entrypoint through the Overseer loopback. `postal-mime` converts raw MIME into structured sender, recipient, subject, text, HTML, and attachment data before delivery.

Source: [packages/gatekeeper-email/README.md](https://github.com/cloudflare/cloudflare-os/blob/9a2c8509089653eba0727a8d73124ea50361ef5c/packages/gatekeeper-email/README.md) at commit `9a2c8509`.
