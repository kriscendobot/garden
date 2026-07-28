from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-07-28T15:08:08Z
watchdog_key: provider-quota
notice_count: 4
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-07-28T15:08:08Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-07-28T08:48:08Z, latest 2026-07-28T15:08:08Z).
The SAME condition (`provider-quota`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

provider quota/usage limit reached — the API is refusing calls fleet-wide (resets 3:20pm (UTC) — the responder could NOT diagnose garden-follow-up (rc=1); its capture is blob 3e7fbeddf04eadf1a607f343e1834219c0b05ffa (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-follow-up. Observed: You've hit your session limit · resets 3:20pm (UTC) — the responder could NOT diagnose garden-follow-up (rc=1); its capture is blob 3e7fbeddf04eadf1a607f343e1834219c0b05ffa (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 3e7fbeddf04eadf1a607f343e1834219c0b05ffa).
