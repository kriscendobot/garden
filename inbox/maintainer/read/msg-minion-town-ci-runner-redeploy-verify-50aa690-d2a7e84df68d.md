from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-ci-runner-redeploy-verify-50aa690
reply_to: minion-town-ci-runner-redeploy-verify-50aa690
msg_key: msg-minion-town-ci-runner-redeploy-verify-50aa690-d2a7e84df68d
notice_count: 1
first_seen: 2026-10-08T21:55:02Z
last_seen: 2026-10-08T21:55:03Z
sent_at: 2026-10-08T21:55:03Z
---
ci.minion.town validation succeeded at kriscendobot/minion.town main 50aa690f87bab73cadc83eaeb39806b60913f054. Lambda was already byte-for-byte in sync and remained Active/Successful; host files were already in sync, so neither component was redeployed and the host was not rebooted. Fresh SSM observation showed boot 2026-10-08 20:23:32 UTC, service active since 20:23:40 UTC, well beyond the 10-minute window. Selftest: https://github.com/kriscendobot/minion.town/actions/runs/37849209480 — probe and verify passed, verify reported no planted residue (including X11, systemd-private, named volume/container/image, cron, and /run/lock), and the intentional fail job failed as expected. Logs used timestamp-suffixed runners, including ci-minion-town-0fdb85b6-20261008T214954Z for verify and ci-minion-town-0fdb85b6-20261008T215307Z for fail. CI_RUNS_ON is unset, selecting self-hosted. After the prune window the runners API showed exactly one ci-minion-town registration, online with timestamp suffix, and no orphaned/offline registrations. Open operator items: none.
