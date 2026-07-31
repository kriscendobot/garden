from_host: endolin-garden2-5bcdff64
from: watchdog:mentor-claude
sent_at: 2026-07-31T01:20:13Z
watchdog_key: ollama-model-less-endpoint-endolin-garden2-5bcdff64
notice_count: 4
first_seen: 2026-07-28T22:56:20Z
last_seen: 2026-07-31T01:20:13Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-07-28T22:56:20Z, latest 2026-07-31T01:20:13Z).
The SAME condition (`ollama-model-less-endpoint-endolin-garden2-5bcdff64`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

local inference endpoint http://127.0.0.1:11434/v1 serves no qwen3:0.6b; hermit cannot run 'mentor'. Run `ollama pull qwen3:0.6b` against this endpoint (a client call, so it lands in the serving daemon's own store — a copy in another user's store is invisible here). No local-inference unit is running: neither `systemctl --user status garden-ollama.service` (the garden-supervised one, enabled only where `hermits: N>0`) nor `systemctl status ollama.service` (the installer system unit, run as the `ollama` user) is active. Bring up whichever this host is meant to serve with.
