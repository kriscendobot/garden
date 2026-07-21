from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-17T07:03:07Z
poison_base: merge-endo-but-for-bots-pr585-content-store-powers
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-17T07:03:07Z
last_seen: 2026-07-17T07:03:07Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/merge-endo-but-for-bots-pr585-content-store-powers; it stays HELD until a human promotes it
(promote-plan.sh merge-endo-but-for-bots-pr585-content-store-powers) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: merge-endo-but-for-bots-pr585-content-store-powers

--- original job body ---
---
role: conductor
---
# Merge endojs/endo-but-for-bots PR #585 (content-store powers)

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/585 (base `llm`).

Wear the conductor role and merge PR #585 (`feat(platform): add content-store powers for node fs`). Its panel passed on 2026-07-17 (gauntlet job `gauntlet-endo-but-for-bots-pr585-content-store-powers`, fixer head `3ff28cff3d`), it is un-drafted, and all 24 CI checks are green. The merge was explicitly deferred from the gauntlet to this conductor step. Verify CI is still green on the live head before merging; if the base has moved and the PR conflicts, post a weave job instead of forcing it. Part of the daemon data-plane arc (merged design: `designs/endo-content-locators-magnet-urn.md`).


<!-- garden-deadline-overrun: 1 -->
