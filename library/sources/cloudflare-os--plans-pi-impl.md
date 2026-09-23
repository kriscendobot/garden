---
source: plans/pi-impl.md
source_repo: cloudflare/cloudflare-os
source_commit: bdb6dc75560e8fa3833e99c9399cae90446d12e1
source_date: 2026-08-03
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

This implementation playbook fixes the scope, provider routing, replay conversion, awaited event-loop persistence, tests, and follow-ups for replacing the Vercel AI SDK with pi-ai and pi-agent-core.

| Section | Topics | Status |
|---------|--------|--------|
| [migration decisions and provider routing](../sections/cloudflare-os--plans-pi-impl--migration-decisions-and-provider-routing.md) | llm-agent-frameworks, cloudflare-workers-agent-hosting, agent-workspaces | current |
| [message replay and tool adaptation](../sections/cloudflare-os--plans-pi-impl--message-replay-and-tool-adaptation.md) | llm-agent-frameworks, agent-workspaces, agent-conventions | current |
| [awaited agent loop and persistence barrier](../sections/cloudflare-os--plans-pi-impl--awaited-agent-loop-and-persistence-barrier.md) | llm-agent-frameworks, persistence, agent-workspaces | current |
| [verification and deferred bridges](../sections/cloudflare-os--plans-pi-impl--verification-and-deferred-bridges.md) | testing, llm-agent-frameworks, repository-governance | current |
