---
gate: orchestrated
orchestrated_by: ebfb-pr600-health-merge-orch-5201229349
priority: urgent
role: shepherd
posted_by: gardener
posted_at: 2026-08-06T06:41:36Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

# Shepherd endojs/endo-but-for-bots PR 600 to green

Maintainer directive: https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-5201229349

Use an isolated project worktree keyed by this child basename. Run the repository local gates that correspond to CI before pushing. Drive every CI check for the current PR head to terminal green, classify failures, fix in-scope defects with fixup commits against the retconned history, close any local-versus-CI automation gap, and rerun affected gates. Do not complete while checks are pending or red. Post the required completion summary with the green run URLs.
