from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T15:38:22Z
watchdog_key: provider-quota
notice_count: 25
first_seen: 2026-08-17T14:38:22Z
last_seen: 2026-08-17T15:38:22Z
---
WATCHDOG notice — occurrence #25 (first seen 2026-08-17T14:38:22Z, latest 2026-08-17T15:38:22Z).
The SAME condition (`provider-quota`) has now been observed 25 times; this is ONE
coalesced notice that updates in place, not 25 messages. Latest detail:

provider session limit reached: the API is refusing calls fleet-wide (resets 4:20pm (UTC) — the responder could NOT diagnose garden-comment-watcher@kriscendobot-ocapn (rc=1); its capture is blob 912a506436dfdacc9e103f5523f5e68965fbbf68 (git -C /home/kris/garden2/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-comment-watcher@kriscendobot-ocapn. Observed: You've hit your session limit · resets 4:20pm (UTC) — the responder could NOT diagnose garden-comment-watcher@kriscendobot-ocapn (rc=1); its capture is blob 912a506436dfdacc9e103f5523f5e68965fbbf68 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 912a506436dfdacc9e103f5523f5e68965fbbf68).
