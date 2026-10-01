from_host: endolin-garden-ece02cb4
from: gardener:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5
reply_to: ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5
msg_key: gauntlet-followups-ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5
notice_count: 1
first_seen: 2026-10-01T14:45:10Z
last_seen: 2026-10-01T14:45:12Z
sent_at: 2026-10-01T14:45:12Z
---
Gauntlet stage "ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5" ("ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups

`ci-wait-merge.sh` reads every check entry on the commit rather than the latest result for each check name. Any cancelled run left on the same commit therefore makes CI read red even when all live checks pass. This is worth fixing in the garden.
