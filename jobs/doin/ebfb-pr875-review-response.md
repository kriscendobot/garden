---
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T09:55:03Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/875 (OPEN, un-drafted, package imports field)

#875 has all CI checks green but carries a CHANGES_REQUESTED review. Read the review threads,
address the requested changes as follow-up commits (see skills/review-feedback-followup-commits),
reply to each thread, get the review resolved, and land the PR.

Ordering note: #875 and #876 both touch `EXPORTS_RESOLVER_JS`. This job runs BEFORE the #876
conductor job in the orchestration, so land #875 first; #876 will take the rebase.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T09:55:51Z
