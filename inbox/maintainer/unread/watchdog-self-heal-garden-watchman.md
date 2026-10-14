from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-10-14T12:08:01Z
watchdog_key: self-heal-garden-watchman
notice_count: 1
first_seen: 2026-10-14T12:06:08Z
last_seen: 2026-10-14T12:08:01Z
---
self-heal: garden-watchman exited rc=1 with no scoped fix. Capture: 79161cbbc48bf856a5d102d0f5ef02c13d85390a (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 79161cbbc48bf856a5d102d0f5ef02c13d85390a). Diagnosis: I'm not posting a fix job for the `garden-watchman` failure. It looks transient.

The watchman exited 1 because it couldn't read the root repo while another process held the repo lock. Its fetch of `origin/main2` failed, and then it couldn't resolve local `main2` in three tries, each blocked by a 10s lock timeout. The log ends in `FATAL: cannot resolve local main2`.

The log names pid 799318 as holder, with the lock taken at 1791979461. That pid is already gone: when I checked, the clock read 1791979564, about 100s later. So the holder was a short-lived exclusive operation, and the lock was held for roughly 40–60s. Likely candidates are a deploy, a gc or repack, or the root-repo guard. The watchman fails fast by design, and systemd restarts it, so the next tick should find the lock free.
