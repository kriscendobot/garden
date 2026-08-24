---
title: Scheduler architecture, driver, and fixed limits
source: packages/gatekeeper-scheduler/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [scheduled-agent-tasks, cloudflare-workers-agent-hosting, capability-mediated-integrations]
status: current
---

Each Scheduler account owns one SQLite-backed `ScheduleDriver` Durable Object and one alarm covering all its workspaces, processing at most 20 due schedules per pass with four concurrent deliveries; the single account-wide driver keeps management and revocation simple but is a shared failure domain, and a read-only management app plus fixed policy limits round out the package.

The alarm persists state before crossing an RPC boundary, processes at most 20 due schedules per pass with four concurrent deliveries, then arms an immediate continuation when a backlog remains. Stable `runId` fencing prevents a late completion or retry continuation from mutating a disabled, re-enabled, or revoked schedule. Workspace sessions inherit their opaque scope from the containing Overseer facet, so callers cannot supply an account or workspace ID, and plain schedule metadata and reconstructable RPC capabilities are stored under separate keys and changed transactionally. One account-wide driver keeps management and revocation simple but is a shared failure domain: a user callback that never settles can delay other schedules in that account until the runtime aborts the alarm, and bounded batches limit ordinary load without eliminating that tradeoff. The Scheduler is capability-authorized — it does not receive Workshop user identity, assert its own ambient policy, expose external network authority, or implement actions; the Workshop's existing hook admission and observation authorization remain the security boundaries.

The account advertises a read-only management app at `/gatekeepers/scheduler` through the generic `AccountDescription.providesUi` mechanism, hosted in an opaque-origin, network-isolated `srcDoc` frame that can only call its account-scoped `list()` capability plus bounded host methods for theme, title resolution, navigation, and starter prompts. It is intentionally read-only: enabling and disabling stay in Connections, and the app offers no editing, pausing, deletion, run history, or second hook toggle. Fixed policy limits (not deployment settings) are 500 enabled-or-terminal rows per account, 100 per workspace, 100 rows per management page, 20 due schedules and four concurrent deliveries per alarm pass, eight callback attempts per occurrence, 200-character titles, and 2,000-character descriptions. Deployment requires the `allow_irrevocable_stub_storage` compatibility flag while stored callback capabilities exist, and the vendor defaults to optional provisioning.

Source: [packages/gatekeeper-scheduler/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/gatekeeper-scheduler/README.md) at commit `ba4036b9`.
