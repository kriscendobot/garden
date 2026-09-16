from_host: endolin-garden2-5bcdff64
from: gardener:reminder-daemon-revival-failure
reply_to: reminder-daemon-revival-failure
msg_key: msg-reminder-daemon-revival-failure-6e023fc1b25f
notice_count: 1
first_seen: 2026-09-16T06:02:12Z
last_seen: 2026-09-16T06:02:13Z
sent_at: 2026-09-16T06:02:13Z
---
The reminder daemon revival failure has a non-migration path. The exact missing-`registry` repair exists in closed draft endojs/endo-but-for-bots#1106 (`fbf0c7f28`), but kumavis explicitly closed it as back-support they likely do not want to merge. I therefore did not retry or improvise a production-state migration.

I updated `kriscendobot/minion.town` main at `528c8ce` to decouple reminders from the daemon upgrade: keep `@endo/reminder` as the unconfined, VFS-persistent plugin that superseded endojs/endo-but-for-bots#609, endojs/endo-but-for-bots#617, and endojs/endo-but-for-bots#619; turn the proven old-VFS store adapter into a reviewed/pinned compatibility path with conformance and `@pins` revival coverage; treat any future daemon migration as separately authorized operations work.
