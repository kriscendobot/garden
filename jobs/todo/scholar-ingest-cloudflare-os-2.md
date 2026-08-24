---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Continue the first-pass ingestion of https://github.com/cloudflare/cloudflare-os. The initial cycle ingested `README.md`, `docs/blueprints.md`, and `docs/sharing.md` at their file-specific commits, producing 18 sections and six new domain topics.

Ingest the remaining top-level design documentation, oldest-first and within the normal cycle budget: `docs/ai-gateway-billing.md`, `docs/integration-testing.md`, `docs/oauth-signin.md`, `docs/observers.md`, and `docs/public-server.md`. If those exceed the cycle, repost the remainder precisely. After the `docs/` set, the repository backlog is `plans/git-storage.md`, `plans/multi-gadget.md`, `plans/pi-impl.md`; repository operating documents `AGENTS.md`, `CONTRIBUTING.md`, and `REVIEW.md`; and the architecture-bearing package documentation in `packages/backend-utils/README.md`, `packages/gatekeeper-{cloudflare,confluence,email,github,google,homeassistant,mcp,mcp-portal,notion,scheduler,slack,spotify,supabase,zoominfo}/README.md`, `packages/integration-tests/README.md`, `packages/mcp-shared/README.md`, and `packages/workshop-frontend/README.md`. Survey package source for longform architectural comments only after the documented backlog is exhausted.

Run idempotency checks against the three already-ingested sources before writing. Extend the new Cloudflare OS topics (`agent-workspaces`, `ai-generated-apps`, `capability-mediated-integrations`, `cloudflare-workers-agent-hosting`, `reusable-app-blueprints`, and `collaborative-workspace-sharing`) when they fit, and add a genuinely new topic when the remaining material does not.
