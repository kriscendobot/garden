---
gate: deferred
priority: normal
arc: moonshots
posted_by: producer
posted_at: 2026-10-07T21:29:53Z
---

---
role: fixer
tier: mentor
arc: moonshots
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Restart the gauntlet on https://github.com/endojs/endo-but-for-bots/pull/1379. Its prior gauntlet `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002` HALTED when its fix-1 stage failed once and was not retried. Maintainer approved a budgeted restart (liaison muster, 2026-10-07).

On promotion, first verify the PR is still OPEN. If it merged or closed, complete as a no-op. Otherwise run
`scripts/jobs/post-gauntlet.sh --arc moonshots endojs-endo-but-for-bots-pr1379-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/1379`
and complete. The gauntlet driver takes it from there.
