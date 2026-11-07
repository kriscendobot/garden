from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T15:23:15Z
doom_base: improve-claude-completion-finalizer
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T15:23:15Z
last_seen: 2026-11-07T15:23:15Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-claude-completion-finalizer; it stays HELD until a human promotes it
(promote-plan.sh improve-claude-completion-finalizer) or removes it, so nothing is lost.
Original job base: improve-claude-completion-finalizer

--- original job body ---
---
posted_at: 2026-11-07T14:52:23Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/handlers/monk-claude.sh
scripts/jobs/handlers/monk-claude.sh:522 permits a single completion nudge, after which three unrelated Anthropic jobs ended cleanly without the required marker at 2026-11-07T14:24Z. Add a bounded finalizer continuation for a markerless successful nudge, with an explicit verify-or-handoff prompt and a regression fixture for two clean `end_turn` responses. Preserve fail-closed semantics: write the sentinel only after the verified completion marker.
