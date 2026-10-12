from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr174-gauntlet-fix-9
reply_to: kriscendobot-minion.town-pr174-gauntlet-fix-9
msg_key: msg-kriscendobot-minion.town-pr174-gauntlet-fix-9-ea23b4173799
notice_count: 1
first_seen: 2026-10-12T01:41:58Z
last_seen: 2026-10-12T01:41:59Z
sent_at: 2026-10-12T01:41:59Z
---
kriscendobot/minion.town#174 (interim credit metering, no ERTP) needs a maintainer decision. The panel-9 decomplector asks you to confirm it.

Does your 2026-10-09 decision to build metering "without ERTP" also waive two things?
1. The durable `reserved` event and the never-guess-zero reconciler from clip-usage-metering § 4 (approved on kriscendobot/minion.town#42).
2. The Endo / DynamoDB persistence you asked for in the kriscendobot/minion.town#42 and kriscendobot/minion.town#45 reviews.

What the interim does instead: it keeps reservations in memory in the gateway, stores the ledger as a JSONL file, and lets a charge that fails after a successful publish go unbilled (it is logged).

designs/ertp-credits.md § 6a now states both departures and says they await your confirmation. Reply yes to keep the interim as it is, or no to rebase it onto the durable § 4 shape.
https://github.com/kriscendobot/minion.town/pull/174
