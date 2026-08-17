from_host: endolin-garden2-5bcdff64
from: watchdog:self-heal-claude
sent_at: 2026-08-17T13:33:24Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-minion-town
notice_count: 1
first_seen: 2026-08-17T13:33:24Z
last_seen: 2026-08-17T13:33:24Z
---
self-heal: garden-comment-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 36d7b202a3b4e451a36c428c0bff67df22516be7 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 36d7b202a3b4e451a36c428c0bff67df22516be7). Diagnosis: **Diagnosis: known root cause, fix already in flight — no new job posted.**

`garden-comment-watcher@kriscendobot-minion.town` died at `comment-watcher.sh FATAL: comment source failed`. The proximate cause is one `gh` call at `scripts/jobs/handlers/comment-source-gh.sh:158`:

```
gh api repos/kriscendobot/minion.town/issues/comments?since=…&per_page=100
  failed (definitive, rc=1); not retrying: unexpected end of JSON input
```

`unexpected end of JSON input` is Go's `encoding/json` wording for a response body that was empty or cut short mid-document. `GARDEN_TRANSIENT_GH_API_SIGNATURES` (`scripts/jobs/common.sh:3163`) names the neighbouring cases — `\bEOF\b`, the HTML-error-page decoder string, http2 stream resets — but not this one, so `gh_api_retry` classified it **definitive**,
