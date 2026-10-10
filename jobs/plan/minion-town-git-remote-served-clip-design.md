---
gate: deferred
priority: normal
role: designer
arc: minion-town-git-remote
posted_by: designer
posted_at: 2026-10-10T16:44:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: serve a git-remote partition's pushed content as a clip

Repo: kriscendobot/minion.town (branch main). Arc `minion-town-git-remote`. Plan of record: https://github.com/kriscendobot/garden/blob/main2/designs/minion-town-git-remote-plan.md (increment 4). Designs of record: `designs/git-remote-capability.md` and `designs/git-remote-capability-increment-1.md` in the repo.

A push currently writes content-roots/<id>, which nothing reads, so pushed content is never served. Write a design PR on kriscendobot/minion.town (designs/) that settles: the stable host/identity for a partition-backed clip (parent OQ 10); how endo-gateway resolves it with only content-store authority (parent § 10, with no ref-store or CAS-write handle); the write-side background reconcile sweep (§ 9); and the deployment-coherent root-qualified sub-resource tier (§ 9; increment-1 deferred item 5). Reconcile with open PRs #88 (nonce-locator / fresh-id-on-upgrade), #142 (clip lifecycle authority as capabilities), and #170. Cost the alternatives. Mark open questions; the PR is the maintainer's decision surface. Do not build anything.
