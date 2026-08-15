---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #288

A trusted maintainer (kriskowal) APPROVED this PR with the review
https://github.com/endojs/endo-but-for-bots/pull/288#pullrequestreview-4943030141
("[APPROVED] Please rebase, shepherd, and conduct. If necessary, weave,
shepherd, then conduct."). The rebase/weave step is DONE: the branch
`feat/cbors-package` was rebased onto `llm`, the `@endo/cbor` vs
`@endo/cbor-frame` ocapn dependency conflict resolved as a union (both are
used), composite tsconfigs + yarn.lock regenerated, and a redundant
`/* global setTimeout */` directive dropped (base eslint now declares it).
Pushed head: `33ae7c42acddc81b7bc4d9903b12262dea006102`. PR is mergeable
(no conflicts).

This is the CURATION step: drive CI to green and then merge. Use the
deterministic spine `scripts/jobs/gardening/ci-wait-merge.sh
endojs/endo-but-for-bots 288` from an isolated project worktree — it
block-watches CI to terminal (the "shepherd" step) and merges in the same
job. Do NOT name a merge method — the conductor owns that choice
(roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream.
  - The PR must be OPEN, mergeable, and checks green. If CI regresses (red),
    stall `ci red: needs shepherd` (the shepherd's escalation routes onward);
    do not force the merge.
  - **Stale approval expected.** The rebase rewrote history, so kriskowal's
    approval on the pre-rebase head (`8a4aad504`) is intentionally stale for
    the rebased head. ci-wait-merge's freshness check will stall
    `merge blocked: no maintainer approval` until the maintainer re-approves
    the rebased head `33ae7c42a`. That stall is the correct terminal state,
    not a failure — surface it; do not merge on the stale signature.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/288#pullrequestreview-4943030141
