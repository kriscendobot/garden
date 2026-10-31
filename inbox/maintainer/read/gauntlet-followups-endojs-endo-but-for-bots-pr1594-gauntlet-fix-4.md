from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1594-gauntlet-fix-4
reply_to: endojs-endo-but-for-bots-pr1594-gauntlet-fix-4
msg_key: gauntlet-followups-endojs-endo-but-for-bots-pr1594-gauntlet-fix-4
notice_count: 1
first_seen: 2026-10-31T22:17:02Z
last_seen: 2026-10-31T22:17:04Z
sent_at: 2026-10-31T22:17:04Z
---
Gauntlet stage "endojs-endo-but-for-bots-pr1594-gauntlet-fix-4" ("endojs-endo-but-for-bots-pr1594-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups
- On base, 31 tests in `test/endo.test.js` fail under `test:rust` (Rust supervisor plus XS manager), mainly session owners, native sessions, stored blobs and garbage collection. Under `ENDO_BIN` without `ENDO_NODE_WORKER_BIN`, the file also crashes on load (`testNeedsNodeWorker.serial is not a function`). Both need fixing before `test:rust` can run in CI.
- The `http-content-plane` `ClientDestroyedError` flake on macOS is still there.
