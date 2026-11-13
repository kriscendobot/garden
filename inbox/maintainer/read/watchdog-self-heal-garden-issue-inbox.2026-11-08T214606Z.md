from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:46:06Z
watchdog_key: self-heal-garden-issue-inbox
notice_count: 1
first_seen: 2026-11-05T02:22:18Z
last_seen: 2026-11-08T21:46:06Z
---
self-heal: garden-issue-inbox exited rc=1 with no scoped fix. Capture: d57e8a4f1ec17b5bbbb8e9a2a59cffad53f39bed (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d57e8a4f1ec17b5bbbb8e9a2a59cffad53f39bed). Diagnosis: The `garden-issue-inbox` failure looks transient, and I'm not posting a fix job.

The captured log tail has only two lines. The watcher loaded 8 maintainers from `journal:maintainers/allowlist`. It then logged `cursor unchanged for kriscendobot-garden (acted 0; dropped 0; failed=0; floor=none)`. There is no error, trace, or fatal line, and the tail ends on a normal cycle result. Nothing in it points to a script bug.

The exit code of 1 therefore comes from something outside the captured output, most likely a signal or restart (for example the deploy or drain activity on 2026-11-07) or a transient `git`/`gh` failure that wasn't logged. The two known fail-open or crash bugs for this unit, the bare `cursor-get.sh` crash and the clone-lock contention, are already fixed. If this recurs, check w
