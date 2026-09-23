---
gate: deferred
priority: normal
role: conductor
tier: minion
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
doomed_at: 2026-09-18T21:33:13Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T21:33:13Z
---

---
role: conductor
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Finalize (curate → merge) endojs/endo-but-for-bots PR #1305

A trusted maintainer (@kriskowal) APPROVED this PR with the directive
"Please conduct." The review carried NO inline comments and no other asks —
the whole review is this single finalization directive. This is the CURATION
step: dispatch the **conductor** to un-draft (if the PR is still draft, though
it is already un-drafted) and merge. Do NOT name a merge method — the conductor
owns that choice (roles/conductor/AGENT.md).

State observed at dispatch (re-verify before merging; the truth is the live PR):
  - PR #1305 is OPEN, not draft, mergeable=true, mergeable_state=clean.
  - Every check-run is pass or skipping (test 22.x/24.x on ubuntu & macos all
    pass; lint, cover, build-xsnap, sandbox-drivers, viable-release, zizmor pass).
    The legacy commit-status rollup reads pending/total:0 only because there are
    no legacy status contexts — not a real red.

STACK CONTEXT — read before merging:
  - #1305 is "3/3 of #1125". Its BASE is `bot/build/1125-guest-provisioning`,
    which is the HEAD branch of #1306 ("2/3 of #1125"). #1305's base is a live
    stacked branch, NOT trunk (`main`) and NOT a frozen-base snapshot, so the
    conductor's step-2 unfreeze does not apply — a plain merge lands #1305 into
    `bot/build/1125-guest-provisioning`, advancing the stack (it does NOT reach
    `main`).
  - #1306 (2/3) is currently DRAFT and CONFLICTING; its base is
    `bot/build/1125-readonly-directory-attenuation` (1/3).
  - Merging #1305 into the 2/3 branch is a legitimate stacked-merge step and is
    what the maintainer approved on 3/3. Honor the directive: merge #1305 onto
    its stated base. Do not retarget its base to `main`.

Guards (re-verify before merging):
  - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the
    endojs/endo upstream — those are the maintainer's / boatman's call.
  - The PR must still be OPEN, mergeable, and checks green. If it has regressed
    (conflicts, red CI), dispatch the shepherd/fixer instead of forcing the merge.
  - Idempotent: if the PR is already merging/merged/closed, do nothing.

Source: pr-review-body by kriskowal
Approval: https://github.com/endojs/endo-but-for-bots/pull/1305#pullrequestreview-5252602961
