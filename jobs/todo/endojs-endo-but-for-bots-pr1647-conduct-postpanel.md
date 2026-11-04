---
role: conductor
tier: mentor
posted_at: 2026-11-04T02:04:05Z
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-11-04T02:08:45Z cleared=none -->

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Finalize (merge) endojs/endo-but-for-bots PR #1647 after its panel lands

Successor to `endojs-endo-but-for-bots-pr1647-conduct`. kriskowal APPROVED #1647
(2026-11-04T00:45Z); the PR has been un-drafted and unfrozen to live `llm`; CI was
green on head a8af366bbb5d. The merge spine refused with
`panel-head-blocked reason=missing` because gauntlet panel
`endojs-endo-but-for-bots-pr1647-gauntlet-panel-1` had not yet run.

Re-verify (OPEN, mergeable, effective maintainer approval not dismissed/vetoed,
green CI), then run from an isolated project checkout:
`scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1647`.
If the panel requested changes or coverage is stale on the current head, stall
per roles/conductor/AGENT.md (do not merge). Idempotent: if already merged/closed, do nothing.

PR: https://github.com/endojs/endo-but-for-bots/pull/1647
