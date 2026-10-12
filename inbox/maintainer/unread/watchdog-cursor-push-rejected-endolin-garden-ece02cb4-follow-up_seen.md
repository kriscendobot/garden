from_host: endolin-garden-ece02cb4
from: watchdog:cursor-set
sent_at: 2026-10-12T13:28:35Z
watchdog_key: cursor-push-rejected-endolin-garden-ece02cb4-follow-up_seen
notice_count: 1
first_seen: 2026-10-12T13:28:34Z
last_seen: 2026-10-12T13:28:35Z
---
cursor-set on endolin-garden-ece02cb4 cannot advance follow-up/seen after deterministic remote verification: server-reject. The fetched remote cursor does not contain the requested content and journal2 did not move. Cursor-driven work will replay until this receive-side rejection is repaired. Push diagnostic:
remote: fatal error in commit_refs        
To github.com:kriscendobot/garden.git
 ! [remote rejected]       HEAD -> journal2 (failure)
error: failed to push some refs to 'github.com:kriscendobot/garden.git'
