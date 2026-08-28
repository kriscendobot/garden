from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-08-28T14:56:30Z
watchdog_key: provider-quota
notice_count: 43
first_seen: 2026-08-17T14:38:22Z
last_seen: 2026-08-28T14:56:30Z
---
WATCHDOG notice — occurrence #43 (first seen 2026-08-17T14:38:22Z, latest 2026-08-28T14:56:30Z).
The SAME condition (`provider-quota`) has now been observed 43 times; this is ONE
coalesced notice that updates in place, not 43 messages. Latest detail:

provider session limit reached: the API is refusing calls fleet-wide (resets 3pm (UTC) — the responder could NOT diagnose garden-proxy (rc=1); its capture is blob f5ee58b35f57e41c67a940fd358a60eb111d2f6e (git -C /home/kris/garden/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden-ece02cb4):
provider quota exceeded while running garden-proxy. Observed: You've hit your session limit · resets 3pm (UTC) — the responder could NOT diagnose garden-proxy (rc=1); its capture is blob f5ee58b35f57e41c67a940fd358a60eb111d2f6e (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f5ee58b35f57e41c67a940fd358a60eb111d2f6e).
