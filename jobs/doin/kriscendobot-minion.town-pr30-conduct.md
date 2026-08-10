---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) kriscendobot/minion.town PR #30

A trusted maintainer APPROVED this PR and the watcher confirmed it is
OPEN, mergeable, and checks green. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT name
a merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (the watcher already enforced these; re-verify before merging):
  - Bot repo only (kriscendobot/minion.town). NEVER merge agoric-sdk or the endojs/endo
    upstream — those are the maintainers / boatmans call.
  - The PR must still be OPEN, mergeable, and checks green. If it has
    regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
    forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/kriscendobot/minion.town/pull/30#pullrequestreview-4901886321

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-10T23:55:54Z
