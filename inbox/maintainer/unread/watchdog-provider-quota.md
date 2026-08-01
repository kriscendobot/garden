from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-01T22:20:44Z
watchdog_key: provider-quota
notice_count: 23
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-08-01T22:20:44Z
---
WATCHDOG notice — occurrence #23 (first seen 2026-07-28T08:48:08Z, latest 2026-08-01T22:20:44Z).
The SAME condition (`provider-quota`) has now been observed 23 times; this is ONE
coalesced notice that updates in place, not 23 messages. Latest detail:

provider quota/usage limit reached — the API is refusing calls fleet-wide (resets 11:50pm (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob 34adc89906dcd76ff708e1df804b2566d0b60e07 (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-mentor. Observed: You've hit your session limit · resets 11:50pm (UTC) — the responder could NOT diagnose garden-mentor (rc=1); its capture is blob 34adc89906dcd76ff708e1df804b2566d0b60e07 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 34adc89906dcd76ff708e1df804b2566d0b60e07).
