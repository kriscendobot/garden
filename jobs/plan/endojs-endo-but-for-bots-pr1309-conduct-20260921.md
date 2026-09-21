---
gate: go-ahead
priority: normal
role: conductor
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-21T23:33:23Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-21T23:33:23Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (curate → merge) endojs/endo-but-for-bots PR #1309

A trusted maintainer (kriskowal) APPROVED this PR (review 5271637936) with
asks; those asks — the inline "make the orphan poll configurable and less
frequent" comment and the "retcon" directive — are now RESOLVED (retconned to a
single fix(daemon) commit 9c325fd on the current llm tip; inline reply posted;
lint + teardown tests green locally). This is the CURATION step: dispatch the
**conductor** to un-draft (if the PR is still draft) and merge. Do NOT name a
merge method — the conductor owns that choice (roles/conductor/AGENT.md).

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots), base branch `llm`. NEVER merge
    agoric-sdk or the endojs/endo upstream, and NEVER into `master` — that is
    the maintainer's / boatman's call (ferry required for master work).
  - The PR must still be OPEN, mergeable, and checks green. If it has regressed
    (conflicts, red CI), dispatch the shepherd/fixer instead of forcing.
  - Maintainer approval was on the pre-retcon head (d6997fd); the retcon
    force-push rewrote the head to 9c325fd, so that APPROVED review is now
    STALE against the current head. Per roles/conductor/AGENT.md step 4 the
    merge will block "no maintainer approval" until kriskowal re-approves the
    rebased head — that is the guard working, not a defect.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/1309#pullrequestreview-5271637936
