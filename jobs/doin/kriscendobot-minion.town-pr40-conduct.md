---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate -> merge) kriscendobot/minion.town PR #40

A trusted maintainer APPROVED this PR on its CURRENT head and the
approval RECONCILER confirmed it is OPEN, mergeable, and checks green.
The event-driven comment/review watcher MISSED this approval (it was
down, over a cursor gap, or rate-limited when the review landed); this
periodic backstop caught it. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT
name a merge method — the conductor owns that (roles/conductor/AGENT.md).

Guards (the reconciler already enforced these; re-verify before merging):
  - Bot repo only (kriscendobot/minion.town). NEVER merge agoric-sdk or the endojs/endo
    upstream, and never link to upstream agoric/agoric-sdk.
  - The PR must still be OPEN, mergeable, and checks green, with a
    current maintainer approval on the exact head. If it has regressed
    (conflicts, red CI, head moved past the approval), dispatch the
    shepherd/fixer instead of forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

PR: https://github.com/kriscendobot/minion.town/pull/40
Head: kriscendobot/minion.town (bot-pushable)
Posted AUTOMATICALLY by the approval reconciler on endolin-garden2-5bcdff64 (no maintainer comment).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T06:23:54Z
