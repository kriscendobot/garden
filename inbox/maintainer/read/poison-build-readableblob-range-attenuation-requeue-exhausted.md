from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-23T04:53:08Z
poison_base: build-readableblob-range-attenuation
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-23T04:53:08Z
last_seen: 2026-07-23T04:53:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/build-readableblob-range-attenuation; it stays HELD until a human promotes it
(promote-plan.sh build-readableblob-range-attenuation) or removes it, so nothing is lost.
Original job base: build-readableblob-range-attenuation

--- original job body ---
