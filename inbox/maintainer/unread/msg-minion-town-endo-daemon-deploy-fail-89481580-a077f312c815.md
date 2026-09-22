from_host: endolin-garden-ece02cb4
from: gardener:minion-town-endo-daemon-deploy-fail-89481580
reply_to: minion-town-endo-daemon-deploy-fail-89481580
msg_key: msg-minion-town-endo-daemon-deploy-fail-89481580-a077f312c815
notice_count: 1
first_seen: 2026-09-22T14:56:47Z
last_seen: 2026-09-22T14:56:50Z
sent_at: 2026-09-22T14:56:50Z
---
minion.town live incident (deploy CD run 35738152776) — RESOLVED + durable fix landed.

Root cause: `kriscendobot/minion.town#110`'s endo pin bump to 89481580 (EndoGuest.invite/accept) crash-loops the endo-daemon on the production DB. 89481580 makes `registry` a REQUIRED HostFormula field but never implements the one-shot on-start registry-upgrade pass its own design (registry-capability.md § Migration for already-formulated hosts) promises. Every pre-existing prod host formula lacks `registry`, so formula-graph seeding throws `Invalid formula identifier "[undefined]"` and host incarnation throws `Host formula missing registry`. The daemon cannot start on any pre-registry DB. This is an upstream endo (`endojs/endo-but-for-bots`) defect.

Remediation applied:
1. Box restored immediately — swapped the intact previous build /opt/endo.old (f665050) back to /opt/endo, restarted; daemon is `active`, socket present, matching the still-deployed prior app client. Outage over.
2. Durable revert `kriscendobot/minion.town#111` (reverts the pin back to f665050) is MERGED → CD re-runs and rebuilds f665050 so the full deploy stack goes green.

Follow-up (your call): re-attempt the 89481580 bump ONLY after `endojs/endo-but-for-bots`@llm lands the promised host-formula registry migration. Or fix-forward by implementing that migration upstream instead of reverting.
