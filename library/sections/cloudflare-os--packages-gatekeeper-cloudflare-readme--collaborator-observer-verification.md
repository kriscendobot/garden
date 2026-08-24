---
title: Collaborator observer verification
source: packages/gatekeeper-cloudflare/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1931a1b175d52ed88109d880b90e23d130cca2ad
source_date: 2026-08-18
source_authors: [Nathan Disidore]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, worker-observability, capability-security]
status: current
---

A gadget's Cloudflare telemetry binding is not transferable: every collaborator must prove through their own connected account that they can read the bound resource.

`addObserver` checks the collaborator's credentials rather than trusting the gadget owner's access. Missing access is a refusal, and operational uncertainty such as a transport error or provider 5xx also refuses admission. This fail-closed sharing rule makes the observer set reflect independently held authority instead of treating possession of a shared gadget as a credential delegation.

Source: [packages/gatekeeper-cloudflare/README.md](https://github.com/cloudflare/cloudflare-os/blob/1931a1b175d52ed88109d880b90e23d130cca2ad/packages/gatekeeper-cloudflare/README.md) at commit `1931a1b1`.
