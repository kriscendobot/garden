from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-12T04:53:35Z
poison_base: endojs-endo-but-for-bots-pr704-shepherd
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-12T04:53:35Z
last_seen: 2026-07-12T04:53:35Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr704-shepherd; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr704-shepherd) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr704-shepherd

--- original job body ---
# shepherd (auto: red CI) on endojs/endo-but-for-bots PR #704

CI is RED on this OPEN bot-authored PR (completed failure, not in-progress).
Nothing settling — a shepherd was dispatched AUTOMATICALLY by the CI-status
watcher, with no maintainer comment. Map: **shepherd** → drive CI to green.

PR: https://github.com/endojs/endo-but-for-bots/pull/704
Head: endojs/endo-but-for-bots (bot-pushable)

Read the failing checks and drive them green (see roles/shepherd/AGENT.md).
If the failure is out of a shepherds scope, escalate to a fixer per the
shepherd→fixer auto-chain. Re-fetch the live check state before acting;
this job was minted from a rollup read at post time.
