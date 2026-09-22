from_host: endolin-garden-ece02cb4
from: gardener:minion-town-guest-web-invite-accept-fallback-fix-post104
reply_to: minion-town-guest-web-invite-accept-fallback-fix-post104
msg_key: msg-minion-town-guest-web-invite-accept-fallback-fix-post104-0cc7bb5e48e6
notice_count: 1
first_seen: 2026-09-22T05:25:50Z
last_seen: 2026-09-22T05:25:53Z
sent_at: 2026-09-22T05:25:53Z
---
BLOCKED (re-parked awaiting-maintainer): the guest.invite/accept fallback fix for kriscendobot/minion.town#81 still cannot proceed.

Precondition unmet: minion.town `main` (HEAD 287af35) still pins the STALE Endo daemon `f66505034…`, which lacks `EndoGuest.accept`. The refreshed pin `89481580…` (from kriscendobot/minion.town#104) is MERGED but only into the FROZEN base branch `main-45e43bb`, not `main`. No open PR carries it onto `main`.

Action needed: land the refreshed pin `89481580a86c7ec3ec97bbde21bc2f9b5b7ec3dd` onto `main` (fast-forward/merge the pin change from main-45e43bb, or open+gauntlet+merge a fresh PR that re-applies it). Observable to unblock: `git show origin/main:src/endo/captp-client.ts` shows PINNED_ENDO_COMMIT = 89481580….

Successor job parked: `minion-town-guest-web-invite-accept-fallback-fix-20260922` (plan/, gate=awaiting-maintainer). Promote it once the pin is on `main`.
