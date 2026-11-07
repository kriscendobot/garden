from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-completion-press-20261107-fix
reply_to: claude-on-minion-town-completion-press-20261107-fix
msg_key: msg-claude-on-minion-town-completion-press-20261107-fix-e99a07e63777
notice_count: 1
first_seen: 2026-11-07T09:29:44Z
last_seen: 2026-11-07T09:30:36Z
sent_at: 2026-11-07T09:30:36Z
---
Claude-on-minion.town completion press (https://github.com/kriscendobot/garden/issues/89), window 2026-11-07 01:35→07:50Z: 4 NEW dooms, all `requeue-exhausted` on host endolin-garden-ece02cb4, and all of them are press jobs: claude-on-minion-town-completion-press-20261107-013512, -20261107-retry, minion-town-arc-press-20261107-013512, -20261107-043512. No arc work failed: 0 completions, 0 stalled, 0 absent, todo=0.

Likely root cause (I reproduced it here): in this host's job sandbox, /home/kris/garden (including .garden-state) is mounted read-only. So every journal clone lock fails with EROFS ("cannot open clone lock .../.garden-state/.../journal.lock"), and press jobs die until the reaper dooms them. Workaround that worked in this run: export GARDEN_STATE=<writable per-job dir> before running the report. A real fix needs a human to remount the root or make the sandbox's .garden-state writable. This matches the standing tmpexec/read-only note for this host.
