from_host: endolin-garden-ece02cb4
from: gardener:fu-endojs-endo-but-for-bots-pr1559-gauntlet-clean-1
reply_to: fu-endojs-endo-but-for-bots-pr1559-gauntlet-clean-1
msg_key: msg-fu-endojs-endo-but-for-bots-pr1559-gauntlet-clean-1-f77d7cf79dec
notice_count: 1
first_seen: 2026-10-26T02:11:00Z
last_seen: 2026-10-26T02:11:02Z
sent_at: 2026-10-26T02:11:02Z
---
The @endo/sandbox bwrap CI reds in endojs/endo-but-for-bots (`prlimit nproc` test: dash rejects `ulimit -u`; `parent death` test: no assertions) now hit every PR whose affected set includes @endo/sandbox, e.g. https://github.com/endojs/endo-but-for-bots/pull/1559 (sandbox-drivers, test, and cover legs). They started when ubuntu-latest moved to 26.04, where bwrap really runs.

The fix already exists: https://github.com/endojs/endo-but-for-bots/pull/1542 is un-drafted, CI-green, mergeable, and waiting on your review/merge word. It also carries a driver containment fix (--info-fd init kill). I did not open a duplicate test-only PR. Merging endojs/endo-but-for-bots#1542 (then re-running CI on endojs/endo-but-for-bots#1559) clears these reds. If you'd rather split out a test-only PR so the driver change can be reviewed on its own, say so and I'll post it.
