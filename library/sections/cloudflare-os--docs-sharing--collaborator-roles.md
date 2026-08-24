---
title: Collaborator roles and restricted capabilities
source: docs/sharing.md
source_repo: cloudflare/cloudflare-os
source_commit: 814bdc7ebe2454067b4c48e195fccd37979bb0aa
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-security]
status: current
---

Cloudflare OS represents collaborator access as ordered `build` and `use` roles and returns a role-specific capability from `open()` rather than relying only on scattered method checks.

`build` grants editing, chat, binding management, and gadget interaction, with owner-only deletion and restricted revocation authority. `use` permits only the deployed UI, basic metadata, and presence. Telemetry subscriptions opened speculatively by the frontend return inert streams rather than revealing data.

Owner and `build` sessions receive the full client interface. A `use` session receives a `UseOverseerInterface` that implements the complete Overseer type but rejects methods outside its allowlist. A newly added method therefore fails compilation until its `use` policy is decided, giving the restricted capability a default-deny maintenance property.

Source: [docs/sharing.md](https://github.com/cloudflare/cloudflare-os/blob/814bdc7ebe2454067b4c48e195fccd37979bb0aa/docs/sharing.md) at commit `814bdc7e`.
