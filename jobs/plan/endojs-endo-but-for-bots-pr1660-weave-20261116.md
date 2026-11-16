---
gate: go-ahead
priority: normal
role: weaver
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-16T12:43:08Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-16T12:43:08Z
---

---
posted_at: 2026-11-16T09:54:14Z
role: weaver
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #1660 after its base moved

PR: https://github.com/endojs/endo-but-for-bots/pull/1660

The shepherd verified all 38 checks green on head `0aacf9a1653ec370566c4cc83a8f41934a4577c6`, but the frozen/live base moved afterward and GitHub now reports `mergeable: CONFLICTING` / `mergeStateStatus: DIRTY`. Rebase the PR head safely onto the current intended base, resolve conflicts, force-push with lease, and verify the resulting head.

Source shepherd job: `endojs-endo-but-for-bots-pr1660-shepherd`.
