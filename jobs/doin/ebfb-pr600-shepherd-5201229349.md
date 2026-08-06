---
role: shepherd
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=urgent at=2026-08-06T07:40:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

# Shepherd endojs/endo-but-for-bots PR 600 to green

Maintainer directive: https://github.com/endojs/endo-but-for-bots/pull/600#issuecomment-5201229349

Use an isolated project worktree keyed by this child basename. Run the repository local gates that correspond to CI before pushing. Drive every CI check for the current PR head to terminal green, classify failures, fix in-scope defects with fixup commits against the retconned history, close any local-versus-CI automation gap, and rerun affected gates. Do not complete while checks are pending or red. Post the required completion summary with the green run URLs.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-06T07:40:10Z
