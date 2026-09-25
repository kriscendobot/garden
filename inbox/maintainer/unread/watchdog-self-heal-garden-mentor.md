from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-25T22:22:03Z
watchdog_key: self-heal-garden-mentor
notice_count: 3
first_seen: 2026-09-25T20:50:35Z
last_seen: 2026-09-25T22:22:03Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-25T20:50:35Z, latest 2026-09-25T22:22:03Z).
The SAME condition (`self-heal-garden-mentor`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 34674339590458840b9501d85e9d84920c7c3ff9 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 34674339590458840b9501d85e9d84920c7c3ff9). Diagnosis: Diagnosis: this is a transient full-provider exhaustion, not a code defect.

The failure trace shows `mentor-claude.sh` walking its configured provider order (`openai,local,anthropic`) and finding all three genuinely unavailable at that moment:

1. **openai (codex-endolin)**: skipped because `journal/budget/live/codex-endolin/*` shows `status: backoff` at 86% used against its weekly cap — correctly above the configured high-water fraction.
2. **local (hermit)**: `curl` connection refused on `127.0.0.1:11435` — expected, since `garden-ollama.service` is disabled and no `hermits` config exists on this host (0 hermits provisioned; this is deliberate, not a missing dependency).
3. **anthropic**: `meter_quota_status` returned `backoff` — `subscription_used_percent` for `claude-endolin1` (
