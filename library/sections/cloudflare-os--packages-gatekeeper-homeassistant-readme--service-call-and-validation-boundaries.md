---
title: Service-call and validation boundaries
source: packages/gatekeeper-homeassistant/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 8af429e135671e70394470a9e4c757ad1936ab7a
source_date: 2026-05-22
source_authors: ["Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [home-automation-integrations, capability-mediated-integrations, errors]
status: current
---

The implementation prefers Home Assistant's WebSocket service-call API for consistent target shapes and rejects malformed agent calls synchronously with corrective diagnostics.

The REST service endpoint flattens targets and varies in area, label, and floor support across versions, while WebSocket `call_service` accepts the modern target object directly. Defensive argument validation catches calls shaped as one options object when positional arguments are required and returns a suggested corrected form. Push-event hooks and registry caching remain future work: reads currently refetch registries, and `setHook` is a no-op.

Source: [packages/gatekeeper-homeassistant/README.md](https://github.com/cloudflare/cloudflare-os/blob/8af429e135671e70394470a9e4c757ad1936ab7a/packages/gatekeeper-homeassistant/README.md) at commit `8af429e1`.
