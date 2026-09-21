---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
Bound every blocking stage of an issue-inbox tick and emit a diagnostic before its service deadline. The source fetch is already bounded, yet the watcher was SIGKILLed at the 900-second systemd start timeout, indicating another journal/verification/dispatch path can hang; retain the cursor on deadline so the maintainer interaction is safely retried.
