from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-01T11:20:57Z
watchdog_key: provider-quota
notice_count: 22
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-08-01T11:20:57Z
---
WATCHDOG notice — occurrence #22 (first seen 2026-07-28T08:48:08Z, latest 2026-08-01T11:20:57Z).
The SAME condition (`provider-quota`) has now been observed 22 times; this is ONE
coalesced notice that updates in place, not 22 messages. Latest detail:

provider quota/usage limit reached — the API is refusing calls fleet-wide (resets 1:20pm (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob a172bc4e7c993e56d9e40af119d0675bc5b2542a (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-mentor. Observed: You've hit your session limit · resets 1:20pm (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob a172bc4e7c993e56d9e40af119d0675bc5b2542a (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p a172bc4e7c993e56d9e40af119d0675bc5b2542a).
