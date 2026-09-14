---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #877

A trusted maintainer (@kriskowal) APPROVED this PR with the sole ask
"Please conduct." (review 5198524053). At dispatch time the PR was OPEN,
not draft, mergeable (mergeable_state=clean), and all checks green/skipped
with no failures. This is the CURATION step: dispatch the **conductor** to
un-draft (if the PR is still draft) and merge. Do NOT name a merge method —
the conductor owns that choice (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream — those are the maintainer's / boatman's call.
  - The PR must still be OPEN, mergeable, and checks green. If it has
    regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
    forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/877#pullrequestreview-5198524053

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-14T13:56:53Z
