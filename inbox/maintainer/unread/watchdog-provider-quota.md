from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-28T11:59:47Z
watchdog_key: provider-quota
notice_count: 42
first_seen: 2026-08-17T14:38:22Z
last_seen: 2026-08-28T11:59:47Z
---
WATCHDOG notice — occurrence #42 (first seen 2026-08-17T14:38:22Z, latest 2026-08-28T11:59:47Z).
The SAME condition (`provider-quota`) has now been observed 42 times; this is ONE
coalesced notice that updates in place, not 42 messages. Latest detail:

provider weekly limit reached: the API is refusing calls fleet-wide (resets 3am (UTC) — the responder could NOT diagnose garden-hermit (rc=1); its capture is blob 9bd6a9a0226ecd8b2fb7d5da1247e0a175872ad8 (git -C /home/kris/garden2/).
limit_type: weekly
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-hermit. Observed: You've hit your weekly limit · resets 3am (UTC) — the responder could NOT diagnose garden-hermit (rc=1); its capture is blob 9bd6a9a0226ecd8b2fb7d5da1247e0a175872ad8 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 9bd6a9a0226ecd8b2fb7d5da1247e0a175872ad8).
