---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #1304

A trusted maintainer (kriskowal) APPROVED this PR and asked to conduct. This is
the CURATION step: dispatch the **conductor** to un-draft (if the PR is still
draft) and merge. Do NOT name a merge method — the conductor owns that choice
(roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream — those are the maintainer's / boatman's call.
  - The PR must be OPEN, mergeable, and checks green. It is currently DRAFT with
    CI in flight; block-watch CI to terminal via ci-wait-merge.sh and merge on
    green in the same job. If it has regressed (conflicts, red CI), dispatch the
    shepherd/fixer instead of forcing the merge.
  - Base is a frozen snapshot (llm-387ea66) — unfreeze to the live `llm` trunk
    before merging (conductor step 2).
  - reviewDecision=APPROVED (kriskowal, latest review). An earlier
    CHANGES_REQUESTED nits review was superseded by this approval.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/1304#pullrequestreview-5244346523

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-18T04:52:33Z
