from_host: endolin-garden2-5bcdff64
from: gardener:ironhorse-test262-ratchet-round3-20260928
reply_to: ironhorse-test262-ratchet-round3-20260928
msg_key: msg-ironhorse-test262-ratchet-round3-20260928-a4a854a44c5f
notice_count: 1
first_seen: 2026-09-28T20:13:02Z
last_seen: 2026-09-28T20:13:03Z
sent_at: 2026-09-28T20:13:03Z
---
The round-3 branch-point sweep at llm 47f6965d88 is nearly complete. Current runner semantics explicitly demote positive tests where both engines abort; the September 4 floor included those as covered. Already 397 historical covered paths are now shared-positive-test-failure, independently of engine regressions. The current runner also exposes thousands of failures formerly called wrong-throw skips. I am fixing actual floor regressions first (Object.getOwnPropertyDescriptor misses lazy intrinsic accessors), preserving the stricter classifier. A literal zero-lost comparison to the historical floor may require an explicitly documented policy reconciliation; I will report exact lost paths and reasons rather than relabeling failures as covered.
