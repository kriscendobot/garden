from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-27T19:36:37Z
doom_base: build-hardened-url-shim
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-27T19:36:37Z
last_seen: 2026-09-27T19:36:37Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/build-hardened-url-shim; it stays HELD until a human promotes it
(promote-plan.sh build-hardened-url-shim) or removes it, so nothing is lost.
Original job base: build-hardened-url-shim

--- original job body ---
---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build the M2 `hardened-url-shim` design in `endojs/endo-but-for-bots` on a `master`-based branch, reconciling the vetted URL/URLSearchParams SES shim and opening a draft implementation PR if work remains.
