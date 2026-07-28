from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-07-28T08:48:08Z
watchdog_key: provider-quota
notice_count: 1
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-07-28T08:48:08Z
---
provider quota/usage limit reached — the API is refusing calls fleet-wide (resets 10am (UTC) — the responder could NOT diagnose garden-follow-up (rc=1); its capture is blob b7a514900ae49ec23340aec5ff8f23bcc8777969 (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-follow-up. Observed: You've hit your session limit · resets 10am (UTC) — the responder could NOT diagnose garden-follow-up (rc=1); its capture is blob b7a514900ae49ec23340aec5ff8f23bcc8777969 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p b7a514900ae49ec23340aec5ff8f23bcc8777969).
