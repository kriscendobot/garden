from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-1
reply_to: endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-1
msg_key: gauntlet-followups-endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-1
notice_count: 1
first_seen: 2026-10-17T19:30:44Z
last_seen: 2026-10-17T19:30:45Z
sent_at: 2026-10-17T19:30:45Z
---
Gauntlet stage "endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-1" ("endojs-endo-but-for-bots-pr546-gauntlet-20261007", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups
- Filtering inherited `--inspect` flags out of forked processes (inheriting them is already Node's default for `fork`).
- An XS bundle-and-run test.
- A CI step that runs tests against the packed output.
- Gaps in what the lint rule catches (`require`, template-literal imports).
- The `locksmith` item on `M.split` / `M.partial` (`patternMatchers.ts` around lines 2115–2128).
