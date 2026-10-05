---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
scripts/jobs/auto-gauntlet-handoff.sh:97 only stages non-design PRs for declared builder roles, so the role-less producer that opened draft #160 at 2026-10-05T15:22Z was missed; stage any bot-authored draft producer artifact unless it matches the existing probe or open-question exceptions, retaining PR-keyed idempotence.
