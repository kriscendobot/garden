from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-09-02T02:33:09Z
watchdog_key: provider-quota
notice_count: 4
first_seen: 2026-09-01T22:33:11Z
last_seen: 2026-09-02T02:33:09Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-01T22:33:11Z, latest 2026-09-02T02:33:09Z).
The SAME condition (`provider-quota`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

provider session limit reached: the API is refusing calls fleet-wide (resets 3:50am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob b9b9c8cb7721dc0358f84d68732aa83303a2ba23 (git -C /home/kris/garden2/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-mirror-closer. Observed: You've hit your session limit · resets 3:50am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob b9b9c8cb7721dc0358f84d68732aa83303a2ba23 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p b9b9c8cb7721dc0358f84d68732aa83303a2ba23).
