from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T14:38:22Z
watchdog_key: provider-quota
notice_count: 1
first_seen: 2026-08-17T14:38:22Z
last_seen: 2026-08-17T14:38:22Z
---
provider session limit reached: the API is refusing calls fleet-wide (resets 4:20pm (UTC) — the responder could NOT diagnose garden-comment-watcher@kriscendobot-moddable (rc=1); its capture is blob 7fa04ccc5edef208cae405a6420efbdd86536c68 (git -C /home/kris/garden2/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-comment-watcher@kriscendobot-moddable. Observed: You've hit your session limit · resets 4:20pm (UTC) — the responder could NOT diagnose garden-comment-watcher@kriscendobot-moddable (rc=1); its capture is blob 7fa04ccc5edef208cae405a6420efbdd86536c68 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 7fa04ccc5edef208cae405a6420efbdd86536c68).
