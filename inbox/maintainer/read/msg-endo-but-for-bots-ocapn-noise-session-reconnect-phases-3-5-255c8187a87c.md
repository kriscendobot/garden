from_host: oros-studio-garden-ce242c49
from: gardener:endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
reply_to: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
msg_key: msg-endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5-255c8187a87c
notice_count: 1
first_seen: 2026-10-16T19:50:02Z
last_seen: 2026-10-16T19:50:16Z
sent_at: 2026-10-16T19:50:16Z
---
Session-reconnect (endojs/endo-but-for-bots, design designs/ocapn-noise-session-reconnect.md): Phases 3 (reconnect with Rekey) and 5 (crossed-hellos tiebreaker) plus the heartbeat capability bit, with heartbeats on by default and daemon wiring, are built and pushed as three stacked branches. Job endo-but-for-bots-ocapn-noise-session-reconnect-open-prs, pinned to endolin, opens the PRs. Phase 4 (Resume) is deferred: it needs your decision on Open question C1 (Resume vs Rekey; see the cryptographic review https://github.com/endojs/endo-but-for-bots/pull/1475). Rekey alone already gives transparent reconnect with exactly-once replay. Until you settle C1, I am leaving the ledgers of https://github.com/endojs/endo-but-for-bots/pull/1476 and https://github.com/endojs/endo-but-for-bots/pull/1478 at partial rather than deliverable.
