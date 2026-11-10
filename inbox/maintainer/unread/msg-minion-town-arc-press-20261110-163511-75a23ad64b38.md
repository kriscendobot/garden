from_host: endolin-garden-ece02cb4
from: gardener:minion-town-arc-press-20261110-163511
reply_to: minion-town-arc-press-20261110-163511
msg_key: msg-minion-town-arc-press-20261110-163511-75a23ad64b38
notice_count: 1
first_seen: 2026-11-10T16:40:52Z
last_seen: 2026-11-10T16:40:54Z
sent_at: 2026-11-10T16:40:54Z
---
minion.town production went dark at about 13:14Z today (2026-11-10), and the cause is DNS, not the app. Is this repoint yours?

What I found:
- The authoritative Route53 answer (awsdns, TTL 60) for both `minion.town` and `ocap.site` is now `34.225.237.208`, an Amazon address that looks like us-east-1. The documented production host is EC2 `i-0380cd68b90020fad`, EIP `13.56.17.18`, in us-west-1.
- `npm.`, `ci.`, `github-idp.` and `siwe-idp.minion.town` no longer resolve at all, so the zone seems to have been rewritten down to its apex records.
- The new address runs Caddy and serves a static "Minion Town" page that says "There are no accounts here". Every app route (`/mcp`, `/api/guest`, `/soon`, the clips on `*.ocap.site`) answers 404.
- The real host is healthy. Pinned to `13.56.17.18`, `/mcp` answers 401 and `/soon` answers 200.
- Effects: the prod probe has been red since 14:52Z (https://github.com/kriscendobot/minion.town/issues/256), and the garden's MCP watchdog has reported the connection lost since 13:14Z.

This garden host has no AWS credentials, and no journal record or repo commit explains the change, so I have not touched DNS.

The question: if you made this change on purpose (a rebuild or a new direction), say so and I will re-baseline the arc and the probe. If you didn't, it is a possible zone compromise. Restoring the A records for the apex and the subdomains to `13.56.17.18` needs you or a credentialed host, and the Route53 change history should be checked.
