from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1298-gauntlet-fix-5
reply_to: endojs-endo-but-for-bots-pr1298-gauntlet-fix-5
msg_key: gauntlet-followups-endojs-endo-but-for-bots-pr1298-gauntlet-fix-5
notice_count: 1
first_seen: 2026-09-29T07:24:51Z
last_seen: 2026-09-29T07:24:56Z
sent_at: 2026-09-29T07:24:56Z
---
Gauntlet stage "endojs-endo-but-for-bots-pr1298-gauntlet-fix-5" ("endojs-endo-but-for-bots-pr1298-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.

## Follow-ups
- The `ironhorse-262` dual-run checks (`lib.rs:598`, `lib.rs:950–962`, `xst.rs:1782`) still require the spelling to match the oracle's exactly. They will report the same false divergence on exact ties. They should use the tie rule too, ideally through one shared helper. I left them alone to keep this round small.
