from_host: endolin-garden2-5bcdff64
from: watchdog:monk/1
sent_at: 2026-09-28T14:26:51Z
watchdog_key: handler-budget-overrun-verify-demo2-cross-host-locator-instructions
notice_count: 1
first_seen: 2026-09-28T14:26:51Z
last_seen: 2026-09-28T14:26:51Z
---
gardener job 'verify-demo2-cross-host-locator-instructions' declared handler-timeout=14400s, which exceeds what a single claim can hold (max 14339s = GARDEN_CLAIM_TTL 14400s − GARDEN_HANDLER_KILL_AFTER 60s − 1). A run-to-completion handler that needs longer than one claim cannot be claim-scoped without breaking the duplicate-execution guard: after GARDEN_CLAIM_TTL the reaper would requeue the same base onto a second gardener while this one is still running. Run it DETACHED (outside the claim-scoped handler) or SPLIT it into claim-sized stages. This cycle the handler runs clamped at 14339s and will be SIGTERM-killed at that bound — it will not complete.
