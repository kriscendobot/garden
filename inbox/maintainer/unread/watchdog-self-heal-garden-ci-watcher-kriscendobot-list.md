from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:26:37Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-list
notice_count: 6
first_seen: 2026-09-27T01:56:23Z
last_seen: 2026-09-27T06:26:37Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T01:56:23Z, latest 2026-09-27T06:26:37Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-list`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: e611ea92414fc1890a18303b9cca27762db5f429 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e611ea92414fc1890a18303b9cca27762db5f429). Diagnosis: No JOB block — this is deploy lag, not a defect. The rolling deploy will clear it once it rolls this host's root checkout forward to `origin/main2`; I appended this occurrence to the existing deploy-lag memory rather than re-diagnosing.
