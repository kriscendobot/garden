from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-09-01T22:33:11Z
watchdog_key: provider-quota
notice_count: 1
first_seen: 2026-09-01T22:33:11Z
last_seen: 2026-09-01T22:33:11Z
---
provider session limit reached: the API is refusing calls fleet-wide (resets 10:50pm (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob aa43ec0bd60540c6b29db8ced88d5f611e990642 (git -C /home/kris/garden2/).
limit_type: session
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
provider quota exceeded while running garden-mirror-closer. Observed: You've hit your session limit · resets 10:50pm (UTC) — the responder could NOT diagnose garden-mirror-closer (rc=1); its capture is blob aa43ec0bd60540c6b29db8ced88d5f611e990642 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p aa43ec0bd60540c6b29db8ced88d5f611e990642).
