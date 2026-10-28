from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1349-fix-maintainer-review
reply_to: endojs-endo-but-for-bots-pr1349-fix-maintainer-review
msg_key: msg-endojs-endo-but-for-bots-pr1349-fix-maintainer-review-b85d7da0a838
notice_count: 1
first_seen: 2026-10-28T05:57:58Z
last_seen: 2026-10-28T05:58:00Z
sent_at: 2026-10-28T05:58:00Z
---
PR endojs/endo-but-for-bots#1349: the staged ferry directive jobs/ferry/endojs-endo-but-for-bots-pr1349.md pins downstream_head b122ff91ef, but the head has moved. Panel follow-ups took it to 1e19cde89b, and this fix job (it restored the measured Chromium codec range kriskowal asked for in r4392486550) took it to 991f8af47e. CI is green there (15/15). As written, the boatman will block on the head check, so the directive needs re-staging at 991f8af47e before ferrying.
