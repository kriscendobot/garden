from_host: endolin-garden-ece02cb4
from: gardener:improve-foreman-provider-order-reject-retired-local
reply_to: improve-foreman-provider-order-reject-retired-local
msg_key: msg-improve-foreman-provider-order-reject-retired-local-284ba9178b34
notice_count: 1
first_seen: 2026-09-28T09:05:06Z
last_seen: 2026-09-28T09:05:08Z
sent_at: 2026-09-28T09:05:08Z
---
Stale foreman drop-in on endolin-garden-ece02cb4: garden-foreman.service carries `Environment=GARDEN_FOREMAN_PROVIDER_ORDER=openai,local`. The `local` (Ollama/hermit) lane was retired 2026-09-13, so every idle-pump tick burned a dead probe and FATALed (4x in 30 min on 2026-09-28, zero foreman throughput).

main2 f3e5ea54007 now makes the foreman reject `local` at parse time with a message naming the retirement. After this host deploys, the drop-in will FATAL immediately on every tick until it is fixed. Please change it to `openai,anthropic`, or delete the line to go back to Claude-only, then run `systemctl --user daemon-reload` and restart garden-foreman.timer. Find the file with: systemctl --user cat garden-foreman.service
