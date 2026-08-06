---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate -> merge) endojs/endo-but-for-bots PR #934

A trusted maintainer APPROVED this PR on its CURRENT head and the
approval RECONCILER confirmed it is OPEN, mergeable, and checks green.
The event-driven comment/review watcher MISSED this approval (it was
down, over a cursor gap, or rate-limited when the review landed); this
periodic backstop caught it. This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT
name a merge method — the conductor owns that (roles/conductor/AGENT.md).

Guards (the reconciler already enforced these; re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the endojs/endo
    upstream, and never link to upstream agoric/agoric-sdk.
  - The PR must still be OPEN, mergeable, and checks green, with a
    current maintainer approval on the exact head. If it has regressed
    (conflicts, red CI, head moved past the approval), dispatch the
    shepherd/fixer instead of forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

PR: https://github.com/endojs/endo-but-for-bots/pull/934
Head: endojs/endo-but-for-bots (bot-pushable)
Posted AUTOMATICALLY by the approval reconciler on endolin-garden2-5bcdff64 (no maintainer comment).
