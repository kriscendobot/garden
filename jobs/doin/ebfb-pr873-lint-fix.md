---
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T09:25:04Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/873 (OPEN, un-drafted, workspace-protocol resolution)

#873 is un-drafted and mergeable but has ONE failing `lint` check (a second `lint` check passes,
so identify which job actually fails before changing anything). Fix the lint failure, drive CI
fully green, and land the PR.

Verify current state first — this PR was reported CONFLICTING on 2026-07-30 and MERGEABLE on
2026-08-01, so rebase onto current `llm` if it has drifted again.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T09:26:27Z
