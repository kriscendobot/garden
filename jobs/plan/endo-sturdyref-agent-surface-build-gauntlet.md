---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-07-26T23:03:04Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-07-26T23:03:04Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: gardener
auto_gauntlet: true
build_job: endo-sturdyref-agent-surface-build
pr: https://github.com/endojs/endo-but-for-bots/pull/871
handler-timeout: 14000
---

Automatic gauntlet handoff for completed feature build endo-sturdyref-agent-surface-build.

The build opened https://github.com/endojs/endo-but-for-bots/pull/871 and it remains an OPEN draft PR. Run the full gardening
state machine now: clean, panel, fixer loop as needed, CI, then un-draft only when
the panel terminates cleanly. This handoff was posted by the build completion edge,
not inferred by a watcher.

Resume context (verified by press-driver endo-sturdyref-press-20260726-233502,
2026-07-26): the first gauntlet cycle COMPLETED the clean stage — it pushed
`076318a0b` (regenerate composite tsconfig) and `c3fa894c9` (satisfy documentation
type checks) to `build/sturdyref-agent-surface`, and PR #871 is 21/21 CI-green at
head `c3fa894c9`. Zero reviews exist on the PR: the PANEL stage never started.
Spend your budget there — do not redo clean or re-wait on already-green CI. The
`handler-timeout: 14000` header above raises this job's budget from the default
2400s to ~3.9h (within the 14339s claim-budget max), because the prior cycle's
deadline overrun is what poisoned this job.

<!-- garden-deadline-overrun: 1 -->
