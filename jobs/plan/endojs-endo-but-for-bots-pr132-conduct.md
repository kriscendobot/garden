---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr132-retcon
priority: normal
role: conductor
posted_by: weaver
posted_at: 2026-08-15T06:01:27Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct (finalize -> merge) endojs/endo-but-for-bots PR #132

A trusted maintainer (@kriskowal) APPROVED PR #132 and asked to rebase, gauntlet,
retcon, and conduct. The rebase, gauntlet, and retcon ran before this. This is the
CURATION step: dispatch the conductor to un-draft (if still draft) and merge. Do NOT
name a merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream.
  - The PR must still be OPEN, mergeable, and checks green. If it regressed
    (conflicts, red CI), dispatch the shepherd/fixer instead of forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.
  - After merge, sweep the stale frozen base branches per the conductor's cleanup.

PR: https://github.com/endojs/endo-but-for-bots/pull/132
Approval: https://github.com/endojs/endo-but-for-bots/pull/132#pullrequestreview-4943007790
