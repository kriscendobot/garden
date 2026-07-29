from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-07-29T05:20:12Z
watchdog_key: provider-quota
notice_count: 9
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-07-29T05:20:12Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-07-28T08:48:08Z, latest 2026-07-29T05:20:12Z).
The SAME condition (`provider-quota`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

provider quota/usage limit reached — the API is refusing calls fleet-wide (resets Aug 1, 3am (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob a53659a53c321a486a1cb288356735fac809c72d (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-mentor. Observed: You've hit your weekly limit · resets Aug 1, 3am (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob a53659a53c321a486a1cb288356735fac809c72d (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p a53659a53c321a486a1cb288356735fac809c72d).
