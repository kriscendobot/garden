---
role: conductor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-06T06:56:06Z cleared=none -->

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate -> merge) endojs/endo-but-for-bots PR #877

kriskowal APPROVED PR #877 (`feat/endor-npm-dual-build-execution`) on 2026-08-06.
Once the blocking weave (job endojs-endo-but-for-bots-pr877-rebase) has resolved
the base conflict, pushed, and CI has dispatched, this is the CURATION step:
un-draft (the PR is currently DRAFT) and merge. Do NOT name a merge method — the
conductor owns that choice (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots, base `llm`). NEVER merge agoric-sdk
    or the endojs/endo upstream.
  - The PR must be OPEN, mergeable, and checks green. Block on CI via
    skills/pr-ci-watch (scripts/jobs/gardening/ci-wait-merge.sh). If it regressed
    (conflicts, red CI), dispatch the shepherd/fixer instead of forcing the merge.
  - Idempotent: if already merging/merged/closed, do nothing.

Source: shepherd hand-off from job endojs-endo-but-for-bots-pr877-shepherd.
Approval: https://github.com/endojs/endo-but-for-bots/pull/877#pullrequestreview-4871702108

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T06:56:13Z
