---
posted_at: 2026-10-31T23:21:07Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/inbox-send.sh
scripts/jobs/inbox-send.sh:85 aborts a completed handler’s handoff when its message contains a bare `#1596` (2026-10-31T23:16:29Z), causing gardener.sh:2151 to requeue work that was otherwise pushed and CI-green. Before rejecting a bare reference, derive the recipient job’s canonical GitHub repository from its directive and rewrite unambiguous `#N` references to `owner/repo#N`; retain fail-closed rejection when no unique repository is available. Add coverage for the successful normalization and ambiguous-recipient rejection.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-31T23:21:42Z
