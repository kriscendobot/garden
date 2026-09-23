from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-22T23:03:09Z
poison_base: endojs-endo-but-for-bots-pr826-build
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-22T23:03:09Z
last_seen: 2026-07-22T23:03:09Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr826-build; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr826-build) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr826-build

--- original job body ---
---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=high at=2026-07-22T22:11:04Z -->

# Build the approved ReadableBlob range-attenuation design from PR #826

Repository: endojs/endo-but-for-bots
Design PR: https://github.com/endojs/endo-but-for-bots/pull/826

Wear the builder role. After the conductor has successfully merged design PR #826 into llm, implement that approved design against the then-current llm branch. Open or update the implementation as a DRAFT pull request, preserve the design intent, add proportionate tests and documentation, and run the repository-required local verification. This is a mergeable-feature build, so carry the resulting draft PR through the automatic gauntlet (clean, panel review, fix loop, and un-draft) under the normal gardening state machine. Report the implementation PR URL and verification evidence.
