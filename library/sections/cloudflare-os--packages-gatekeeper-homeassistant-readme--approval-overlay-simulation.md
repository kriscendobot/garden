---
title: Approval overlay simulation
source: packages/gatekeeper-homeassistant/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 8af429e135671e70394470a9e4c757ad1936ab7a
source_date: 2026-05-22
source_authors: ["Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [home-automation-integrations, capability-mediated-integrations, agent-workspaces, capability-security]
status: current
---

Home Assistant writes wait in the standard approval queue, while subsequent reads overlay their predicted final state so an agent can continue planning against its own pending actions.

Every observation calls `authorizeObservation`; every mutation calls `submitAction` and receives an integer Durable Object sequence ID stored under `pending:<id>`. Until approval, recognized service calls affect only the simulated read view. The overlay models final states, not transitions, and cannot predict arbitrary custom integrations, scenes, scripts, or templates. Reads for those unrecognized operations remain unchanged until execution.

Source: [packages/gatekeeper-homeassistant/README.md](https://github.com/cloudflare/cloudflare-os/blob/8af429e135671e70394470a9e4c757ad1936ab7a/packages/gatekeeper-homeassistant/README.md) at commit `8af429e1`.
