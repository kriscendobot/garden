---
gate: orchestrated
orchestrated_by: minion-town-pr17-conduct-deploy-validate
priority: normal
posted_by: producer
posted_at: 2026-09-02T22:22:37Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Merge https://github.com/kriscendobot/minion.town/pull/17 ("test(endo): admit refreshed credentials on pinned sessions").

Maintainer directive (kriskowal, approving review): "Please conduct, deploy, and validate in production." — https://github.com/kriscendobot/minion.town/pull/17#pullrequestreview-5095277423

Status at posting time: reviewDecision APPROVED, CI green (test: SUCCESS), mergeStateStatus CLEAN. The PR's baseRefName is a frozen snapshot (`main-975a035`), not live `main` — unfreeze it per roles/conductor/AGENT.md step 2 (`gh pr edit 17 -R kriscendobot/minion.town --base main`) before rebasing/merging, so the merge lands on live `main` and not the snapshot.

This is child 1 of 2 in an orchestration; deploy and production validation are the second child, gated on this merge actually landing (state=MERGED).
