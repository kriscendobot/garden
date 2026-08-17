from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T13:33:30Z
watchdog_key: self-heal-garden-comment-watcher-endojs-endo-but-for-bots
notice_count: 1
first_seen: 2026-08-17T13:33:30Z
last_seen: 2026-08-17T13:33:30Z
---
self-heal: garden-comment-watcher@endojs-endo-but-for-bots exited rc=1 with no scoped fix. Capture: 4a3cad7157bef233fe5ff86033c15818aad01198 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 4a3cad7157bef233fe5ff86033c15818aad01198). Diagnosis: **Diagnosis: transient GitHub-side incident, no code fix — no job posted.**

The watcher failed exactly as designed. Every `GET repos/<repo>/pulls/<n>/reviews` returned HTTP 404, so `comment-source-gh.sh:258` hit its `note_fetch_failure "pulls/$n/reviews"` guard for 7 of the 8 activity-bounded PRs, the source exited nonzero with `FETCH INCOMPLETE`, and `comment-watcher.sh` froze the cursor rather than advancing past un-enumerated comments — the correct, deliberate behavior for an unreliable fetch.

The 404 is not ours. Probing live:

- `pulls/1019/reviews` → 404 whose body is a **GraphQL-shaped** error: `Could not resolve to a node with the global id of 'PR_kwDORRE4FM8AAAABABM7Nw'` — GitHub's REST-over-GraphQL backend for the list-reviews endpoint failing, not a REST "no such PR" 4
