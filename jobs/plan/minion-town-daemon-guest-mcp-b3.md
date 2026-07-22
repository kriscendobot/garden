---
gate: orchestrated
orchestrated_by: minion-town-daemon-guest-mcp-build
priority: high
roadmap: MCP daemon guest tools B3
role: builder
posted_by: gardener
posted_at: 2026-07-22T08:22:32Z
---

Implement B3 from the merged design https://github.com/kriscendobot/minion.town/pull/13 in https://github.com/kriscendobot/minion.town, after B2 is complete. Work in an isolated project worktree keyed to this job. Add the pinned endo-daemon.service deployment path, deploy-endo-daemon.sh, minion-mcp ENDO_SOCK configuration, and dependency-ordered continuous-deployment step without altering the existing OCapN demo lane. Deployment is authorized only as the smallest safe validation step after green B2 evidence. Record deployed PKCE guest write/read, daemon-owner observation, restart persistence, and exact commands; report unavailable privileged access honestly.
