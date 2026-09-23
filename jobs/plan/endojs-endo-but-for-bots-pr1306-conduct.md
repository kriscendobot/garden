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
doomed_at: 2026-09-18T22:13:09Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-18T22:13:09Z
---

---
role: conductor
dispatch: automatic
tier: minion
model-burned: mentor
fallback-tier: 
---
# Conduct endojs/endo-but-for-bots#1306 — un-draft + merge (guest provisioning, 2/3 of #1125)

PR #1306 (`feat(daemon): caller-elected pins, networks, and names for new agents`)
was rebased onto `llm` after slice 1/3 (#1304) merged; base is now the live `llm`
trunk, head `9e16e50b14`, a single per-package `@endo/daemon` commit (tsc + eslint
clean). kriskowal's review (pullrequestreview-5252661169) APPROVED and directed
"rebase, resolving conflicts, shepherd, retcon, and conduct. Do not wait for
re-approval."

Task: un-draft the PR (it is DRAFT) and drive it to a merged state via
`scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1306` from an
isolated project worktree — block-watch CI to terminal, then `gh pr merge --merge`
(merge-commit shape; NEVER --squash/--rebase). Bot repo; the `llm` trunk merge is
in scope.

IMPORTANT — approval is expected to be stale and re-approval is warranted here:
the rebase changed the head SHA, AND the conflict resolution materially NARROWED
the approved surface. Slice 1/3's round-2 must-fix retired the forgeable
`isReadOnlyDirectoryFormula` recognizer (a read-only `EndoDirectory.readOnly()`
view now has no formula identity), so this PR's read-only-view `networks`
acceptance was removed and `networks` narrowed to a real directory; un-mutable
read-only delegation is deferred to a follow-up. This is documented in a PR comment
(issuecomment-5736561872). kriskowal's "do not wait for re-approval" covered a
mechanical rebase, not this narrowing — so if the exact-head approval gate stalls
`merge blocked: no maintainer approval`, that is the correct, desired surfacing:
stall and let the maintainer approve the narrowed head rather than force-merging a
changed security surface. On `ci red`, stall `ci red: needs shepherd`.
