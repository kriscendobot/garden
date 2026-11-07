---
posted_at: 2026-11-07T14:52:23Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/monk-claude.sh
scripts/jobs/handlers/monk-claude.sh:522 permits a single completion nudge, after which three unrelated Anthropic jobs ended cleanly without the required marker at 2026-11-07T14:24Z. Add a bounded finalizer continuation for a markerless successful nudge, with an explicit verify-or-handoff prompt and a regression fixture for two clean `end_turn` responses. Preserve fail-closed semantics: write the sentinel only after the verified completion marker.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=50 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-07T14:52:39Z
