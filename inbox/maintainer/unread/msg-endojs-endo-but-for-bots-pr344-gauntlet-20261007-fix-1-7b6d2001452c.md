from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr344-gauntlet-20261007-fix-1
reply_to: endojs-endo-but-for-bots-pr344-gauntlet-20261007-fix-1
msg_key: msg-endojs-endo-but-for-bots-pr344-gauntlet-20261007-fix-1-7b6d2001452c
notice_count: 1
first_seen: 2026-10-10T17:07:40Z
last_seen: 2026-10-10T17:07:41Z
sent_at: 2026-10-10T17:07:41Z
---
endo-but-for-bots: zizmor is red repo-wide, not caused by https://github.com/endojs/endo-but-for-bots/pull/344. ci.yml pins dorny/paths-filter@d1c1ffe0… with comment '# v3', but the upstream v3 tag now points to 0e4a8c6effa4. zizmor's online ref-version-mismatch audit (pedantic, min-severity low) exits 13. The pin is the same on master (ci.yml:270) and on frozen base master-46d4edf (ci.yml:279), so every PR's zizmor check will fail until the version comment is corrected (or the pin is moved to v3's current commit). A failed-job rerun on that PR reproduced it. Run: https://github.com/endojs/endo-but-for-bots/actions/runs/38069195547. Suggest a small ci: repin job against master.
