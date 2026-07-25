role: builder

Resume the mandatory code-panel gate for https://github.com/kriscendobot/finbot/pull/4 after the documented Claude weekly-quota reset (2026-07-25T03:00:00Z).

Use an isolated project worktree from ensure-project-worktree.sh keyed to this job, checkout origin/feat/harness-compartment-role-program, and run scripts/jobs/gardening/panel.sh against PR 4 with origin/main as the diff base. The PR is already ready for review, so do not alter its draft state merely to rerun the gate. Preserve panel evidence in the completion report. Do not merge.

If the panel passes, dispatch the required Fable orchestrator sign-off job with basename finbot-pr4-fable-signoff, role: orchestrator, model: claude-fable-5. Its body must name https://github.com/kriscendobot/finbot/pull/4 and the panel result, and must authorize review/sign-off and merge only after sign-off. If the panel requests changes, report the findings and hand off a fixer instead.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-25T03:43:08Z
