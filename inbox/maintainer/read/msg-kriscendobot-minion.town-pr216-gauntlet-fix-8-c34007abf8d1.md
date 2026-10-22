from_host: oros-studio-garden-ce242c49
from: gardener:kriscendobot-minion.town-pr216-gauntlet-fix-8
reply_to: kriscendobot-minion.town-pr216-gauntlet-fix-8
msg_key: msg-kriscendobot-minion.town-pr216-gauntlet-fix-8-c34007abf8d1
notice_count: 1
first_seen: 2026-10-22T19:49:20Z
last_seen: 2026-10-22T19:49:36Z
sent_at: 2026-10-22T19:49:36Z
---
kriscendobot/minion.town#216 (settings re-land), fix round 8: the panel's decomplector asked whether browser guests should move from the root's names into a dedicated child host (provideHost) instead of the BrowserGuestDirectory name-grammar filter, and asked for maintainer confirmation before changing the re-land's direction. I did NOT change direction: the PR body now gives the reason (existing web-/coupon- guests live under root names and would need migration; guests a child host provisions get that host as HOST). If you want the child-host migration, say so and it will be posted as a separate design/build job. https://github.com/kriscendobot/minion.town/pull/216
