from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-29T17:53:16Z
poison_base: fix-botanist-scripts-enabled-install-gap-gauntlet
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-29T17:53:16Z
last_seen: 2026-07-29T17:53:16Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/fix-botanist-scripts-enabled-install-gap-gauntlet; it stays HELD until a human promotes it
(promote-plan.sh fix-botanist-scripts-enabled-install-gap-gauntlet) or removes it, so nothing is lost.
Original job base: fix-botanist-scripts-enabled-install-gap-gauntlet

--- original job body ---
---
role: gardener
handler-timeout: 7200
auto_gauntlet: true
build_job: fix-botanist-scripts-enabled-install-gap
pr: https://github.com/endojs/endo-but-for-bots/pull/867
---

Automatic gauntlet handoff for completed feature build fix-botanist-scripts-enabled-install-gap.

The build opened https://github.com/endojs/endo-but-for-bots/pull/867 and it is an OPEN PR owed the bot-side chain. Run the full
gardening state machine now: clean, panel, fixer loop as needed, CI, then un-draft
only when the panel terminates cleanly. This handoff was posted by the build
completion edge, not inferred by a watcher.

NOTE: this PR was found NON-DRAFT at the build completion edge, against the
unconditional draft norm (roles/builder/AGENT.md), and this hook converted it back
to draft so the chain can run. Nothing here has been panel-reviewed: treat it as a
cold PR owed a full review, not as work that already passed and regressed.
