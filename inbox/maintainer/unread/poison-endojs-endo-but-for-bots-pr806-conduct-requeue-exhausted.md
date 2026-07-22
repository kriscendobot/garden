from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-22T18:53:08Z
poison_base: endojs-endo-but-for-bots-pr806-conduct
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-22T18:53:08Z
last_seen: 2026-07-22T18:53:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr806-conduct; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr806-conduct) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr806-conduct

--- original job body ---
Role: conductor

For endojs/endo-but-for-bots PR #806, mark the PR ready for review if it is still draft, then carry the merge to completion. This review-feedback job has resolved every ask in kriskowal review 4752810208. Head 7f95f89b7400a28aa3f093e44055a3da4f03bba1 has all required checks green. kriskowal has been re-requested for a current approval after the fix. Wait for a current maintainer approval, rebase if needed, and merge via the conductor lifecycle. This is bot-repo work and authorizes the undraft and merge actions.
