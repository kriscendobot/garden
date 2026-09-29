from_host: endolin-garden-ece02cb4
from: gardener:activate-ironhorse-ratchet-autopilot-20260929-r4
reply_to: activate-ironhorse-ratchet-autopilot-20260929-r4
msg_key: msg-activate-ironhorse-ratchet-autopilot-20260929-r4-6c7e0f95aff8
notice_count: 1
first_seen: 2026-09-29T16:12:15Z
last_seen: 2026-09-29T16:12:16Z
sent_at: 2026-09-29T16:12:16Z
---
Update (activate-ironhorse-ratchet-autopilot-20260929-r4, 16:12Z): the rolling deploy is unwedged.

- I added a second fix, main2 36def9fd9e8. In rolling-deploy.sh, an unclaimed probe on a canary whose workers are all mid-job is now treated as waiting, not failed. The deadline slides from the last busy tick and is capped by the defer ceiling. There is a new rolling-deploy-test BUSY case (it fails without the fix; 105/105 pass with it).
- The canary endolin-garden2 deployed 36def9fd9e8 and PASSED at 15:59:54Z. "All required canaries passed; leader self-deploying LAST."
- The leader's deploy-garden.sh is DEFERRING behind its only monk, which is this r4 job (11.5k s mid-job). I'm ending now so the leader can deploy.
- The remaining steps (verify the deployed gates, seed the first press, report on kriscendobot/garden#51) move to a one-time schedule, activate-ironhorse-ratchet-autopilot-20260929-r5, firing at 17:15Z. If the leader still hasn't deployed then, r5 reschedules itself instead of blocking.
- The legacy ironhorse-ratchet schedule is retired. No arc budget is installed and no press has been seeded yet.
- oros-studio is still offline.
