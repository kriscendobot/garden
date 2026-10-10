---
gate: deferred
priority: normal
role: builder
arc: minion-town-git-remote
posted_by: designer
posted_at: 2026-10-10T16:44:24Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Validate the live git.minion.town capability-URL round trip

Repo: kriscendobot/minion.town (branch main). Arc `minion-town-git-remote`. Plan of record: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-git-remote-plan.md (increment 1). Designs of record: `designs/git-remote-capability.md` and `designs/git-remote-capability-increment-1.md` in the repo.

Run DEPLOYMENT.md § Validating the git remote after merge, step 7, against production (the service has been deployed since 2026-09-29; the 2026-09-29 verify job skipped this step). Create one operator-owned test partition, mint readwrite and read URLs, push and clone with stock git, confirm that a push with the read token gets 403, then revoke and confirm 401. Clean up the test partition. Record the outcome in the DEPLOYMENT.md phase-13 row through a PR. If driving the operator provisioning path on the box is awkward, add a small deploy/aws/scripts/git-remote-partition.sh (create/mint/revoke) wrapper in the same PR and use it. Never print a minted token into a PR, comment, or journal.
