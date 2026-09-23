---
gate: deferred
priority: normal
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
elapsed_constancy_confirmations: 1
doomed_at: 2026-09-18T07:33:12Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T07:33:12Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# receipt (auto) — completion receipt for kriscendobot/minion.town PR #99 (merged)

tier: mentor
fallback-tier: minion

This OPEN-and-now-merged PR was completed by the garden. Emit its COMPLETION
RECEIPT deterministically — run the generator, which builds the per-engagement
rows + the maintainer-review heuristic, posts the PR comment (identity-pinned
gh), and archives the receipt in the journal, all idempotently:

    scripts/jobs/pr-receipt.sh kriscendobot/minion.town 99

It is fail-open and idempotent (journal archive file + comment marker guards),
so a re-run never double-posts. Report the archive path and the posted comment
URL. See designs/pr-completion-receipts.md and scripts/jobs/pr-receipt.sh.

PR: https://github.com/kriscendobot/minion.town/pull/99
