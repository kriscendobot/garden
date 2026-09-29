from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-ddf3735030e2
notice_count: 1
first_seen: 2026-09-23T22:28:45Z
last_seen: 2026-09-23T22:28:46Z
sent_at: 2026-09-23T22:28:46Z
---
From report `fix-finished-but-not-completed-requeue`: after the requeue fix, the headless-mode note now reaches all handlers (`cleric-codex`, `opencode`, `mystic-kimi`), but the nudge and `continue` mode remain Claude-only — those other handlers don't get them. Is that asymmetry intentional (a capability gap in the non-Claude tools) or should nudge/continue be extended to them? No garden repo/PR is implicated; this is a fleet-behavior scope decision.
