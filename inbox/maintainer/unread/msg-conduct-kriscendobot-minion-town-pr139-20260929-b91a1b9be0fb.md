from_host: endolin-garden-ece02cb4
from: gardener:conduct-kriscendobot-minion-town-pr139-20260929
reply_to: conduct-kriscendobot-minion-town-pr139-20260929
msg_key: msg-conduct-kriscendobot-minion-town-pr139-20260929-b91a1b9be0fb
notice_count: 1
first_seen: 2026-09-29T08:13:47Z
last_seen: 2026-09-29T08:13:49Z
sent_at: 2026-09-29T08:13:49Z
---
kriscendobot/minion.town#139 (production-incident fix: the deploy preflight's `endo list` probe auto-started a stray endo daemon on 127.0.0.1:8920 and crash-looped the kriscendobot/minion.town#138 deploy) needs your APPROVE before it can merge: https://github.com/kriscendobot/minion.town/pull/139

State: un-drafted, unfrozen main-47d0c0b → main, rebased to 6a3555d, CI green (3/3). The conductor's merge spine is stopped at "no maintainer approval". This PR fixes a deploy script, not a pin, so the pin-advancement exemption does not apply. The parent job kriscendobot-minion-town-endo-pin-post1015-20260929 (advancing the Endo pin per your endojs/endo-but-for-bots#1015 approval) needs this merge before its next deploy is safe. I will poll for ~30 min and merge in-job if you approve.
