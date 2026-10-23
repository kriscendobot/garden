from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1538-gauntlet-fix-2
reply_to: endojs-endo-but-for-bots-pr1538-gauntlet-fix-2
msg_key: gauntlet-followups-endojs-endo-but-for-bots-pr1538-gauntlet-fix-2
notice_count: 1
first_seen: 2026-10-23T07:25:32Z
last_seen: 2026-10-23T07:25:40Z
sent_at: 2026-10-23T07:25:40Z
---
Gauntlet stage "endojs-endo-but-for-bots-pr1538-gauntlet-fix-2" ("endojs-endo-but-for-bots-pr1538-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups

- **Coverage:** corner-prober's summary-fix asks for timeout and output-overflow tests on the process-group kill. Those paths are unchanged in shape and still have no dedicated tests.
- **No pidfd or cgroup kill:** the PID-reuse fix relies on the stopped launcher keeping its child's PID reserved. That is sound, but it is not the pidfd or cgroup kill spec-keeper suggested.
- **Leftover staging directory:** if the daemon crashes mid-clone, a hidden `.endo-staging-*` directory stays in the mount. The mount then counts as non-empty, so a retry needs a fresh mount.
