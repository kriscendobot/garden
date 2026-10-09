from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-10-09T11:03:11Z
watchdog_key: provider-quota
notice_count: 1
first_seen: 2026-10-09T11:03:11Z
last_seen: 2026-10-09T11:03:11Z
---
provider weekly limit reached: the API is refusing calls fleet-wide (resets 3am (UTC) — the responder could NOT diagnose garden-triager@kriscendobot-minion).
limit_type: weekly
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-triager@kriscendobot-minion.town. Observed: You've hit your weekly limit · resets 3am (UTC) — the responder could NOT diagnose garden-triager@kriscendobot-minion.town (rc=1); its capture is blob 4421fe70430212905f5469a14f22e0d832992939 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 4421fe70430212905f5469a14f22e0d832992939).
