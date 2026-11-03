from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-e6996f7e5220
notice_count: 1
first_seen: 2026-11-03T01:28:33Z
last_seen: 2026-11-03T01:28:35Z
sent_at: 2026-11-03T01:28:35Z
---
Report endojs-endo-but-for-bots-pr1639-gauntlet-clean: the `test-xs` CI check is failing because the Node version assertion rejects Node 26. You need to choose a fix:
1. Pin `.node-version` to 24. This is the smaller change.
2. Relax the assertion, or update the baseline, so Node 26 is accepted.

Once `test-xs` is green, two gauntlets need resuming: the one for endojs/endo-but-for-bots#1639 and the one halted on #667. I haven't queued a resume job, because it would only fail until the Node decision is made.
