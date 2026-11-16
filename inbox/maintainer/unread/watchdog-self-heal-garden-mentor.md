from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-16T09:51:58Z
watchdog_key: self-heal-garden-mentor
notice_count: 4
first_seen: 2026-09-25T20:50:35Z
last_seen: 2026-11-16T09:51:58Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-25T20:50:35Z, latest 2026-11-16T09:51:58Z).
The SAME condition (`self-heal-garden-mentor`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: e2e14d2c83bb00f31fb768358ca466435b13a5f2 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e2e14d2c83bb00f31fb768358ca466435b13a5f2). Diagnosis: The failure is a code defect, not a transient one. I didn't read the surrounding code beyond the lines around the `die` call.

`mentor.sh` ran its improve handler. The handler tried to post `improve-dependabot-post-outbox`, which belongs to the paused project `minion-town`. `post-job.sh` refused with rc=78. `mentor.sh` then called `die` ("improve handler failed; leaving markers so the next tick retries"). The markers never advance, so every tick hits the same refusal and fails again. Systemd restarts the unit and the loop repeats. The pause is deliberate, so the mentor should skip these jobs instead of failing.

JOB self-heal-fix-garden-mentor-paused-project-post-rc78
`scripts/jobs/mentor.sh` fails in a loop. The improve handler tries to post `improve-dependabot-post-outbox`, which belongs
