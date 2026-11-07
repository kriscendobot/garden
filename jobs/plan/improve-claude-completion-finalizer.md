---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-07T15:23:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T15:23:06Z
---

---
posted_at: 2026-11-07T14:52:23Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/handlers/monk-claude.sh
scripts/jobs/handlers/monk-claude.sh:522 permits a single completion nudge, after which three unrelated Anthropic jobs ended cleanly without the required marker at 2026-11-07T14:24Z. Add a bounded finalizer continuation for a markerless successful nudge, with an explicit verify-or-handoff prompt and a regression fixture for two clean `end_turn` responses. Preserve fail-closed semantics: write the sentinel only after the verified completion marker.
