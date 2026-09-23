from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T01:33:22Z
doom_base: fu-guard-worker-self-disqualify-missing-agent-bin-1
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-19T01:33:22Z
last_seen: 2026-08-19T01:33:22Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/fu-guard-worker-self-disqualify-missing-agent-bin-1; it stays HELD until a human promotes it
(promote-plan.sh fu-guard-worker-self-disqualify-missing-agent-bin-1) or removes it, so nothing is lost.
Original job base: fu-guard-worker-self-disqualify-missing-agent-bin-1

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Garden repo (main2): `run-test.sh` currently has ~30 pre-existing failures (environmental — sandbox lacks network for `github.com:kriskowal/garden.git`, a shellcheck-wrapper subtest, a foreman fill-batch block), leaving the suite red by default so it can't gate anything. Fix or properly skip the environmental failures.
