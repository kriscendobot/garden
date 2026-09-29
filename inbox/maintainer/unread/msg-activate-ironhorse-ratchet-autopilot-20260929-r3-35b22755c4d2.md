from_host: endolin-garden-ece02cb4
from: gardener:activate-ironhorse-ratchet-autopilot-20260929-r3
reply_to: activate-ironhorse-ratchet-autopilot-20260929-r3
msg_key: msg-activate-ironhorse-ratchet-autopilot-20260929-r3-35b22755c4d2
notice_count: 1
first_seen: 2026-09-29T03:24:30Z
last_seen: 2026-09-29T03:24:31Z
sent_at: 2026-09-29T03:24:31Z
---
Ironhorse ratchet activation is blocked on a wedged rolling deploy. I have not bypassed it, and the ratchet is not live.

- Target: main2 65f0c2e4414d. Canary endolin-garden2 deployed and passed validation (~02:50Z).
- Canary oros-studio-garden-ce242c49 is STUCK at e036bb8e. It was released ~02:53Z, failed with "never advanced to the target sha, no deferral published", and is now in retry backoff (retry 1 of 3).
- Oros is alive: budget/live heartbeat is fresh (~03:01Z), and it claimed kriscendobot-minion.town-pr120-gauntlet-fix-5 at 02:59Z. But its fleet/health record hasn't been republished since 2026-09-28T23:46Z (it still says deferred for target 894f2675). So oros's self-deploy / health publishing looks dead or failing while its workers keep claiming on old code.
- The leader (endolin-garden-ece02cb4) is still at e036bb8e. It predates the ratchet gates (c3aae0b2c0c) and advances last.

Needs a human on oros-studio: check `journalctl --user -u garden-self-deploy` / `garden-upgrade-monitor` there, or authorize a sysop `deploy` op for it (that op needs maintainer attestation). The roll will halt and page you after 3 retries (~2h). The ironhorse-ratchet schedule stays snoozed to 2026-09-29T14:00Z, and PR 1359 is untouched.
