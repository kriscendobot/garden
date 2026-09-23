from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-07-26T12:23:12Z
poison_base: build-exo-google-sheets
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-26T12:23:12Z
last_seen: 2026-07-26T12:23:12Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/build-exo-google-sheets; it stays HELD until a human promotes it
(promote-plan.sh build-exo-google-sheets) or removes it, so nothing is lost.
Original job base: build-exo-google-sheets

--- original job body ---
