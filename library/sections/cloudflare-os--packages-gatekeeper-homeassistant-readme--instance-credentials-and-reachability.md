---
title: Instance credentials and reachability
source: packages/gatekeeper-homeassistant/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 8af429e135671e70394470a9e4c757ad1936ab7a
source_date: 2026-05-22
source_authors: ["Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [home-automation-integrations, capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

Home Assistant connections use an instance URL plus a long-lived access token because there is no central OAuth authority, making deployment reachability part of the credential contract.

The Gatekeeper validates a pasted URL and token through `GET /api/` and stores both in the user's Durable Object. A Cloudflare-hosted deployment can reach only publicly exposed instances, through Nabu Casa, a tunnel, or equivalent routing. A self-hosted workerd deployment on the same network can instead use local hostnames and private addresses, which is the intended LAN configuration.

Source: [packages/gatekeeper-homeassistant/README.md](https://github.com/cloudflare/cloudflare-os/blob/8af429e135671e70394470a9e4c757ad1936ab7a/packages/gatekeeper-homeassistant/README.md) at commit `8af429e1`.
