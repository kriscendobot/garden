---
gate: deferred
priority: normal
role: builder
arc: minion-town-git-remote
posted_by: designer
posted_at: 2026-10-10T16:44:36Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resource caps on git-remote receive-pack

Repo: kriscendobot/minion.town (branch main). Arc `minion-town-git-remote`. Plan of record: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-git-remote-plan.md (increment 2). Designs of record: `designs/git-remote-capability.md` and `designs/git-remote-capability-increment-1.md` in the repo.

Add configurable caps (config.ts env vars, with safe defaults) for max push request/pack bytes, max partition on-disk size, and a per-partition push rate. Enforce each cap before or while the git http-backend CGI runs, and refuse with a clean git-protocol error that leaves the repo unchanged. Add a protocol or e2e test for every refusal. Out of scope: billing/metering (#174) and GC. Draft PR on kriscendobot/minion.town; update designs/git-remote-capability-increment-1.md deferred item 3 and DEPLOYMENT.md § Git remote env table.
