# Finalize (curate → merge) endojs/endo-but-for-bots PR #590

A trusted maintainer APPROVED this PR and the watcher confirmed it is
OPEN, mergeable, and checks green. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT name
a merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (the watcher already enforced these; re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the endojs/endo
    upstream — those are the maintainers / boatmans call.
  - The PR must still be OPEN, mergeable, and checks green. If it has
    regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
    forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by erights
Approval: https://github.com/endojs/endo-but-for-bots/pull/590#pullrequestreview-4614720239

---
claim:
  host: endolinbot
  gardener: 82
  claimed_at: 2026-07-02T14:31:09Z
