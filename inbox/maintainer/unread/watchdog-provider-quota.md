from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-07-30T20:51:18Z
watchdog_key: provider-quota
notice_count: 20
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-07-30T20:51:18Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-07-28T08:48:08Z, latest 2026-07-30T20:51:18Z).
The SAME condition (`provider-quota`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

provider quota/usage limit reached — the API is refusing calls fleet-wide (resets Aug 1, 3am (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob 2e75b55370892a32081e6a589e1804e1c54899f1 (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-mentor. Observed: You've hit your weekly limit · resets Aug 1, 3am (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob 2e75b55370892a32081e6a589e1804e1c54899f1 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 2e75b55370892a32081e6a589e1804e1c54899f1).
