---
title: Capability-based introductions
source: README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda, "Yo'av Moshe", Nathan Disidore, Phillip Jones, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

Agents and gadgets begin with no external authority and gain narrowly designated resources through explicit user introductions rather than ambient connector access.

Configuring an external account does not automatically expose it to every chat or gadget. A user introduces a particular repository, document, or other resource by pasting its link or selecting it in the UI. An agent may request an introduction, which the user can provide or deny.

On the server, a Dynamic Worker gadget has internet access disabled and can communicate only through designated Workers bindings. Client code runs in a sandboxed iframe whose server channel is a Cap'n Web session passed through `postMessage()`.

Source: [README.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/README.md) at commit `1ef6020a`.
