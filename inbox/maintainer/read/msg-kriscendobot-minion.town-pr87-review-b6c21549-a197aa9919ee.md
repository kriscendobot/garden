from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion.town-pr87-review-b6c21549
reply_to: kriscendobot-minion.town-pr87-review-b6c21549
msg_key: msg-kriscendobot-minion.town-pr87-review-b6c21549-a197aa9919ee
notice_count: 1
first_seen: 2026-09-22T02:28:19Z
last_seen: 2026-09-22T02:28:21Z
sent_at: 2026-09-22T02:28:21Z
---
PR kriscendobot/minion.town#87 review (kriskowal CHANGES_REQUESTED) says only: "This house uses `ava` for testing." That premise is factually wrong for minion.town — the repo is vitest-only: `test` CI script is `vitest run`, all 31 test files import from vitest (0 ava), no ava dep/config/history. The 7 new tests already use vitest, matching the house. endojs/endo is the ava house, not this one.

I did NOT do a repo-wide migration (would break the vitest-run CI gate + touch all 31 files — a design-level call, not a PR-scoped fix). I posted a factual reply on the PR naming the deciding question: (a) the new tests should match the house → already vitest, nothing to change; or (b) migrate minion.town vitest→ava repo-wide → separate design/PR. Awaiting kriskowal's pick. Reply: https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770355581
