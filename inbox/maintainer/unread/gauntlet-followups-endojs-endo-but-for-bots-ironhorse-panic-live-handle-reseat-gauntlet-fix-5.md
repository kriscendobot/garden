from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5
reply_to: endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5
msg_key: gauntlet-followups-endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5
notice_count: 1
first_seen: 2026-09-30T21:51:14Z
last_seen: 2026-09-30T21:51:16Z
sent_at: 2026-09-30T21:51:16Z
---
Gauntlet stage "endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5" ("endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups

- **Should-fix items not done:**
  - no hasher test across suspend and resume past the size limit;
  - no test for a crank that stages no outbound frames;
  - no `proptest` round-trip test for the CAS store;
  - no statement context in the SQLite params-parse error.
- **Local build setup:** to build, I initialized the `c/moddable` submodule in the project checkout.
