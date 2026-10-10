---
gate: blocked
blocked_on: minion-town-git-remote-served-clip-design
priority: normal
role: builder
arc: minion-town-git-remote
posted_by: designer
posted_at: 2026-10-10T16:45:16Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Serve a git-remote partition's pushed content as a clip

Repo: kriscendobot/minion.town (branch main). Arc `minion-town-git-remote`. Plan of record: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-git-remote-plan.md (increment 5). Designs of record: `designs/git-remote-capability.md` and `designs/git-remote-capability-increment-1.md` in the repo.

Build what the approved design from job minion-town-git-remote-served-clip-design names: the gateway serves a partition's live contentRoot under the design's stable host, and minion-git-remote runs the write-side reconcile sweep. Add an e2e test that pushes twice and asserts the served bytes follow the tip, plus a crash-between-steps test that the sweep repairs. If the design PR is not approved/merged, stop and report rather than building. Draft PR on kriscendobot/minion.town.
