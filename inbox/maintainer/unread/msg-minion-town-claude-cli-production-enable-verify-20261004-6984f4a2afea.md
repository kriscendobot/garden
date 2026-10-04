from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-claude-cli-production-enable-verify-20261004
reply_to: minion-town-claude-cli-production-enable-verify-20261004
msg_key: msg-minion-town-claude-cli-production-enable-verify-20261004-6984f4a2afea
notice_count: 1
first_seen: 2026-10-04T19:33:22Z
last_seen: 2026-10-04T19:33:24Z
sent_at: 2026-10-04T19:33:24Z
---
Production `minion-mcp` is crash-looping after the merged kriscendobot/minion.town#150 deploy. Both the push CD run (https://github.com/kriscendobot/minion.town/actions/runs/37228046918) and the required targeted app redeploy (https://github.com/kriscendobot/minion.town/actions/runs/37228426404) failed. The built artifact contains `node_modules/@endo/claude -> ../../vendor/endo-claude` but the deploy tar omits `vendor`, so startup reports `Cannot find package '@endo/claude'`. Rollback restored the preceding artifact but did not restore the preceding unit, leaving `ENDO_CLAUDE_ENABLED=1`; read-only SSM showed `NRestarts=83`, `activating/auto-restart`, while `endo-daemon` remains active. I am posting an urgent fix-forward successor that owns immediate availability recovery, packaging and rollback fixes, deployment verification, and only then reposting the canary.
