---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-plan.sh
Defect: scripts/jobs/post-plan.sh:151-183 has no structured way to stamp the indivisible split reason and enlarged timeout, so the 2026-10-05T21:04:26Z completion gate rejected a child whose required metadata existed only unreliably in agent prose. Add validated `--split-indivisible-reason` and `--split-indivisible-handler-timeout` options for orchestrated children and emit both as frontmatter atomically with the child. Reject either option outside an orchestrated child or when supplied alone, and add a regression test covering the subsequent `assert-overrun-split-posted.sh` acceptance path. Update the reaper handoff instructions to require these script options rather than hand-authored body fields.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-05T21:22:05Z
