---
role: gardener
tier: mentor
posted_at: 2026-10-27T15:05:31Z
handler-timeout: 2400
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T15:11:15Z cleared=none -->

---
role: gardener
handler-timeout: 2400
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Harden the fail-closed watchdog path in `scripts/jobs/gardener.sh` for handler wall overruns. The current contract near lines 131-140 says a handler cannot exceed its execution budget plus 60 seconds, yet the 2026-10-27T14:04:07Z progress evidence records a 7,200-second handler lasting 10,265 seconds.

Inspect the handler launch, watchdog, cgroup/process-tree ownership, wait/reap behavior, and failure reporting. Implement a bounded termination path that cannot leave the gardener parent blocked when an overdue handler or descendant remains live: terminate the complete handler cgroup/tree, escalate after a bounded grace period, reap safely, and include concrete watchdog evidence in the recorded failure. Preserve existing completion/requeue semantics and unrelated worktree changes. Add or update focused tests for the watchdog implementation where practical, run the relevant test suite, commit explicit pathspecs, and push to `main2` using the required garden repository lock and rebase CAS loop from the job prompt.

This is the first serial slice of `improve-enforce-handler-wall-bound-split`. Its successor `improve-enforce-handler-wall-bound-regression` owns the adversarial descendant regression and final wall-bound validation. End with the orchestrated failure signal only if you genuinely finish this slice but cannot achieve its gated outcome.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T15:11:49Z
