from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-10-02T18:43:17Z
doom_base: build-confined-application-makers-p2-20261002
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-10-02T18:43:17Z
last_seen: 2026-10-02T18:43:17Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/build-confined-application-makers-p2-20261002; it stays HELD until a human promotes it
(promote-plan.sh build-confined-application-makers-p2-20261002) or removes it, so nothing is lost.
Original job base: build-confined-application-makers-p2-20261002

--- original job body ---
---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-02T17:04:05Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Phase 2: daemon capture for node-modules-with-map and node-modules-scan layouts, including the daemon canonical hook for mounts; EndoHost.makeFromTree gains layout and entry.

Repo endojs/endo-but-for-bots, base llm. Implement exactly the landed design https://github.com/endojs/endo-but-for-bots/blob/llm/designs/agent-confined-application-makers.md (merged via #1340, refs #1339/#1336) — read the full doc, especially § Phased implementation and § Test plan. Open a DRAFT PR via ensure-pr.sh (one PR per phase; stack on the previous phase's branch if it has not merged yet). Predecessor: endojs-endo-but-for-bots-pr1340-build-20261002.
