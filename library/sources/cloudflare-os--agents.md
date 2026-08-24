---
source: AGENTS.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Cloudflare OS contributors]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The repository's agent guide maps the architecture and high-scrutiny kernel, then records its pnpm/Vite+ build rules, Cap'n Web capability practices, and secret-safe observability boundaries.

| Section | Topics | Status |
|---------|--------|--------|
| [repository architecture and kernel bar](../sections/cloudflare-os--agents--repository-architecture-and-kernel-bar.md) | agent-conventions, repository-governance, agent-workspaces | current |
| [Vite+ build, test, and lint contract](../sections/cloudflare-os--agents--vite-plus-build-test-and-lint-contract.md) | agent-conventions, testing, node-packaging | current |
| [Cap'n Web RPC discipline](../sections/cloudflare-os--agents--capn-web-rpc-discipline.md) | agent-conventions, capability-security, eventual-send | current |
| [structured observability and error reporting](../sections/cloudflare-os--agents--structured-observability-and-error-reporting.md) | agent-conventions, capability-security, cloudflare-workers-agent-hosting | current |
