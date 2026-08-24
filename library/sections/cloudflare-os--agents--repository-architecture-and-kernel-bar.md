---
title: Repository architecture and kernel bar
source: AGENTS.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Cloudflare OS contributors]
ingested: 2026-08-24
ingested_by: scholar
topics: [agent-conventions, repository-governance, agent-workspaces]
status: current
---

Cloudflare OS is a pnpm monorepo for sandboxed personal applications and agents, divided into a React Workshop frontend, a Cloudflare Workers kernel backend, shared Cap'n Web APIs, external-service Gatekeepers, routing, deployment tooling, and shared MCP machinery.

`workshop-backend` and the public `workshop-shared` API form the kernel and receive line-by-line scrutiny. Exported API members require documentation; mirror interfaces plus unsafe casts are rejected; existing mechanisms should be extended before parallel ones are invented; and large kernel changes are split from UI work. A Gatekeeper cannot assert that its own resource is ambient. Authority comes from user or admin configuration, with `user.ts:getGatekeeperClassFor()` enforcing disabled resources before capability minting.

Source: [AGENTS.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/AGENTS.md) at commit `1ef6020a`.
