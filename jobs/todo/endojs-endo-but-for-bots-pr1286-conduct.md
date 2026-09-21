---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finalize (curate -> merge) endojs/endo-but-for-bots PR #1286

A trusted maintainer (kriskowal) APPROVED this PR with the bundled ask
"Please conduct." The review carried NO inline comments and NO other asks,
so conduct is the sole and complete directive. This is the CURATION step:
dispatch the **conductor** to un-draft (if still draft) and merge. Do NOT
name a merge method — the conductor owns that (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream, and never link to upstream agoric/agoric-sdk.
  - The PR must still be OPEN, mergeable, and checks green, with the
    effective maintainer approval intact. At review-handling time the PR was
    OPEN, not draft, mergeable:true, with CI still IN PROGRESS (rust + test
    matrix running, none failing) — the conductor's ci-wait-merge spine
    blocks until CI is terminal-green before merging. If CI has regressed
    (conflicts, red CI, approval dismissed), dispatch the shepherd/fixer
    instead of forcing the merge.
  - Base branch is `slot-machine` (a stacked-PR base, not a frozen-base
    snapshot and not a trunk) — merge into it as-is; the conductor owns any
    rebase/base handling.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

PR: https://github.com/endojs/endo-but-for-bots/pull/1286
Head: ebfb-thixotrope-drop-inert-bundle-filter @ 6e952bba01e02d6dea6ad7e91c12d74be37cbbaa (bot-pushable)
Review: https://github.com/endojs/endo-but-for-bots/pull/1286#pullrequestreview-5271790535
Posted by the review-handling gardener (job endojs-endo-but-for-bots-pr1286-review-17e29af8).
