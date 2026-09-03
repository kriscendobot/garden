from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-09-03T01:33:09Z
watchdog_key: provider-quota
notice_count: 13
first_seen: 2026-09-01T22:33:11Z
last_seen: 2026-09-03T01:33:09Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-09-01T22:33:11Z, latest 2026-09-03T01:33:09Z).
The SAME condition (`provider-quota`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

provider weekly limit reached: the API is refusing calls fleet-wide (resets Sep 5, 3am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 564c3b4f64271910d722c6bc244362c0b7f7dc91 (git -C /home/kris/garden2/).
limit_type: weekly
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-mirror-closer. Observed: You've hit your weekly limit · resets Sep 5, 3am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 564c3b4f64271910d722c6bc244362c0b7f7dc91 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 564c3b4f64271910d722c6bc244362c0b7f7dc91).
