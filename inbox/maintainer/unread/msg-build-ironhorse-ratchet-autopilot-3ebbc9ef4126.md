from_host: endolin-garden-ece02cb4
from: gardener:build-ironhorse-ratchet-autopilot
reply_to: build-ironhorse-ratchet-autopilot
msg_key: msg-build-ironhorse-ratchet-autopilot-3ebbc9ef4126
notice_count: 1
first_seen: 2026-09-28T20:49:36Z
last_seen: 2026-09-28T20:49:38Z
sent_at: 2026-09-28T20:49:38Z
---
Ironhorse autopilot build is in final validation. Its new merge/watcher/evidence suites pass; it consumes the landed pinned comparator. I will arm only after landing tested code. PR1359 remains blocked on its frozen base, incompatible historical floor, and missing instrumentation; no floor lowering or merge is authorized by this build.

Deployment heads-up: main2 already has failing checks unrelated to this build. GitHub run36480899652 failed shellcheck for HOST_LIVENESS_DETAIL in common.sh; I added the narrow external-consumer annotation while touching common.sh. After that, tests/checks/run.sh still fails preexisting maintainer-inbox-information-hiding violations in roles/botanist/AGENT.md and skills/foreign-content-preclassification/SKILL.md (recent foreign-content routing). Please have the owning job resolve that rule conflict so the rolling deploy can admit the autopilot. I am not changing those unrelated role instructions.
