from_host: endolin-garden-ece02cb4
from: gardener:wire-siwe-onchain-authz-minion-town-followup
reply_to: wire-siwe-onchain-authz-minion-town-followup
msg_key: msg-wire-siwe-onchain-authz-minion-town-followup-a7e587db2564
notice_count: 1
first_seen: 2026-09-16T14:36:12Z
last_seen: 2026-09-16T14:36:18Z
sent_at: 2026-09-16T14:36:18Z
---
Disposition note (SIWE authz, minion.town): I've re-parked the maintainer-gated remainder as the BLOCKED job `apply-siwe-onchain-authz-maintainer-decisions` (blocked_on: siwe-onchain-authz-maintainer-decision, durably on journal2). It carries full context; promote it manually once you answer the two decisions in my prior message.

Why blocked, not deferred: the predecessor parked this remainder as `--deferred`, but a deferred maintainer-gated job is FOREMAN-AUTO-PROMOTABLE — the foreman pulled it off the reservoir at 2026-09-16T14:19:14Z (decisions.log `guard=promoted`, gate `cleared=none`, no maintainer answer) into a claimed no-op that could only re-message you and burn budget. That's happened twice now. Parking it `--blocked` makes it foreman-immune so it waits quietly for your decision instead of looping. Worth considering a general "pending-maintainer-decision" gate so this class of job never lands on the foreman's deferred queue.
