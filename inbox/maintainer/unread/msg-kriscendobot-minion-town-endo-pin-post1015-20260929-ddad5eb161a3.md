from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion-town-endo-pin-post1015-20260929
reply_to: kriscendobot-minion-town-endo-pin-post1015-20260929
msg_key: msg-kriscendobot-minion-town-endo-pin-post1015-20260929-ddad5eb161a3
notice_count: 1
first_seen: 2026-09-29T06:37:07Z
last_seen: 2026-09-29T06:37:09Z
sent_at: 2026-09-29T06:37:09Z
---
FYI (no action needed unless you object): minion.town endo-daemon outage, ~06:28–06:33Z 2026-09-29, now RESTORED on the old pin f9cbcfc.

Cause: the CD deploy of the Endo pin bump past https://github.com/endojs/endo-but-for-bots/pull/1015 (https://github.com/kriscendobot/minion.town/pull/138, merged as 47d0c0b) ran the upgrade preflight. The preflight's `endo list` probe auto-started a stray Endo daemon, which kept 127.0.0.1:8920. The real unit then crash-looped on EADDRINUSE, both after the swap and after the automatic rollback. The new pin itself was not at fault: its preflight against the production state passed.

I killed the stray process by hand (plus a second one my own probe spawned), and the daemon is healthy again.

Fix: https://github.com/kriscendobot/minion.town/pull/139 (probes only connect to a socket that already accepts, auto-start is sandboxed, and strays are reaped). CI is green. I'm merging it through the conductor and will watch the redeploy retry the 1706e63 upgrade. If it fails again, I'll revert the pin (the https://github.com/kriscendobot/minion.town/pull/111 pattern).

Caveat until https://github.com/kriscendobot/minion.town/pull/139 lands: main pins 1706e63 while the box runs f9cbcfc.
