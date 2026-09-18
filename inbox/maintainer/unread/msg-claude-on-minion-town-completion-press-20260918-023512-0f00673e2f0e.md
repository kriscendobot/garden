from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-completion-press-20260918-023512
reply_to: claude-on-minion-town-completion-press-20260918-023512
msg_key: msg-claude-on-minion-town-completion-press-20260918-023512-0f00673e2f0e
notice_count: 1
first_seen: 2026-09-18T02:41:10Z
last_seen: 2026-09-18T02:41:12Z
sent_at: 2026-09-18T02:41:12Z
---
**Arc (kriscendobot/garden#89) — split-pr1125-stack-gauntlets orchestration HALTED (needs your call).**

The serial orchestration `split-pr1125-stack-gauntlets` (gauntlet each of the three endojs/endo-but-for-bots#1125-split slices, on-child-failure=halt) halted at child 1/3 `split-pr1125-1304-gauntlet-shepherd`, which **doomed requeue-exhausted** (doom_count 1, requeue_cycles 2, doomed 2026-09-18T00:03:11Z on endolin-garden-ece02cb4; split_reason repeated-plain-exit — the supervising gardener kept plain-exiting on the long blocking gauntlet). 0/3 children completed, so slices 2 & 3 shepherds (`split-pr1125-1305-gauntlet-shepherd`, `split-pr1125-1306-gauntlet-shepherd`) are parked under a held orchestrated gate and will **not** auto-promote.

Nuance: slice-1 (endojs/endo-but-for-bots#1304) gauntlet is actually fine — it's driving itself via the standard pr1304-gauntlet chain (viability→clean→panel→fix, now at fix-2 in doin, healthy). What's stuck is gauntleting endojs/endo-but-for-bots#1305 and endojs/endo-but-for-bots#1306. To resume the stack you'd promote the doomed 1304-shepherd (or its two held siblings) once endojs/endo-but-for-bots#1304 lands; I don't touch doomed/orchestrated jobs.

Two other in-window arc dooms are sub-threshold and block nothing: `endojs-endo-but-for-bots-pr1125-receipt` (idempotent receipt for the now-closed endojs/endo-but-for-bots#1125) and `pr1125-review-af33f29e` (review of the retired endojs/endo-but-for-bots#1125, moot after the split).
