---
title: Resource capability granularities
source: packages/gatekeeper-homeassistant/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 8af429e135671e70394470a9e4c757ad1936ab7a
source_date: 2026-05-22
source_authors: ["Yo'av Moshe"]
ingested: 2026-08-24
ingested_by: scholar
topics: [home-automation-integrations, capability-mediated-integrations, capability-security]
status: current
---

The Home Assistant Gatekeeper attenuates one account credential into five selectable resource capabilities: whole instance, area, label, device, or entity.

Each granularity has its own picker and produces a correspondingly narrow TypeScript interface. A whole-instance session can enumerate resources and reach dashboards, templates, history, and services; area and label capabilities collect related entities; device and entity capabilities constrain authority to a physical device or one stateful endpoint. The API preserves those boundaries through typed accessors and scoped service calls rather than handing gadget code the bearer token.

Source: [packages/gatekeeper-homeassistant/README.md](https://github.com/cloudflare/cloudflare-os/blob/8af429e135671e70394470a9e4c757ad1936ab7a/packages/gatekeeper-homeassistant/README.md) at commit `8af429e1`.
