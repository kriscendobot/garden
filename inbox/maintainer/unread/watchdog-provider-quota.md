from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-09-02T05:35:11Z
watchdog_key: provider-quota
notice_count: 6
first_seen: 2026-09-01T22:33:11Z
last_seen: 2026-09-02T05:35:11Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-01T22:33:11Z, latest 2026-09-02T05:35:11Z).
The SAME condition (`provider-quota`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

provider session limit reached: the API is refusing calls fleet-wide (resets 8:50am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 1d4f71a60c237d137119b1482c336f981e65415e (git -C /home/kris/garden2/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-mirror-closer. Observed: You've hit your session limit · resets 8:50am (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob 1d4f71a60c237d137119b1482c336f981e65415e (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 1d4f71a60c237d137119b1482c336f981e65415e).
