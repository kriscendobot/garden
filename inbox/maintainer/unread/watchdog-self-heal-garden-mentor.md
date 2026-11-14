from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-14T04:51:53Z
watchdog_key: self-heal-garden-mentor
notice_count: 2
first_seen: 2026-09-25T20:50:35Z
last_seen: 2026-11-14T04:51:53Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-25T20:50:35Z, latest 2026-11-14T04:51:53Z).
The SAME condition (`self-heal-garden-mentor`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 240eefebd0b262d7083d812ffe39dc67002c07f6 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 240eefebd0b262d7083d812ffe39dc67002c07f6). Diagnosis: I've found the cause and am writing it up now.

**Diagnosis:** `garden-mentor` exited 1 because the mentor's improve handler tried to post `improve-foreman-paused-plan-and-pipeline`. `post-job.sh` refused it with rc=78, because the job belongs to the paused project `minion-town` (journal record `pauses/minion-town.md`, per the recent "minion.town project pause" commit). `mentor.sh` (around line 407) treats any non-transient handler failure as fatal. It leaves the input markers unadvanced, so every tick reproduces the same refusal, dies, and fires self-heal. Nothing is wrong with the digest or the provider. This is a pause refusal handled as a crash.

Restarting the service won't clear it, and the refusal will recur every tick until the pause is lifted (`pause-project.sh minion-town off`) o
