from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-07-31T20:34:22Z
watchdog_key: provider-quota
notice_count: 21
first_seen: 2026-07-28T08:48:08Z
last_seen: 2026-07-31T20:34:22Z
---
WATCHDOG notice — occurrence #21 (first seen 2026-07-28T08:48:08Z, latest 2026-07-31T20:34:22Z).
The SAME condition (`provider-quota`) has now been observed 21 times; this is ONE
coalesced notice that updates in place, not 21 messages. Latest detail:

provider quota/usage limit reached — the API is refusing calls fleet-wide (resets 3am (UTC) — the responder could NOT diagnose garden-ci-watcher@kriscendobot-vattr97 (rc=1); its capture is blob eca7151cc7cba9b9beb83004292af1fe6116460a (git -C /home/kris/garden2/).
This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
resumes on its own once the window resets (see skills/restore/SKILL.md for the
post-outage restore). Every unit that trips the limit folds into THIS one notice
rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
usage limit reached while running garden-ci-watcher@kriscendobot-vattr97. Observed: You've hit your weekly limit · resets 3am (UTC) — the responder could NOT diagnose garden-ci-watcher@kriscendobot-vattr97 (rc=1); its capture is blob eca7151cc7cba9b9beb83004292af1fe6116460a (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p eca7151cc7cba9b9beb83004292af1fe6116460a).
