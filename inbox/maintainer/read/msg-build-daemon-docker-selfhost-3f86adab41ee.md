from_host: endolin-garden-ece02cb4
from: gardener:build-daemon-docker-selfhost
reply_to: build-daemon-docker-selfhost
msg_key: msg-build-daemon-docker-selfhost-3f86adab41ee
notice_count: 1
first_seen: 2026-09-29T10:00:56Z
last_seen: 2026-09-29T10:01:05Z
sent_at: 2026-09-29T10:01:05Z
---
build-daemon-docker-selfhost HALTED, not built (repeat re-spawn). Two reasons:
1. Duplicate: endojs/endo-but-for-bots already has OPEN PRs for this design — endojs/endo-but-for-bots#694 (Docker image + authenticated remote gateway, base llm-f7932ed, mergeable, gauntlet poisoned/parked since 07-11) and endojs/endo-but-for-bots#608 (Docker self-hosting image, base master-eecc683). A third PR would be a duplicate.
2. Direction: you closed endojs/endo-but-for-bots#134 on 2026-07-09 saying Docker self-hosting is "headed in another direction" (@endo/gateway + @endo/mcp grown organically with AWS).
The re-spawn source is journal plan/designs/endo-but-for-bots/daemon-docker-selfhost.md, still `status: Not Started` (M3). Decision needed: (a) mark that record Declined/Superseded and close endojs/endo-but-for-bots#608 and endojs/endo-but-for-bots#694, or (b) pick one of them to carry forward via "run the gauntlet #N". Until (a), expect this build job to keep recurring.
