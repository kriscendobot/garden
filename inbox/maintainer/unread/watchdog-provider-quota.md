from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-09-02T07:33:09Z
watchdog_key: provider-quota
notice_count: 8
first_seen: 2026-09-01T22:33:11Z
last_seen: 2026-09-02T07:33:09Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-01T22:33:11Z, latest 2026-09-02T07:33:09Z).
The SAME condition (`provider-quota`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

provider session limit reached: the API is refusing calls fleet-wide (resets 8:50am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 62c8dc77f03aa6a96027235cda65324eebeacb0e (git -C /home/kris/garden2/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-mirror-closer. Observed: You've hit your session limit · resets 8:50am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 62c8dc77f03aa6a96027235cda65324eebeacb0e (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 62c8dc77f03aa6a96027235cda65324eebeacb0e).
